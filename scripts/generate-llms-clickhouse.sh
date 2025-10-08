#!/bin/bash

# Generate llms/clickhouse/llms.txt - focused on ClickHouse database access
# Usage: ./scripts/generate-llms-clickhouse.sh [output_file] [config_file] [clickhouse_host] [detail_level]

set -e

# Default parameters
output_file="${1:-llms/clickhouse/llms.txt}"
config_file="${2:-config.yaml}"
clickhouse_host="${3:-${CLICKHOUSE_HOST:-http://localhost:8123}}"
detail_level="${4:-concise}"  # concise or full

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/log.sh"

log "Generating ClickHouse-focused llms.txt ($detail_level) at $output_file..."

# Ensure output directory exists
mkdir -p "$(dirname "$output_file")"

# Check if ClickHouse is available for CBT auto-discovery
cbt_discovery_enabled=false
if curl -s "$clickhouse_host" --data "SELECT 1 FORMAT TabSeparated" > /dev/null 2>&1; then
    if curl -s "$clickhouse_host" --data "SELECT 1 FROM system.databases WHERE name = 'mainnet' FORMAT TabSeparated" | grep -q "1"; then
        cbt_discovery_enabled=true
        log "CBT auto-discovery enabled (ClickHouse mainnet database found)"
    else
        log "CBT auto-discovery disabled (mainnet database not found)"
    fi
else
    log "CBT auto-discovery disabled (ClickHouse not available at $clickhouse_host)"
fi

