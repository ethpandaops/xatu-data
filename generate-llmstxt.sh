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

# Ensure yq and curl are installed
if ! command -v yq &> /dev/null; then
    log "Required command 'yq' is not installed. Please install it to proceed."
    exit 1
fi

if ! command -v curl &> /dev/null; then
    log "Required command 'curl' is not installed. Please install it to proceed."
    exit 1
fi

# Create the llms.txt file
log "Generating llms.txt file..."

# Start writing the file
cat > "$output_file" << 'EOF'
# Xatu Dataset Guide

Note: 
## Dataset Overview

Xatu data contains information about the Ethereum network, organized into different datasets.
- Xatu is a data collection and processing pipeline for Ethereum network data.
- Xatu contains multiple "modules" that each derive Ethereum data differently. This data is then forwarded on to a data pipeline, and stored in a Clickhouse database.
- ethPandaOps runs all modules to hydrate the data pipeline. Community members also run some modules to contribute their data to the data pipeline.
- All the data is then openly published to Parquet files with a 1 to 3 day delay with a few columns redacted for privacy.

## Notes

### Clickhouse
When querying data via Parquet files:
  - Data is partitioned differently for each table. Check the table config for the partitioning column and type.
  - You should calculate the minimum and maximum values for the partitioning column to avoid querying too much data. Generally its better to request a little more data than you need and to then filter within the query.
  - You MUST use the partitioning column as a filter to avoid querying too much data. 
    - This is extremely important and can be the difference between a query that runs in seconds and one that runs for hours.
    
When loading Parquet files into Clickhouse, you should first create the table schema in Clickhouse, and then use the `url` function to load the data.
  - Without this, Clickhouse will store the data sub-optimally resulting in significantly more disk space usage.
  - The CREATE TABLE statement is available here: https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/$DATABASE/$TABLE_NAME.sql

## Datasets
EOF

# Extract dataset information
cat config.yaml | yq e '.datasets[] | "- **" + .name + "**: " + .description + " (Prefix: `" + .tables.prefix + "`)"' - >> "$output_file"

# Add information about data availability
cat >> "$output_file" << 'EOF'

## Data Availability

- **Public Parquet Files**: Available to everyone
- **EthPandaOps Clickhouse**: Restricted access (contact ethpandaops@ethereum.org)


## URL Patterns

### Datetime partitioned tables:
```
https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/YYYY/MM/DD.parquet
https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/YYYY/MM/DD/HH.parquet
```

### Integer partitioned tables:
```
https://data.ethpandaops.io/xatu/NETWORK/databases/DATABASE/TABLE/INTERVAL/CHUNK_NUMBER.parquet
```

Where:
- NETWORK: mainnet, holesky, sepolia, etc.
- DATABASE: usually "default"
- TABLE: the table name
- INTERVAL: partitioning interval (e.g., 1000)
- CHUNK_NUMBER: chunk number (e.g., 0, 1000, 2000)

## Query Examples

### Using Clickhouse:
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

-- Multiple files using glob pattern
--- With hourly partitioning
SELECT
    toDate(slot_start_date_time) AS date,
    count(*) AS event_count
FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/{20,21,22}.parquet', 'Parquet')
GROUP BY date
ORDER BY date

--- With integer partitioning
SELECT 
COUNT(*) 
FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/{20000..20010}000.parquet', 'Parquet')
LIMIT 10 FORMAT Pretty"
```

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

EOF

cat >> "$output_file" << 'EOF'

## Schema Documentation

### Common Fields

All tables include:
- **meta_client_name**: Client that collected the data
- **meta_client_id**: Unique Session ID
- **meta_client_version**: Client version
- **meta_network_name**: Network name
- **event_date_time**: When the event was created

### Tables
EOF

# Generate and add the table listing with date ranges
log "Generating table listing with date ranges..."
yq e '.tables[] | "# " + .name + 
  "\n  - Database: " + .database + 
  "\n  - Description: " + .description + 
  "\n  - Partitioning: " + .partitioning.column + " (" + .partitioning.type + "), " + .partitioning.interval + 
  "\n  - Networks: " + 
  (.networks | to_entries | map(
    .key + " (" + .value.from + " to " + .value.to + ")"
  ) | join(", ")) +
  "\n  - Tags: " + (.tags | join(", "))' config.yaml >> "$output_file"

# Add information about table structure
cat >> "$output_file" << 'EOF'

## License

Xatu data is licensed under CC BY 4.0.

For more information: https://github.com/ethpandaops/xatu-data
EOF

log "llms.txt file generated successfully." 