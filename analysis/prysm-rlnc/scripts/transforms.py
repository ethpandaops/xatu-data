import pandas as pd
import numpy as np

def process_block_data(block_data, head_data=None):
    """
    Process block arrival data and combine with head data if available.

    Args:
        block_data (list): List of tuples from block arrival query
        head_data (list, optional): List of tuples from head arrival query

    Returns:
        DataFrame: Processed block arrival data
    """
    # Create DataFrames from query results
    columns = ['slot', 'slot_start_date_time', 'arrival_time', 'meta_client_name', 'meta_consensus_implementation']
    
    block_df = pd.DataFrame(block_data, columns=columns)
    block_df.rename(columns={'arrival_time': 'block_arrival_time'}, inplace=True)
    
    if head_data is not None:
        head_df = pd.DataFrame(head_data, columns=columns)
        head_df.rename(columns={'arrival_time': 'head_arrival_time'}, inplace=True)
        
        # Merge block and head data
        combined_df = pd.merge(
            block_df, 
            head_df[['slot', 'meta_client_name', 'head_arrival_time']], 
            on=['slot', 'meta_client_name'], 
            how='outer'
        )
    else:
        combined_df = block_df.copy()
        combined_df['head_arrival_time'] = None
    
    
    # Calculate minimum arrival time
    numeric_cols = ['block_arrival_time', 'head_arrival_time']
    combined_df['min_arrival_time'] = combined_df[numeric_cols].min(axis=1)
    
    # Ensure slot_start_date_time is a datetime
    combined_df['slot_start_date_time'] = pd.to_datetime(combined_df['slot_start_date_time'])
    
    return combined_df

def process_blob_data(blob_data):
    """
    Process blob data to get blob counts per slot.
    
    Args:
        blob_data (list): List of tuples from blob query
        
    Returns:
        DataFrame: DataFrame with slot and blob_count
    """
    blob_df = pd.DataFrame(blob_data, columns=['slot', 'highest_index'])
    
    # Calculate blob count (highest_index + 1, or 0 if no blobs)
    blob_df['blob_count'] = blob_df['highest_index'].apply(
        lambda x: 0 if pd.isna(x) else int(x) + 1
    )
    
    return blob_df[['slot', 'blob_count']]

def calculate_arrival_metrics(combined_df, blob_df=None):
    """
    Calculate metrics for block arrival times.
    
    Args:
        combined_df (DataFrame): Processed block arrival data
        blob_df (DataFrame, optional): Blob count data
        
    Returns:
        DataFrame: Aggregated metrics per slot
    """
    # Group by slot
    metrics_df = combined_df.groupby('slot').agg({
        'slot_start_date_time': 'first',  # Keep timestamp
        'min_arrival_time': [
            ('min', 'min'),
            ('p05', lambda x: np.percentile(x, 5) if len(x) > 0 else np.nan),
            ('p50', lambda x: np.percentile(x, 50) if len(x) > 0 else np.nan),
            ('mean', 'mean'),
            ('p95', lambda x: np.percentile(x, 95) if len(x) > 0 else np.nan),
            ('max', 'max'),
            ('count', 'count')
        ]
    })
    
    # Flatten multi-index columns
    metrics_df.columns = ['slot_start_date_time', 
                          'min_arrival_time', 'p05_arrival_time', 
                          'p50_arrival_time', 'mean_arrival_time', 
                          'p95_arrival_time', 'max_arrival_time',
                          'node_count']
    
    # Reset index to make slot a regular column
    metrics_df = metrics_df.reset_index()
    
    # If blob data is provided, merge it with metrics
    if blob_df is not None:
        metrics_df = pd.merge(metrics_df, blob_df, on='slot', how='left')
        metrics_df['blob_count'] = metrics_df['blob_count'].fillna(0)
    else:
        metrics_df['blob_count'] = 0
        
    return metrics_df

def compare_networks(before_metrics, after_metrics):
    """
    Compare metrics between two networks (before and after RLNC).
    
    Args:
        before_metrics (DataFrame): Metrics from before network
        after_metrics (DataFrame): Metrics from after network
        
    Returns:
        dict: Comparison statistics
    """
    comparison = {}
    
    # Calculate average metrics for both networks
    for metric in ['min_arrival_time', 'p05_arrival_time', 'p50_arrival_time', 
                   'mean_arrival_time', 'p95_arrival_time', 'max_arrival_time']:
        before_avg = before_metrics[metric].mean()
        after_avg = after_metrics[metric].mean()
        
        # Calculate improvement percentage
        if before_avg > 0:
            improvement = (before_avg - after_avg) / before_avg * 100
        else:
            improvement = 0
            
        comparison[metric] = {
            'before': before_avg,
            'after': after_avg,
            'difference': before_avg - after_avg,
            'improvement_percent': improvement
        }
    
    # Calculate average metrics grouped by blob count
    # Use only numeric columns to avoid TypeError with string columns
    numeric_columns = ['min_arrival_time', 'p05_arrival_time', 'p50_arrival_time',
                   'mean_arrival_time', 'p95_arrival_time', 'max_arrival_time',
                   'node_count']

    before_by_blob = before_metrics.groupby('blob_count')[numeric_columns].mean().reset_index()
    after_by_blob = after_metrics.groupby('blob_count')[numeric_columns].mean().reset_index()
    
    # Add blob count comparison
    comparison['by_blob_count'] = {}
    
    # Find common blob counts
    common_blob_counts = set(before_by_blob['blob_count']).intersection(set(after_by_blob['blob_count']))
    
    for blob_count in common_blob_counts:
        before_row = before_by_blob[before_by_blob['blob_count'] == blob_count].iloc[0]
        after_row = after_by_blob[after_by_blob['blob_count'] == blob_count].iloc[0]
        
        comparison['by_blob_count'][blob_count] = {}
        
        for metric in ['min_arrival_time', 'p05_arrival_time', 'p50_arrival_time', 
                       'mean_arrival_time', 'p95_arrival_time', 'max_arrival_time']:
            before_val = before_row[metric]
            after_val = after_row[metric]
            
            if before_val > 0:
                improvement = (before_val - after_val) / before_val * 100
            else:
                improvement = 0
                
            comparison['by_blob_count'][blob_count][metric] = {
                'before': before_val,
                'after': after_val,
                'difference': before_val - after_val,
                'improvement_percent': improvement
            }
    
    return comparison