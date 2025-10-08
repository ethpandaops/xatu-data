#!/bin/bash

# Import dep scripts
source ./scripts/log.sh
source ./scripts/date.sh

set -e

# Configuration
llms_txt_file="llms.txt"
llms_full_txt_file="llms-full.txt"
llms_parquet_file="llms/parquet/llms.txt"
llms_clickhouse_file="llms/clickhouse/llms.txt"
config_file="config.yaml"
github_config_url="https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml"
schema_dir="./schema/clickhouse"
clickhouse_host=${CLICKHOUSE_HOST:-http://localhost:8123}

# Auto-discover CBT tables from ClickHouse
discover_cbt_tables() {
    local cbt_database="mainnet"

    # Get all tables from mainnet database, excluding views, admin tables, and schema_migrations
    curl -s "$clickhouse_host" --data "
        SELECT name
        FROM system.tables
        WHERE database = '$cbt_database'
          AND engine NOT LIKE '%View%'
          AND name NOT LIKE 'admin_%'
          AND name NOT IN ('schema_migrations', 'schema_migrations_local')
          AND name NOT LIKE '%_local'
        ORDER BY name
        FORMAT TabSeparated
    "
}

# Get CBT table info for llms.txt
get_cbt_table_info() {
    local table_name=$1
    local cbt_database="mainnet"

    # Get table description
    local description=$(curl -s "$clickhouse_host" --data "SELECT comment FROM system.tables WHERE database = '$cbt_database' AND name = '${table_name}_local' FORMAT TabSeparated")

    # Get ORDER BY clause
    local sorting_key=$(curl -s "$clickhouse_host" --data "SELECT sorting_key FROM system.tables WHERE database = '$cbt_database' AND name = '${table_name}_local' FORMAT TabSeparated")

    # Extract first column from ORDER BY
    local partition_column=$(echo "$sorting_key" | sed 's/,.*//; s/^[[:space:]]*//; s/[[:space:]]*$//')

    # Get column type to determine partition type
    local column_type=$(curl -s "$clickhouse_host" --data "SELECT type FROM system.columns WHERE database = '$cbt_database' AND table = '${table_name}_local' AND name = '$partition_column' FORMAT TabSeparated")

    # Determine partition type based on column type
    local partition_type="none"
    local partition_interval=""
    if [[ "$column_type" =~ ^DateTime || "$column_type" =~ ^Date ]]; then
        partition_type="datetime"
        partition_interval="daily"
    elif [[ "$column_type" =~ ^UInt || "$column_type" =~ ^Int ]]; then
        partition_type="integer"
        partition_interval="1000"
    fi

    # Output in the format expected by llms.txt generation
    echo "### $table_name"
    echo "- **Database**: Network-specific (see Networks below)"
    echo "- **Description**: $description"
    echo "- **Partitioning**: $partition_column ($partition_type), $partition_interval"
    echo "- **Networks**: mainnet (\`mainnet.$table_name\`), sepolia (\`sepolia.$table_name\`), holesky (\`holesky.$table_name\`), hoodi (\`hoodi.$table_name\`)"
    echo "- **Tags**: "
}

# Check if ClickHouse is available for CBT auto-discovery
cbt_discovery_enabled=false
if curl -s "$clickhouse_host" --data "SELECT 1 FORMAT TabSeparated" > /dev/null 2>&1; then
    # Check if mainnet database exists
    if curl -s "$clickhouse_host" --data "SELECT 1 FROM system.databases WHERE name = 'mainnet' FORMAT TabSeparated" | grep -q "1"; then
        cbt_discovery_enabled=true
        log "CBT auto-discovery enabled (ClickHouse mainnet database found)"
    else
        log "CBT auto-discovery disabled (mainnet database not found)"
    fi
else
    log "CBT auto-discovery disabled (ClickHouse not available at $clickhouse_host)"
fi

# Show help information
show_help() {
  echo "Usage: $0 [options]"
  echo "Generates llms.txt files for LLM consumption"
  echo ""
  echo "Options:"
  echo "  -c <config_file>   Specify the config file (default: config.yaml)"
  echo "  -s <schema_dir>    Specify the schema directory (default: ./schema/clickhouse)"
  echo "  -l <llms_file>     Specify the output file for llms.txt (default: llms.txt)"
  echo "  -f <full_file>     Specify the output file for llms-full.txt (default: llms-full.txt)"
  echo "  -p <parquet_file>  Specify the output file for parquet llms.txt (default: llms/parquet/llms.txt)"
  echo "  -d <clickhouse_file> Specify the output file for clickhouse llms.txt (default: llms/clickhouse/llms.txt)"
  echo "  -h                 Show this help message"
}

# Command line options
while getopts "c:s:l:f:p:d:h" opt; do
  case $opt in
    c) config_file="$OPTARG" ;;  # Custom config file
    s) schema_dir="$OPTARG" ;;   # Custom schema directory
    l) llms_txt_file="$OPTARG" ;;      # Custom llms.txt output file
    f) llms_full_txt_file="$OPTARG" ;;  # Custom llms-full.txt output file
    p) llms_parquet_file="$OPTARG" ;;  # Custom parquet llms.txt output file
    d) llms_clickhouse_file="$OPTARG" ;;  # Custom clickhouse llms.txt output file
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

