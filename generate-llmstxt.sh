#!/bin/bash

# Import dep scripts
source ./scripts/log.sh
source ./scripts/date.sh

set -e

# Configuration
llms_txt_file="llms.txt"
llms_full_txt_file="llms-full.txt"
config_file="config.yaml"
github_config_url="https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml"
schema_dir="./schema/clickhouse"

# Show help information
show_help() {
  echo "Usage: $0 [options]"
  echo "Generates llms.txt and llms-full.txt files for LLM consumption"
  echo ""
  echo "Options:"
  echo "  -c <config_file>   Specify the config file (default: config.yaml)"
  echo "  -s <schema_dir>    Specify the schema directory (default: ./schema/clickhouse)"
  echo "  -l <llms_file>     Specify the output file for llms.txt (default: llms.txt)"
  echo "  -f <full_file>     Specify the output file for llms-full.txt (default: llms-full.txt)"
  echo "  -h                 Show this help message"
}

# Command line options
while getopts "c:s:l:f:h" opt; do
  case $opt in
    c) config_file="$OPTARG" ;;  # Custom config file
    s) schema_dir="$OPTARG" ;;   # Custom schema directory
    l) llms_txt_file="$OPTARG" ;;      # Custom llms.txt output file
    f) llms_full_txt_file="$OPTARG" ;;  # Custom llms-full.txt output file
    h) show_help; exit 0 ;;
    *) show_help; exit 1 ;;
  esac
done

# Ensure yq and curl are installed
if ! command -v yq &> /dev/null; then
  log "Required command 'yq' is not installed. Please install it to proceed."
  exit 1
fi

if ! command -v curl &> /dev/null; then
  log "Required command 'curl' is not installed. Please install it to proceed."
  exit 1
fi

# Generate the common sections that appear in both files
generate_common_header() {
  local output_file=$1
  cat > "$output_file" << 'EOF'
# Xatu Dataset
> Comprehensive Ethereum network data collection focusing on blockchain metrics, client performance, and network analysis.

## Overview

Xatu is a data collection and processing pipeline for Ethereum network data.
- Xatu contains multiple "modules" that each derive Ethereum data differently
- The data is stored in a Clickhouse database and published to Parquet files
- ethPandaOps runs all modules, with community members also contributing data
- Public Parquet files are available with a 1-3 day delay with some privacy redactions
EOF
}

# Generate warnings section
generate_warnings_section() {
  local output_file=$1
  local detail_level=$2
  
  cat >> "$output_file" << 'EOF'

## ⚠️ Critical Usage Warning

**You MUST filter on the partitioning column when querying these datasets.**
- Failure to do so will result in extremely slow queries that scan entire tables
- This is especially important for large tables with billions of rows
- Always check the table's partitioning column and type before querying

**⚠️ IMPORTANT: NEVER use wildcards (*) when looking up Parquet files!**
- The data.ethpandaops.io endpoint is NOT S3-compatible
- Wildcard queries like `*.parquet` will NOT work
- Always use explicit paths or valid globbing patterns as shown in examples
EOF

  if [ "$detail_level" = "detailed" ]; then
    cat >> "$output_file" << 'EOF'
- For datetime partitioning, filter on the date column: `slot_start_date_time BETWEEN toDateTime('2024-01-01') AND toDateTime('2024-01-02')`
- For integer partitioning, filter on the range: `block_number BETWEEN 1000 AND 2000`
- When working with Parquet files, limit your query to specific date or range partitions in the URL pattern
- Performance will be significantly better when you properly utilize partitioning
- Use explicit globbing patterns like `{20,21,22}.parquet` or ranges like `{20000..20010}000.parquet`
EOF
  fi
}

