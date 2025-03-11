#!/bin/bash

# Import dep scripts
source ./scripts/log.sh
source ./scripts/date.sh

set -e

# Configuration
output_file="llms.txt"
github_config_url="https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml"

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# Ensure yq is installed
if ! command -v yq &> /dev/null; then
    log "Required command 'yq' is not installed. Please install it to proceed."
    exit 1
fi

# Ensure curl is installed
if ! command -v curl &> /dev/null; then
    log "Required command 'curl' is not installed. Please install it to proceed."
    exit 1
fi

# Create the llms.txt file
log "Generating llms.txt file..."

# Start writing the file
cat > "$output_file" << 'EOF'
# Xatu Dataset Guide

This is a concise guide to the Xatu dataset, which contains information about the Ethereum network, including beacon chain events, mempool activity, and canonical chain events.

## Dataset Overview

Xatu data is organized into different datasets, each with its own prefix and tables:

EOF

# Extract dataset information
curl -s "$github_config_url" | yq e '.datasets[] | "- **" + .name + "**: " + .description + " (Prefix: `" + .tables.prefix + "`)"' - >> "$output_file"

# Add information about data availability
cat >> "$output_file" << 'EOF'

## Data Availability

Xatu data is available in two forms:
1. **Public Parquet Files**: Available to everyone
2. **EthPandaOps Clickhouse**: Access is restricted (contact ethpandaops@ethereum.org for access)

## How to Query Parquet Files

Parquet files are organized by network, database, table, and partitioning scheme. The URL pattern depends on the partitioning type:

### Querying
Whenever querying any data in the Xata dataset, it is paramount that you use the partitioning column as a filter to avoid querying too much data.

#### For datetime partitioned tables:

Daily partitioning:
```
https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/YYYY/MM/DD.parquet
```

Hourly partitioning:
```
https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/YYYY/MM/DD/HH.parquet
```

#### For integer partitioned tables:

```
https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/INTERVAL/CHUNK_NUMBER.parquet
```

Where:
- NETWORK: mainnet, holesky, sepolia, etc.
- DATABASE: usually "default"
- TABLE: the table name (see schema documentation)
- INTERVAL: the partitioning interval (e.g., 1000)
- CHUNK_NUMBER: the chunk number (e.g., 0, 1000, 2000, etc.)

## Query Examples

### Using Docker with Clickhouse to query Parquet files:

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query="
    SELECT *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/TABLE/YYYY/MM/DD.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty"
```

### Using EthPandaOps Clickhouse:

```bash
echo "
    SELECT *
    FROM default.TABLE
    WHERE partition_column >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```

### Using Python with Pandas:

```python
import pandas as pd

# Load a parquet file
df = pd.read_parquet("https://data.ethpandaops.io/xatu/mainnet/databases/default/TABLE/YYYY/MM/DD.parquet")

# Display the first few rows
print(df.head())
```

### Using Python with DuckDB:

```python
import duckdb

# Query a parquet file
result = duckdb.query("""
    SELECT *
    FROM 'https://data.ethpandaops.io/xatu/mainnet/databases/default/TABLE/YYYY/MM/DD.parquet'
    LIMIT 10
""").fetchdf()

print(result)
```

## Checking Data Availability

You can check what data is available directly from the GitHub repository's config.yaml file. The config file contains information about which tables are available, for which networks, and for what time periods or ranges.

### Get all tables with basic information

```bash
# List all tables with their database and partitioning info
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | "Table: " + .name + "\nDatabase: " + .database + "\nPartitioning: " + .partitioning.type + " by " + .partitioning.column + " (" + .partitioning.interval + ")"'
```

To get more detailed information about tables from a specific dataset:

```bash
# Get all beacon API tables with database, partitioning, and network info
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name | test("^beacon_api_")) | 
    "Table: " + .name + 
    "\n  Database: " + .database + 
    "\n  Partitioning: " + .partitioning.type + " by " + .partitioning.column + " (" + .partitioning.interval + ")" +
    "\n  Networks: " + (.networks | keys | join(", "))' -
