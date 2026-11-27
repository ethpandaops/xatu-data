# Xatu Iceberg Migration Plan

## Overview
Migrate Xatu's ClickHouse → Parquet export pipeline from Kubernetes CronJobs to GitHub Actions CI, adding Iceberg metadata generation while maintaining existing file structure. All implemented in Python with environment-based configuration.

## Phase 1: Project Structure Setup

### 1.1 Create Python Project Structure
- [ ] Create directory structure:
  ```
  xatu-data/
  ├── config/
  │   ├── environments.yaml     # Environment configurations
  │   ├── tables.yaml          # Table definitions
  │   └── schedules.yaml       # Export schedules
  ├── src/
  │   ├── __init__.py
  │   ├── exporter.py          # Main export logic
  │   ├── iceberg_manager.py  # Iceberg metadata handling
  │   ├── clickhouse.py        # ClickHouse client
  │   └── storage.py           # R2/S3 operations
  ├── scripts/
  │   ├── export_table.py      # CLI for single table export
  │   ├── export_all.py        # Export all tables
  │   └── backfill.py          # Historical data migration
  ├── tests/
  │   └── ...
  ├── requirements.txt
  └── pyproject.toml
  ```

### 1.2 Environment Configuration
- [ ] Create `config/environments.yaml`:
  ```yaml
  environments:
    staging:
      clickhouse:
        default:
          host: clickhouse.staging.example.com
          port: 8123
          user: exporter_staging
          password_env: CLICKHOUSE_STAGING_PASSWORD  # From env var
        experimental:
          host: clickhouse.experimental-staging.example.com
          port: 8123
          user: exporter_staging
          password_env: EXPERIMENTAL_CLICKHOUSE_STAGING_PASSWORD
      storage:
        endpoint: https://xxx.r2.cloudflarestorage.com
        bucket: xatu-staging
        access_key_env: STAGING_AWS_ACCESS_KEY_ID
        secret_key_env: STAGING_AWS_SECRET_ACCESS_KEY
        public_url: https://staging-data.ethpandaops.io
    
    production:
      clickhouse:
        default:
          host: chendpoint-xatu-clickhouse
          port: 8123
          user: exporter
          password_env: CLICKHOUSE_PASSWORD
        experimental:
          host: clickhouse.xatu-experimental.ethpandaops.io
          port: 8123
          user: default
          password_env: EXPERIMENTAL_CLICKHOUSE_PASSWORD
      storage:
        endpoint: https://xxx.r2.cloudflarestorage.com
        bucket: xatu-public
        access_key_env: AWS_ACCESS_KEY_ID
        secret_key_env: AWS_SECRET_ACCESS_KEY
        public_url: https://data.ethpandaops.io
  
  # Define which ClickHouse clusters export to which storage
  export_mappings:
    - source: staging.default
      destination: staging
    - source: production.experimental
      destination: staging
    - source: production.default
      destination: production
  ```

### 1.3 Table Configuration
- [ ] Create `config/tables.yaml` (migrate from Helm values):
  ```yaml
  table_groups:
    daily:
      - name: beacon_api_eth_v1_events_block
        database: default
        networks:
          - name: mainnet
            start_date: "2020-12-01"
          - name: holesky
            start_date: "2023-12-24"
          - name: sepolia
            start_date: "2023-12-24"
        partition:
          column: slot_start_date_time
          type: daily
        lag_days: 0
        redacted_columns:
          meta_client_ip: "CAST('0.0.0.0' AS IPv6)"
          meta_client_geo_longitude: "CAST(0 AS Float64)"
          # ... etc
    
    hourly:
      - name: beacon_api_eth_v1_events_attestation
        # ... similar structure
    
    chunked:
      - name: canonical_execution_block
        database: default
        networks:
          - name: mainnet
            start_index: 21010000
          # ...
        partition:
          column: block_number
          type: integer
          chunk_size: 1000
        lag_interval: 0
  ```

## Phase 2: Core Python Implementation

