# Beacon API Event Stream

Events derived from the Beacon API event stream

## Availability
- Public Parquet Files
- EthPandaOps Clickhouse

## Tables

<!-- schema_toc_start -->
- [`beacon_api_eth_v1_beacon_committee`](#beacon_api_eth_v1_beacon_committee)
- [`beacon_api_eth_v1_events_attestation`](#beacon_api_eth_v1_events_attestation)
- [`beacon_api_eth_v1_events_blob_sidecar`](#beacon_api_eth_v1_events_blob_sidecar)
- [`beacon_api_eth_v1_events_block`](#beacon_api_eth_v1_events_block)
- [`beacon_api_eth_v1_events_chain_reorg`](#beacon_api_eth_v1_events_chain_reorg)
- [`beacon_api_eth_v1_events_contribution_and_proof`](#beacon_api_eth_v1_events_contribution_and_proof)
- [`beacon_api_eth_v1_events_finalized_checkpoint`](#beacon_api_eth_v1_events_finalized_checkpoint)
- [`beacon_api_eth_v1_events_head`](#beacon_api_eth_v1_events_head)
- [`beacon_api_eth_v1_events_voluntary_exit`](#beacon_api_eth_v1_events_voluntary_exit)
- [`beacon_api_eth_v1_validator_attestation_data`](#beacon_api_eth_v1_validator_attestation_data)
- [`beacon_api_eth_v2_beacon_block`](#beacon_api_eth_v2_beacon_block)
- [`beacon_api_eth_v1_proposer_duty`](#beacon_api_eth_v1_proposer_duty)
<!-- schema_toc_end -->

<!-- schema_start -->
## beacon_api_eth_v1_beacon_committee




> Sometimes sentries may [publish different committees](https://github.com/ethpandaops/xatu/issues/288) for the same epoch.

### Availability
Data is partitioned **hourly** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-09-05` to `2024-09-15`
- **holesky**: `2023-12-25` to `2024-09-15`
- **sepolia**: `2023-12-24` to `2024-09-14`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_beacon_committee/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_beacon_committee/2024/9/10/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v1_beacon_committee \
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
    FROM default.beacon_api_eth_v1_beacon_committee \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## beacon_api_eth_v1_events_attestation



### Availability
Data is partitioned **hourly** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-06-05` to `2024-09-15`
- **holesky**: `2023-09-29` to `2024-09-15`
- **sepolia**: `2023-09-01` to `2024-09-14`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_attestation/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_attestation/2024/9/10/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v1_events_attestation \
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
    FROM default.beacon_api_eth_v1_events_attestation \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## beacon_api_eth_v1_events_blob_sidecar



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-03-13` to `2024-09-15`
- **holesky**: `2024-02-07` to `2024-09-15`
- **sepolia**: `2024-01-30` to `2024-09-16`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_blob_sidecar/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_blob_sidecar/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v1_events_blob_sidecar \
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
    FROM default.beacon_api_eth_v1_events_blob_sidecar \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## beacon_api_eth_v1_events_block



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-02-28` to `2024-09-15`
- **holesky**: `2023-12-24` to `2024-09-15`
- **sepolia**: `2023-12-24` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_block/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v1_events_block \
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
    FROM default.beacon_api_eth_v1_events_block \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## beacon_api_eth_v1_events_chain_reorg



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-03-01` to `2024-09-15`
- **holesky**: `2024-02-05` to `2024-09-15`
- **sepolia**: `2024-05-23` to `2024-09-16`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_chain_reorg/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_chain_reorg/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v1_events_chain_reorg \
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
    FROM default.beacon_api_eth_v1_events_chain_reorg \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## beacon_api_eth_v1_events_contribution_and_proof



### Availability
Data is partitioned **daily** on **contribution_slot_start_date_time** for the following networks:

- **mainnet**: `2023-08-31` to `2024-09-15`
- **holesky**: `2023-12-24` to `2024-09-16`
- **sepolia**: `2023-12-24` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_contribution_and_proof/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_contribution_and_proof/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v1_events_contribution_and_proof \
    WHERE \
        contribution_slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 10"

```
### Example - EthPandaOps Clickhouse

```bash
curl -G "https://clickhouse.analytics.production.platform.ethpandaops.io" \
-u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" \
    --data-urlencode "query= \
    SELECT \
        * \
    FROM default.beacon_api_eth_v1_events_contribution_and_proof \
    WHERE \
        contribution_slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## beacon_api_eth_v1_events_finalized_checkpoint



### Availability
Data is partitioned **daily** on **epoch_start_date_time** for the following networks:

- **mainnet**: `2023-04-10` to `2024-09-15`
- **holesky**: `2023-03-26` to `2024-09-15`
- **sepolia**: `2023-03-26` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_finalized_checkpoint/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_finalized_checkpoint/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v1_events_finalized_checkpoint \
    WHERE \
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 10"

```
### Example - EthPandaOps Clickhouse

```bash
curl -G "https://clickhouse.analytics.production.platform.ethpandaops.io" \
-u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" \
    --data-urlencode "query= \
    SELECT \
        * \
    FROM default.beacon_api_eth_v1_events_finalized_checkpoint \
    WHERE \
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## beacon_api_eth_v1_events_head



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-08-30` to `2024-09-15`
- **holesky**: `2023-12-05` to `2024-09-15`
- **sepolia**: `2023-12-05` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_head/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_head/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v1_events_head \
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
    FROM default.beacon_api_eth_v1_events_head \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## beacon_api_eth_v1_events_voluntary_exit



### Availability
Data is partitioned **daily** on **wallclock_epoch_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2024-09-16`
- **holesky**: `2023-10-01` to `2024-09-16`
- **sepolia**: `2023-10-01` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_voluntary_exit/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_voluntary_exit/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v1_events_voluntary_exit \
    WHERE \
        wallclock_epoch_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 10"

```
### Example - EthPandaOps Clickhouse

```bash
curl -G "https://clickhouse.analytics.production.platform.ethpandaops.io" \
-u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" \
    --data-urlencode "query= \
    SELECT \
        * \
    FROM default.beacon_api_eth_v1_events_voluntary_exit \
    WHERE \
        wallclock_epoch_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## beacon_api_eth_v1_validator_attestation_data



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-08-31` to `2024-09-16`
- **holesky**: `2023-12-24` to `2024-09-16`
- **sepolia**: `2023-12-24` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_validator_attestation_data/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_validator_attestation_data/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v1_validator_attestation_data \
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
    FROM default.beacon_api_eth_v1_validator_attestation_data \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## beacon_api_eth_v2_beacon_block



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-11-14` to `2024-09-15`
- **holesky**: `2023-12-24` to `2024-09-15`
- **sepolia**: `2023-12-24` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v2_beacon_block/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v2_beacon_block/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v2_beacon_block \
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
    FROM default.beacon_api_eth_v2_beacon_block \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## beacon_api_eth_v1_proposer_duty



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-04-03` to `2024-09-15`
- **holesky**: `2024-04-03` to `2024-09-16`
- **sepolia**: `2024-04-03` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_proposer_duty/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_proposer_duty/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.beacon_api_eth_v1_proposer_duty \
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
    FROM default.beacon_api_eth_v1_proposer_duty \
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
