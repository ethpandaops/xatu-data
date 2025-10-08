#!/bin/bash

# Generate llms/parquet/llms.txt - focused on public Parquet file access
# Usage: ./scripts/generate-llms-parquet.sh [output_file] [config_file] [detail_level]

set -e

# Default parameters
output_file="${1:-llms/parquet/llms.txt}"
config_file="${2:-config.yaml}"
detail_level="${3:-concise}"  # concise or full

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/log.sh"

log "Generating Parquet-focused llms.txt ($detail_level) at $output_file..."

# Ensure output directory exists
mkdir -p "$(dirname "$output_file")"

# Generate the file
cat > "$output_file" << 'EOF'
# Xatu Parquet Data
> Public Ethereum network data in Parquet format - no authentication required

## Looking for ClickHouse Access?
**If you need direct database access with lower latency and no redactions**, see https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/clickhouse/llms.txt for ClickHouse-specific documentation.

## Overview

Xatu provides comprehensive Ethereum network data as publicly accessible Parquet files:
- **No authentication required** - freely accessible to everyone
- **Updated daily** with 1-3 day delay
- **Privacy-conscious** - some columns redacted for user protection
- **Organized by network** - mainnet, holesky, sepolia, hoodi

## ⚠️ Critical: Partitioning Requirements

**ALWAYS filter on the partitioning column** when querying:
- Datetime partitions: Filter on date/time columns (e.g., `slot_start_date_time`)
- Integer partitions: Filter on numeric ranges (e.g., `block_number`)
- **Failure to partition = extremely slow queries** on billions of rows

**NEVER use wildcards (*) for file paths:**
- ❌ `*.parquet` will NOT work
- ✅ Use explicit paths: `{20,21,22}.parquet`
- ✅ Use ranges: `{20000..20010}000.parquet`
- The endpoint is NOT S3-compatible

## URL Patterns

### Datetime Partitioned Tables
```
https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/YYYY/M/D.parquet
https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/YYYY/M/D/H.parquet
```

### Integer Partitioned Tables
```
https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/INTERVAL/CHUNK_NUMBER.parquet
```

### Parameters
- **NETWORK**: `mainnet`, `holesky`, `sepolia`, `hoodi`
- **DATABASE**: Usually `default`
- **TABLE**: Table name (see datasets below)
- **YYYY/M/D/H**: Year/Month/Day/Hour for datetime partitioning
- **INTERVAL**: Partition size (e.g., `1000` for blocks)
- **CHUNK_NUMBER**: Partition number (e.g., `0`, `1000`, `2000`)

## Quick Start Examples

### Single Day Query (Python + Pandas)
```python
import pandas as pd

url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet"
df = pd.read_parquet(url)
print(df.head())
```

### Multiple Days (Python + Polars)
```python
import polars as pl
from datetime import datetime, timedelta

# Generate explicit URLs (NEVER use wildcards)
base = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/"
start = datetime(2024, 4, 1)
urls = [f"{base}{(start + timedelta(days=i)).strftime('%Y/%-m/%-d')}.parquet"
        for i in range(3)]  # 3 days

# Lazy load and query
df = pl.concat([pl.scan_parquet(url) for url in urls])
result = df.select(["slot", "block_root", "propagation_slot_start_diff"]).collect()
```

### ClickHouse + Parquet URL
```sql
-- Single file
SELECT
    toDate(slot_start_date_time) AS date,
    quantile(0.50)(propagation_slot_start_diff) AS median_ms
FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet', 'Parquet')
GROUP BY date;

-- Multiple files with explicit glob (NOT wildcards)
SELECT COUNT(*)
FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/{1,2,3}.parquet', 'Parquet');

-- Integer partitioned (blocks)
SELECT COUNT(*)
FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/{19000..19010}000.parquet', 'Parquet');
```

### R + Arrow
```r
library(arrow)

url <- "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet"
df <- read_parquet(url)
head(df)
```

EOF

# Add datasets section
cat >> "$output_file" << 'EOF'

## Available Datasets

EOF

# Extract PUBLIC dataset information with brief descriptions
yq e '.datasets[] | select(.availability[] == "public") | "### " + .name + "\n> " + .description + "\n\n**Table Prefix**: `" + .tables.prefix + "`\n"' "$config_file" >> "$output_file"

cat >> "$output_file" << 'EOF'

## Table Catalog

**Find specific tables and their partitioning:**

EOF

# Generate table listing - only public tables with partitioning info
yq e '.tables[] | "### `" + .name + "`\n- **Partitioning**: `" + .partitioning.column + "` (" + .partitioning.type + ", " + .partitioning.interval + ")\n- **Networks**: " + (.networks | to_entries | map(.key) | join(", ")) + "\n- **Description**: " + .description + "\n"' "$config_file" >> "$output_file"

