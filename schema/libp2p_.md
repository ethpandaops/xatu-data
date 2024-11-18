# libp2p_

Events from the consensus layer p2p network

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`libp2p_gossipsub_beacon_attestation`](#libp2p_gossipsub_beacon_attestation)
- [`libp2p_gossipsub_beacon_block`](#libp2p_gossipsub_beacon_block)
- [`libp2p_gossipsub_blob_sidecar`](#libp2p_gossipsub_blob_sidecar)
<!-- schema_toc_end -->

<!-- schema_start -->
## libp2p_gossipsub_beacon_attestation

Table for libp2p gossipsub beacon attestation data.

### Availability
Data is partitioned **hourly** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-05-01` to `2024-11-17`
- **holesky**: `2024-05-01` to `2024-11-17`
- **sepolia**: `2024-05-01` to `2024-11-17`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_beacon_attestation/YYYY/MM/DD/HH.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_beacon_attestation/2024/11/11/0.parquet', 'Parquet')
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
    FROM default.libp2p_gossipsub_beacon_attestation FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.libp2p_gossipsub_beacon_attestation FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **version** | `UInt32` | *Version of this row, to help with de-duplication we want the latest updated_date_time but lowest propagation_slot_start_diff time* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event with millisecond precision* |
| **slot** | `UInt32` | *Slot number associated with the event* |
| **slot_start_date_time** | `DateTime` | *Start date and time of the slot* |
| **epoch** | `UInt32` | *The epoch number in the attestation* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **committee_index** | `LowCardinality(String)` | *The committee index in the attestation* |
| **attesting_validator_index** | `Nullable(UInt32)` | *The index of the validator attesting to the event* |
| **attesting_validator_committee_index** | `LowCardinality(String)` | *The committee index of the attesting validator* |
| **wallclock_slot** | `UInt32` | *Slot number of the wall clock when the event was received* |
| **wallclock_slot_start_date_time** | `DateTime` | *Start date and time of the wall clock slot when the event was received* |
| **wallclock_epoch** | `UInt32` | *Epoch number of the wall clock when the event was received* |
| **wallclock_epoch_start_date_time** | `DateTime` | *Start date and time of the wall clock epoch when the event was received* |
| **propagation_slot_start_diff** | `UInt32` | *Difference in slot start time for propagation* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer* |
| **message_id** | `String` | *Identifier of the message* |
| **message_size** | `UInt32` | *Size of the message in bytes* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic in the gossipsub protocol* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding used for the topic* |
| **aggregation_bits** | `String` | *The aggregation bits of the event in the attestation* |
| **beacon_block_root** | `FixedString(66)` | *The beacon block root hash in the attestation* |
| **source_epoch** | `UInt32` | *The source epoch number in the attestation* |
| **source_epoch_start_date_time** | `DateTime` | *The wall clock time when the source epoch started* |
| **source_root** | `FixedString(66)` | *The source beacon block root hash in the attestation* |
| **target_epoch** | `UInt32` | *The target epoch number in the attestation* |
| **target_epoch_start_date_time** | `DateTime` | *The wall clock time when the target epoch started* |
| **target_root** | `FixedString(66)` | *The target beacon block root hash in the attestation* |
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
| **meta_network_id** | `Int32` | *Network ID associated with the client* |
| **meta_network_name** | `LowCardinality(String)` | *Name of the network associated with the client* |

## libp2p_gossipsub_beacon_block

Table for libp2p gossipsub beacon block data.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-04-26` to `2024-11-17`
- **holesky**: `2024-04-26` to `2024-11-17`
- **sepolia**: `2024-04-26` to `2024-11-17`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_beacon_block/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_beacon_block/2024/11/11.parquet', 'Parquet')
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
    FROM default.libp2p_gossipsub_beacon_block FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.libp2p_gossipsub_beacon_block FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **version** | `UInt32` | *Version of this row, to help with de-duplication we want the latest updated_date_time but lowest propagation_slot_start_diff time* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event with millisecond precision* |
| **slot** | `UInt32` | *Slot number associated with the event* |
| **slot_start_date_time** | `DateTime` | *Start date and time of the slot* |
| **epoch** | `UInt32` | *Epoch number associated with the event* |
| **epoch_start_date_time** | `DateTime` | *Start date and time of the epoch* |
| **wallclock_slot** | `UInt32` | *Slot number of the wall clock when the event was received* |
| **wallclock_slot_start_date_time** | `DateTime` | *Start date and time of the wall clock slot when the event was received* |
| **wallclock_epoch** | `UInt32` | *Epoch number of the wall clock when the event was received* |
| **wallclock_epoch_start_date_time** | `DateTime` | *Start date and time of the wall clock epoch when the event was received* |
| **propagation_slot_start_diff** | `UInt32` | *Difference in slot start time for propagation* |
| **block** | `FixedString(66)` | *The beacon block root hash* |
| **proposer_index** | `UInt32` | *The proposer index of the beacon block* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer* |
| **message_id** | `String` | *Identifier of the message* |
| **message_size** | `UInt32` | *Size of the message in bytes* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic in the gossipsub protocol* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding used for the topic* |
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
| **meta_network_id** | `Int32` | *Network ID associated with the client* |
| **meta_network_name** | `LowCardinality(String)` | *Name of the network associated with the client* |

## libp2p_gossipsub_blob_sidecar

Table for libp2p gossipsub blob sidecar data

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-06-04` to `2024-11-17`
- **holesky**: `2024-06-04` to `2024-11-17`
- **sepolia**: `2024-06-04` to `2024-11-17`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_blob_sidecar/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_blob_sidecar/2024/11/11.parquet', 'Parquet')
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
    FROM default.libp2p_gossipsub_blob_sidecar FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.libp2p_gossipsub_blob_sidecar FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **version** | `UInt32` | *Version of this row, to help with de-duplication we want the latest updated_date_time but lowest propagation_slot_start_diff time* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event with millisecond precision* |
| **slot** | `UInt32` | *Slot number associated with the event* |
| **slot_start_date_time** | `DateTime` | *Start date and time of the slot* |
| **epoch** | `UInt32` | *Epoch number associated with the event* |
| **epoch_start_date_time** | `DateTime` | *Start date and time of the epoch* |
| **wallclock_slot** | `UInt32` | *Slot number of the wall clock when the event was received* |
| **wallclock_slot_start_date_time** | `DateTime` | *Start date and time of the wall clock slot when the event was received* |
| **wallclock_epoch** | `UInt32` | *Epoch number of the wall clock when the event was received* |
| **wallclock_epoch_start_date_time** | `DateTime` | *Start date and time of the wall clock epoch when the event was received* |
| **propagation_slot_start_diff** | `UInt32` | *Difference in slot start time for propagation* |
| **proposer_index** | `UInt32` | *The proposer index of the beacon block* |
| **blob_index** | `UInt32` | *Blob index associated with the record* |
| **parent_root** | `FixedString(66)` | *Parent root of the beacon block* |
| **state_root** | `FixedString(66)` | *State root of the beacon block* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer* |
| **message_id** | `String` | *Identifier of the message* |
| **message_size** | `UInt32` | *Size of the message in bytes* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic in the gossipsub protocol* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding used for the topic* |
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
| **meta_network_id** | `Int32` | *Network ID associated with the client* |
| **meta_network_name** | `LowCardinality(String)` | *Name of the network associated with the client* |

<!-- schema_end -->
