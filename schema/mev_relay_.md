# MEV Relay

Events derived from MEV relays

## Availability
- Public Parquet Files
- EthPandaOps Clickhouse

## Tables

<!-- schema_toc_start -->
- [`mev_relay_bid_trace`](#mev_relay_bid_trace)
- [`mev_relay_proposer_payload_delivered`](#mev_relay_proposer_payload_delivered)
<!-- schema_toc_end -->

<!-- schema_start -->
## mev_relay_bid_trace



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-09-16` to `2024-09-16`
- **holesky**: `2024-09-16` to `2024-09-16`
- **sepolia**: `2024-09-16` to `2024-09-16`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mev_relay_bid_trace/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mev_relay_bid_trace/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.mev_relay_bid_trace \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 10"

```
### Example - EthPandaOps Clickhouse

```bash
curl -G "https://clickhouse.analytics.production.platform.ethpandaops.io" \
-u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" \
    --data-urlencode "query= \
    SELECT \
        * \
    FROM default.mev_relay_bid_trace \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## mev_relay_proposer_payload_delivered



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-09-16` to `2024-09-16`
- **holesky**: `2024-09-16` to `2024-09-16`
- **sepolia**: `2024-09-16` to `2024-09-16`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mev_relay_proposer_payload_delivered/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mev_relay_proposer_payload_delivered/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.mev_relay_proposer_payload_delivered \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 10"

```
### Example - EthPandaOps Clickhouse

```bash
curl -G "https://clickhouse.analytics.production.platform.ethpandaops.io" \
-u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" \
    --data-urlencode "query= \
    SELECT \
        * \
    FROM default.mev_relay_proposer_payload_delivered \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

<!-- schema_end -->