### 2.1 Main Exporter Class
- [ ] Create `src/exporter.py`:
  ```python
  import yaml
  from datetime import datetime, timedelta
  from pathlib import Path
  import logging
  from typing import Optional, Dict, Any, List, Tuple
  import tempfile
  
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
          with open('config/environments.yaml') as f:
              env_config = yaml.safe_load(f)
          with open('config/tables.yaml') as f:
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
                  storage_config = self.config['env']['storage']
                  self.storage_clients[mapping['destination']] = R2Storage(storage_config)
                  
                  # Initialize Iceberg manager
                  self.iceberg_managers[mapping['destination']] = IcebergManager(
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
              self._update_iceberg_catalog()
          
          return success
      
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
      
      def _export_single_file(self, table_config: Dict, network: str,
                             file_info: Dict[str, Any]) -> None:
          """Export a single file with column redaction"""
          ch_client = self._get_clickhouse_client_for_network(network)
          storage = self._get_storage_for_network(network)
          iceberg = self._get_iceberg_manager_for_network(network)
          
          # Build query with redacted columns
          query = self._build_export_query(
              table_config, network, file_info,
              table_config.get('redacted_columns', {})
          )
          
          # Export to temporary file
          with tempfile.NamedTemporaryFile(suffix='.parquet', delete=False) as tmp:
              metadata = ch_client.export_to_parquet(query, tmp.name)
              
              # Upload to storage
              remote_path = file_info['path']
              storage.upload_file(tmp.name, remote_path, dry_run=self.dry_run)
              
              # Register with Iceberg
              iceberg.register_file(
                  table_config['name'], network, remote_path,
                  file_info['partition_value'], metadata
              )
              
              # Clean up
              Path(tmp.name).unlink()
      
      def _build_export_query(self, table_config: Dict, network: str,
                             file_info: Dict, redacted_columns: Dict) -> str:
          """Build ClickHouse query with column redaction"""
          # Get all columns from table
          all_columns = self._get_table_columns(
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
          
          # Build WHERE clause based on partition type
          where_clause = self._build_where_clause(
              table_config, network, file_info
          )
          
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
      
      def export_all_daily(self, date: Optional[datetime] = None):
          """Export all daily tables for a given date"""
          if date is None:
              date = datetime.now() - timedelta(days=1)
          
          for table in self.config['tables']['daily']:
              for network in table['networks']:
                  self.export_table(table['name'], network['name'], date)
  ```

### 2.2 ClickHouse Client
- [ ] Create `src/clickhouse.py`:
  ```python
  import os
  import clickhouse_connect
  from typing import Dict, Any, Optional
  import pandas as pd
  
  class ClickHouseClient:
      def __init__(self, config: Dict[str, Any]):
          self.config = config
          self.client = self._connect()
      
      def _connect(self):
          password = os.environ.get(self.config['password_env'])
          if not password:
              raise ValueError(f"Password not found in {self.config['password_env']}")
          
          return clickhouse_connect.get_client(
              host=self.config['host'],
              port=self.config['port'],
              username=self.config['user'],
              password=password
          )
      
      def export_to_parquet(self, query: str, output_path: str,
                           compression: str = 'zstd') -> Dict[str, Any]:
          """Export query results to Parquet file"""
          # Use ClickHouse's native Parquet export
          query_with_format = f"{query} FORMAT Parquet SETTINGS output_format_parquet_compression_method='{compression}'"
          
          with open(output_path, 'wb') as f:
              for chunk in self.client.query_iter(query_with_format):
                  f.write(chunk)
          
          # Return metadata about the export
          return {
              'row_count': self._get_row_count(query),
              'file_size': os.path.getsize(output_path),
              'export_time': datetime.now().isoformat()
          }
  ```