cat >> "$output_file" << 'EOF'

## Schema Discovery

### View Table Schema
```bash
# Get CREATE TABLE statement for any table
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/TABLE_NAME.sql

# Example: beacon block events
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/beacon_api_eth_v1_events_block.sql
```

### List All Available Tables
```bash
# List all schemas
curl -s https://api.github.com/repos/ethpandaops/xatu-data/contents/schema/clickhouse/default | jq -r '.[].name | select(endswith(".sql"))'
```

### Common Fields
Most tables include:
- `meta_client_name` - Client that collected the data
- `meta_client_id` - Unique session ID
- `meta_network_name` - Network (mainnet, holesky, etc.)
- `event_date_time` - When event was recorded
- Partition column (check table details above)

## Common Query Patterns

### Network Timing Analysis
```python
# Analyze block propagation across the network
import polars as pl

url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet"
df = pl.read_parquet(url)

# Calculate propagation statistics by slot
stats = df.group_by("slot").agg([
    pl.col("propagation_slot_start_diff").min().alias("min_ms"),
    pl.col("propagation_slot_start_diff").quantile(0.5).alias("p50_ms"),
    pl.col("propagation_slot_start_diff").quantile(0.95).alias("p95_ms"),
    pl.col("meta_client_name").n_unique().alias("observer_count")
])
```

### Joining Data Sources
```sql
-- Join canonical blocks with event observations
WITH
    blocks AS (
        SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block/2024/4/1.parquet', 'Parquet')
    ),
    events AS (
        SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet', 'Parquet')
    )
SELECT
    b.slot,
    b.proposer_index,
    COUNT(DISTINCT e.meta_client_name) as observers,
    MIN(e.propagation_slot_start_diff) as fastest_observation_ms
FROM blocks b
LEFT JOIN events e ON b.slot = e.slot
GROUP BY b.slot, b.proposer_index
ORDER BY b.slot;
```

## Data Freshness & Updates

- **Update frequency**: Daily
- **Delay**: 1-3 days behind current time
- **Privacy**: Some sensitive fields redacted
- **Historical data**: Stable, not rewritten
- **Retention**: Check network date ranges in table catalog above

EOF

# Add full version content
if [ "$detail_level" = "full" ]; then
    cat >> "$output_file" << 'EOF'

## Advanced Examples

### DuckDB Analysis
```sql
-- Install DuckDB httpfs extension
INSTALL httpfs;
LOAD httpfs;

-- Query Parquet files directly
SELECT
    DATE_TRUNC('hour', slot_start_date_time) as hour,
    COUNT(*) as blocks,
    APPROX_QUANTILE(propagation_slot_start_diff, 0.5) as median_prop
FROM read_parquet('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet')
GROUP BY hour
ORDER BY hour;
```

### Apache Spark (PySpark)
```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("XatuAnalysis").getOrCreate()

# Read multiple days
base_url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/"
urls = [f"{base_url}{day}.parquet" for day in range(1, 8)]

df = spark.read.parquet(*urls)

# Analyze propagation
df.groupBy("slot") \
    .agg(
        {"propagation_slot_start_diff": "min"},
        {"propagation_slot_start_diff": "avg"}
    ) \
    .show()
```

### Julia with DataFrames
```julia
using Parquet2
using DataFrames
using HTTP
using Statistics

# Download and read
url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet"
response = HTTP.get(url)
df = Parquet2.Dataset(IOBuffer(response.body)) |> DataFrame

# Analyze
grouped = combine(groupby(df, :slot),
    :propagation_slot_start_diff => mean => :avg_prop,
    :propagation_slot_start_diff => std => :std_prop
)
```

## Performance Optimization

### Efficient Multi-Day Queries
```python
# Use Polars lazy evaluation for memory efficiency
import polars as pl
from datetime import datetime, timedelta

def generate_urls(start_date, days):
    base = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/"
    return [
        f"{base}{(start_date + timedelta(days=i)).strftime('%Y/%-m/%-d')}.parquet"
        for i in range(days)
    ]

# Lazy load 30 days without loading into memory
urls = generate_urls(datetime(2024, 4, 1), 30)
lazy_frames = [pl.scan_parquet(url) for url in urls]

# Filter and aggregate without loading all data
result = (
    pl.concat(lazy_frames)
    .filter(pl.col("meta_client_name") == "lighthouse")
    .group_by("slot")
    .agg([
        pl.col("propagation_slot_start_diff").min().alias("min_prop"),
        pl.col("propagation_slot_start_diff").median().alias("median_prop")
    ])
    .collect()  # Only now do we execute
)
```

