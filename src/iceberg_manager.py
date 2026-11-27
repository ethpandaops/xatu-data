import json
import uuid
from typing import Dict, Any, Optional, Set, List
from datetime import datetime
import logging
import tempfile
from pathlib import Path
import pyarrow.parquet as pq

from .storage import R2Storage


class IcebergManager:
    def __init__(self, storage_config: Dict[str, Any], dry_run: bool = False):
        self.storage_config = storage_config
        self.dry_run = dry_run
        self.catalog_url = f"{storage_config['public_url']}/xatu/catalog.json"
        self.storage = R2Storage(storage_config)
        self.logger = logging.getLogger(__name__)
        self._metadata_cache = {}  # Cache loaded metadata
        self._manifest_cache = {}  # Cache loaded manifests
    
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
            for manifest_entry in manifest_list:
                manifest_content = self._load_manifest(manifest_entry['manifest_path'])
                for entry in manifest_content.get('entries', []):
                    if entry['status'] in ['ADDED', 'EXISTING']:
                        file_path = entry['data_file']['file_path']
                        # Convert absolute path to relative if needed
                        if file_path.startswith(self.storage_config['public_url']):
                            file_path = file_path[len(self.storage_config['public_url']) + 1:]
                        file_paths.add(file_path)
            
            return file_paths
            
        except Exception as e:
            self.logger.warning(f"Could not load existing files for {table_name}/{network}: {e}")
            return set()
    
    def register_file(self, table_name: str, network: str, file_path: str,
                     partition_value: Any, file_metadata: Dict[str, Any]) -> None:
        """Register a new Parquet file with Iceberg metadata"""
        if self.dry_run:
            self.logger.info(f"[DRY RUN] Would register {file_path} in Iceberg metadata")
            return
        
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
        
        # Save new metadata version
        self._save_metadata(metadata_path, new_metadata)
        
        # Update version hint
        self._update_version_hint(metadata_path, new_metadata['format-version'])
    
    def update_catalog(self, table_name: str, network: str):
        """Update the main Iceberg catalog"""
        if self.dry_run:
            self.logger.info(f"[DRY RUN] Would update catalog for {table_name}/{network}")
            return
        
        # Load existing catalog
        catalog = self._load_catalog()
        
        # Add or update table entry
        table_id = f"{network}.{table_name}"
        metadata_path = self._get_metadata_path(table_name, network)
        
        catalog['tables'][table_id] = {
            'metadata-location': f"{self.storage_config['public_url']}/{metadata_path}/current.metadata.json",
            'updated-at': datetime.now().isoformat()
        }
        
        # Save catalog
        catalog_key = "xatu/catalog.json"
        self.storage.put_file_content(
            catalog_key,
            json.dumps(catalog, indent=2),
            dry_run=self.dry_run
        )
    
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
    
    def _load_catalog(self) -> Dict[str, Any]:
        """Load the main Iceberg catalog"""
        catalog_key = "xatu/catalog.json"
        catalog_content = self.storage.get_file_content(catalog_key)
        
        if catalog_content:
            return json.loads(catalog_content)
        
        # Create initial catalog
        return {
            'format-version': 1,
            'location': f"{self.storage_config['public_url']}/xatu",
            'tables': {},
            'updated-at': datetime.now().isoformat()
        }
    
    def _create_initial_metadata(self, table_name: str, network: str,
                                first_file: str, partition_value: Any) -> Dict:
        """Create initial Iceberg metadata for a new table"""
        table_uuid = str(uuid.uuid4())
        location = f"{self.storage_config['public_url']}/xatu/{network}/databases/default/{table_name}"
        
        # Get schema from the actual Parquet file
        schema = self._get_parquet_schema(first_file)
        
        return {
            "format-version": 2,
            "table-uuid": table_uuid,
            "location": location,
            "last-sequence-number": 0,
            "last-updated-ms": int(datetime.now().timestamp() * 1000),
            "last-column-id": len(schema.get('fields', [])),
            "current-schema-id": 0,
            "schemas": [schema],
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
            "refs": {
                "main": {
                    "snapshot-id": -1,
                    "type": "branch"
                }
            }
        }
    
    def _get_parquet_schema(self, file_path: str) -> Dict[str, Any]:
        """Extract Iceberg schema from a Parquet file"""
        # For remote files, we'd need to download temporarily
        # For now, return a basic schema structure
        return {
            "type": "struct",
            "schema-id": 0,
            "fields": []  # Would be populated from actual Parquet schema
        }
    
    def _get_partition_spec(self, table_name: str) -> Dict[str, Any]:
        """Get partition spec for a table based on configuration"""
        # This would be derived from table configuration
        # For now, return a basic partition spec
        return {
            "spec-id": 0,
            "fields": [{
                "source-id": 1,
                "field-id": 1000,
                "name": "partition_date",
                "transform": "identity"
            }]
        }
    
    def _add_file_to_metadata(self, metadata: Dict, file_path: str,
                             partition_value: Any, file_metadata: Dict) -> Dict:
        """Add a new file to existing metadata, creating a new snapshot"""
        # Clone metadata for new version
        new_metadata = json.loads(json.dumps(metadata))
        
        # Increment version
        current_version = new_metadata.get('format-version', 1)
        new_metadata['format-version'] = current_version
        
        # Update timestamp and sequence
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
                "spark.app.id": "xatu-exporter",
                "added-data-files": "1",
                "added-records": str(file_metadata.get('row_count', 0)),
                "added-files-size": str(file_metadata.get('file_size', 0)),
                "total-data-files": str(self._count_total_files(metadata) + 1),
                "total-records": str(self._count_total_records(metadata) + file_metadata.get('row_count', 0)),
                "total-files-size": str(self._count_total_size(metadata) + file_metadata.get('file_size', 0))
            },
            "manifest-list": self._create_manifest_list_path(metadata, snapshot_id)
        }
        
        # Add snapshot
        new_metadata['snapshots'].append(snapshot)
        new_metadata['current-snapshot-id'] = snapshot_id
        
        # Update refs
        if 'refs' not in new_metadata:
            new_metadata['refs'] = {}
        new_metadata['refs']['main'] = {
            "snapshot-id": snapshot_id,
            "type": "branch"
        }
        
        # Update snapshot log
        new_metadata['snapshot-log'].append({
            "timestamp-ms": snapshot['timestamp-ms'],
            "snapshot-id": snapshot_id
        })
        
        # Create manifest for the new file
        self._create_manifest_for_file(
            metadata, snapshot, file_path, partition_value, file_metadata
        )
        
        return new_metadata
    
    def _create_manifest_list_path(self, metadata: Dict, snapshot_id: int) -> str:
        """Generate manifest list path for a snapshot"""
        base_path = metadata['location']
        if base_path.startswith(self.storage_config['public_url']):
            base_path = base_path[len(self.storage_config['public_url']) + 1:]
        return f"{base_path}/metadata/snap-{snapshot_id}-manifest-list.json"
    
    def _create_manifest_for_file(self, metadata: Dict, snapshot: Dict,
                                 file_path: str, partition_value: Any,
                                 file_metadata: Dict) -> None:
        """Create manifest entry for a new file"""
        manifest_path = f"{metadata['location']}/metadata/manifest-{uuid.uuid4()}.json"
        
        # Create manifest entry
        manifest = {
            "entries": [{
                "status": "ADDED",
                "snapshot_id": snapshot['snapshot-id'],
                "sequence_number": snapshot['sequence-number'],
                "data_file": {
                    "content": "DATA",
                    "file_path": f"{self.storage_config['public_url']}/{file_path}",
                    "file_format": "PARQUET",
                    "partition": {"partition_date": partition_value},
                    "record_count": file_metadata.get('row_count', 0),
                    "file_size_in_bytes": file_metadata.get('file_size', 0),
                    "column_sizes": {},
                    "value_counts": {},
                    "null_value_counts": {},
                    "nan_value_counts": {},
                    "lower_bounds": {},
                    "upper_bounds": {}
                }
            }]
        }
        
        # Save manifest
        if manifest_path.startswith(self.storage_config['public_url']):
            manifest_key = manifest_path[len(self.storage_config['public_url']) + 1:]
        else:
            manifest_key = manifest_path
        
        self.storage.put_file_content(
            manifest_key,
            json.dumps(manifest, indent=2),
            dry_run=self.dry_run
        )
        
        # Create manifest list
        manifest_list = [{
            "manifest_path": manifest_path,
            "manifest_length": len(json.dumps(manifest)),
            "partition_spec_id": 0,
            "content": "data",
            "sequence_number": snapshot['sequence-number'],
            "min_sequence_number": snapshot['sequence-number'],
            "added_snapshot_id": snapshot['snapshot-id'],
            "added_files_count": 1,
            "existing_files_count": 0,
            "deleted_files_count": 0,
            "added_rows_count": file_metadata.get('row_count', 0),
            "existing_rows_count": 0,
            "deleted_rows_count": 0,
            "partitions": [{"partition_date": partition_value}]
        }]
        
        # Save manifest list
        manifest_list_key = snapshot['manifest-list']
        if manifest_list_key.startswith(self.storage_config['public_url']):
            manifest_list_key = manifest_list_key[len(self.storage_config['public_url']) + 1:]
        
        self.storage.put_file_content(
            manifest_list_key,
            json.dumps(manifest_list, indent=2),
            dry_run=self.dry_run
        )
    
    def _save_metadata(self, metadata_path: str, metadata: Dict) -> None:
        """Save metadata to storage"""
        version = len(metadata.get('metadata-log', [])) + 1
        metadata_key = f"{metadata_path}/v{version}.metadata.json"
        
        # Add to metadata log
        if 'metadata-log' not in metadata:
            metadata['metadata-log'] = []
        
        metadata['metadata-log'].append({
            "timestamp-ms": metadata['last-updated-ms'],
            "metadata-file": metadata_key
        })
        
        # Save metadata file
        self.storage.put_file_content(
            metadata_key,
            json.dumps(metadata, indent=2),
            dry_run=self.dry_run
        )
        
        # Update current symlink
        current_key = f"{metadata_path}/current.metadata.json"
        self.storage.put_file_content(
            current_key,
            json.dumps(metadata, indent=2),
            dry_run=self.dry_run
        )
    
    def _update_version_hint(self, metadata_path: str, version: int) -> None:
        """Update version hint file"""
        version_hint_key = f"{metadata_path}/version-hint.text"
        self.storage.put_file_content(
            version_hint_key,
            str(version),
            dry_run=self.dry_run
        )
    
    def _get_metadata_path(self, table_name: str, network: str) -> str:
        """Get the metadata path for a table"""
        return f"xatu/{network}/databases/default/{table_name}/metadata"
    
    def _load_manifest_list(self, manifest_list_path: str) -> List[Dict]:
        """Load manifest list from storage"""
        if manifest_list_path in self._manifest_cache:
            return self._manifest_cache[manifest_list_path]
        
        # Convert URL to storage key if needed
        if manifest_list_path.startswith(self.storage_config['public_url']):
            key = manifest_list_path[len(self.storage_config['public_url']) + 1:]
        else:
            key = manifest_list_path
        
        content = self.storage.get_file_content(key)
        if content:
            manifest_list = json.loads(content)
            self._manifest_cache[manifest_list_path] = manifest_list
            return manifest_list
        
        return []
    
    def _load_manifest(self, manifest_path: str) -> Dict:
        """Load manifest from storage"""
        if manifest_path in self._manifest_cache:
            return self._manifest_cache[manifest_path]
        
        # Convert URL to storage key if needed
        if manifest_path.startswith(self.storage_config['public_url']):
            key = manifest_path[len(self.storage_config['public_url']) + 1:]
        else:
            key = manifest_path
        
        content = self.storage.get_file_content(key)
        if content:
            manifest = json.loads(content)
            self._manifest_cache[manifest_path] = manifest
            return manifest
        
        return {"entries": []}
    
    def _count_total_files(self, metadata: Dict) -> int:
        """Count total files in all snapshots"""
        # Simple implementation - would need to deduplicate in production
        current_snapshot_id = metadata.get('current-snapshot-id')
        if not current_snapshot_id:
            return 0
        
        for snapshot in metadata.get('snapshots', []):
            if snapshot['snapshot-id'] == current_snapshot_id:
                return int(snapshot.get('summary', {}).get('total-data-files', 0))
        
        return 0
    
    def _count_total_records(self, metadata: Dict) -> int:
        """Count total records in all snapshots"""
        current_snapshot_id = metadata.get('current-snapshot-id')
        if not current_snapshot_id:
            return 0
        
        for snapshot in metadata.get('snapshots', []):
            if snapshot['snapshot-id'] == current_snapshot_id:
                return int(snapshot.get('summary', {}).get('total-records', 0))
        
        return 0
    
    def _count_total_size(self, metadata: Dict) -> int:
        """Count total size in all snapshots"""
        current_snapshot_id = metadata.get('current-snapshot-id')
        if not current_snapshot_id:
            return 0
        
        for snapshot in metadata.get('snapshots', []):
            if snapshot['snapshot-id'] == current_snapshot_id:
                return int(snapshot.get('summary', {}).get('total-files-size', 0))
        
        return 0