### 2.3 Storage Handler
- [ ] Create `src/storage.py`:
  ```python
  import os
  import boto3
  from typing import Dict, Any, Optional
  from pathlib import Path
  
  class R2Storage:
      def __init__(self, config: Dict[str, Any]):
          self.config = config
          self.client = self._create_client()
          self.bucket = config['bucket']
          self.public_url = config['public_url']
      
      def _create_client(self):
          return boto3.client(
              's3',
              endpoint_url=self.config['endpoint'],
              aws_access_key_id=os.environ.get(self.config['access_key_env']),
              aws_secret_access_key=os.environ.get(self.config['secret_key_env']),
              region_name='auto'
          )
      
      def upload_file(self, local_path: str, remote_key: str, 
                     dry_run: bool = False) -> str:
          """Upload file to R2 and return public URL"""
          if dry_run:
              print(f"[DRY RUN] Would upload {local_path} to {remote_key}")
              return f"{self.public_url}/{remote_key}"
          
          self.client.upload_file(local_path, self.bucket, remote_key)
          return f"{self.public_url}/{remote_key}"
      
      def file_exists(self, remote_key: str) -> bool:
          """Check if file exists in R2"""
          try:
              self.client.head_object(Bucket=self.bucket, Key=remote_key)
              return True
          except:
              return False
      
      def get_file_content(self, remote_key: str) -> Optional[str]:
          """Get file content as string"""
          try:
              response = self.client.get_object(Bucket=self.bucket, Key=remote_key)
              return response['Body'].read().decode('utf-8')
          except:
              return None
      
      def list_files(self, prefix: str) -> List[str]:
          """List all files under a prefix"""
          files = []
          paginator = self.client.get_paginator('list_objects_v2')
          
          for page in paginator.paginate(Bucket=self.bucket, Prefix=prefix):
              if 'Contents' in page:
                  files.extend([obj['Key'] for obj in page['Contents']])
          
          return files
  ```