```

### Check available networks and date ranges for a specific table:

```bash
# For datetime partitioned tables (shows from/to dates)
TABLE="beacon_api_eth_v1_events_head"
DATABASE=$(curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | .database' -)
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | "Table: " + .name + "\nDatabase: " + .database + "\nNetworks: " + (.networks | to_json)' -

# For integer partitioned tables (shows from/to chunk numbers)
TABLE="mempool_transaction"
DATABASE=$(curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | .database' -)
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | "Table: " + .name + "\nDatabase: " + .database + "\nNetworks: " + (.networks | to_json)' -
```

### Check partitioning information for a table:

```bash
# Get partitioning type, column, and interval
TABLE="beacon_api_eth_v1_events_head"
DATABASE=$(curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | .database' -)
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | "Table: " + .name + "\nDatabase: " + .database + "\nPartitioning: " + (.partitioning | to_json)' -
```

### Example: Constructing a URL for a specific date or range:

For a datetime partitioned table with daily partitioning:
```bash
TABLE="beacon_api_eth_v1_events_head"
NETWORK="mainnet"
DATABASE=$(curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | .database' -)
DATE="2023-01-01"
YEAR=$(date -d "$DATE" '+%Y')
MONTH=$(date -d "$DATE" '+%-m')
DAY=$(date -d "$DATE" '+%-d')

echo "https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE/$YEAR/$MONTH/$DAY.parquet"
```

For a datetime partitioned table with hourly partitioning:
```bash
TABLE="beacon_api_eth_v1_events_head"
NETWORK="mainnet"
DATABASE=$(curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | .database' -)
DATE="2023-01-01"
HOUR=12
YEAR=$(date -d "$DATE" '+%Y')
MONTH=$(date -d "$DATE" '+%-m')
DAY=$(date -d "$DATE" '+%-d')

echo "https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE/$YEAR/$MONTH/$DAY/$HOUR.parquet"
```

For an integer partitioned table:
```bash
TABLE="canonical_execution_block"
NETWORK="mainnet"
DATABASE=$(curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | .database' -)
INTERVAL=$(curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | .partitioning.interval' -)
BLOCK_NUMBER=16000000
CHUNK_NUMBER=$(( (BLOCK_NUMBER / INTERVAL) * INTERVAL ))

echo "https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE/$INTERVAL/$CHUNK_NUMBER.parquet"
```

For multiple files in a range (integer partitioning):
```bash
TABLE="canonical_execution_block"
NETWORK="mainnet"
DATABASE=$(curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | .database' -)
INTERVAL=$(curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml | \
  yq e '.tables[] | select(.name == "'$TABLE'") | .partitioning.interval' -)
START_BLOCK=16000000
END_BLOCK=16010000
START_CHUNK=$(( (START_BLOCK / INTERVAL) * INTERVAL ))
END_CHUNK=$(( (END_BLOCK / INTERVAL) * INTERVAL ))

echo "https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE/$INTERVAL/{$START_CHUNK..$END_CHUNK}.parquet"
```

## Practical Query Examples

### Query datetime partitioned data with Docker and output as JSON:

```bash
# Query block propagation times for a specific date range and output as JSON
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query="
    SELECT
        toDate(slot_start_date_time) AS date,
        round(MIN(propagation_slot_start_diff)) AS min_ms,
        round(quantile(0.05)(propagation_slot_start_diff)) AS p05_ms,
        round(quantile(0.50)(propagation_slot_start_diff)) AS p50_ms,
        round(quantile(0.90)(propagation_slot_start_diff)) AS p90_ms
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/{20..27}.parquet', 'Parquet')
    GROUP BY date
    ORDER BY date
    FORMAT JSONEachRow
"
```

### Query integer partitioned data with Docker:

```bash
# Query transaction data for blocks in a specific range
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query="
    SELECT
      *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/{16000..16010}000.parquet', 'Parquet')
    WHERE block_number BETWEEN 16000000 AND 16010000
    LIMIT 2
    FORMAT JSONEachRow
"
```

### Complete example with JSON output for scripting:

```bash
#!/bin/bash

# Define parameters
NETWORK="mainnet"
DATABASE="default"
TABLE="canonical_execution_block"
START_BLOCK=16000000
END_BLOCK=16001000
INTERVAL=1000

# Calculate chunk numbers
START_CHUNK=$((START_BLOCK / INTERVAL * INTERVAL))
END_CHUNK=$((END_BLOCK / INTERVAL * INTERVAL))

# Construct the query - use explicit file path instead of glob pattern to avoid "too many result addresses" error
QUERY="
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE/$INTERVAL/$START_CHUNK.parquet', 'Parquet')
    WHERE block_number BETWEEN $START_BLOCK AND $END_BLOCK
    ORDER BY block_number
    LIMIT 2
    FORMAT JSONEachRow
"

# Execute the query and capture the output
RESULT=$(docker run --rm -i clickhouse/clickhouse-server clickhouse local --query="$QUERY")

# Output the result (can be piped to jq for further processing)
echo "$RESULT"

# Example of how to use with jq to extract specific fields
# echo "$RESULT" | jq -r '.block_number + "," + .block_hash'
```

## Schema Documentation

Each dataset has its own schema documentation file:

EOF

# Add schema links
curl -s "$github_config_url" | yq e '.datasets[] | "- [" + .name + "](./schema/" + .tables.prefix + ".md): Tables with prefix `" + .tables.prefix + "`"' - >> "$output_file"

# Add information about table structure
cat >> "$output_file" << 'EOF'

## Table Structure

Each table in the Xatu dataset follows a consistent structure with metadata fields:
- **meta_client_name**: The name of the client that collected the data
- **meta_client_id**: Unique Session ID of the client that generated the event
- **meta_client_version**: The version of the client
- **meta_network_name**: The network name (e.g., mainnet, holesky, sepolia, etc.)
- **event_date_time**: When the data pipeline created the event

Additional columns are specific to each table and are documented in the schema files.

## Partitioning

Tables are partitioned either by:
1. **datetime**: Partitioned by a timestamp column (hourly or daily)
2. **integer**: Partitioned by an integer column in chunks of a specific interval

## Common Use Cases

1. **Analyzing block propagation**:
   ```sql
   SELECT 
       meta_network_name,
       slot,
       meta_client_name,
       event_date_time - slot_start_date_time AS propagation_time
   FROM beacon_api_eth_v1_events_block
   WHERE slot_start_date_time >= NOW() - INTERVAL '1 DAY'
   ORDER BY slot, event_date_time
   ```

2. **Tracking finalized checkpoints**:
   ```sql
   SELECT 
       meta_network_name,
       epoch,
       root,
       meta_client_name,
       event_date_time
   FROM beacon_api_eth_v1_events_finalized_checkpoint
   WHERE epoch_start_date_time >= NOW() - INTERVAL '1 DAY'
   ORDER BY epoch, event_date_time
   ```

3. **Monitoring transaction propagation in the mempool**:
   ```sql
   SELECT 
       meta_network_name,
       hash,
       meta_client_name,
       event_date_time
   FROM mempool_transaction
   WHERE event_date_time >= NOW() - INTERVAL '1 DAY'
   ORDER BY event_date_time
   ```

## License

Xatu data is licensed under CC BY 4.0.

For more information, visit: https://github.com/ethpandaops/xatu-data
EOF

log "llms.txt file generated successfully." 