# Auto-discover CBT tables from ClickHouse
discover_cbt_tables() {
    local cbt_database="mainnet"
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

# Get CBT table info
get_cbt_table_info() {
    local table_name=$1
    local cbt_database="mainnet"

    local description=$(curl -s "$clickhouse_host" --data "SELECT comment FROM system.tables WHERE database = '$cbt_database' AND name = '${table_name}_local' FORMAT TabSeparated")
    local sorting_key=$(curl -s "$clickhouse_host" --data "SELECT sorting_key FROM system.tables WHERE database = '$cbt_database' AND name = '${table_name}_local' FORMAT TabSeparated")
    local partition_column=$(echo "$sorting_key" | sed 's/,.*//; s/^[[:space:]]*//; s/[[:space:]]*$//')
    local column_type=$(curl -s "$clickhouse_host" --data "SELECT type FROM system.columns WHERE database = '$cbt_database' AND table = '${table_name}_local' AND name = '$partition_column' FORMAT TabSeparated")

    local partition_type="none"
    local partition_interval=""
    if [[ "$column_type" =~ ^DateTime || "$column_type" =~ ^Date ]]; then
        partition_type="datetime"
        partition_interval="daily"
    elif [[ "$column_type" =~ ^UInt || "$column_type" =~ ^Int ]]; then
        partition_type="integer"
        partition_interval="1000"
    fi

    echo "### $table_name"
    echo "- **Database**: Network-specific (see Networks below)"
    echo "- **Description**: $description"
    echo "- **Partitioning**: $partition_column ($partition_type), $partition_interval"
    echo "- **Networks**: mainnet (\`mainnet.$table_name\`), sepolia (\`sepolia.$table_name\`), holesky (\`holesky.$table_name\`), hoodi (\`hoodi.$table_name\`)"
    echo "- **Tags**: "
}

# Generate the file
cat > "$output_file" << 'EOF'
# Xatu ClickHouse Database
> Direct database access to Ethereum network data.
Xatu is a data collection and processing pipeline for Ethereum network data.
- Xatu contains multiple "modules" that each derive Ethereum data differently
- The data is stored in a Clickhouse database and published to Parquet files
- ethPandaOps runs all modules, with community members also contributing data

## Looking for Public Parquet Files?
**If you want public access without authentication**, see https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/parquet/llms.txt for Parquet file documentation.

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

### CBT (ClickHouse Build Tool) Tables

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
yq e '.tables[] | "### `" + .name + "`\n- **Database**: `" + .database + "`\n- **Partitioning**: `" + .partitioning.column + "` (" + .partitioning.type + ", " + .partitioning.interval + ")\n- **Networks**: " + (.networks | to_entries | map(.key) | join(", ")) + "\n- **Description**: " + .description + "\n"' "$config_file" >> "$output_file"

cat >> "$output_file" << 'EOF'

## Advanced Query Patterns

### Proper JOIN with CTEs
```sql
-- ALWAYS use CTEs when joining to avoid cross-shard issues
WITH
    canonical AS (
        SELECT *
        FROM canonical_beacon_block FINAL
        WHERE slot_start_date_time BETWEEN toDateTime('2024-04-01') AND toDateTime('2024-04-02')
            AND meta_network_name = 'mainnet'
    ),
    events AS (
        SELECT *
        FROM beacon_api_eth_v1_events_block FINAL
        WHERE slot_start_date_time BETWEEN toDateTime('2024-04-01') AND toDateTime('2024-04-02')
            AND meta_network_name = 'mainnet'
    )
SELECT
    c.slot,
    c.block_root,
    c.proposer_index,
    COUNT(DISTINCT e.meta_client_name) as observer_count,
    MIN(e.propagation_slot_start_diff) as min_propagation
FROM canonical c
LEFT JOIN events e ON c.slot = e.slot
GROUP BY c.slot, c.block_root, c.proposer_index
ORDER BY c.slot;
```

### Time-Based Aggregation
```sql
SELECT
    toStartOfHour(slot_start_date_time) AS hour,
    COUNT(*) as block_count,
    quantile(0.5)(propagation_slot_start_diff) as p50_propagation,
    quantile(0.95)(propagation_slot_start_diff) as p95_propagation
FROM beacon_api_eth_v1_events_block FINAL
WHERE
    slot_start_date_time >= NOW() - INTERVAL 24 HOUR
    AND meta_network_name = 'mainnet'
GROUP BY hour
ORDER BY hour DESC;
```

### Network Consensus Analysis
```sql
-- Find missed slots
WITH expected_slots AS (
    SELECT number as slot
    FROM numbers(
        (SELECT MIN(slot) FROM canonical_beacon_block WHERE slot_start_date_time >= toDateTime('2024-04-01')),
        (SELECT MAX(slot) FROM canonical_beacon_block WHERE slot_start_date_time < toDateTime('2024-04-02'))
    )
)
SELECT
    e.slot,
    b.block_root IS NULL as is_missed
FROM expected_slots e
LEFT JOIN canonical_beacon_block b ON e.slot = b.slot
WHERE is_missed = 1;
```

### MEV Analysis
```sql
SELECT
    slot,
    builder_pubkey,
    value / 1e18 as value_eth,
    num_txs
FROM mev_relay_bid_trace FINAL
WHERE
    slot_start_date_time >= toDateTime('2024-04-01')
    AND slot_start_date_time < toDateTime('2024-04-02')
    AND meta_network_name = 'mainnet'
ORDER BY value DESC
LIMIT 20;
```

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

## Dataset overview
- Data is stored in ClickHouse database. You MUST use CTEs when joining to avoid cross-shard issues.
- The data pipeline can be delayed by 10seconds to 10 minutes.
- IMPORTANT: If the table contains a `meta_client_name` column, there is a high chance that the data is being collected by multiple instances and you will see the same data multiple times. THIS IS A FEATURE OF THE DATASET.
- Querying the CBT tables should be a priority as they are pre-aggregated and are the most complete and reliable source of data.
- It is HIGHLY recommended to explore the available tables and understand the data before querying.

### Core Datasets
- **Beacon API Event Stream**: Events derived from the Beacon API event stream. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances. These tables are usually fairly slim and contain only a few columns. These tables can be joined with the canonical tables to get a more complete view of the data. For example, you can join the beacon_api_eth_v1_events_block table on block_root or slot with the canonical_beacon_block table to get the block data for each block. (Prefix: `beacon_api_`)
- **Execution Layer P2P**: Events from the execution layer p2p network. This data is usually useful for 'timing' events, such as when a transaction was seen in the mempool by an instance. Because of this it usually has the same data but from many different instances. (Prefix: `mempool_`)
- **Canonical Beacon**: Events derived from the finalized beacon chain. This data is only derived by a single instance, are deduped, and are more complete and reliable than the beacon_api_ tables. These tables can be reliably JOINed on to hydrate other tables with information (Prefix: `canonical_beacon_`)
- **Canonical Execution**: Data extracted from the execution layer. This data is only derived by a single instance, are deduped, and are more complete and reliable than the execution_layer_p2p tables. These tables can be reliably JOINed on to hydrate other tables with information (Prefix: `canonical_execution_`)
- **Consensus Layer P2P**: Events from the consensus layer p2p network. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances. (Prefix: `libp2p_`)
- **MEV Relay**: Events derived from MEV relays. Data is scraped from multiple MEV Relays by multiple instances. (Prefix: `mev_relay_`)
- **CBT (ClickHouse Build Tools)**: Pre-aggregated analytical tables for common blockchain queries. These tables are transformation tables similar to DBT, powered by [xatu-cbt](https://github.com/ethpandaops/xatu-cbt) using [ClickHouse Build Tools (CBT)](https://github.com/ethpandaops/cbt). (Prefix: ``). These tables exist in the $network databases.

### ⚠️ Critical: Query Optimization
**ALWAYS filter on partitioning columns:**
- Queries without partition filters will scan **billions of rows**
- Use `FINAL` modifier for tables with `ReplacingMergeTree` engine
- Use CTEs when joining to avoid cross-shard issues
- Check table partitioning column before querying

### Get Table Schema
```bash
# Download CREATE TABLE statement
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/$DATABASE/$TABLE_NAME.sql

# Example: canonical beacon blocks
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/canonical_beacon_block.sql
```

### Common Metadata Fields
- `meta_client_name` - Data collection client
- `meta_client_id` - Unique session ID
- `meta_network_name` - Network filter (mainnet, holesky, etc.)
- `event_date_time` - Event timestamp
- Partition column (see table catalog)

**Note**: CBT tables don't include meta fields; network selection is via database.

EOF

# Add full version content
if [ "$detail_level" = "full" ]; then
    cat >> "$output_file" << 'EOF'

## Advanced Integration Examples

### Apache Superset Dashboard
```python
# superset_config.py
from sqlalchemy import create_engine

SQLALCHEMY_DATABASE_URI = f"clickhouse+http://{user}:{password}@clickhouse.xatu.ethpandaops.io:443/default?protocol=https"

# Create saved query
"""
SELECT
    toStartOfDay(slot_start_date_time) as date,
    meta_network_name,
    COUNT(*) as block_count,
    quantile(0.5)(propagation_slot_start_diff) as median_propagation
FROM beacon_api_eth_v1_events_block FINAL
WHERE slot_start_date_time >= NOW() - INTERVAL 30 DAY
    AND meta_network_name IN ('mainnet', 'holesky')
GROUP BY date, meta_network_name
ORDER BY date DESC
"""
```

### Grafana + ClickHouse
```sql
-- Create dashboard query for Grafana ClickHouse plugin
SELECT
    $__timeInterval(slot_start_date_time) as time,
    meta_client_name as metric,
    COUNT(*) as value
FROM beacon_api_eth_v1_events_block FINAL
WHERE $__timeFilter(slot_start_date_time)
    AND meta_network_name = '$network'
GROUP BY time, metric
ORDER BY time
```

### dbt-clickhouse Transformations
```yaml
# models/schema.yml
version: 2

models:
  - name: daily_block_stats
    description: "Daily aggregated block statistics"
    config:
      materialized: table
      engine: MergeTree()
      order_by: ['date', 'network']
      partition_by: toYYYYMM(date)

# models/daily_block_stats.sql
{{  config(
    materialized='table',
    engine='MergeTree()',
    order_by='(date, network)'
) }}

SELECT
    toDate(slot_start_date_time) as date,
    meta_network_name as network,
    COUNT(*) as total_blocks,
    COUNT(DISTINCT proposer_index) as unique_proposers,
    AVG(propagation_slot_start_diff) as avg_propagation_ms
FROM {{ source('xatu', 'beacon_api_eth_v1_events_block') }} FINAL
WHERE slot_start_date_time >= current_date() - INTERVAL 90 DAY
GROUP BY date, network
```

## Performance Tuning

### Materialized Views for Common Queries
```sql
-- Create materialized view for frequently accessed aggregations
CREATE MATERIALIZED VIEW daily_attestation_stats_mv
ENGINE = SummingMergeTree()
PARTITION BY toYYYYMM(date)
ORDER BY (date, meta_network_name)
AS SELECT
    toDate(slot_start_date_time) AS date,
    meta_network_name,
    COUNT(*) AS attestation_count,
    uniqExact(meta_client_name) AS unique_clients,
    quantileState(0.5)(propagation_slot_start_diff) AS median_prop_state
FROM beacon_api_eth_v1_events_attestation
GROUP BY date, meta_network_name;

-- Query the materialized view (much faster)
SELECT
    date,
    meta_network_name,
    sum(attestation_count) as total_attestations,
    quantileMerge(0.5)(median_prop_state) as median_propagation
FROM daily_attestation_stats_mv
WHERE date >= today() - 30
GROUP BY date, meta_network_name
ORDER BY date DESC;
```

### Using Projections
```sql
-- Create a projection for common access patterns
ALTER TABLE beacon_api_eth_v1_events_block
ADD PROJECTION block_by_client (
    SELECT
        meta_client_name,
        slot,
        block_root,
        propagation_slot_start_diff
    ORDER BY (meta_client_name, slot)
);

-- Materialize the projection
ALTER TABLE beacon_api_eth_v1_events_block
MATERIALIZE PROJECTION block_by_client;

-- Queries filtering by meta_client_name will now be faster
SELECT slot, AVG(propagation_slot_start_diff)
FROM beacon_api_eth_v1_events_block FINAL
WHERE meta_client_name = 'lighthouse'
    AND slot_start_date_time >= NOW() - INTERVAL 1 DAY
GROUP BY slot;
```

### Query Result Caching
```bash
# Enable query cache for repeated queries
echo """
SELECT
    meta_client_name,
    COUNT(*) as block_count
FROM beacon_api_eth_v1_events_block FINAL
WHERE slot_start_date_time >= today() - 1
    AND meta_network_name = 'mainnet'
GROUP BY meta_client_name
SETTINGS use_query_cache = 1
""" | curl "https://clickhouse.xatu.ethpandaops.io" \
    -u "$USER:$PASS" \
    --data-binary @-
```

## Data Quality & Monitoring

### Checking Data Completeness
```sql
-- Find gaps in block data
WITH expected AS (
    SELECT number as slot
    FROM numbers(
        (SELECT MIN(slot) FROM canonical_beacon_block WHERE slot_start_date_time >= today() - 1),
        (SELECT MAX(slot) FROM canonical_beacon_block WHERE slot_start_date_time < today()) + 1
    )
),
actual AS (
    SELECT DISTINCT slot
    FROM canonical_beacon_block
    WHERE slot_start_date_time >= today() - 1
)
SELECT e.slot as missing_slot
FROM expected e
LEFT JOIN actual a ON e.slot = a.slot
WHERE a.slot IS NULL
ORDER BY e.slot;
```

### Data Freshness Monitoring
```sql
-- Check how recent the data is
SELECT
    'beacon_api_eth_v1_events_block' as table_name,
    MAX(slot_start_date_time) as latest_timestamp,
    dateDiff('second', MAX(slot_start_date_time), NOW()) as seconds_behind
FROM beacon_api_eth_v1_events_block
WHERE meta_network_name = 'mainnet'

UNION ALL

SELECT
    'canonical_beacon_block' as table_name,
    MAX(slot_start_date_time) as latest_timestamp,
    dateDiff('second', MAX(slot_start_date_time), NOW()) as seconds_behind
FROM canonical_beacon_block
WHERE meta_network_name = 'mainnet';
```

### Detecting Duplicate Data
```sql
-- Find duplicates in event stream tables
SELECT
    slot,
    block_root,
    COUNT(*) as observation_count,
    groupArray(meta_client_name) as observing_clients
FROM beacon_api_eth_v1_events_block
WHERE slot_start_date_time >= NOW() - INTERVAL 1 HOUR
    AND meta_network_name = 'mainnet'
GROUP BY slot, block_root
HAVING observation_count > 20  -- Unusually high
ORDER BY observation_count DESC
LIMIT 10;
```

## Complex Analysis Patterns

### Validator Performance Analysis
```sql
-- Analyze validator block proposal success rate
WITH proposals AS (
    SELECT
        proposer_index,
        COUNT(*) as proposed_count
    FROM canonical_beacon_block FINAL
    WHERE slot_start_date_time >= NOW() - INTERVAL 7 DAY
        AND meta_network_name = 'mainnet'
    GROUP BY proposer_index
),
expected AS (
    SELECT
        proposer_index,
        COUNT(*) as expected_count
    FROM beacon_api_eth_v1_beacon_committee FINAL
    WHERE slot_start_date_time >= NOW() - INTERVAL 7 DAY
        AND meta_network_name = 'mainnet'
        AND duty = 'proposer'
    GROUP BY proposer_index
)
SELECT
    e.proposer_index,
    e.expected_count,
    COALESCE(p.proposed_count, 0) as proposed_count,
    round(COALESCE(p.proposed_count, 0) / e.expected_count * 100, 2) as success_rate_pct
FROM expected e
LEFT JOIN proposals p ON e.proposer_index = p.proposer_index
WHERE e.expected_count >= 5  -- At least 5 expected proposals
ORDER BY success_rate_pct ASC
LIMIT 20;
```

### Network Health Dashboard Query
```sql
-- Comprehensive network health metrics
SELECT
    toStartOfHour(slot_start_date_time) as hour,

    -- Block metrics
    COUNT(DISTINCT b.slot) as unique_slots,
    COUNT(DISTINCT b.proposer_index) as unique_proposers,

    -- Propagation metrics
    AVG(e.propagation_slot_start_diff) as avg_propagation_ms,
    quantile(0.95)(e.propagation_slot_start_diff) as p95_propagation_ms,

    -- Observer diversity
    uniqExact(e.meta_client_name) as unique_observers,

    -- MEV metrics
    COUNT(DISTINCT m.block_hash) as mev_blocks,
    SUM(m.value) / 1e18 as total_mev_value_eth

FROM canonical_beacon_block b FINAL
LEFT JOIN beacon_api_eth_v1_events_block e FINAL
    ON b.slot = e.slot AND b.meta_network_name = e.meta_network_name
LEFT JOIN mev_relay_bid_trace m FINAL
    ON b.execution_block_hash = m.block_hash AND b.meta_network_name = m.meta_network_name

WHERE b.slot_start_date_time >= NOW() - INTERVAL 24 HOUR
    AND b.meta_network_name = 'mainnet'

GROUP BY hour
ORDER BY hour DESC;
```

### Cross-Network Comparison
```sql
-- Compare metrics across networks
SELECT
    meta_network_name as network,
    COUNT(DISTINCT DATE(slot_start_date_time)) as days_of_data,
    COUNT(*) as total_blocks,
    COUNT(DISTINCT proposer_index) as unique_validators,
    AVG(propagation_slot_start_diff) as avg_propagation_ms,
    MIN(slot_start_date_time) as earliest_data,
    MAX(slot_start_date_time) as latest_data
FROM beacon_api_eth_v1_events_block FINAL
WHERE slot_start_date_time >= NOW() - INTERVAL 30 DAY
GROUP BY network
ORDER BY total_blocks DESC;
```

## Troubleshooting

### Common Query Errors

**Error: Memory limit exceeded**
```sql
-- Solution: Add LIMIT or use sampling
SELECT *
FROM large_table
WHERE partition_column >= '2024-01-01'
LIMIT 10000;  -- Add explicit limit

-- Or use sampling
SELECT *
FROM large_table SAMPLE 0.1  -- Sample 10%
WHERE partition_column >= '2024-01-01';
```

**Error: Timeout exceeded**
```sql
-- Solution: Use streaming or break into smaller queries
SELECT *
FROM large_query
SETTINGS max_execution_time = 300;  -- Increase timeout

-- Or break into time windows
SELECT *
FROM table
WHERE slot_start_date_time >= '2024-04-01 00:00:00'
    AND slot_start_date_time < '2024-04-01 01:00:00';  -- 1 hour window
```

**Error: Too many parts**
- Reduce query frequency
- Use larger batch sizes
- Contact ethpandaops team

### Query Debugging
```sql
-- Enable query profiling
SELECT *
FROM system.query_log
WHERE type = 'QueryFinish'
    AND query_duration_ms > 1000
    AND event_time >= NOW() - INTERVAL 1 HOUR
ORDER BY query_duration_ms DESC
LIMIT 10;

-- Explain query plan
EXPLAIN PLAN
SELECT *
FROM beacon_api_eth_v1_events_block
WHERE slot_start_date_time >= NOW() - INTERVAL 1 DAY
    AND meta_network_name = 'mainnet';
```

## Data Retention & Historical Access

- **Hot data**: Last 30 days (fast queries)
- **Warm data**: 30-90 days (moderate performance)
- **Cold data**: >90 days (contact for access)
- **Network coverage**: See table catalog for specific ranges

EOF
fi

cat >> "$output_file" << 'EOF'

## Data Freshness

- **Real-time**: Streamed directly from Xatu collectors
- **Latency**: Typically seconds to minutes
- **Completeness**: No redactions or privacy filtering
- **Network coverage**: See table catalog for date ranges

## Additional Resources

- **Parquet Files**: https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/llms/parquet/llms.txt for public file access
- **Schema Repository**: https://github.com/ethpandaops/xatu-data/tree/master/schema/clickhouse
- **Config File**: https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml
- **Contact**: ethpandaops@ethereum.org

## Hints (VERY IMPORTANT)
- It is HIGHLY recommended to explore the available tables and understand the data before querying.
- The CBT tables (in the $network database) MUST be your first choice for data. Inspect all the available tables and understand the data before querying.
- A large amount of CBT tables have _head and _canonical variants. Make sure you know which one you are querying as the data can be different.
- To check when a block was first seen by nodes in the Xatu network, check the $network.fct_block_first_seen_by_node table.
- A "best effort" table in $network.dim_node contains validator information like the entity running the validator. In devnets this also contains the node name that is running the validator.
- When asked for Grafana compatible queries you should make use of $__timeFilter() over the tables partition column. If asked for Grafana timeseries queries, you need to use $__timeInterval() over the tables partition column, usually with something like toStartOfFiveMinutes() or toStartOfHour().

## License
Data licensed under CC BY 4.0
EOF

log "✅ ClickHouse llms.txt generated successfully at $output_file"
