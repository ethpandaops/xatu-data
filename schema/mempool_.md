# Execution Layer P2P

Events from the execution layer p2p network

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`mempool_transaction`](#mempool_transaction)
<!-- schema_toc_end -->

<!-- schema_start -->
## mempool_transaction



### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2023-07-22` to `2024-09-15`
- **holesky**: `2024-01-08` to `2024-09-15`
- **sepolia**: `2024-01-08` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mempool_transaction/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mempool_transaction/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.mempool_transaction \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 10"

```
### Example - EthPandaOps Clickhouse

```bash
curl -G "https://clickhouse.analytics.production.platform.ethpandaops.io" \
-u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" \
    --data-urlencode "query= \
    SELECT \
        * \
    FROM default.mempool_transaction \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

<!-- schema_end -->
