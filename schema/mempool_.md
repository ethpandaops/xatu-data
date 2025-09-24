# mempool_

Events from the execution layer p2p network. This data is usually useful for 'timing' events, such as when a transaction was seen in the mempool by an instance. Because of this it usually has the same data but from many different instances.

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`mempool_transaction`](#mempool_transaction)
<!-- schema_toc_end -->

<!-- schema_start -->
## mempool_transaction

Each row represents a transaction that was seen in the mempool by a sentry client. Sentries can report the same transaction multiple times if it has been long enough since the last report.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2023-03-03` to `2025-09-23`
- **holesky**: `2024-01-08` to `2025-09-23`
- **sepolia**: `2024-01-08` to `2025-09-23`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mempool_transaction/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mempool_transaction/2025/9/23.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.mempool_transaction FINAL
    WHERE
        event_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.mempool_transaction FINAL
    WHERE
        event_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *The time when the sentry saw the transaction in the mempool* |
| **hash** | `FixedString(66)` | *The hash of the transaction* |
| **from** | `FixedString(42)` | *The address of the account that sent the transaction* |
| **to** | `Nullable(FixedString(42))` | *The address of the account that is the transaction recipient* |
| **nonce** | `UInt64` | *The nonce of the sender account at the time of the transaction* |
| **gas_price** | `UInt128` | *The gas price of the transaction in wei* |
| **gas** | `UInt64` | *The maximum gas provided for the transaction execution* |
| **gas_tip_cap** | `Nullable(UInt128)` | *The priority fee (tip) the user has set for the transaction* |
| **gas_fee_cap** | `Nullable(UInt128)` | *The max fee the user has set for the transaction* |
| **value** | `UInt128` | *The value transferred with the transaction in wei* |
| **type** | `Nullable(UInt8)` | *The type of the transaction* |
| **size** | `UInt32` | *The size of the transaction data in bytes* |
| **call_data_size** | `UInt32` | *The size of the call data of the transaction in bytes* |
| **blob_gas** | `Nullable(UInt64)` | *The maximum gas provided for the blob transaction execution* |
| **blob_gas_fee_cap** | `Nullable(UInt128)` | *The max fee the user has set for the transaction* |
| **blob_hashes** | `Array(String)` | *The hashes of the blob commitments for blob transactions* |
| **blob_sidecars_size** | `Nullable(UInt32)` | *The total size of the sidecars for blob transactions in bytes* |
| **blob_sidecars_empty_size** | `Nullable(UInt32)` | *The total empty size of the sidecars for blob transactions in bytes* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client that generated the event* |
| **meta_client_id** | `String` | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client that generated the event* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client that generated the event* |
| **meta_client_os** | `LowCardinality(String)` | *Operating system of the client that generated the event* |
| **meta_client_ip** | `Nullable(IPv6)` | *IP address of the client that generated the event* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client that generated the event* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |
| **meta_execution_fork_id_hash** | `LowCardinality(String)` | *The hash of the fork ID of the current Ethereum network* |
| **meta_execution_fork_id_next** | `LowCardinality(String)` | *The fork ID of the next planned Ethereum network upgrade* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

<!-- schema_end -->
