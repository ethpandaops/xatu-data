# Prysm RLNC Block Arrivals Analysis Plan

## Overview

This plan outlines the steps to create a series of Jupyter notebooks to analyze the impact of Reed-Solomon Linear Network Coding (RLNC) implementation by Prysm on beacon block propagation times. The analysis will compare block arrival times between two different networks: NFT-Devnet-2 (before RLNC) and NFT-Devnet-3 (after RLNC).

## Project Setup

### Directory Structure

```
analysis/pectra/rlnc_arrivals/
├── example.env                 # Environment variables template
├── notebook.ipynb              # Main notebook for visualizations and analysis
├── scripts/
│   ├── clickhouse.py           # Module for querying Clickhouse
│   ├── bootstrap.py            # Module for initializing the analysis
│   └── transforms.py           # Module for data transformation functions
```

### Required Files

1. Create `example.env` with the following:
```
XATU_CLICKHOUSE_USERNAME=your_username
XATU_CLICKHOUSE_PASSWORD=your_password
XATU_CLICKHOUSE_HOST=clickhouse.xatu.ethpandaops.io
```

2. Create the main notebook `notebook.ipynb`
3. Create the script modules

## Data Collection Approach

1. **Network and Time Range Configuration**: 
   - Define in the first cell of the notebook:
   ```python
   config = {
     "before": {
       "network": "nft-devnet-2",
       "start_at_slot": X,  # Replace with actual slot number
       "finish_at_slot": Y  # Replace with actual slot number
     },
     "after": {
       "network": "nft-devnet-3",
       "start_at_slot": X,  # Replace with actual slot number
       "finish_at_slot": Y  # Replace with actual slot number
     }
   }
   ```

2. **Target Dataset**: Focus on the `beacon_api_eth_v1_events_block` table from the ethPandaOps Clickhouse cluster
   - This data represents block arrival times reported by beacon nodes

3. **Filtering**:
   - Focus only on block events (not head events or blob sidecars)
   - Include all client nodes in the analysis

## Analysis Steps

### 1. Bootstrap Module (`bootstrap.py`)

This module will handle initialization tasks:
- Loading environment variables
- Setting up the database connection
- Processing the config with network and slot ranges
- Creating helper functions for visualization branding

### 2. Clickhouse Module (`clickhouse.py`)

This module will handle data retrieval:
- Connect to the ClickHouse cluster
- Define query functions to fetch block arrival data
- Handle network-specific queries based on the config

Key queries:
- Block arrival times from `beacon_api_eth_v1_events_block` for both networks
- Filter by slot ranges as defined in the config

### 3. Transforms Module (`transforms.py`)

This module will handle data processing:
- Normalize timestamps and calculate propagation times
- Calculate statistical metrics for block arrival times
- Create functions to label data as "before" (NFT-Devnet-2) or "after" (NFT-Devnet-3)
- Prepare data for various visualization formats

Functions needed:
- Data preparation for boxplots, violin plots, and histograms
- Statistical analysis for percentile comparisons
- Blob count analysis functions

### 4. Main Notebook (`notebook.ipynb`)

The notebook will tell a cohesive story about the RLNC implementation:

1. **Introduction**:
   - Brief summary of how the data is processed and visualized
   - Clear statement of analysis goals

2. **Data Collection**:
   - Fetch block arrival data for both networks (NFT-Devnet-2 and NFT-Devnet-3)
   - Show summary statistics of the collected data

3. **Analysis Sections**:
   - **Overall Block Arrival Time Comparison**: 
     - Box plots, violin plots and histograms comparing both networks
     - Statistical significance tests

   - **Percentile Analysis**: 
     - Compare changes in p05, p50, p95 metrics
     - Highlight differences at different percentiles

   - **Blob Count Impact**:
     - Analyze if performance differs based on blob count
     - Group blocks by blob count and compare propagation times

## Implementation Details

### Required Python Packages

```python
# Required packages
import dotenv
import os
import pandas as pd
import numpy as np
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import polars as pl
from sqlalchemy import create_engine, text
```

### Key Visualizations

1. **NFT-Devnet-2 vs NFT-Devnet-3 Comparisons**:
   - Box plots showing arrival time distribution
   - ECDF plots to visualize full distribution changes
   - Bar charts of percentile changes

2. **Time Series Visualizations**:
   - Plot of arrival times across the slot ranges
   - Rolling averages to smooth slot-to-slot variations

### Data Schema Information

When retrieving data from the `beacon_api_eth_v1_events_block` table, focus on these columns:
- `slot`: The slot number of the block
- `slot_start_date_time`: The timestamp when the slot started
- `propagation_slot_start_diff`: The time difference between when the block was observed and when the slot started
- `meta_client_name`: The name of the client that observed the block

## Next Steps for Implementation

1. Create the directory structure and initial files
2. Implement the data collection modules
3. Develop the transformation functions
4. Create the visualizations

The implementation will be based on the `prysm-batch-publish-blocks.ipynb` notebook, adapting the code to focus on comparing the two networks rather than a before/after analysis on the same network.