### 2.4 Iceberg Manager
- [ ] Create `src/iceberg_manager.py`:
  ```python
  from pyiceberg.catalog import Catalog
  from pyiceberg.table import Table
  from pyiceberg.schema import Schema
  from pyarrow import parquet as pq
  import json
  import uuid
  from typing import Dict, Any, Optional, Set, List
  from datetime import datetime
  import logging
  
  class IcebergManager:
      def __init__(self, storage_config: Dict[str, Any], dry_run: bool = False):
          self.storage_config = storage_config
          self.dry_run = dry_run
          self.catalog_url = f"{storage_config['public_url']}/xatu/catalog.json"
          self.storage = R2Storage(storage_config)  # Reuse storage client
          self.logger = logging.getLogger(__name__)
          self._metadata_cache = {}  # Cache loaded metadata
      
      def get_existing_files(self, table_name: str, network: str) -> Set[str]:
          """Get set of existing file paths from Iceberg metadata"""
          try:
              metadata = self._load_table_metadata(table_name, network)
              if not metadata:
                  return set()
              
              # Extract file paths from current snapshot
              current_snapshot_id = metadata.get('current-snapshot-id')
              if not current_snapshot_id:
                  return set()
              
              # Find current snapshot
              current_snapshot = None
              for snapshot in metadata.get('snapshots', []):
                  if snapshot['snapshot-id'] == current_snapshot_id:
                      current_snapshot = snapshot
                      break
              
              if not current_snapshot:
                  return set()
              
              # Load manifest list
              manifest_list = self._load_manifest_list(
                  current_snapshot['manifest-list']
              )
              
              # Extract all data file paths
              file_paths = set()
              for manifest in manifest_list:
                  manifest_content = self._load_manifest(manifest['manifest_path'])
                  for entry in manifest_content.get('entries', []):
                      if entry['status'] == 'ADDED':
                          file_paths.add(entry['data_file']['file_path'])
              
              return file_paths
              
          except Exception as e:
              self.logger.warning(f"Could not load existing files for {table_name}/{network}: {e}")
              return set()
      
      def register_file(self, table_name: str, network: str, file_path: str,
                       partition_value: Any, file_metadata: Dict[str, Any]) -> None:
          """Register a new Parquet file with Iceberg metadata"""
          metadata_path = self._get_metadata_path(table_name, network)
          
          # Load or create table metadata
          metadata = self._load_table_metadata(table_name, network)
          if not metadata:
              metadata = self._create_initial_metadata(
                  table_name, network, file_path, partition_value
              )
          
          # Add file to metadata
          new_metadata = self._add_file_to_metadata(
              metadata, file_path, partition_value, file_metadata
          )
          
          if not self.dry_run:
              # Save new metadata version
              self._save_metadata(metadata_path, new_metadata)
              
              # Update version hint
              self._update_version_hint(metadata_path, new_metadata['version'])
      
      def _load_table_metadata(self, table_name: str, network: str) -> Optional[Dict]:
          """Load current table metadata from storage"""
          cache_key = f"{network}/{table_name}"
          if cache_key in self._metadata_cache:
              return self._metadata_cache[cache_key]
          
          try:
              metadata_path = self._get_metadata_path(table_name, network)
              version_hint_key = f"{metadata_path}/version-hint.text"
              
              # Get current version
              version_hint = self.storage.get_file_content(version_hint_key)
              if not version_hint:
                  return None
              
              current_version = int(version_hint.strip())
              
              # Load metadata file
              metadata_key = f"{metadata_path}/v{current_version}.metadata.json"
              metadata_content = self.storage.get_file_content(metadata_key)
              
              if metadata_content:
                  metadata = json.loads(metadata_content)
                  self._metadata_cache[cache_key] = metadata
                  return metadata
                  
          except Exception as e:
              self.logger.debug(f"No existing metadata for {table_name}/{network}: {e}")
          
          return None
      
      def _create_initial_metadata(self, table_name: str, network: str,
                                  first_file: str, partition_value: Any) -> Dict:
          """Create initial Iceberg metadata for a new table"""
          # Read schema from the first Parquet file
          # This would need to download the file temporarily
          # For now, we'll assume a known schema structure
          
          table_uuid = str(uuid.uuid4())
          location = f"{self.storage_config['public_url']}/xatu/{network}/databases/default/{table_name}"
          
          return {
              "format-version": 2,
              "table-uuid": table_uuid,
              "location": location,
              "last-sequence-number": 0,
              "last-updated-ms": int(datetime.now().timestamp() * 1000),
              "last-column-id": 100,  # Reserve space for columns
              "current-schema-id": 0,
              "schemas": [self._get_table_schema(table_name)],
              "default-spec-id": 0,
              "partition-specs": [self._get_partition_spec(table_name)],
              "last-partition-id": 1000,
              "default-sort-order-id": 0,
              "sort-orders": [{"order-id": 0, "fields": []}],
              "properties": {
                  "created-by": "xatu-exporter",
                  "created-at": datetime.now().isoformat()
              },
              "snapshots": [],
              "snapshot-log": [],
              "metadata-log": [],
              "version": 1
          }
      
      def _add_file_to_metadata(self, metadata: Dict, file_path: str,
                               partition_value: Any, file_metadata: Dict) -> Dict:
          """Add a new file to existing metadata, creating a new snapshot"""
          # Clone metadata for new version
          new_metadata = json.loads(json.dumps(metadata))
          
          # Update version and timestamp
          new_metadata['version'] = metadata.get('version', 1) + 1
          new_metadata['last-updated-ms'] = int(datetime.now().timestamp() * 1000)
          new_metadata['last-sequence-number'] += 1
          
          # Create new snapshot
          snapshot_id = new_metadata['last-sequence-number']
          snapshot = {
              "sequence-number": snapshot_id,
              "snapshot-id": snapshot_id,
              "timestamp-ms": new_metadata['last-updated-ms'],
              "summary": {
                  "operation": "append",
                  "added-data-files": "1",
                  "added-records": str(file_metadata.get('row_count', 0)),
                  "added-files-size": str(file_metadata.get('file_size', 0)),
                  "total-data-files": str(self._count_total_files(metadata) + 1),
                  "total-records": str(self._count_total_records(metadata) + file_metadata.get('row_count', 0)),
                  "total-files-size": str(self._count_total_size(metadata) + file_metadata.get('file_size', 0))
              },
              "manifest-list": f"{self._get_metadata_path_from_metadata(metadata)}/snap-{snapshot_id}-manifest-list.avro"
          }
          
          # Add snapshot
          new_metadata['snapshots'].append(snapshot)
          new_metadata['current-snapshot-id'] = snapshot_id
          
          # Update snapshot log
          new_metadata['snapshot-log'].append({
              "timestamp-ms": snapshot['timestamp-ms'],
              "snapshot-id": snapshot_id
          })
          
          # Create manifest entry for the new file
          # In practice, this would be written as Avro files
          # For now, we'll store as JSON for simplicity
          self._create_manifest_for_file(
              metadata, snapshot, file_path, partition_value, file_metadata
          )
          
          return new_metadata
      
      def _get_metadata_path(self, table_name: str, network: str) -> str:
          """Get the metadata path for a table"""
          return f"xatu/{network}/databases/default/{table_name}/metadata"
      
      def _get_table_schema(self, table_name: str) -> Dict:
          """Get Iceberg schema for a table (would be generated from actual Parquet schema)"""
          # This would be table-specific
          # For now, return a generic schema structure
          return {
              "type": "struct",
              "schema-id": 0,
              "fields": [
                  # This would be populated from actual table schema
              ]
          }
      
      def _get_partition_spec(self, table_name: str) -> Dict:
          """Get partition spec for a table"""
          # This would be loaded from table configuration
          return {
              "spec-id": 0,
              "fields": [
                  # Populated based on table config
              ]
          }
  ```

