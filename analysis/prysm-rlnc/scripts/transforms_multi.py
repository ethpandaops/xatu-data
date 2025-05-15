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

def compare_networks_multi(metrics_dict):
    """
    Compare metrics across multiple networks.
    
    Args:
        metrics_dict (dict): Dictionary with network keys and metrics DataFrames as values
        
    Returns:
        dict: Comparison statistics
    """
    comparison = {}
    network_keys = list(metrics_dict.keys())
    
    # Calculate average metrics for each network
    for network in network_keys:
        comparison[network] = {}
        metrics_df = metrics_dict[network]
        
        for metric in ['min_arrival_time', 'p05_arrival_time', 'p50_arrival_time', 
                      'mean_arrival_time', 'p95_arrival_time', 'max_arrival_time']:
            comparison[network][metric] = metrics_df[metric].mean()
    
    # Calculate pairwise comparisons between networks
    for i, network1 in enumerate(network_keys):
        for j, network2 in enumerate(network_keys):
            if i < j:  # Only compare each pair once
                key = f"{network1}_vs_{network2}"
                comparison[key] = {}
                
                for metric in ['min_arrival_time', 'p05_arrival_time', 'p50_arrival_time', 
                              'mean_arrival_time', 'p95_arrival_time', 'max_arrival_time']:
                    val1 = comparison[network1][metric]
                    val2 = comparison[network2][metric]
                    
                    # Calculate difference and percentage
                    if val1 > 0:
                        improvement = (val1 - val2) / val1 * 100
                    else:
                        improvement = 0
                        
                    comparison[key][metric] = {
                        network1: val1,
                        network2: val2,
                        'difference': val1 - val2,
                        'improvement_percent': improvement
                    }
    
    # Add block size range comparison
    # Create a combined comparison by block size
    comparison['by_block_size'] = {}
    
    # Define block size bins
    size_bins = [0, 50*1024, 100*1024, 200*1024, 500*1024, 1000*1024, float('inf')]
    size_labels = ['0-50KB', '50-100KB', '100-200KB', '200-500KB', '500KB-1MB', '>1MB']
    
    # Process each network's metrics by block size
    network_bin_stats = {}
    
    for network in network_keys:
        metrics_df = metrics_dict[network]
        if 'block_total_bytes' in metrics_df.columns:
            metrics_temp = metrics_df.copy()
            metrics_temp.loc[:, 'block_size_bin'] = pd.cut(metrics_temp['block_total_bytes'], 
                                                  bins=size_bins, labels=size_labels)
            
            # Group by block size bin
            numeric_columns = ['min_arrival_time', 'p05_arrival_time', 'p50_arrival_time',
                           'mean_arrival_time', 'p95_arrival_time', 'max_arrival_time',
                           'node_count']
            
            by_size = metrics_temp.groupby('block_size_bin', observed=True)[numeric_columns].mean().reset_index()
            network_bin_stats[network] = by_size.copy()
    
    # Find sizes present in any network
    all_size_bins = set()
    for network, stats in network_bin_stats.items():
        all_size_bins.update(stats['block_size_bin'].unique())
    
    # Create comparisons for each size bin
    for size_bin in all_size_bins:
        comparison['by_block_size'][size_bin] = {}
        
        # Get stats for this bin across networks
        bin_stats = {}
        for network, stats in network_bin_stats.items():
            bin_data = stats[stats['block_size_bin'] == size_bin]
            if not bin_data.empty:
                bin_stats[network] = bin_data.iloc[0]
        
        # Create pairwise comparisons for this bin
        networks_with_data = list(bin_stats.keys())
        for i, network1 in enumerate(networks_with_data):
            for j, network2 in enumerate(networks_with_data):
                if i < j:  # Only compare each pair once
                    key = f"{network1}_vs_{network2}"
                    comparison['by_block_size'][size_bin][key] = {}
                    
                    for metric in ['min_arrival_time', 'p05_arrival_time', 'p50_arrival_time', 
                                 'mean_arrival_time', 'p95_arrival_time', 'max_arrival_time']:
                        val1 = bin_stats[network1][metric]
                        val2 = bin_stats[network2][metric]
                        
                        # Calculate difference and percentage
                        if val1 > 0:
                            improvement = (val1 - val2) / val1 * 100
                        else:
                            improvement = 0
                            
                        comparison['by_block_size'][size_bin][key][metric] = {
                            network1: val1,
                            network2: val2,
                            'difference': val1 - val2,
                            'improvement_percent': improvement
                        }
    
    return comparison