import pandas as pd
import numpy as np

def process_block_data(block_data):
    """
    Process block arrival data.

    Args:
        block_data (list): List of tuples from block arrival query

    Returns:
        DataFrame: Processed block arrival data
    """
    # Create DataFrames from query results
    columns = ['slot', 'slot_start_date_time', 'arrival_time', 'meta_client_name', 'meta_consensus_implementation']
    
    block_df = pd.DataFrame(block_data, columns=columns)
    block_df.rename(columns={'arrival_time': 'block_arrival_time'}, inplace=True)
    
    # Use block arrival time as the arrival time
    block_df['min_arrival_time'] = block_df['block_arrival_time']
    
    # Ensure slot_start_date_time is a datetime
    block_df['slot_start_date_time'] = pd.to_datetime(block_df['slot_start_date_time'])
    
    return block_df

def process_block_size_data(block_size_data):
    """
    Process block size data.
    
    Args:
        block_size_data (list): List of tuples from block size data query
        
    Returns:
        DataFrame: Processed block size data
    """
    columns = ['slot', 'block_total_bytes', 'num_observations', 
               'max', 'p95', 'average', 'p50', 'p05', 'min']
    
    # Create DataFrame from query results
    block_size_df = pd.DataFrame(block_size_data, columns=columns)
    
    # Convert numeric columns to appropriate types
    numeric_cols = ['block_total_bytes', 'num_observations', 
                    'max', 'p95', 'average', 'p50', 'p05', 'min']
    for col in numeric_cols:
        block_size_df[col] = pd.to_numeric(block_size_df[col])
    
    return block_size_df

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

def calculate_arrival_metrics(combined_df, block_size_df=None):
    """
    Calculate metrics for block arrival times.
    
    Args:
        combined_df (DataFrame): Processed block arrival data
        block_size_df (DataFrame, optional): Block size data
        
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
    
    # If block size data is provided, merge it with metrics
    if block_size_df is not None:
        # We only need to merge the block_total_bytes column
        block_size_df_slim = block_size_df[['slot', 'block_total_bytes']].copy()
        metrics_df = pd.merge(metrics_df, block_size_df_slim, on='slot', how='left')
    else:
        metrics_df['block_total_bytes'] = np.nan
        
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
    
    # Add block size range comparison
    if 'block_total_bytes' in before_metrics.columns and 'block_total_bytes' in after_metrics.columns:
        # Define block size bins
        size_bins = [0, 50*1024, 100*1024, 200*1024, 500*1024, 1000*1024, float('inf')]
        size_labels = ['0-50KB', '50-100KB', '100-200KB', '200-500KB', '500KB-1MB', '>1MB']
        
        # Add block size bin column
        before_metrics_temp = before_metrics.copy()
        after_metrics_temp = after_metrics.copy()
        
        before_metrics_temp['block_size_bin'] = pd.cut(before_metrics_temp['block_total_bytes'], 
                                                 bins=size_bins, labels=size_labels)
        after_metrics_temp['block_size_bin'] = pd.cut(after_metrics_temp['block_total_bytes'], 
                                                bins=size_bins, labels=size_labels)
        
        # Group by block size bin
        numeric_columns = ['min_arrival_time', 'p05_arrival_time', 'p50_arrival_time',
                       'mean_arrival_time', 'p95_arrival_time', 'max_arrival_time',
                       'node_count']
        
        before_by_size = before_metrics_temp.groupby('block_size_bin')[numeric_columns].mean().reset_index()
        after_by_size = after_metrics_temp.groupby('block_size_bin')[numeric_columns].mean().reset_index()
        
        # Add block size comparison
        comparison['by_block_size'] = {}
        
        # Find common block size bins
        common_sizes = set(before_by_size['block_size_bin']).intersection(set(after_by_size['block_size_bin']))
        
        for size_bin in common_sizes:
            before_row = before_by_size[before_by_size['block_size_bin'] == size_bin].iloc[0]
            after_row = after_by_size[after_by_size['block_size_bin'] == size_bin].iloc[0]
            
            comparison['by_block_size'][size_bin] = {}
            
            for metric in ['min_arrival_time', 'p05_arrival_time', 'p50_arrival_time', 
                           'mean_arrival_time', 'p95_arrival_time', 'max_arrival_time']:
                before_val = before_row[metric]
                after_val = after_row[metric]
                
                if before_val > 0:
                    improvement = (before_val - after_val) / before_val * 100
                else:
                    improvement = 0
                    
                comparison['by_block_size'][size_bin][metric] = {
                    'before': before_val,
                    'after': after_val,
                    'difference': before_val - after_val,
                    'improvement_percent': improvement
                }
    
    return comparison