# Generate top-level llms.txt (navigation to specialized files)
generate_top_level_llms() {
  local output_file=$1
  cat > "$output_file" << 'EOF'
# Xatu Data
> Ethereum network data via Parquet files or ClickHouse database

## Choose Your Access Method

Xatu provides Ethereum network data through two primary access methods. Select the documentation that matches your needs:

### 🌐 Public Parquet Files (No Authentication)
**Best for:** Data scientists, researchers, anyone wanting free access to Ethereum data

👉 **See https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/parquet/llms.txt** for complete Parquet documentation
- Public HTTP access, no credentials needed
- Python, R, SQL, DuckDB examples
- Daily updates with 1-3 day delay
- Privacy-conscious (some columns redacted)

📚 **Advanced Parquet usage:** https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/parquet/llms-full.txt

---

### 🔒 ClickHouse Database (Authentication Required)
**Best for:** Real-time analysis, ethPandaOps partners, advanced users

👉 **See https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/clickhouse/llms.txt** for complete ClickHouse documentation
- Direct database access with lower latency
- No redactions or delays
- Production and experimental endpoints
- Advanced query capabilities

📚 **Advanced ClickHouse usage:** https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/clickhouse/llms-full.txt

---

## Quick Overview

### What is Xatu?
Xatu is a comprehensive Ethereum network data collection and processing pipeline:
- Multiple collection modules for different data types
- Data stored in ClickHouse database
- Public Parquet exports available
- Run by ethPandaOps with community contributions

### Available Data
- **Beacon API Event Stream** - Block/attestation timing from multiple sentries
- **Canonical Beacon/Execution** - Deduplicated, authoritative chain data
- **MEV Relay** - Block auction and builder data
- **P2P Network Events** - Consensus and execution layer propagation
- **CBT Tables** - Pre-aggregated analytics (ClickHouse only). Exists in $network databases.

### Networks
- Mainnet (production Ethereum)
- Holesky (testnet)
- Sepolia (testnet)
- Hoodi (devnet)
- Experimental networks like devnets (via experimental endpoint)

## ⚠️ Critical: Query Performance

**ALWAYS filter on partitioning columns** when querying:
- Datetime tables: Filter on date/time columns (e.g., `slot_start_date_time`)
- Integer tables: Filter on ranges (e.g., `block_number`)
- Failure to partition = scanning billions of rows = very slow queries

## Getting Started

1. **Choose your access method** (Parquet or ClickHouse)
2. **Read the appropriate documentation** (links above)
3. **Check table catalog** for available data and date ranges
4. **Start with small queries** on recent data (last 24 hours)
5. **Always use partition filters** for better performance

## Additional Resources

- **GitHub Repository**: https://github.com/ethpandaops/xatu-data
- **Schema Repository**: https://github.com/ethpandaops/xatu-data/tree/master/schema/clickhouse
- **Config File**: https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml
- **Contact**: ethpandaops@ethereum.org

## License

Data licensed under CC BY 4.0
EOF
}

