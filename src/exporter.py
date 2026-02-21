import yaml
from datetime import datetime, timedelta
from pathlib import Path
import logging
from typing import Optional, Dict, Any, List, Tuple
import tempfile
import os
from concurrent.futures import Future

from .clickhouse import ClickHouseClient
from .storage import R2Storage
from .iceberg_manager import IcebergManager


class XatuExporter:
    def __init__(self, environment: str, dry_run: bool = False):
        self.environment = environment
        self.dry_run = dry_run
        self.config = self._load_config()
        self.setup_clients()
        self.logger = logging.getLogger(__name__)
    
    def _load_config(self) -> Dict[str, Any]:
        """Load environment and table configurations"""
        config_path = Path(__file__).parent.parent / 'config'
        
        # Allow override path for local development
        if 'XATU_CONFIG_PATH' in os.environ:
            config_path = Path(os.environ['XATU_CONFIG_PATH'])
        
        with open(config_path / 'environments.yaml') as f:
            env_config = yaml.safe_load(f)
        with open(config_path / 'tables.yaml') as f:
            table_config = yaml.safe_load(f)
        
        return {
            'env': env_config['environments'][self.environment],
            'tables': table_config['table_groups'],
            'mappings': env_config['export_mappings']
        }
    
    def setup_clients(self):
        """Initialize ClickHouse and storage clients"""
        self.clickhouse_clients = {}
        self.storage_clients = {}
        self.iceberg_managers = {}
        
        # Set up based on export mappings
        for mapping in self.config['mappings']:
            source_env, source_cluster = mapping['source'].split('.')
            if source_env == self.environment:
                # Initialize ClickHouse client
                ch_config = self.config['env']['clickhouse'][source_cluster]
                self.clickhouse_clients[source_cluster] = ClickHouseClient(ch_config)
                
                # Initialize storage client
                dest_env = mapping['destination']
                # Get storage config for destination environment
                if dest_env == self.environment:
                    storage_config = self.config['env']['storage']
                else:
                    # Load destination environment config
                    with open(Path(__file__).parent.parent / 'config' / 'environments.yaml') as f:
                        all_envs = yaml.safe_load(f)
                    storage_config = all_envs['environments'][dest_env]['storage']
                
                self.storage_clients[dest_env] = R2Storage(storage_config)
                
                # Initialize Iceberg manager
                self.iceberg_managers[dest_env] = IcebergManager(
                    storage_config, dry_run=self.dry_run
                )
    
    def export_table(self, table_name: str, network: str, 
                    date: Optional[datetime] = None,
                    force: bool = False) -> bool:
        """Export a single table/network/date combination"""
        table_config = self._get_table_config(table_name)
        if not table_config:
            self.logger.error(f"Table {table_name} not found in config")
            return False
        
        # Check if network is configured for this table
        network_config = self._get_network_config(table_config, network)
        if not network_config:
            self.logger.error(f"Network {network} not configured for table {table_name}")
            return False
        
        # Determine which files need to be exported based on Iceberg metadata
        files_to_export = self._get_missing_files(
            table_name, network, date, table_config, force
        )
        
        if not files_to_export:
            self.logger.info(f"No files to export for {table_name}/{network}")
            return True
        
        # Export each missing file
        success = True
        for file_info in files_to_export:
            try:
                self._export_single_file(
                    table_config, network, file_info
                )
            except Exception as e:
                self.logger.error(f"Failed to export {file_info}: {e}")
                success = False
        
        # Update Iceberg catalog after all exports
        if success and not self.dry_run:
            self._update_iceberg_catalog(table_name, network)
        
        return success
    
    def _get_table_config(self, table_name: str) -> Optional[Dict[str, Any]]:
        """Get configuration for a specific table"""
        for group in self.config['tables'].values():
            for table in group:
                if table['name'] == table_name:
                    return table
        return None
    
    def _get_network_config(self, table_config: Dict, network: str) -> Optional[Dict[str, Any]]:
        """Get network-specific configuration for a table"""
        for net_config in table_config['networks']:
            if net_config['name'] == network:
                return net_config
        return None
    
    def _get_missing_files(self, table_name: str, network: str,
                          date: Optional[datetime], table_config: Dict,
                          force: bool) -> List[Dict[str, Any]]:
        """Determine which files need to be exported based on Iceberg metadata"""
        iceberg_manager = self._get_iceberg_manager_for_table(table_name)
        
        # Get list of existing files from Iceberg metadata
        existing_files = iceberg_manager.get_existing_files(
            table_name, network
        ) if not force else set()
        
        # Generate list of files that should exist
        if table_config['partition']['type'] == 'daily':
            expected_files = self._generate_daily_files(
                table_name, network, date, table_config
            )
        elif table_config['partition']['type'] == 'hourly':
            expected_files = self._generate_hourly_files(
                table_name, network, date, table_config
            )
        else:  # chunked
            expected_files = self._generate_chunked_files(
                table_name, network, table_config
            )
        
        # Return files that don't exist in Iceberg
        return [f for f in expected_files if f['path'] not in existing_files]
    
    def _generate_daily_files(self, table_name: str, network: str, 
                             date: Optional[datetime], table_config: Dict) -> List[Dict[str, Any]]:
        """Generate list of daily partition files"""
        if date is None:
            date = datetime.now() - timedelta(days=1)
        
        # Get network start date
        network_config = self._get_network_config(table_config, network)
        start_date = datetime.strptime(network_config['start_date'], '%Y-%m-%d')
        
        # Apply lag
        lag_days = table_config.get('lag_days', 0)
        max_date = datetime.now() - timedelta(days=lag_days)
        
        if date > max_date:
            self.logger.warning(f"Date {date} is within lag period, skipping")
            return []
        
        if date < start_date:
            self.logger.warning(f"Date {date} is before network start date {start_date}")
            return []
        
        # Generate file path
        date_str = date.strftime('%Y-%m-%d')
        path = f"xatu/{network}/databases/{table_config['database']}/{table_name}/partition_date={date_str}/{table_name}.parquet"
        
        return [{
            'path': path,
            'partition_value': date_str,
            'date': date,
            'where_clause': f"{table_config['partition']['column']} >= '{date_str} 00:00:00' AND {table_config['partition']['column']} < '{date_str} 00:00:00' + INTERVAL 1 DAY"
        }]
    
    def _generate_hourly_files(self, table_name: str, network: str,
                              date: Optional[datetime], table_config: Dict) -> List[Dict[str, Any]]:
        """Generate list of hourly partition files"""
        if date is None:
            date = datetime.now() - timedelta(hours=1)
        
        # Get network start date
        network_config = self._get_network_config(table_config, network)
        start_date = datetime.strptime(network_config['start_date'], '%Y-%m-%d')
        
        # Apply lag
        lag_hours = table_config.get('lag_hours', 0)
        max_date = datetime.now() - timedelta(hours=lag_hours)
        
        files = []
        # Generate all hours for the date
        current_hour = date.replace(hour=0, minute=0, second=0, microsecond=0)
        for hour in range(24):
            check_time = current_hour + timedelta(hours=hour)
            if check_time > max_date or check_time < start_date:
                continue
            
            date_str = check_time.strftime('%Y-%m-%d')
            hour_str = check_time.strftime('%H')
            path = f"xatu/{network}/databases/{table_config['database']}/{table_name}/partition_date={date_str}/partition_hour={hour_str}/{table_name}.parquet"
            
            files.append({
                'path': path,
                'partition_value': f"{date_str}/{hour_str}",
                'date': check_time,
                'where_clause': f"{table_config['partition']['column']} >= '{check_time.strftime('%Y-%m-%d %H:00:00')}' AND {table_config['partition']['column']} < '{check_time.strftime('%Y-%m-%d %H:00:00')}' + INTERVAL 1 HOUR"
            })
        
        return files
    
    def _generate_chunked_files(self, table_name: str, network: str,
                               table_config: Dict) -> List[Dict[str, Any]]:
        """Generate list of chunked partition files based on integer ranges"""
        network_config = self._get_network_config(table_config, network)
        start_index = network_config.get('start_index', 0)
        chunk_size = table_config['partition']['chunk_size']
        
        # Query ClickHouse for max value
        ch_client = self._get_clickhouse_client_for_table(table_name)
        max_value = ch_client.get_max_value(
            table_config['database'], 
            table_name, 
            table_config['partition']['column'],
            f"meta_network_name = '{network}'"
        )
        
        if max_value is None:
            return []
        
        # Apply lag
        lag_interval = table_config.get('lag_interval', 0)
        max_value = max_value - lag_interval
        
        files = []
        current_chunk = (start_index // chunk_size) * chunk_size
        
        while current_chunk <= max_value:
            chunk_end = current_chunk + chunk_size - 1
            path = f"xatu/{network}/databases/{table_config['database']}/{table_name}/partition_chunk={current_chunk}/{table_name}.parquet"
            
            files.append({
                'path': path,
                'partition_value': str(current_chunk),
                'chunk_start': current_chunk,
                'chunk_end': chunk_end,
                'where_clause': f"{table_config['partition']['column']} >= {current_chunk} AND {table_config['partition']['column']} <= {chunk_end}"
            })
            
            current_chunk += chunk_size
        
        return files
    
    def _export_single_file(self, table_config: Dict, network: str,
                           file_info: Dict[str, Any]) -> None:
        """Export a single file with column redaction"""
        ch_client = self._get_clickhouse_client_for_table(table_config['name'])
        storage = self._get_storage_for_table(table_config['name'])
        iceberg = self._get_iceberg_manager_for_table(table_config['name'])
        
        # Build query with redacted columns
        query = self._build_export_query(
            table_config, network, file_info,
            table_config.get('redacted_columns', {})
        )
        
        # Export to temporary file
        with tempfile.NamedTemporaryFile(suffix='.parquet', delete=False) as tmp:
            try:
                metadata = ch_client.export_to_parquet(query, tmp.name)
                
                # Upload to storage
                remote_path = file_info['path']
                storage.upload_file(tmp.name, remote_path, dry_run=self.dry_run)
                
                # Register with Iceberg
                iceberg.register_file(
                    table_config['name'], network, remote_path,
                    file_info['partition_value'], metadata
                )
                
                self.logger.info(f"Successfully exported {remote_path}")
            finally:
                # Clean up
                Path(tmp.name).unlink(missing_ok=True)
    
    def _build_export_query(self, table_config: Dict, network: str,
                           file_info: Dict, redacted_columns: Dict) -> str:
        """Build ClickHouse query with column redaction"""
        # Get all columns from table
        ch_client = self._get_clickhouse_client_for_table(table_config['name'])
        all_columns = ch_client.get_table_columns(
            table_config['database'], table_config['name']
        )
        
        # Build SELECT with redacted columns
        select_parts = []
        for col in all_columns:
            if col in redacted_columns:
                select_parts.append(f"{redacted_columns[col]} AS {col}")
            else:
                select_parts.append(col)
        
        select_clause = ", ".join(select_parts)
        
        # Build WHERE clause
        where_parts = [file_info['where_clause']]
        where_parts.append(f"meta_network_name = '{network}'")
        where_clause = " AND ".join(where_parts)
        
        # Determine if FINAL is needed
        final_clause = self._get_final_clause(
            table_config['database'], table_config['name']
        )
        
        return f"""
            SELECT {select_clause}
            FROM {table_config['database']}.{table_config['name']} {final_clause}
            WHERE {where_clause}
            ORDER BY {table_config['partition']['column']}
        """
    
    def _get_final_clause(self, database: str, table: str) -> str:
        """Determine if FINAL clause is needed based on table engine"""
        ch_client = list(self.clickhouse_clients.values())[0]
        engine = ch_client.get_table_engine(database, table)
        
        # Use FINAL for MergeTree engines that deduplicate
        if 'ReplacingMergeTree' in engine or 'CollapsingMergeTree' in engine:
            return 'FINAL'
        return ''
    
    def _get_clickhouse_client_for_table(self, table_name: str) -> ClickHouseClient:
        """Get the appropriate ClickHouse client for a table"""
        # For now, use the first available client
        # In future, this could be more sophisticated based on table mapping
        return list(self.clickhouse_clients.values())[0]
    
    def _get_storage_for_table(self, table_name: str) -> R2Storage:
        """Get the appropriate storage client for a table"""
        # Determine destination based on mapping
        for mapping in self.config['mappings']:
            source_env, source_cluster = mapping['source'].split('.')
            if source_env == self.environment:
                return self.storage_clients[mapping['destination']]
        return list(self.storage_clients.values())[0]
    
    def _get_iceberg_manager_for_table(self, table_name: str) -> IcebergManager:
        """Get the appropriate Iceberg manager for a table"""
        # Determine destination based on mapping
        for mapping in self.config['mappings']:
            source_env, source_cluster = mapping['source'].split('.')
            if source_env == self.environment:
                return self.iceberg_managers[mapping['destination']]
        return list(self.iceberg_managers.values())[0]
    
    def _update_iceberg_catalog(self, table_name: str, network: str):
        """Update Iceberg catalog after exports"""
        iceberg = self._get_iceberg_manager_for_table(table_name)
        iceberg.update_catalog(table_name, network)
    
    def export_all_daily(self, date: Optional[datetime] = None):
        """Export all daily tables for a given date"""
        if date is None:
            date = datetime.now() - timedelta(days=1)
        
        results = []
        for table in self.config['tables'].get('daily', []):
            for network in table['networks']:
                success = self.export_table(table['name'], network['name'], date)
                results.append((table['name'], network['name'], success))
        
        return results
    
    def export_all_hourly(self, date: Optional[datetime] = None):
        """Export all hourly tables for a given date"""
        if date is None:
            date = datetime.now() - timedelta(hours=1)
        
        results = []
        for table in self.config['tables'].get('hourly', []):
            for network in table['networks']:
                success = self.export_table(table['name'], network['name'], date)
                results.append((table['name'], network['name'], success))
        
        return results
    
    def export_all_chunked(self):
        """Export all chunked tables"""
        results = []
        for table in self.config['tables'].get('chunked', []):
            for network in table['networks']:
                success = self.export_table(table['name'], network['name'])
                results.append((table['name'], network['name'], success))
        
        return results
    
    def submit_daily_exports(self, executor, date: Optional[datetime] = None) -> List[Future]:
        """Submit daily export jobs to executor"""
        if date is None:
            date = datetime.now() - timedelta(days=1)
        
        futures = []
        for table in self.config['tables'].get('daily', []):
            for network in table['networks']:
                future = executor.submit(
                    self.export_table, table['name'], network['name'], date
                )
                futures.append(future)
        
        return futures
    
    def submit_hourly_exports(self, executor, date: Optional[datetime] = None) -> List[Future]:
        """Submit hourly export jobs to executor"""
        if date is None:
            date = datetime.now() - timedelta(hours=1)
        
        futures = []
        for table in self.config['tables'].get('hourly', []):
            for network in table['networks']:
                future = executor.submit(
                    self.export_table, table['name'], network['name'], date
                )
                futures.append(future)
        
        return futures
    
    def submit_chunked_exports(self, executor) -> List[Future]:
        """Submit chunked export jobs to executor"""
        futures = []
        for table in self.config['tables'].get('chunked', []):
            for network in table['networks']:
                future = executor.submit(
                    self.export_table, table['name'], network['name']
                )
                futures.append(future)
        
        return futures