# Generate access methods section
generate_access_methods_section() {
  local output_file=$1
  local detail_level=$2

  cat >> "$output_file" << 'EOF'

## Access Methods

Xatu data is available through two primary access methods:

### 🌐 Parquet Files (Public, No Authentication Required)

Parquet files are publicly available without any authentication requirements. They are typically updated with a 1-3 day delay and have some columns redacted for privacy.

**URL Patterns:**
- Datetime partitioning: `https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/YYYY/M/D.parquet`
- Datetime partitioning (hourly): `https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/YYYY/M/D/H.parquet`
- Integer partitioning: `https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/INTERVAL/CHUNK_NUMBER.parquet`

**Parameters:**
- NETWORK: mainnet, holesky, sepolia, etc.
- DATABASE: usually "default"
- TABLE: the table name
- INTERVAL: partitioning interval (e.g., 1000)
- CHUNK_NUMBER: chunk number (e.g., 0, 1000, 2000)

**Example URL:**
```
https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet
```

**Using with Clickhouse:**
```sql
SELECT *
FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet', 'Parquet')
LIMIT 10
```
EOF

  if [ "$detail_level" = "detailed" ]; then
    cat >> "$output_file" << 'EOF'

**Accessing Parquet Files Directly:**

You can directly download and read parquet files using various libraries:

**Python with pandas:**
```python
import pandas as pd
url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet"
df = pd.read_parquet(url)
```

**Python with polars:**
```python
import polars as pl
url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet"
df = pl.read_parquet(url)
# Or using lazy evaluation
lazy_df = pl.scan_parquet(url)
```

**R with arrow:**
```r
library(arrow)
url <- "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet"
df <- read_parquet(url)
```

**Command line with parquet-tools:**
```bash
pip install parquet-tools
parquet-tools head https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet
```
EOF
  fi

  cat >> "$output_file" << 'EOF'

### 🔒 Clickhouse Database (Restricted Access)

The ethPandaOps Clickhouse database provides direct access to all Xatu data with lower latency and no redactions. This access method requires authentication.

**Available Endpoints:**
- 🌐 **Mainnet Endpoint:** `https://clickhouse.xatu.ethpandaops.io`
  - Supported networks: Mainnet, Hoodi, Sepolia, Holesky
- 🧪 **Experimental Endpoint:** `https://clickhouse.xatu-experimental.ethpandaops.io`
  - Supported networks: Devnets, Experimental Networks

**Authentication:**
- Contact ethpandaops@ethereum.org for access credentials
- You will receive a username and password to use with the API

**Using with curl:**
```bash
# Replace with your actual credentials
CLICKHOUSE_USER="your-username"
CLICKHOUSE_PASSWORD="your-password"

echo """
    SELECT
        *
    FROM beacon_api_eth_v1_events_block
    WHERE
        slot_start_date_time > NOW() - INTERVAL '1 day'
        AND meta_network_name = 'mainnet'
    LIMIT 5
    FORMAT JSON
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @- | jq
```

**Table Schemas:**
- Create tables using schema: `https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/DATABASE/TABLE_NAME.sql`
EOF

  if [ "$detail_level" = "detailed" ]; then
    cat >> "$output_file" << 'EOF'

**Using with Jupyter Notebooks:**

```python
# Install dependencies
# pip install jupysql clickhouse_sqlalchemy

import os
from sqlalchemy import create_engine

# Set credentials (use environment variables for security)
ENDPOINT = "clickhouse.xatu.ethpandaops.io"
CLICKHOUSE_USER = os.environ.get("CLICKHOUSE_USER", "your-username")
CLICKHOUSE_PASSWORD = os.environ.get("CLICKHOUSE_PASSWORD", "your-password")

# Create connection string
db_url = f"clickhouse+http://{CLICKHOUSE_USER}:{CLICKHOUSE_PASSWORD}@{ENDPOINT}:443/default?protocol=https"

# Create engine and connect
engine = create_engine(db_url)
connection = engine.connect()

# Execute query
query = """
    SELECT
        *
    FROM beacon_api_eth_v1_events_block FINAL
    WHERE
        slot_start_date_time BETWEEN toDateTime('2024-04-01') AND toDateTime('2024-04-02')
        AND meta_network_name = 'mainnet'
    LIMIT 10
"""
result = connection.execute(query)
for row in result:
    print(row)
```

**Jupyter with magic commands:**

```python
# Using JupySQL with magic commands
%load_ext sql
%sql clickhouse+http://{{CLICKHOUSE_USER}}:{{CLICKHOUSE_PASSWORD}}@clickhouse.xatu.ethpandaops.io:443/default?protocol=https

%%sql
SELECT
    slot,
    block_root,
    meta_client_name,
    propagation_slot_start_diff
FROM
    beacon_api_eth_v1_events_block FINAL
WHERE
    slot_start_date_time > NOW() - INTERVAL '1 HOUR'
    AND meta_network_name = 'mainnet'
LIMIT 10
```

**Optimizing Clickhouse Queries:**
When using Clickhouse, make sure to:

1. Always use the partitioning column in your WHERE clauses
2. Use the FINAL modifier for tables that use ReplacingMergeTree engine
3. Take advantage of Clickhouse's vectorized query execution
EOF
  fi
}

