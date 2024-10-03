# mev_relay_

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

Contains MEV relay block bids data.

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
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mev_relay_bid_trace/2024/9/26.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.mev_relay_bid_trace FINAL \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 10"

```
### Example - EthPandaOps Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
curl -G "https://clickhouse.analytics.production.platform.ethpandaops.io" \
-u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" \
    --data-urlencode "query= \
    SELECT \
        * \
    FROM default.mev_relay_bid_trace FINAL \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the bid was fetched* |
| **slot** | `UInt32` | *Slot number within the block bid* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the bid is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the bid is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the bid is for* |
| **wallclock_request_slot** | `UInt32` | *The wallclock slot when the request was sent* |
| **wallclock_request_slot_start_date_time** | `DateTime` | *The start time for the slot when the request was sent* |
| **wallclock_request_epoch** | `UInt32` | *The wallclock epoch when the request was sent* |
| **wallclock_request_epoch_start_date_time** | `DateTime` | *The start time for the wallclock epoch when the request was sent* |
| **requested_at_slot_time** | `UInt32` | *The time in the slot when the request was sent* |
| **response_at_slot_time** | `UInt32` | *The time in the slot when the response was received* |
| **relay_name** | `String` | *The relay that the bid was fetched from* |
| **parent_hash** | `FixedString(66)` | *The parent hash of the bid* |
| **block_number** | `UInt64` | *The block number of the bid* |
| **block_hash** | `FixedString(66)` | *The block hash of the bid* |
| **builder_pubkey** | `String` | *The builder pubkey of the bid* |
| **proposer_pubkey** | `String` | *The proposer pubkey of the bid* |
| **proposer_fee_recipient** | `FixedString(42)` | *The proposer fee recipient of the bid* |
| **gas_limit** | `UInt64` | *The gas limit of the bid* |
| **gas_used** | `UInt64` | *The gas used of the bid* |
| **value** | `UInt256` | *The transaction value in float64* |
| **num_tx** | `UInt32` | *The number of transactions in the bid* |
| **timestamp** | `Int64` | *The timestamp of the bid* |
| **timestamp_ms** | `Int64` | *The timestamp of the bid in milliseconds* |
| **optimistic_submission** | `Bool` | *Whether the bid was optimistic* |
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
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## mev_relay_proposer_payload_delivered

Contains MEV relay proposer payload delivered data.

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
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mev_relay_proposer_payload_delivered/2024/9/26.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.mev_relay_proposer_payload_delivered FINAL \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 10"

```
### Example - EthPandaOps Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
curl -G "https://clickhouse.analytics.production.platform.ethpandaops.io" \
-u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" \
    --data-urlencode "query= \
    SELECT \
        * \
    FROM default.mev_relay_proposer_payload_delivered FINAL \
    WHERE \
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the payload was delivered* |
| **slot** | `UInt32` | *Slot number within the payload* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the bid is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the bid is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the bid is for* |
| **wallclock_slot** | `UInt32` | *The wallclock slot when the request was sent* |
| **wallclock_slot_start_date_time** | `DateTime` | *The start time for the slot when the request was sent* |
| **wallclock_epoch** | `UInt32` | *The wallclock epoch when the request was sent* |
| **wallclock_epoch_start_date_time** | `DateTime` | *The start time for the wallclock epoch when the request was sent* |
| **block_number** | `UInt64` | *The block number of the payload* |
| **relay_name** | `String` | *The relay that delivered the payload* |
| **block_hash** | `FixedString(66)` | *The block hash associated with the payload* |
| **proposer_pubkey** | `String` | *The proposer pubkey that received the payload* |
| **builder_pubkey** | `String` | *The builder pubkey that sent the payload* |
| **proposer_fee_recipient** | `FixedString(42)` | *The proposer fee recipient of the payload* |
| **gas_limit** | `UInt64` | *The gas limit of the payload* |
| **gas_used** | `UInt64` | *The gas used by the payload* |
| **num_tx** | `UInt32` | *The number of transactions in the payload* |
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
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

<!-- schema_end -->