## Phase 3: CLI Scripts

### 3.1 Single Table Export Script
- [ ] Create `scripts/export_table.py`:
  ```python
  #!/usr/bin/env python3
  import click
  import logging
  from datetime import datetime
  from src.exporter import XatuExporter
  
  @click.command()
  @click.option('--environment', '-e', required=True, 
                type=click.Choice(['staging', 'production']),
                help='Environment to export from/to')
  @click.option('--table', '-t', required=True, help='Table name to export')
  @click.option('--network', '-n', required=True, help='Network to export')
  @click.option('--date', '-d', type=click.DateTime(['%Y-%m-%d']),
                help='Date to export (for daily tables)')
  @click.option('--force', '-f', is_flag=True, 
                help='Force export even if file exists')
  @click.option('--dry-run', is_flag=True, 
                help='Show what would be done without doing it')
  def export_table(environment, table, network, date, force, dry_run):
      """Export a single table/network combination"""
      logging.basicConfig(level=logging.INFO)
      
      exporter = XatuExporter(environment, dry_run=dry_run)
      success = exporter.export_table(table, network, date, force)
      
      if success:
          click.echo(f"✓ Successfully exported {table}/{network}")
      else:
          click.echo(f"✗ Failed to export {table}/{network}", err=True)
          raise click.Abort()
  
  if __name__ == '__main__':
      export_table()
  ```

### 3.2 Batch Export Script
- [ ] Create `scripts/export_all.py`:
  ```python
  #!/usr/bin/env python3
  import click
  from datetime import datetime, timedelta
  from concurrent.futures import ThreadPoolExecutor
  from src.exporter import XatuExporter
  
  @click.command()
  @click.option('--environment', '-e', required=True,
                type=click.Choice(['staging', 'production']))
  @click.option('--table-group', '-g', 
                type=click.Choice(['daily', 'hourly', 'chunked', 'all']),
                default='all')
  @click.option('--date', '-d', type=click.DateTime(['%Y-%m-%d']))
  @click.option('--parallel', '-p', default=4, help='Number of parallel exports')
  @click.option('--dry-run', is_flag=True)
  def export_all(environment, table_group, date, parallel, dry_run):
      """Export all tables for a given date/group"""
      exporter = XatuExporter(environment, dry_run=dry_run)
      
      if table_group == 'all':
          groups = ['daily', 'hourly', 'chunked']
      else:
          groups = [table_group]
      
      with ThreadPoolExecutor(max_workers=parallel) as executor:
          # Submit export jobs
          futures = []
          for group in groups:
              if group == 'daily':
                  futures.extend(exporter.submit_daily_exports(executor, date))
              # ... handle other groups
      
      # Wait for completion and report results
      # ...
  ```

## Phase 4: GitHub Actions Configuration

