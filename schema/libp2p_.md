# Consensus Layer P2P

Events from the consensus layer p2p network

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`libp2p_gossipsub_beacon_attestation`](#libp2p-gossipsub-beacon-attestation)
- [`libp2p_gossipsub_beacon_block`](#libp2p-gossipsub-beacon-block)
- [`libp2p_gossipsub_blob_sidecar`](#libp2p-gossipsub-blob-sidecar)
<!-- schema_toc_end -->

<!-- schema_start -->
## libp2p_gossipsub_beacon_attestation



### Availability
Data is partitioned **hourly** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-05-01` to `2024-09-14`
- **holesky**: `2024-05-01` to `2024-09-14`
- **sepolia**: `2024-05-01` to `2024-09-14`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_beacon_attestation/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_beacon_attestation/2024/9/10/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_gossipsub_beacon_attestation \
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
    FROM default.libp2p_gossipsub_beacon_attestation \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## libp2p_gossipsub_beacon_block



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-04-26` to `2024-09-14`
- **holesky**: `2024-04-26` to `2024-09-14`
- **sepolia**: `2024-04-26` to `2024-09-14`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_beacon_block/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_beacon_block/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_gossipsub_beacon_block \
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
    FROM default.libp2p_gossipsub_beacon_block \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## libp2p_gossipsub_blob_sidecar



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-06-04` to `2024-09-14`
- **holesky**: `2024-06-04` to `2024-09-14`
- **sepolia**: `2024-06-04` to `2024-09-14`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_blob_sidecar/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_blob_sidecar/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_gossipsub_blob_sidecar \
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
    FROM default.libp2p_gossipsub_blob_sidecar \
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
