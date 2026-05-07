#!/usr/bin/env python3
import click
import logging
import sys
from datetime import datetime, timedelta
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
import json

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from src.storage import R2Storage
from src.iceberg_manager import IcebergManager


def setup_logging(verbose: bool):
    """Configure logging based on verbosity"""
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(
        level=level,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )


@click.command()
@click.option('--environment', '-e', required=True,
              type=click.Choice(['staging', 'production']),
              help='Environment to backfill')
@click.option('--table', '-t', help='Specific table to backfill')
@click.option('--network', '-n', help='Specific network to backfill')
@click.option('--start-date', type=click.DateTime(['%Y-%m-%d']),
              help='Start date for backfill')
@click.option('--end-date', type=click.DateTime(['%Y-%m-%d']),
              help='End date for backfill')
@click.option('--parallel', '-p', default=10,
              help='Number of parallel workers')
@click.option('--dry-run', is_flag=True,
              help='Show what would be done without doing it')
@click.option('--verbose', '-v', is_flag=True,
              help='Enable verbose logging')
def backfill_iceberg(environment, table, network, start_date, end_date, parallel, dry_run, verbose):
    """Generate Iceberg metadata for existing Parquet files
    
    This command scans existing Parquet files in R2 storage and generates
    Iceberg metadata for them, allowing historical data to be queried via Iceberg.
    
    Examples:
        # Backfill all tables and networks
        backfill_iceberg.py -e production
        
        # Backfill specific table
        backfill_iceberg.py -e production -t beacon_api_eth_v1_events_block
        
        # Backfill specific date range
        backfill_iceberg.py -e production --start-date 2024-01-01 --end-date 2024-01-31
        
        # Dry run to see what would be backfilled
        backfill_iceberg.py -e staging --dry-run
    """
    setup_logging(verbose)
    logger = logging.getLogger(__name__)
    
    try:
        if dry_run:
            click.echo("🔍 Running in DRY RUN mode - no metadata will be created")
        
        click.echo(f"📊 Backfilling Iceberg metadata for {environment}")
        
        # Load configuration
        config_path = Path(__file__).parent.parent / 'config'
        with open(config_path / 'environments.yaml') as f:
            import yaml
            env_config = yaml.safe_load(f)
        
        with open(config_path / 'tables.yaml') as f:
            table_config = yaml.safe_load(f)
        
        # Get storage configuration
        storage_config = env_config['environments'][environment]['storage']
        storage = R2Storage(storage_config)
        iceberg = IcebergManager(storage_config, dry_run=dry_run)
        
        # Determine which tables to backfill
        tables_to_backfill = []
        for group_name, group_tables in table_config['table_groups'].items():
            for table_info in group_tables:
                if table and table_info['name'] != table:
                    continue
                
                for network_info in table_info['networks']:
                    if network and network_info['name'] != network:
                        continue
                    
                    tables_to_backfill.append({
                        'table': table_info['name'],
                        'network': network_info['name'],
                        'database': table_info.get('database', 'default'),
                        'partition_type': table_info['partition']['type'],
                        'start_date': network_info.get('start_date'),
                        'start_index': network_info.get('start_index')
                    })
        
        click.echo(f"Found {len(tables_to_backfill)} table/network combinations to backfill")
        
        # Process each table/network combination
        total_files = 0
        with ThreadPoolExecutor(max_workers=parallel) as executor:
            futures = []
            
            for table_info in tables_to_backfill:
                future = executor.submit(
                    backfill_table_network,
                    storage, iceberg, table_info, start_date, end_date, dry_run
                )
                futures.append(future)
            
            # Wait for completion
            with click.progressbar(
                as_completed(futures),
                length=len(futures),
                label='Backfilling tables'
            ) as bar:
                for future in bar:
                    try:
                        count = future.result()
                        total_files += count
                    except Exception as e:
                        logger.error(f"Backfill failed: {e}")
        
        click.echo(f"\n✅ Backfilled metadata for {total_files} files")
        
    except Exception as e:
        click.echo(f"❌ Error: {e}", err=True)
        if verbose:
            import traceback
            traceback.print_exc()
        sys.exit(1)


def backfill_table_network(storage, iceberg, table_info, start_date, end_date, dry_run):
    """Backfill a single table/network combination"""
    logger = logging.getLogger(__name__)
    
    table_name = table_info['table']
    network = table_info['network']
    database = table_info['database']
    
    logger.info(f"Backfilling {table_name}/{network}")
    
    # List existing Parquet files
    prefix = f"xatu/{network}/databases/{database}/{table_name}/"
    existing_files = storage.list_files(prefix)
    
    # Filter to only Parquet files
    parquet_files = [f for f in existing_files if f.endswith('.parquet')]
    
    # Filter by date range if specified
    if start_date or end_date:
        filtered_files = []
        for file_path in parquet_files:
            # Extract date from path (depends on partition structure)
            if 'partition_date=' in file_path:
                date_part = file_path.split('partition_date=')[1].split('/')[0]
                try:
                    file_date = datetime.strptime(date_part, '%Y-%m-%d')
                    if start_date and file_date < start_date:
                        continue
                    if end_date and file_date > end_date:
                        continue
                    filtered_files.append(file_path)
                except:
                    pass
            else:
                filtered_files.append(file_path)
        parquet_files = filtered_files
    
    logger.info(f"Found {len(parquet_files)} Parquet files to backfill")
    
    # Get existing files from Iceberg metadata
    existing_in_iceberg = iceberg.get_existing_files(table_name, network)
    
    # Determine which files need to be added
    files_to_add = []
    for file_path in parquet_files:
        if file_path not in existing_in_iceberg:
            files_to_add.append(file_path)
    
    logger.info(f"Need to add {len(files_to_add)} files to Iceberg metadata")
    
    # Process each file
    for file_path in files_to_add:
        try:
            # Extract partition value from path
            partition_value = extract_partition_value(file_path, table_info['partition_type'])
            
            # Get file metadata
            file_metadata = storage.get_file_metadata(file_path)
            if not file_metadata:
                logger.warning(f"Could not get metadata for {file_path}")
                continue
            
            # Register with Iceberg
            iceberg.register_file(
                table_name, network, file_path, partition_value,
                {
                    'file_size': file_metadata['size'],
                    'row_count': 0,  # Would need to read Parquet metadata for actual count
                    'export_time': file_metadata['last_modified'].isoformat()
                }
            )
            
        except Exception as e:
            logger.error(f"Failed to backfill {file_path}: {e}")
    
    # Update catalog
    if not dry_run and files_to_add:
        iceberg.update_catalog(table_name, network)
    
    return len(files_to_add)


def extract_partition_value(file_path, partition_type):
    """Extract partition value from file path"""
    if partition_type == 'daily':
        if 'partition_date=' in file_path:
            return file_path.split('partition_date=')[1].split('/')[0]
    elif partition_type == 'hourly':
        if 'partition_date=' in file_path and 'partition_hour=' in file_path:
            date_part = file_path.split('partition_date=')[1].split('/')[0]
            hour_part = file_path.split('partition_hour=')[1].split('/')[0]
            return f"{date_part}/{hour_part}"
    elif partition_type == 'integer':
        if 'partition_chunk=' in file_path:
            return file_path.split('partition_chunk=')[1].split('/')[0]
    
    # Fallback
    return Path(file_path).parent.name


if __name__ == '__main__':
    backfill_iceberg()