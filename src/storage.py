import os
import boto3
from typing import Dict, Any, Optional, List
from pathlib import Path
import logging
from botocore.exceptions import ClientError


class R2Storage:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.client = self._create_client()
        self.bucket = config['bucket']
        self.public_url = config['public_url']
        self.logger = logging.getLogger(__name__)
    
    def _create_client(self):
        access_key = os.environ.get(self.config['access_key_env'])
        secret_key = os.environ.get(self.config['secret_key_env'])
        
        if not access_key or not secret_key:
            raise ValueError(f"AWS credentials not found in environment variables")
        
        return boto3.client(
            's3',
            endpoint_url=self.config['endpoint'],
            aws_access_key_id=access_key,
            aws_secret_access_key=secret_key,
            region_name='auto'
        )
    
    def upload_file(self, local_path: str, remote_key: str, 
                   dry_run: bool = False) -> str:
        """Upload file to R2 and return public URL"""
        if dry_run:
            self.logger.info(f"[DRY RUN] Would upload {local_path} to {remote_key}")
            return f"{self.public_url}/{remote_key}"
        
        try:
            # Get file size for progress logging
            file_size = os.path.getsize(local_path)
            self.logger.info(f"Uploading {file_size:,} bytes to {remote_key}")
            
            # Upload with metadata
            self.client.upload_file(
                local_path, 
                self.bucket, 
                remote_key,
                ExtraArgs={
                    'ContentType': 'application/octet-stream',
                    'Metadata': {
                        'uploaded-by': 'xatu-exporter',
                        'upload-time': str(os.path.getmtime(local_path))
                    }
                }
            )
            
            self.logger.info(f"Successfully uploaded to {remote_key}")
            return f"{self.public_url}/{remote_key}"
            
        except ClientError as e:
            self.logger.error(f"Failed to upload {local_path}: {e}")
            raise
    
    def file_exists(self, remote_key: str) -> bool:
        """Check if file exists in R2"""
        try:
            self.client.head_object(Bucket=self.bucket, Key=remote_key)
            return True
        except ClientError as e:
            if e.response['Error']['Code'] == '404':
                return False
            # For other errors, log and return False
            self.logger.error(f"Error checking file existence: {e}")
            return False
    
    def get_file_content(self, remote_key: str) -> Optional[str]:
        """Get file content as string"""
        try:
            response = self.client.get_object(Bucket=self.bucket, Key=remote_key)
            return response['Body'].read().decode('utf-8')
        except ClientError as e:
            if e.response['Error']['Code'] == 'NoSuchKey':
                return None
            self.logger.error(f"Error reading file {remote_key}: {e}")
            return None
    
    def get_file_content_bytes(self, remote_key: str) -> Optional[bytes]:
        """Get file content as bytes"""
        try:
            response = self.client.get_object(Bucket=self.bucket, Key=remote_key)
            return response['Body'].read()
        except ClientError as e:
            if e.response['Error']['Code'] == 'NoSuchKey':
                return None
            self.logger.error(f"Error reading file {remote_key}: {e}")
            return None
    
    def put_file_content(self, remote_key: str, content: str, 
                        dry_run: bool = False) -> bool:
        """Put string content to a file"""
        if dry_run:
            self.logger.info(f"[DRY RUN] Would write content to {remote_key}")
            return True
        
        try:
            self.client.put_object(
                Bucket=self.bucket,
                Key=remote_key,
                Body=content.encode('utf-8'),
                ContentType='application/json' if remote_key.endswith('.json') else 'text/plain',
                Metadata={
                    'uploaded-by': 'xatu-exporter',
                }
            )
            return True
        except ClientError as e:
            self.logger.error(f"Failed to put content to {remote_key}: {e}")
            return False
    
    def list_files(self, prefix: str, max_results: Optional[int] = None) -> List[str]:
        """List all files under a prefix"""
        files = []
        paginator = self.client.get_paginator('list_objects_v2')
        
        page_iterator = paginator.paginate(
            Bucket=self.bucket, 
            Prefix=prefix,
            PaginationConfig={
                'MaxItems': max_results
            } if max_results else {}
        )
        
        try:
            for page in page_iterator:
                if 'Contents' in page:
                    files.extend([obj['Key'] for obj in page['Contents']])
        except ClientError as e:
            self.logger.error(f"Error listing files with prefix {prefix}: {e}")
        
        return files
    
    def delete_file(self, remote_key: str, dry_run: bool = False) -> bool:
        """Delete a file from R2"""
        if dry_run:
            self.logger.info(f"[DRY RUN] Would delete {remote_key}")
            return True
        
        try:
            self.client.delete_object(Bucket=self.bucket, Key=remote_key)
            self.logger.info(f"Deleted {remote_key}")
            return True
        except ClientError as e:
            self.logger.error(f"Failed to delete {remote_key}: {e}")
            return False
    
    def get_file_metadata(self, remote_key: str) -> Optional[Dict[str, Any]]:
        """Get metadata for a file"""
        try:
            response = self.client.head_object(Bucket=self.bucket, Key=remote_key)
            return {
                'size': response['ContentLength'],
                'last_modified': response['LastModified'],
                'etag': response['ETag'],
                'content_type': response.get('ContentType'),
                'metadata': response.get('Metadata', {})
            }
        except ClientError as e:
            if e.response['Error']['Code'] == '404':
                return None
            self.logger.error(f"Error getting metadata for {remote_key}: {e}")
            return None
    
    def copy_file(self, source_key: str, dest_key: str, 
                  dry_run: bool = False) -> bool:
        """Copy a file within the bucket"""
        if dry_run:
            self.logger.info(f"[DRY RUN] Would copy {source_key} to {dest_key}")
            return True
        
        try:
            copy_source = {'Bucket': self.bucket, 'Key': source_key}
            self.client.copy_object(
                CopySource=copy_source,
                Bucket=self.bucket,
                Key=dest_key
            )
            self.logger.info(f"Copied {source_key} to {dest_key}")
            return True
        except ClientError as e:
            self.logger.error(f"Failed to copy {source_key} to {dest_key}: {e}")
            return False
    
    def download_file(self, remote_key: str, local_path: str) -> bool:
        """Download a file from R2"""
        try:
            self.client.download_file(self.bucket, remote_key, local_path)
            self.logger.info(f"Downloaded {remote_key} to {local_path}")
            return True
        except ClientError as e:
            self.logger.error(f"Failed to download {remote_key}: {e}")
            return False