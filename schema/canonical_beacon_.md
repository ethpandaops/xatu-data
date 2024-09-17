# Canonical Beacon

Events derived from the finalized beacon chain

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`canonical_beacon_block`](#canonical_beacon_block)
- [`canonical_beacon_block_attester_slashing`](#canonical_beacon_block_attester_slashing)
- [`canonical_beacon_block_proposer_slashing`](#canonical_beacon_block_proposer_slashing)
- [`canonical_beacon_block_bls_to_execution_change`](#canonical_beacon_block_bls_to_execution_change)
- [`canonical_beacon_block_execution_transaction`](#canonical_beacon_block_execution_transaction)
- [`canonical_beacon_block_voluntary_exit`](#canonical_beacon_block_voluntary_exit)
- [`canonical_beacon_block_deposit`](#canonical_beacon_block_deposit)
- [`canonical_beacon_block_withdrawal`](#canonical_beacon_block_withdrawal)
- [`canonical_beacon_blob_sidecar`](#canonical_beacon_blob_sidecar)
- [`canonical_beacon_proposer_duty`](#canonical_beacon_proposer_duty)
- [`canonical_beacon_elaborated_attestation`](#canonical_beacon_elaborated_attestation)
<!-- schema_toc_end -->

<!-- schema_start -->
## canonical_beacon_block



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2024-09-15`
- **holesky**: `2023-09-23` to `2024-09-15`
- **sepolia**: `2022-06-20` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.canonical_beacon_block \
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
    FROM default.canonical_beacon_block \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## canonical_beacon_block_attester_slashing



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2024-09-15`
- **holesky**: `2023-09-23` to `2024-09-15`
- **sepolia**: `2022-06-22` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_attester_slashing/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_attester_slashing/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.canonical_beacon_block_attester_slashing \
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
    FROM default.canonical_beacon_block_attester_slashing \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## canonical_beacon_block_proposer_slashing



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2024-09-15`
- **holesky**: `2023-09-23` to `2024-09-16`
- **sepolia**: `2022-06-22` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_proposer_slashing/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_proposer_slashing/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.canonical_beacon_block_proposer_slashing \
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
    FROM default.canonical_beacon_block_proposer_slashing \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## canonical_beacon_block_bls_to_execution_change



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-04-12` to `2024-09-16`
- **holesky**: `2023-09-28` to `2024-09-15`
- **sepolia**: `2022-06-22` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_bls_to_execution_change/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_bls_to_execution_change/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.canonical_beacon_block_bls_to_execution_change \
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
    FROM default.canonical_beacon_block_bls_to_execution_change \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## canonical_beacon_block_execution_transaction



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2022-09-06` to `2024-09-15`
- **holesky**: `2023-09-23` to `2024-09-15`
- **sepolia**: `2022-06-22` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_execution_transaction/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_execution_transaction/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.canonical_beacon_block_execution_transaction \
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
    FROM default.canonical_beacon_block_execution_transaction \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## canonical_beacon_block_voluntary_exit



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2024-09-15`
- **holesky**: `2023-09-23` to `2024-09-15`
- **sepolia**: `2022-06-22` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_voluntary_exit/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_voluntary_exit/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.canonical_beacon_block_voluntary_exit \
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
    FROM default.canonical_beacon_block_voluntary_exit \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## canonical_beacon_block_deposit



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2024-09-15`
- **holesky**: `2023-09-23` to `2024-09-16`
- **sepolia**: `2022-06-22` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_deposit/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_deposit/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.canonical_beacon_block_deposit \
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
    FROM default.canonical_beacon_block_deposit \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## canonical_beacon_block_withdrawal



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-04-12` to `2024-09-15`
- **holesky**: `2023-09-23` to `2024-09-15`
- **sepolia**: `2023-02-28` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_withdrawal/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_withdrawal/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.canonical_beacon_block_withdrawal \
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
    FROM default.canonical_beacon_block_withdrawal \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## canonical_beacon_blob_sidecar



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-03-13` to `2024-09-15`
- **holesky**: `2024-02-07` to `2024-09-15`
- **sepolia**: `2024-01-30` to `2024-09-16`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_blob_sidecar/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_blob_sidecar/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.canonical_beacon_blob_sidecar \
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
    FROM default.canonical_beacon_blob_sidecar \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## canonical_beacon_proposer_duty



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2024-09-15`
- **holesky**: `2023-09-23` to `2024-09-15`
- **sepolia**: `2022-06-20` to `2024-09-15`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_proposer_duty/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_proposer_duty/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.canonical_beacon_proposer_duty \
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
    FROM default.canonical_beacon_proposer_duty \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|

## canonical_beacon_elaborated_attestation



### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2024-09-16`
- **holesky**: `2023-09-23` to `2024-09-15`
- **sepolia**: `2022-06-22` to `2024-09-16`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_elaborated_attestation/YYYY/MM/DD.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_elaborated_attestation/2024/9/10.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.canonical_beacon_elaborated_attestation \
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
    FROM default.canonical_beacon_elaborated_attestation \
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