### 4.1 Workflow for Daily Tables
- [ ] Create `.github/workflows/export-daily.yml`:
  ```yaml
  name: Export Daily Tables
  
  on:
    schedule:
      - cron: '0 4 * * *'  # 4 AM UTC
    workflow_dispatch:
      inputs:
        date:
          description: 'Date to export (YYYY-MM-DD)'
          required: false
        environment:
          description: 'Environment to use'
          required: true
          type: choice
          options:
            - production
            - staging
          default: production
  
  jobs:
    export:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        
        - name: Set up Python
          uses: actions/setup-python@v4
          with:
            python-version: '3.11'
        
        - name: Install dependencies
          run: |
            pip install -r requirements.txt
        
        - name: Export daily tables
          env:
            # Production secrets
            CLICKHOUSE_PASSWORD: ${{ secrets.CLICKHOUSE_PASSWORD }}
            EXPERIMENTAL_CLICKHOUSE_PASSWORD: ${{ secrets.EXPERIMENTAL_CLICKHOUSE_PASSWORD }}
            AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
            AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
            # Staging secrets
            CLICKHOUSE_STAGING_PASSWORD: ${{ secrets.CLICKHOUSE_STAGING_PASSWORD }}
            EXPERIMENTAL_CLICKHOUSE_STAGING_PASSWORD: ${{ secrets.EXPERIMENTAL_CLICKHOUSE_STAGING_PASSWORD }}
            STAGING_AWS_ACCESS_KEY_ID: ${{ secrets.STAGING_AWS_ACCESS_KEY_ID }}
            STAGING_AWS_SECRET_ACCESS_KEY: ${{ secrets.STAGING_AWS_SECRET_ACCESS_KEY }}
          run: |
            ENVIRONMENT="${{ github.event.inputs.environment || 'production' }}"
            DATE="${{ github.event.inputs.date || '' }}"
            
            if [ -n "$DATE" ]; then
              python scripts/export_all.py -e $ENVIRONMENT -g daily -d $DATE
            else
              python scripts/export_all.py -e $ENVIRONMENT -g daily
            fi
  ```

### 4.2 Manual Trigger Workflow
- [ ] Create `.github/workflows/export-manual.yml`:
  ```yaml
  name: Manual Table Export
  
  on:
    workflow_dispatch:
      inputs:
        environment:
          description: 'Environment'
          required: true
          type: choice
          options:
            - staging
            - production
        table:
          description: 'Table name'
          required: true
        network:
          description: 'Network'
          required: true
        date:
          description: 'Date (YYYY-MM-DD) for daily/hourly tables'
          required: false
        dry_run:
          description: 'Dry run only'
          type: boolean
          default: false
  
  jobs:
    export:
      runs-on: ubuntu-latest
      steps:
        # ... similar setup steps
        
        - name: Export single table
          env:
            # ... environment variables
          run: |
            ARGS="-e ${{ inputs.environment }} -t ${{ inputs.table }} -n ${{ inputs.network }}"
            
            if [ -n "${{ inputs.date }}" ]; then
              ARGS="$ARGS -d ${{ inputs.date }}"
            fi
            
            if [ "${{ inputs.dry_run }}" = "true" ]; then
              ARGS="$ARGS --dry-run"
            fi
            
            python scripts/export_table.py $ARGS
  ```

## Phase 5: Local Development & Testing

### 5.1 Local Development Setup
- [ ] Create `Makefile`:
  ```makefile
  .PHONY: install test export-local
  
  install:
  	pip install -e ".[dev]"
  
  test:
  	pytest tests/
  
  # Export single table locally
  export-local:
  	python scripts/export_table.py \
  		-e staging \
  		-t beacon_api_eth_v1_events_block \
  		-n mainnet \
  		-d 2024-05-30 \
  		--dry-run
  
  # Test export all for yesterday
  export-all-local:
  	python scripts/export_all.py \
  		-e staging \
  		-g daily \
  		--dry-run
  
  # Run with local config override
  export-dev:
  	XATU_CONFIG_PATH=config/dev-override.yaml \
  	python scripts/export_table.py -e staging -t $(TABLE) -n $(NETWORK)
  ```

