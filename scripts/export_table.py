#!/usr/bin/env python3
import click
import logging
import sys
from datetime import datetime
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from src.exporter import XatuExporter


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
              help='Environment to export from/to')
@click.option('--table', '-t', required=True, help='Table name to export')
@click.option('--network', '-n', required=True, help='Network to export')
@click.option('--date', '-d', type=click.DateTime(['%Y-%m-%d']),
              help='Date to export (for daily/hourly tables)')
@click.option('--force', '-f', is_flag=True, 
              help='Force export even if file exists')
@click.option('--dry-run', is_flag=True, 
              help='Show what would be done without doing it')
@click.option('--verbose', '-v', is_flag=True,
              help='Enable verbose logging')
def export_table(environment, table, network, date, force, dry_run, verbose):
    """Export a single table/network combination
    
    Examples:
        # Export yesterday's data for a daily table
        export_table.py -e production -t beacon_api_eth_v1_events_block -n mainnet
        
        # Export specific date
        export_table.py -e staging -t beacon_api_eth_v1_events_block -n mainnet -d 2024-05-30
        
        # Dry run to see what would be exported
        export_table.py -e production -t canonical_execution_block -n mainnet --dry-run
        
        # Force re-export even if files exist
        export_table.py -e production -t beacon_api_eth_v1_events_block -n mainnet -f
    """
    setup_logging(verbose)
    
    try:
        if dry_run:
            click.echo("🔍 Running in DRY RUN mode - no files will be uploaded")
        
        click.echo(f"📊 Exporting {table} for {network} from {environment}")
        
        exporter = XatuExporter(environment, dry_run=dry_run)
        success = exporter.export_table(table, network, date, force)
        
        if success:
            click.echo(f"✅ Successfully exported {table}/{network}")
            sys.exit(0)
        else:
            click.echo(f"❌ Failed to export {table}/{network}", err=True)
            sys.exit(1)
            
    except Exception as e:
        click.echo(f"❌ Error: {e}", err=True)
        if verbose:
            import traceback
            traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    export_table()