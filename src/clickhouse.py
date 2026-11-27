import os
import clickhouse_connect
from typing import Dict, Any, Optional, List
from datetime import datetime
import logging


class ClickHouseClient:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.client = self._connect()
        self.logger = logging.getLogger(__name__)
    
    def _connect(self):
        password = os.environ.get(self.config['password_env'])
        if not password:
            raise ValueError(f"Password not found in {self.config['password_env']}")
        
        return clickhouse_connect.get_client(
            host=self.config['host'],
            port=self.config['port'],
            username=self.config['user'],
            password=password,
            settings={
                'max_block_size': 65536,
                'max_threads': 8,
                'max_memory_usage': 10 * 1024 * 1024 * 1024,  # 10GB
            }
        )
    
    def export_to_parquet(self, query: str, output_path: str,
                         compression: str = 'zstd') -> Dict[str, Any]:
        """Export query results to Parquet file"""
        # Use ClickHouse's native Parquet export
        query_with_format = f"{query} FORMAT Parquet SETTINGS output_format_parquet_compression_method='{compression}'"
        
        # Count rows first
        count_query = f"SELECT count() as cnt FROM ({query})"
        row_count = self.client.query(count_query).first_row[0]
        
        self.logger.info(f"Exporting {row_count} rows to {output_path}")
        
        # Export to file
        start_time = datetime.now()
        with open(output_path, 'wb') as f:
            # Stream results to avoid memory issues
            result = self.client.raw_query(query_with_format)
            f.write(result)
        
        export_duration = (datetime.now() - start_time).total_seconds()
        
        # Return metadata about the export
        return {
            'row_count': row_count,
            'file_size': os.path.getsize(output_path),
            'export_time': datetime.now().isoformat(),
            'export_duration_seconds': export_duration,
            'compression': compression
        }
    
    def get_table_columns(self, database: str, table: str) -> List[str]:
        """Get list of columns for a table"""
        query = f"""
            SELECT name
            FROM system.columns
            WHERE database = '{database}'
              AND table = '{table}'
            ORDER BY position
        """
        result = self.client.query(query)
        return [row[0] for row in result.result_rows]
    
    def get_table_engine(self, database: str, table: str) -> str:
        """Get the engine type for a table"""
        query = f"""
            SELECT engine
            FROM system.tables
            WHERE database = '{database}'
              AND name = '{table}'
        """
        result = self.client.query(query)
        if result.result_rows:
            return result.result_rows[0][0]
        return ''
    
    def get_max_value(self, database: str, table: str, column: str, 
                     where_clause: Optional[str] = None) -> Optional[int]:
        """Get maximum value for a column"""
        where = f"WHERE {where_clause}" if where_clause else ""
        query = f"""
            SELECT max({column}) as max_val
            FROM {database}.{table}
            {where}
        """
        try:
            result = self.client.query(query)
            if result.result_rows and result.result_rows[0][0] is not None:
                return result.result_rows[0][0]
        except Exception as e:
            self.logger.error(f"Failed to get max value: {e}")
        return None
    
    def test_connection(self) -> bool:
        """Test if connection is working"""
        try:
            result = self.client.query("SELECT 1")
            return result.result_rows[0][0] == 1
        except Exception as e:
            self.logger.error(f"Connection test failed: {e}")
            return False
    
    def get_table_size(self, database: str, table: str) -> Dict[str, Any]:
        """Get size information for a table"""
        query = f"""
            SELECT 
                sum(rows) as total_rows,
                sum(bytes_on_disk) as bytes_on_disk,
                sum(data_compressed_bytes) as compressed_bytes,
                sum(data_uncompressed_bytes) as uncompressed_bytes,
                count() as parts_count
            FROM system.parts
            WHERE database = '{database}'
              AND table = '{table}'
              AND active
        """
        result = self.client.query(query)
        if result.result_rows:
            row = result.result_rows[0]
            return {
                'total_rows': row[0] or 0,
                'bytes_on_disk': row[1] or 0,
                'compressed_bytes': row[2] or 0,
                'uncompressed_bytes': row[3] or 0,
                'parts_count': row[4] or 0
            }
        return {
            'total_rows': 0,
            'bytes_on_disk': 0,
            'compressed_bytes': 0,
            'uncompressed_bytes': 0,
            'parts_count': 0
        }
    
    def check_partition_exists(self, database: str, table: str, 
                              partition: str) -> bool:
        """Check if a partition exists in the table"""
        query = f"""
            SELECT count() > 0
            FROM system.parts
            WHERE database = '{database}'
              AND table = '{table}'
              AND partition = '{partition}'
              AND active
        """
        try:
            result = self.client.query(query)
            return result.result_rows[0][0] == 1
        except Exception as e:
            self.logger.error(f"Failed to check partition: {e}")
            return False