### 5.2 Development Configuration Override
- [ ] Create `config/dev-override.yaml` (git-ignored):
  ```yaml
  # Local development overrides
  environments:
    staging:
      clickhouse:
        default:
          host: localhost
          port: 9000
          user: default
          password_env: LOCAL_CLICKHOUSE_PASSWORD
      storage:
        endpoint: http://localhost:9001  # MinIO
        bucket: xatu-dev
        access_key_env: LOCAL_MINIO_ACCESS_KEY
        secret_key_env: LOCAL_MINIO_SECRET_KEY
        public_url: http://localhost:9001/xatu-dev
  ```

### 5.3 Testing Framework
- [ ] Create `tests/test_exporter.py`:
  ```python
  import pytest
  from unittest.mock import Mock, patch
  from src.exporter import XatuExporter
  
  @pytest.fixture
  def mock_environment():
      with patch.dict('os.environ', {
          'CLICKHOUSE_STAGING_PASSWORD': 'test123',
          'STAGING_AWS_ACCESS_KEY_ID': 'test-key',
          'STAGING_AWS_SECRET_ACCESS_KEY': 'test-secret'
      }):
          yield
  
  def test_export_table_dry_run(mock_environment):
      exporter = XatuExporter('staging', dry_run=True)
      
      # Test that dry run doesn't actually upload
      with patch.object(exporter.storage_clients['staging'], 'upload_file') as mock_upload:
          exporter.export_table('test_table', 'mainnet', datetime.now())
          mock_upload.assert_not_called()
  ```

## Phase 6: Monitoring & Logging

### 6.1 Structured Logging
- [ ] Add logging configuration:
  ```python
  import structlog
  
  def setup_logging():
      structlog.configure(
          processors=[
              structlog.stdlib.filter_by_level,
              structlog.stdlib.add_logger_name,
              structlog.stdlib.add_log_level,
              structlog.stdlib.PositionalArgumentsFormatter(),
              structlog.processors.TimeStamper(fmt="iso"),
              structlog.processors.StackInfoRenderer(),
              structlog.processors.format_exc_info,
              structlog.processors.UnicodeDecoder(),
              structlog.processors.JSONRenderer()
          ],
          context_class=dict,
          logger_factory=structlog.stdlib.LoggerFactory(),
          cache_logger_on_first_use=True,
      )
  ```

### 6.2 Export Metrics
- [ ] Track and report:
  - Export duration
  - File sizes
  - Row counts
  - Failed exports
  - Iceberg metadata generation time

## Phase 7: Migration Process

### 7.1 Parallel Run Phase
- [ ] Run GitHub Actions in staging environment
- [ ] Compare outputs with Kubernetes exports
- [ ] Monitor for discrepancies

### 7.2 Production Rollout
- [ ] Enable GitHub Actions for production
- [ ] Run in parallel with Kubernetes for 1 week
- [ ] Disable Kubernetes CronJobs
- [ ] Monitor and validate

### 7.3 Historical Backfill
- [ ] Create `scripts/backfill_iceberg.py`:
  ```python
  @click.command()
  @click.option('--table', '-t', help='Specific table to backfill')
  @click.option('--start-date', type=click.DateTime(['%Y-%m-%d']))
  @click.option('--end-date', type=click.DateTime(['%Y-%m-%d']))
  @click.option('--parallel', '-p', default=10)
  def backfill_iceberg(table, start_date, end_date, parallel):
      """Generate Iceberg metadata for existing Parquet files"""
      # List existing files in R2
      # Generate Iceberg metadata
      # Update catalog
  ```

## Success Criteria

- [ ] All exports can run locally with staging configuration
- [ ] GitHub Actions successfully export to correct environments
- [ ] Iceberg metadata is queryable via PyIceberg/DuckDB
- [ ] Export times are comparable to Kubernetes implementation
- [ ] No data loss or corruption during migration
- [ ] Clear logging and error reporting

## Benefits of This Approach

1. **Configuration as Code**: All environment configs in YAML
2. **Local Testing**: Can test entire pipeline locally
3. **Environment Flexibility**: Easy to add new environments
4. **Pure Python**: Easier to maintain and debug than bash scripts
5. **Dry Run Support**: Test changes without affecting production
6. **Parallel Execution**: Built-in support for concurrent exports
7. **Structured Logging**: Better observability