# Generate datasets section
generate_datasets_section() {
  local output_file=$1
  local detail_level=$2
  
  cat >> "$output_file" << 'EOF'

## Core Datasets
EOF

  # Extract dataset information
  yq e '.datasets[] | "- **" + .name + "**: " + .description + " (Prefix: `" + .tables.prefix + "`)"' "$config_file" >> "$output_file"
  
  if [ "$detail_level" = "detailed" ]; then
    cat >> "$output_file" << 'EOF'

## Dataset Details

### Data Organization
The data is organized into several logical datasets, each focusing on a specific aspect of the Ethereum network:

1. **Beacon API Event Stream**: These tables contain events captured directly from the Beacon API. They're useful for analyzing timing and propagation of events across the network. These events are captured by multiple sentries, so you'll often see the same events from different observers.

2. **Canonical Beacon**: This dataset contains deduplicated, authoritative data from the beacon chain. This is the most reliable source for consensus layer information.

3. **Canonical Execution**: Similar to Canonical Beacon, but for the execution layer. These tables contain deduplicated, authoritative data about blocks, transactions, events, etc.

4. **Consensus Layer P2P**: These tables contain events captured from the p2p network, showing how data propagates through the consensus layer.

5. **MEV Relay**: Data related to Maximal Extractable Value relays, showing block auctions and builder activity.

### Data Consistency
- All tables include metadata fields (meta_client_name, meta_client_id, etc.)
- Event times are recorded in UTC
- Data is partitioned for efficient querying
- Some identifiers (like validator indices) can be joined across tables
EOF
  fi
}

# Generate data architecture section (only for full file)
generate_data_architecture_section() {
  local output_file=$1
  
  cat >> "$output_file" << 'EOF'

## Data Architecture

Xatu collects data from multiple sources across the Ethereum network:

1. **Collection**: Data is collected by:
   - ethPandaOps running monitoring nodes across multiple regions
   - Community members running Xatu modules
   - Direct integrations with MEV relays and other services

2. **Processing**: The raw data is:
   - Parsed into structured formats
   - Enriched with metadata
   - Timestamped with collection time
   - Deduplicated where appropriate
   - Validated for consistency

3. **Storage**:
   - Primary storage in Clickhouse database
   - Exported to Parquet files for public access
   - Partitioned by time or numeric identifiers for efficient querying

4. **Access Patterns**:
   - Public access via Parquet files (with 1-3 day delay)
   - Direct Clickhouse access for ethPandaOps team and partners
   - Data exported to other formats for specific analysis needs

### Data Flow
1. Events occur on the Ethereum network
2. Xatu modules capture these events
3. Events are processed and stored in Clickhouse
4. Data is exported to Parquet files
5. Researchers and analysts use the data for insights

### Data Freshness
- Parquet files are typically updated once per day
- Some sensitive information is redacted from public files
- Historical data remains stable and isn't rewritten
EOF
}