# Generate top-level llms-full.txt (comprehensive with links)
generate_top_level_llms_full() {
  local output_file=$1
  cat > "$output_file" << 'EOF'
# Xatu Data - Complete Documentation
> Comprehensive Ethereum network data via Parquet files or ClickHouse database

## Navigation Guide

This is the complete documentation for Xatu data. For focused, use-case specific guides:

### 📁 Parquet Files Documentation
- **Concise**: https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/parquet/llms.txt - Quick start with Parquet files
- **Complete**: https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/parquet/llms-full.txt - Advanced patterns, DuckDB, Spark, Julia examples

### 🗄️ ClickHouse Database Documentation
- **Concise**: https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/clickhouse/llms.txt - Quick start with ClickHouse
- **Complete**: https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/clickhouse/llms-full.txt - Advanced integrations, monitoring, performance tuning

---

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
    "\n- **Tags**: " + ((.tags // []) | join(", "))' "$config_file" >> "$output_file"

  # Add auto-discovered CBT tables if available
  if [ "$cbt_discovery_enabled" = true ]; then
    log "Adding auto-discovered CBT tables..."
    for table_name in $(discover_cbt_tables); do
      get_cbt_table_info "$table_name" >> "$output_file"
    done
  else
    log "Skipping CBT tables (auto-discovery disabled)"
  fi

  cat >> "$output_file" << 'EOF'

## Schema Documentation

### Common Fields

Most tables include standard metadata fields:
- **meta_client_name**: Client that collected the data
- **meta_client_id**: Unique Session ID
- **meta_client_version**: Client version
- **meta_network_name**: Network name
- **event_date_time**: When the event was created

**Note:** CBT (ClickHouse Build Tools) tables are pre-aggregated analytical tables and do not include these metadata fields. Network selection for CBT tables is done via database targeting (e.g., `mainnet.table_name`).

## Schema Access

To view table schemas:

```bash
# Get a specific table schema (default database)
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/TABLE_NAME.sql

# Get a CBT table schema
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/cbt/TABLE_NAME.sql

# Search within a schema for details
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/beacon_api_eth_v1_events_block.sql | grep -A 50 "CREATE TABLE"
```
EOF

  if [ "$detail_level" = "detailed" ]; then
    cat >> "$output_file" << 'EOF'

### Listing Available Tables
To get a list of all available tables, you can use:

```bash
# List all default database schemas
curl -s https://api.github.com/repos/ethpandaops/xatu-data/contents/schema/clickhouse/default | jq -r '.[].name'

# List all CBT table schemas
curl -s https://api.github.com/repos/ethpandaops/xatu-data/contents/schema/clickhouse/cbt | jq -r '.[].name'

# Get table details from config (excludes auto-discovered CBT tables)
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

# Generate parquet-focused llms.txt
generate_parquet_llms() {
  local output_file=$1

  cat > "$output_file" << 'EOF'
# Xatu Parquet Data
> Public Ethereum network data in Parquet format - no authentication required

## Looking for ClickHouse Access?
**If you need direct database access with lower latency and no redactions**, see [/llms/clickhouse/llms.txt](../clickhouse/llms.txt) for ClickHouse-specific documentation.

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

## Additional Resources

- **Full Documentation**: https://github.com/ethpandaops/xatu-data
- **ClickHouse Access**: See `/llms/clickhouse/llms.txt` for database credentials and advanced queries
- **Schema Repository**: https://github.com/ethpandaops/xatu-data/tree/master/schema/clickhouse
- **Config File**: https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml

## License

Data licensed under CC BY 4.0
EOF

  generate_table_hints "$output_file"
}

generate_table_hints() {
  local output_file=$1
  cat >> "$output_file" << 'EOF'
  ## Hints (VERY IMPORTANT)
  - It is HIGHLY recommended to explore the available tables and understand the data before querying.
  - The CBT tables in the $network database should be your first choice for data. Inspect all the available tables and understand the data before querying. 
  - A large amount of CBT tables have _head and _canonical variants. Make sure you know which one you are querying as the data can be different.
  - To check when a block was first seen by nodes in the Xatu network, check the $network.fct_block_first_seen_by_node table.
  - A "best effort" table in $network.dim_node contains validator information like the entity running the validator. In devnets this also contains the node name that is running the validator.
  - When asked for Grafana compatible queries you should make use of $__timeFilter() over the tables partition column. If asked for Grafana timeseries queries, you need to use $__timeInterval() over the tables partition column, usually with something like toStartOfFiveMinutes() or toStartOfHour().
EOF
}

# Generate clickhouse-focused llms.txt
generate_clickhouse_llms() {
  local output_file=$1

  cat > "$output_file" << 'EOF'
# Xatu ClickHouse Database
> Direct database access to Ethereum network data - authentication required

## Looking for Public Parquet Files?
**If you want public access without authentication**, see [/llms/parquet/llms.txt](../parquet/llms.txt) for Parquet file documentation.

## Overview

Xatu ClickHouse provides direct database access to Ethereum network data:
- **Authentication required** - contact ethpandaops@ethereum.org
- **Real-time access** - lower latency than Parquet files
- **Complete data** - no redactions or privacy filtering
- **Multiple endpoints** - production and experimental networks

## ⚠️ Critical: Query Optimization

**ALWAYS filter on partitioning columns:**
- Queries without partition filters will scan **billions of rows**
- Use `FINAL` modifier for tables with `ReplacingMergeTree` engine
- Use CTEs when joining to avoid cross-shard issues
- Check table partitioning column before querying

## Endpoints

### Production Endpoint
```
https://clickhouse.xatu.ethpandaops.io
```
**Networks**: Mainnet, Sepolia, Holesky, Hoodi

### Experimental Endpoint
```
https://clickhouse.xatu-experimental.ethpandaops.io
```
**Networks**: Devnets, experimental networks

## Authentication

Contact **ethpandaops@ethereum.org** for credentials.

You'll receive:
- Username
- Password
- Endpoint URL

## Quick Start Examples

### curl + jq
```bash
CLICKHOUSE_USER="your-username"
CLICKHOUSE_PASSWORD="your-password"

echo """
SELECT
    toDate(slot_start_date_time) AS date,
    COUNT(*) AS blocks,
    quantile(0.5)(propagation_slot_start_diff) AS median_propagation_ms
FROM beacon_api_eth_v1_events_block FINAL
WHERE
    slot_start_date_time >= toDateTime('2024-04-01 00:00:00')
    AND slot_start_date_time < toDateTime('2024-04-02 00:00:00')
    AND meta_network_name = 'mainnet'
GROUP BY date
FORMAT JSON
""" | curl "https://clickhouse.xatu.ethpandaops.io" \
    -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" \
    --data-binary @- | jq
```

### Python + SQLAlchemy
```python
from sqlalchemy import create_engine
import pandas as pd
import os

# Credentials from environment
endpoint = "clickhouse.xatu.ethpandaops.io"
user = os.environ["CLICKHOUSE_USER"]
password = os.environ["CLICKHOUSE_PASSWORD"]

# Create connection
db_url = f"clickhouse+http://{user}:{password}@{endpoint}:443/default?protocol=https"
engine = create_engine(db_url)

# Query with proper partitioning
query = """
SELECT
    slot,
    block_root,
    proposer_index,
    slot_start_date_time
FROM canonical_beacon_block FINAL
WHERE
    slot_start_date_time >= toDateTime('2024-04-01')
    AND slot_start_date_time < toDateTime('2024-04-02')
    AND meta_network_name = 'mainnet'
LIMIT 1000
"""

df = pd.read_sql(query, engine)
```

### Jupyter Notebook Magic
```python
%load_ext sql

# Set connection
%sql clickhouse+http://$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD@clickhouse.xatu.ethpandaops.io:443/default?protocol=https

# Query directly in cell
%%sql
SELECT
    meta_client_name,
    COUNT(*) as observations
FROM beacon_api_eth_v1_events_block FINAL
WHERE
    slot_start_date_time > NOW() - INTERVAL 1 HOUR
    AND meta_network_name = 'mainnet'
GROUP BY meta_client_name
ORDER BY observations DESC
```

EOF

  # Add datasets section
  cat >> "$output_file" << 'EOF'

## Available Datasets

EOF

  # Extract ALL dataset information (both public and clickhouse-only)
  yq e '.datasets[] | "### " + .name + "\n> " + .description + "\n\n**Table Prefix**: `" + .tables.prefix + "`\n**Availability**: " + (.availability | join(", ")) + "\n"' "$config_file" >> "$output_file"

  # Add CBT specific info
  cat >> "$output_file" << 'EOF'

### CBT (ClickHouse Build Tools) Tables

CBT tables are pre-aggregated analytical tables accessed via **network-specific databases**:

```sql
-- Query mainnet CBT table
SELECT * FROM mainnet.table_name LIMIT 10;

-- Query sepolia CBT table
SELECT * FROM sepolia.table_name LIMIT 10;
```

**Database naming**: `mainnet`, `sepolia`, `holesky`, `hoodi`

**Table types**:
- `dim_*` - Dimension tables
- `fct_*` - Fact tables
- `int_*` - Intermediate tables

EOF

  # Add auto-discovered CBT tables if available
  if [ "$cbt_discovery_enabled" = true ]; then
    cat >> "$output_file" << 'EOF'

### Auto-Discovered CBT Tables

EOF
    for table_name in $(discover_cbt_tables); do
      get_cbt_table_info "$table_name" >> "$output_file"
    done
  fi

  cat >> "$output_file" << 'EOF'

## Table Catalog

**Standard tables** (accessed via `default` database or directly):

EOF

  # Generate full table listing with all details
  yq e '.tables[] | "### `" + .name + "`\n- **Database**: `" + .database + "`\n- **Partitioning**: `" + .partitioning.column + "` (" + .partitioning.type + ", " + .partitioning.interval + ")\n- **Networks**: " + (.networks | to_entries | map(.key + " (" + .value.from + " to " + .value.to + ")") | join(", ")) + "\n- **Description**: " + .description + "\n"' "$config_file" >> "$output_file"

  cat >> "$output_file" << 'EOF'

## Schema Access

### Get Table Schema
```bash
# Download CREATE TABLE statement
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/DATABASE/TABLE_NAME.sql

# Example: beacon blocks
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/canonical_beacon_block.sql
```

### Create Local Table
```sql
-- Use schema to create table locally
-- Download schema first, then execute in your ClickHouse instance
```

### Common Metadata Fields
- `meta_client_name` - Data collection client
- `meta_client_id` - Unique session ID
- `meta_network_name` - Network filter (mainnet, holesky, etc.)
- `event_date_time` - Event timestamp
- Partition column (see table catalog)

**Note**: CBT tables don't include meta fields; network selection is via database.

## Query Optimization Tips

1. **Always filter partitions first**
   ```sql
   WHERE slot_start_date_time BETWEEN '2024-04-01' AND '2024-04-02'  -- Good
   WHERE slot > 1000000  -- Bad (no partition filter)
   ```

2. **Use FINAL for ReplacingMergeTree**
   ```sql
   FROM canonical_beacon_block FINAL  -- Deduplicates rows
   ```

3. **Use CTEs for joins**
   ```sql
   WITH t1 AS (...), t2 AS (...)  -- Good
   FROM table1 JOIN table2  -- May cause cross-shard issues
   ```

4. **Use appropriate FORMAT**
   ```sql
   FORMAT JSON  -- For API consumption
   FORMAT Pretty  -- For terminal viewing
   FORMAT TabSeparated  -- For piping to other tools
   ```

## Data Freshness

- **Real-time**: Streamed directly from Xatu collectors
- **Latency**: Typically seconds to minutes
- **Completeness**: No redactions or privacy filtering
- **Network coverage**: See table catalog for date ranges

## Additional Resources

- **Parquet Files**: See `/llms/parquet/llms.txt` for public file access
- **Schema Repository**: https://github.com/ethpandaops/xatu-data/tree/master/schema/clickhouse
- **Config File**: https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml

## License

Data licensed under CC BY 4.0
EOF
}

# Main execution

# Generate llms/parquet and llms/clickhouse files FIRST (so they're referenced by top-level files)

# Generate llms/parquet/llms.txt (concise) using separate script
log "Generating $llms_parquet_file file..."
./scripts/generate-llms-parquet.sh "$llms_parquet_file" "$config_file" "concise"

# Generate llms/parquet/llms-full.txt (comprehensive) using separate script
llms_parquet_full_file="llms/parquet/llms-full.txt"
log "Generating $llms_parquet_full_file file..."
./scripts/generate-llms-parquet.sh "$llms_parquet_full_file" "$config_file" "full"

# Generate llms/clickhouse/llms.txt (concise) using separate script
log "Generating $llms_clickhouse_file file..."
./scripts/generate-llms-clickhouse.sh "$llms_clickhouse_file" "$config_file" "$clickhouse_host" "concise"

# Generate llms/clickhouse/llms-full.txt (comprehensive) using separate script
llms_clickhouse_full_file="llms/clickhouse/llms-full.txt"
log "Generating $llms_clickhouse_full_file file..."
./scripts/generate-llms-clickhouse.sh "$llms_clickhouse_full_file" "$config_file" "$clickhouse_host" "full"

# Now generate top-level llms.txt (navigation to specialized files)
log "Generating $llms_txt_file file..."
generate_top_level_llms "$llms_txt_file"
log "$llms_txt_file file generated successfully."

# Generate llms-full.txt (same as llms.txt - just navigation)
log "Generating $llms_full_txt_file file..."
generate_top_level_llms "$llms_full_txt_file"
log "$llms_full_txt_file file generated successfully."