### Caching Strategy
```python
# Cache frequently accessed data locally
import pandas as pd
from pathlib import Path
import requests

def cached_parquet(url, cache_dir="./cache"):
    cache_path = Path(cache_dir) / url.split("/")[-1]
    cache_path.parent.mkdir(exist_ok=True)

    if not cache_path.exists():
        response = requests.get(url)
        cache_path.write_bytes(response.content)

    return pd.read_parquet(cache_path)

# Use cached version
df = cached_parquet("https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet")
```

## Data Exploration Patterns

### Finding Data Availability
```bash
# Check what dates are available for a table
# Note: You need to enumerate dates, wildcards don't work

for month in {1..12}; do
    for day in {1..31}; do
        url="https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/$month/$day.parquet"
        if curl -s --head "$url" | grep -q "200 OK"; then
            echo "Available: 2024-$month-$day"
        fi
    done
done
```

### Schema Inspection
```python
import pyarrow.parquet as pq
import requests
from io import BytesIO

# Inspect schema without downloading entire file
url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet"
response = requests.get(url, stream=True)

# Read only metadata
parquet_file = pq.ParquetFile(BytesIO(response.content))
print("Schema:", parquet_file.schema)
print("Number of rows:", parquet_file.metadata.num_rows)
print("Number of row groups:", parquet_file.metadata.num_row_groups)

# Get first few rows only
table = parquet_file.read_row_group(0, columns=['slot', 'block_root', 'propagation_slot_start_diff'])
df = table.to_pandas()
```

## Cross-Dataset Joins

### Joining Beacon and Execution Data
```python
import polars as pl

# Load both datasets
beacon_url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block/2024/4/1.parquet"
execution_url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/19000000.parquet"

beacon = pl.read_parquet(beacon_url)
execution = pl.read_parquet(execution_url)

# Join on block number
joined = beacon.join(
    execution,
    left_on="execution_block_number",
    right_on="block_number",
    how="inner"
)

# Analyze
result = joined.select([
    "slot",
    "execution_block_number",
    "gas_used",
    "transaction_count"
]).head(10)
```

## Troubleshooting

### Common Issues

**Issue: File Not Found (404)**
- Check date ranges in table catalog
- Verify network name (mainnet, holesky, sepolia, hoodi)
- Ensure date exists (no data for future dates)
- Check if table has data for that specific date

**Issue: Out of Memory**
- Use lazy evaluation (Polars `scan_parquet`, not `read_parquet`)
- Process files one at a time in a loop
- Use column selection to only load needed fields
- Consider using DuckDB for larger-than-memory queries

**Issue: Slow Queries**
- Pre-filter data before loading into memory
- Use Parquet row group filtering
- Consider using ClickHouse with Parquet URLs for better performance
- Parallelize file downloads

### Debug Example
```python
import polars as pl
import logging

logging.basicConfig(level=logging.DEBUG)

# Debug data loading
url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet"

try:
    # Check if file exists
    import requests
    response = requests.head(url)
    print(f"Status: {response.status_code}")
    print(f"Content-Length: {response.headers.get('Content-Length')}")

    # Load with lazy evaluation to check schema
    lazy_df = pl.scan_parquet(url)
    print(f"Columns: {lazy_df.columns}")

    # Sample first 10 rows
    sample = lazy_df.head(10).collect()
    print(sample)

except Exception as e:
    print(f"Error: {e}")
```

EOF
fi

cat >> "$output_file" << 'EOF'

## Additional Resources

- **Full Documentation**: https://github.com/ethpandaops/xatu-data
- **ClickHouse Access**: https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/clickhouse/llms.txt for database credentials and advanced queries
- **Schema Repository**: https://github.com/ethpandaops/xatu-data/tree/master/schema/clickhouse
- **Config File**: https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml

## Hints (VERY IMPORTANT)
- It is HIGHLY recommended to explore the available tables and understand the data before querying.
- The CBT tables in the $network database should be your first choice for data. Inspect all the available tables and understand the data before querying.
- A large amount of CBT tables have _head and _canonical variants. Make sure you know which one you are querying as the data can be different.
- To check when a block was first seen by nodes in the Xatu network, check the $network.fct_block_first_seen_by_node table.
- A "best effort" table in $network.dim_node contains validator information like the entity running the validator. In devnets this also contains the node name that is running the validator.
- When asked for Grafana compatible queries you should make use of $__timeFilter() over the tables partition column. If asked for Grafana timeseries queries, you need to use $__timeInterval() over the tables partition column, usually with something like toStartOfFiveMinutes() or toStartOfHour().

## License

Data licensed under CC BY 4.0
EOF

log "✅ Parquet llms.txt generated successfully at $output_file"