# Generate examples section
generate_examples_section() {
  local output_file=$1
  local detail_level=$2
  
  cat >> "$output_file" << 'EOF'

## Query Examples

### Using Clickhouse with Parquet:

**⚠️ IMPORTANT NOTES:**
- **NEVER use wildcards (*) when looking up Parquet files - they will not work!**
- Always use explicit paths or valid globbing patterns with explicit ranges
- Use CTEs when joining tables to avoid cross-shard issues

```sql
-- Single file query
SELECT
    toDate(slot_start_date_time) AS date,
    round(MIN(propagation_slot_start_diff)) AS min_ms,
    round(quantile(0.50)(propagation_slot_start_diff)) AS p50_ms,
    round(quantile(0.90)(propagation_slot_start_diff)) AS p90_ms
FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/20.parquet', 'Parquet')
GROUP BY date
ORDER BY date

-- Multiple files using VALID glob patterns (NOT wildcards)
--- With daily partitioning (explicit list in curly braces)
SELECT
    toDate(slot_start_date_time) AS date,
    count(*) AS event_count
FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/{20,21,22}.parquet', 'Parquet')
GROUP BY date
ORDER BY date

--- With integer partitioning (explicit range in curly braces)
SELECT 
COUNT(*) 
FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/{20000..20010}000.parquet', 'Parquet')
LIMIT 10 FORMAT Pretty
```
EOF

  if [ "$detail_level" = "detailed" ]; then
    cat >> "$output_file" << 'EOF'

### Joining Tables in Clickhouse:

**⚠️ IMPORTANT: Always use CTEs when joining tables in Clickhouse to avoid cross-shard joins!**

```sql
-- Join block events with canonical blocks (USING CTEs TO AVOID SHARD ISSUES)
WITH 
    blocks AS (
        SELECT *
        FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block/2024/4/1.parquet', 'Parquet')
    ),
    events AS (
        SELECT *
        FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet', 'Parquet')
    )
SELECT
    b.slot,
    b.block_root,
    e.meta_client_name,
    e.propagation_slot_start_diff
FROM blocks b
JOIN events e ON b.slot = e.slot
ORDER BY b.slot, e.propagation_slot_start_diff

-- Join execution and consensus data (USING CTEs TO AVOID SHARD ISSUES)
WITH
    consensus_blocks AS (
        SELECT *
        FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block/2024/4/1.parquet', 'Parquet')
    ),
    execution_blocks AS (
        SELECT *
        FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/17000000.parquet', 'Parquet')
    )
SELECT
    cb.slot,
    cb.slot_start_date_time,
    ce.block_number,
    ce.block_hash,
    ce.transaction_count
FROM consensus_blocks cb
JOIN execution_blocks ce ON cb.execution_block_number = ce.block_number
WHERE cb.execution_block_number > 0
ORDER BY cb.slot
LIMIT 10
```

### Advanced Examples:

```sql
-- Calculate attestation inclusion delay
SELECT
    slot, 
    MIN(propagation_slot_start_diff) as min_delay,
    AVG(propagation_slot_start_diff) as avg_delay,
    quantile(0.95)(propagation_slot_start_diff) as p95_delay
FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_attestation/2024/4/1.parquet', 'Parquet')
GROUP BY slot
ORDER BY slot

-- Find slow blocks (USING CTEs TO AVOID SHARD ISSUES)
WITH 
    canonical_blocks AS (
        SELECT *
        FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block/2024/4/1.parquet', 'Parquet')
    ),
    block_events AS (
        SELECT *
        FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/4/1.parquet', 'Parquet')
    )
SELECT
    b.slot,
    b.slot_start_date_time,
    b.proposer_index,
    MAX(e.propagation_slot_start_diff) as max_propagation_time,
    COUNT(DISTINCT e.meta_client_name) as observer_count
FROM canonical_blocks b
JOIN block_events e ON b.slot = e.slot
GROUP BY b.slot, b.slot_start_date_time, b.proposer_index
HAVING max_propagation_time > 2000
ORDER BY max_propagation_time DESC
LIMIT 10
```
EOF
  fi
  
  cat >> "$output_file" << 'EOF'

## Checking Data Availability

```bash
# Get the most recent table config
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | "# Table: " + .name +
  "\n  Database: " + .database +
  "\n  Partitioning: " + .partitioning.column + " (" + .partitioning.type + ") in chunks of " + .partitioning.interval +
  "\n  Networks: " + (.networks | keys | join(", ")) +
  "\n  Tags: " + (.tags | join(", "))'

# Check networks for a specific table
TABLE="beacon_api_eth_v1_events_head"
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | "Networks: " + (.networks | keys | join(", "))'
```

## Table Listing

The following tables are available in the Xatu dataset:

EOF

  # Generate and add the table listing with date ranges
  log "Generating table listing with date ranges..."
  yq e '.tables[] | "### " + .name +
    "\n- **Database**: " + .database +
    "\n- **Description**: " + .description +
    "\n- **Partitioning**: " + .partitioning.column + " (" + .partitioning.type + "), " + .partitioning.interval +
    "\n- **Networks**: " +
    (.networks | to_entries | map(
      .key + " (" + .value.from + " to " + .value.to + ")"
    ) | join(", ")) +
    "\n- **Tags**: " + (.tags | join(", "))' "$config_file" >> "$output_file"

  cat >> "$output_file" << 'EOF'

## Schema Documentation

### Common Fields

All tables include:
- **meta_client_name**: Client that collected the data
- **meta_client_id**: Unique Session ID
- **meta_client_version**: Client version
- **meta_network_name**: Network name
- **event_date_time**: When the event was created

## Schema Access

To view table schemas:

```bash
# Get a specific table schema
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/TABLE_NAME.sql

# Search within a schema for details
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/beacon_api_eth_v1_events_block.sql | grep -A 50 "CREATE TABLE"
```
EOF

  if [ "$detail_level" = "detailed" ]; then
    cat >> "$output_file" << 'EOF'

### Listing Available Tables
To get a list of all available tables, you can use:

```bash
# List all schemas
curl -s https://api.github.com/repos/ethpandaops/xatu-data/contents/schema/clickhouse/default | jq -r '.[].name'

# Get table details from config
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | "Table: " + .name + ", Partition: " + .partitioning.column + " (" + .partitioning.type + ")"'
```
EOF
  fi
}

# Generate full schema section (only for full file)
generate_full_schema_section() {
  local output_file=$1
  
  cat >> "$output_file" << 'EOF'

## Complete Table Schemas

This section contains the full CREATE TABLE statements for all tables in the Xatu dataset.
These schemas can be used to create tables in your own Clickhouse instance.

### How to Access Table Schemas

You can access any table's schema directly using:

```bash
# View a specific table schema
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/TABLE_NAME.sql

# Find and view a schema for a specific table
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/canonical_beacon_block.sql
```

To search for a specific table's schema, you can use:

```bash
# List all available schemas
curl -s https://api.github.com/repos/ethpandaops/xatu-data/contents/schema/clickhouse/default | jq -r '.[].name'

# Fetch and find details about a specific table
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/beacon_api_eth_v1_events_block.sql | grep -A 50 "CREATE TABLE"
```
EOF

  # Include actual schemas by reading from the schema directory
  echo >> "$output_file"
  echo "### Table Schemas" >> "$output_file"
  echo >> "$output_file"
  
  # Loop through all database directories in the schema/clickhouse directory
  for db_dir in "$schema_dir"/*; do
    if [ -d "$db_dir" ]; then
      db_name=$(basename "$db_dir")
      echo "#### Database: $db_name" >> "$output_file"
      echo >> "$output_file"
      
      # Loop through all table SQL files in the database directory
      for sql_file in "$db_dir"/*.sql; do
        # Only include the non-_local files to avoid duplication
        if [[ ! "$sql_file" == *"_local.sql" ]]; then
          table_name=$(basename "$sql_file" .sql)
          echo "##### Table: $table_name" >> "$output_file"
          echo >> "$output_file"
          echo '```sql' >> "$output_file"
          cat "$sql_file" >> "$output_file"
          echo '```' >> "$output_file"
          echo >> "$output_file"
        fi
      done
    fi
  done
}

# Generate programmatic access section (only for full file)
generate_programmatic_section() {
  local output_file=$1
  cat >> "$output_file" << 'EOF'

## Programmatic Access Examples

**⚠️ IMPORTANT: NEVER use wildcards (*) when accessing Parquet files!**
- The data.ethpandaops.io endpoint is NOT S3-compatible
- Wildcard queries like `*.parquet` will NOT work
- Always use explicit paths or valid globbing patterns as shown in examples

### Python with Pandas
```python
import pandas as pd
from datetime import datetime, timedelta

# Set date range
start_date = datetime(2024, 4, 1)
end_date = datetime(2024, 4, 2)

# Generate EXPLICIT URLs for the date range (NEVER USE WILDCARDS!)
base_url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/"
urls = [f"{base_url}{date.year}/{date.month}/{date.day}.parquet" 
        for date in (start_date + timedelta(days=n) 
                    for n in range((end_date - start_date).days + 1))]

# IMPORTANT: Notice we are generating a SPECIFIC list of URLs, not using wildcards

# Download and load data
dfs = []
for url in urls:
    df = pd.read_parquet(url)
    df['slot_start_date_time'] = pd.to_datetime(df['slot_start_date_time'], unit='s')
    dfs.append(df)

# Combine and analyze
df_combined = pd.concat(dfs)
grouped = df_combined.groupby('slot_start_date_time')['propagation_slot_start_diff'].median()
```

### Python with Polars (Lazy Evaluation)
```python
import polars as pl
from datetime import datetime, timedelta

# Set date range
start_date = datetime(2024, 4, 1)
end_date = datetime(2024, 4, 2)

# Generate EXPLICIT URLs for the date range (NEVER USE WILDCARDS!)
base_url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/"
urls = [f"{base_url}{date.year}/{date.month}/{date.day}.parquet" 
        for date in (start_date + timedelta(days=n) 
                    for n in range((end_date - start_date).days + 1))]

# IMPORTANT: Always create a specific list of URLs, not using wildcards or globs for HTTP

# Create lazy DataFrames
lazy_dfs = [pl.scan_parquet(url) for url in urls]
combined = pl.concat(lazy_dfs)

# Analyze with lazy evaluation
result = (combined
    .group_by("slot_start_date_time")
    .agg(pl.col("propagation_slot_start_diff").median())
    .collect())
```

### R with Arrow
```r
library(arrow)
library(dplyr)
library(lubridate)

# Set date range
start_date <- as.Date("2024-04-01")
end_date <- as.Date("2024-04-02")
dates <- seq(start_date, end_date, by="day")

# Generate EXPLICIT URLs (NEVER USE WILDCARDS with data.ethpandaops.io!)
base_url <- "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/"
urls <- paste0(base_url, 
               format(dates, "%Y"), "/", 
               format(dates, "%m"), "/", 
               format(dates, "%d"), ".parquet")

# IMPORTANT: Always create specific URLs rather than using wildcards
# This is because the data.ethpandaops.io endpoint is not S3-compatible

# Read and combine data
df_list <- lapply(urls, read_parquet)
combined_df <- bind_rows(df_list)

# Analyze data
result <- combined_df %>%
  mutate(slot_date = as_datetime(slot_start_date_time)) %>%
  group_by(slot_date) %>%
  summarize(
    min_prop = min(propagation_slot_start_diff),
    median_prop = median(propagation_slot_start_diff),
    max_prop = max(propagation_slot_start_diff)
  )
```

### Julia with Parquet.jl
```julia
using Parquet
using DataFrames
using Dates
using Statistics

# Set date range
start_date = Date(2024, 4, 1)
end_date = Date(2024, 4, 2)
dates = start_date:Day(1):end_date

# Generate EXPLICIT URLs (NEVER USE WILDCARDS with data.ethpandaops.io!)
base_url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/"
urls = [string(base_url, year(d), "/", month(d), "/", day(d), ".parquet") for d in dates]

# IMPORTANT: Always use explicit paths; the data.ethpandaops.io endpoint
# is not S3-compatible and does not support wildcard operations

# Read and combine data
dfs = [DataFrame(read_parquet(url)) for url in urls]
combined_df = vcat(dfs...)

# Analyze data
using Statistics
grouped = combine(groupby(combined_df, :slot), 
    :propagation_slot_start_diff => median => :median_delay,
    :propagation_slot_start_diff => minimum => :min_delay)
```
EOF
}

# Generate glossary section (only for full file)
generate_glossary_section() {
  local output_file=$1
  cat >> "$output_file" << 'EOF'

## Glossary

### Ethereum Terminology
- **Slot**: Basic time unit in the Ethereum consensus layer (12 seconds)
- **Epoch**: A group of 32 slots (approximately 6.4 minutes)
- **Block**: A collection of transactions and state updates
- **Attestation**: A validator's vote for a specific block
- **Validator**: An entity participating in Ethereum consensus by staking ETH
- **Proposer**: A validator selected to create a block for a specific slot
- **Finalization**: The process by which blocks become irreversible
- **MEV**: Maximal Extractable Value, additional value that can be extracted by reordering transactions
- **Relay**: A service that connects validators with block builders

### Data-Specific Terminology
- **Propagation Time**: Time between slot start and when a node observed an event
- **Canonical**: Data from the finalized, canonical chain
- **Event Stream**: Real-time data from the Beacon API
- **P2P**: Peer-to-peer network communications
- **Meta Client**: The client/node that collected the data
- **Partition Column**: Column used to divide data into manageable chunks
EOF
}

# Generate footer section
generate_footer() {
  local output_file=$1
  cat >> "$output_file" << 'EOF'

## Data Availability

- **Public Parquet Files**: Available to everyone
- **EthPandaOps Clickhouse**: Restricted access (contact ethpandaops@ethereum.org)

## License

Xatu data is licensed under CC BY 4.0.

For more information: https://github.com/ethpandaops/xatu-data
EOF
}

# Main execution

# Generate llms.txt (concise version)
log "Generating $llms_txt_file file..."
generate_common_header "$llms_txt_file"
generate_warnings_section "$llms_txt_file" "concise"
generate_access_methods_section "$llms_txt_file" "concise"
generate_datasets_section "$llms_txt_file" "concise"
generate_examples_section "$llms_txt_file" "concise"
generate_footer "$llms_txt_file"
log "$llms_txt_file file generated successfully."

# Generate llms-full.txt (comprehensive version)
log "Generating $llms_full_txt_file file..."
generate_common_header "$llms_full_txt_file"
generate_warnings_section "$llms_full_txt_file" "detailed"
generate_data_architecture_section "$llms_full_txt_file"
generate_access_methods_section "$llms_full_txt_file" "detailed"
generate_datasets_section "$llms_full_txt_file" "detailed"
generate_examples_section "$llms_full_txt_file" "detailed"
generate_full_schema_section "$llms_full_txt_file"
generate_programmatic_section "$llms_full_txt_file"
generate_glossary_section "$llms_full_txt_file"
generate_footer "$llms_full_txt_file"
log "$llms_full_txt_file file generated successfully."