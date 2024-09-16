# Consensus Layer P2P

Events from the consensus layer p2p network

## Availability
- ethpandaops-clickhouse
- public

## Tables

<!-- schema_toc_start -->
- [`libp2p_add_peer`](#libp2p-add-peer)
- [`libp2p_connected`](#libp2p-connected)
- [`libp2p_disconnected`](#libp2p-disconnected)
- [`libp2p_gossipsub_beacon_attestation`](#libp2p-gossipsub-beacon-attestation)
- [`libp2p_gossipsub_beacon_block`](#libp2p-gossipsub-beacon-block)
- [`libp2p_gossipsub_blob_sidecar`](#libp2p-gossipsub-blob-sidecar)
- [`libp2p_handle_metadata`](#libp2p-handle-metadata)
- [`libp2p_handle_status`](#libp2p-handle-status)
- [`libp2p_join`](#libp2p-join)
- [`libp2p_peer`](#libp2p-peer)
- [`libp2p_recv_rpc`](#libp2p-recv-rpc)
- [`libp2p_remove_peer`](#libp2p-remove-peer)
- [`libp2p_rpc_meta_control_graft`](#libp2p-rpc-meta-control-graft)
- [`libp2p_rpc_meta_control_ihave`](#libp2p-rpc-meta-control-ihave)
- [`libp2p_rpc_meta_control_iwant`](#libp2p-rpc-meta-control-iwant)
- [`libp2p_rpc_meta_control_prune`](#libp2p-rpc-meta-control-prune)
- [`libp2p_rpc_meta_message`](#libp2p-rpc-meta-message)
- [`libp2p_rpc_meta_subscription`](#libp2p-rpc-meta-subscription)
- [`libp2p_send_rpc`](#libp2p-send-rpc)
<!-- schema_toc_end -->

<!-- schema_start -->
## libp2p_add_peer
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_add_peer/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_add_peer/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_add_peer FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_add_peer FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer* |
| **protocol** | `LowCardinality(String)` | *Protocol used by the peer* |
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

## libp2p_connected
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_connected/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_connected/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_connected FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_connected FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **remote_peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the remote peer* |
| **remote_protocol** | `LowCardinality(String)` | *Protocol of the remote peer* |
| **remote_transport_protocol** | `LowCardinality(String)` | *Transport protocol of the remote peer* |
| **remote_port** | `UInt16` | *Port of the remote peer* |
| **remote_ip** | `Nullable(IPv6)` | *IP address of the remote peer that generated the event* |
| **remote_geo_city** | `LowCardinality(String)` | *City of the remote peer that generated the event* |
| **remote_geo_country** | `LowCardinality(String)` | *Country of the remote peer that generated the event* |
| **remote_geo_country_code** | `LowCardinality(String)` | *Country code of the remote peer that generated the event* |
| **remote_geo_continent_code** | `LowCardinality(String)` | *Continent code of the remote peer that generated the event* |
| **remote_geo_longitude** | `Nullable(Float64)` | *Longitude of the remote peer that generated the event* |
| **remote_geo_latitude** | `Nullable(Float64)` | *Latitude of the remote peer that generated the event* |
| **remote_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the remote peer that generated the event* |
| **remote_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the remote peer that generated the event* |
| **remote_agent_implementation** | `LowCardinality(String)` | *Implementation of the remote peer* |
| **remote_agent_version** | `LowCardinality(String)` | *Version of the remote peer* |
| **remote_agent_version_major** | `LowCardinality(String)` | *Major version of the remote peer* |
| **remote_agent_version_minor** | `LowCardinality(String)` | *Minor version of the remote peer* |
| **remote_agent_version_patch** | `LowCardinality(String)` | *Patch version of the remote peer* |
| **remote_agent_platform** | `LowCardinality(String)` | *Platform of the remote peer* |
| **direction** | `LowCardinality(String)` | *Connection direction* |
| **opened** | `DateTime` | *Timestamp when the connection was opened* |
| **transient** | `Bool` | *Whether the connection is transient* |
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

## libp2p_disconnected
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_disconnected/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_disconnected/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_disconnected FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_disconnected FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **remote_peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the remote peer* |
| **remote_protocol** | `LowCardinality(String)` | *Protocol of the remote peer* |
| **remote_transport_protocol** | `LowCardinality(String)` | *Transport protocol of the remote peer* |
| **remote_port** | `UInt16` | *Port of the remote peer* |
| **remote_ip** | `Nullable(IPv6)` | *IP address of the remote peer that generated the event* |
| **remote_geo_city** | `LowCardinality(String)` | *City of the remote peer that generated the event* |
| **remote_geo_country** | `LowCardinality(String)` | *Country of the remote peer that generated the event* |
| **remote_geo_country_code** | `LowCardinality(String)` | *Country code of the remote peer that generated the event* |
| **remote_geo_continent_code** | `LowCardinality(String)` | *Continent code of the remote peer that generated the event* |
| **remote_geo_longitude** | `Nullable(Float64)` | *Longitude of the remote peer that generated the event* |
| **remote_geo_latitude** | `Nullable(Float64)` | *Latitude of the remote peer that generated the event* |
| **remote_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the remote peer that generated the event* |
| **remote_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the remote peer that generated the event* |
| **remote_agent_implementation** | `LowCardinality(String)` | *Implementation of the remote peer* |
| **remote_agent_version** | `LowCardinality(String)` | *Version of the remote peer* |
| **remote_agent_version_major** | `LowCardinality(String)` | *Major version of the remote peer* |
| **remote_agent_version_minor** | `LowCardinality(String)` | *Minor version of the remote peer* |
| **remote_agent_version_patch** | `LowCardinality(String)` | *Patch version of the remote peer* |
| **remote_agent_platform** | `LowCardinality(String)` | *Platform of the remote peer* |
| **direction** | `LowCardinality(String)` | *Connection direction* |
| **opened** | `DateTime` | *Timestamp when the connection was opened* |
| **transient** | `Bool` | *Whether the connection is transient* |
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

## libp2p_gossipsub_beacon_attestation
{{< lead >}}  {{< /lead >}}

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
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_beacon_attestation/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_gossipsub_beacon_attestation FINAL \
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
    FROM default.libp2p_gossipsub_beacon_attestation FINAL \
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
{{< lead >}}  {{< /lead >}}

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
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_beacon_block/2024/9/9.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_gossipsub_beacon_block FINAL \
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
    FROM default.libp2p_gossipsub_beacon_block FINAL \
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
{{< lead >}}  {{< /lead >}}

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
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_blob_sidecar/2024/9/9.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_gossipsub_blob_sidecar FINAL \
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
    FROM default.libp2p_gossipsub_blob_sidecar FINAL \
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

## libp2p_handle_metadata
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_handle_metadata/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_handle_metadata/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_handle_metadata FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_handle_metadata FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer involved in the RPC* |
| **error** | `Nullable(String)` | *Error message if the metadata handling failed* |
| **protocol** | `LowCardinality(String)` | *The protocol of the metadata handling event* |
| **attnets** | `String` | *Attestation subnets the peer is subscribed to* |
| **seq_number** | `UInt64` | *Sequence number of the metadata* |
| **syncnets** | `String` | *Sync subnets the peer is subscribed to* |
| **latency_milliseconds** | `Decimal(10, 3)` | *How long it took to handle the metadata request in milliseconds* |
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

## libp2p_handle_status
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_handle_status/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_handle_status/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_handle_status FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_handle_status FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer* |
| **error** | `Nullable(String)` | *Error message if the status handling failed* |
| **protocol** | `LowCardinality(String)` | *The protocol of the status handling event* |
| **request_finalized_epoch** | `Nullable(UInt32)` | *Requested finalized epoch* |
| **request_finalized_root** | `Nullable(String)` | *Requested finalized root* |
| **request_fork_digest** | `LowCardinality(String)` | *Requested fork digest* |
| **request_head_root** | `Nullable(FixedString(66))` | *Requested head root* |
| **request_head_slot** | `Nullable(UInt32)` | *Requested head slot* |
| **response_finalized_epoch** | `Nullable(UInt32)` | *Response finalized epoch* |
| **response_finalized_root** | `Nullable(FixedString(66))` | *Response finalized root* |
| **response_fork_digest** | `LowCardinality(String)` | *Response fork digest* |
| **response_head_root** | `Nullable(FixedString(66))` | *Response head root* |
| **response_head_slot** | `Nullable(UInt32)` | *Response head slot* |
| **latency_milliseconds** | `Decimal(10, 3)` | *How long it took to handle the status request in milliseconds* |
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

## libp2p_join
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_join/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_join/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_join FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_join FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding of the topic* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer that joined the topic* |
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

## libp2p_peer
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_peer/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_peer/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_peer FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_peer FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record, seahash of peer_id + meta_network_name* |
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **peer_id** | `String` | *Peer ID* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## libp2p_recv_rpc
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_recv_rpc/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_recv_rpc/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_recv_rpc FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_recv_rpc FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer sender* |
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

## libp2p_remove_peer
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_remove_peer/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_remove_peer/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_remove_peer FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_remove_peer FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer* |
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

## libp2p_rpc_meta_control_graft
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_graft/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_graft/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_rpc_meta_control_graft FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_rpc_meta_control_graft FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each "Graft" control record* |
| **updated_date_time** | `DateTime` | *Timestamp when the "Graft" control record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the "Graft" control event* |
| **control_index** | `Int32` | *Position in the RPC meta control GRAFT array* |
| **rpc_meta_unique_key** | `Int64` | *Unique key associated with the "Graft" control metadata* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding of the topic* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer involved in the Graft control* |
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

## libp2p_rpc_meta_control_ihave
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_ihave/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_ihave/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_rpc_meta_control_ihave FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_rpc_meta_control_ihave FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each "I have" control record* |
| **updated_date_time** | `DateTime` | *Timestamp when the "I have" control record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the "I have" control event* |
| **rpc_meta_unique_key** | `Int64` | *Unique key associated with the "I have" control metadata* |
| **message_index** | `Int32` | *Position in the RPC meta control IWANT message_ids array* |
| **control_index** | `Int32` | *Position in the RPC meta control IWANT array* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding of the topic* |
| **message_id** | `String` | *Identifier of the message associated with the "I have" control* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer involved in the I have control* |
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

## libp2p_rpc_meta_control_iwant
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_iwant/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_iwant/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_rpc_meta_control_iwant FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_rpc_meta_control_iwant FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each "I want" control record* |
| **updated_date_time** | `DateTime` | *Timestamp when the "I want" control record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the "I want" control event* |
| **control_index** | `Int32` | *Position in the RPC meta control IWANT array* |
| **message_index** | `Int32` | *Position in the RPC meta control IWANT message_ids array* |
| **rpc_meta_unique_key** | `Int64` | *Unique key associated with the "I want" control metadata* |
| **message_id** | `String` | *Identifier of the message associated with the "I want" control* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer involved in the I want control* |
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

## libp2p_rpc_meta_control_prune
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_prune/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_prune/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_rpc_meta_control_prune FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_rpc_meta_control_prune FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each "Prune" control record* |
| **updated_date_time** | `DateTime` | *Timestamp when the "Prune" control record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the "Prune" control event* |
| **control_index** | `Int32` | *Position in the RPC meta control PRUNE array* |
| **rpc_meta_unique_key** | `Int64` | *Unique key associated with the "Prune" control metadata* |
| **peer_id_index** | `Int32` | ** |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer involved in the Prune control* |
| **graft_peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the graft peer involved in the Prune control* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding of the topic* |
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

## libp2p_rpc_meta_message
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_message/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_message/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_rpc_meta_message FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_rpc_meta_message FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each RPC message record* |
| **updated_date_time** | `DateTime` | *Timestamp when the RPC message record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the RPC event* |
| **control_index** | `Int32` | *Position in the RPC meta message array* |
| **rpc_meta_unique_key** | `Int64` | *Unique key associated with the RPC metadata* |
| **message_id** | `String` | *Identifier of the message* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding of the topic* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer involved in the RPC* |
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

## libp2p_rpc_meta_subscription
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_subscription/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_subscription/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_rpc_meta_subscription FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_rpc_meta_subscription FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each RPC subscription record* |
| **updated_date_time** | `DateTime` | *Timestamp when the RPC subscription record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the RPC subscription event* |
| **control_index** | `Int32` | *Position in the RPC meta subscription array* |
| **rpc_meta_unique_key** | `Int64` | *Unique key associated with the RPC subscription metadata* |
| **subscribe** | `Bool` | *Boolean indicating if it is a subscription or unsubscription* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding of the topic* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer involved in the subscription* |
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

## libp2p_send_rpc
{{< lead >}}  {{< /lead >}}

### Availability
Data is partitioned **hourly** on **event_date_time** for the following networks:

- **mainnet**: `null` to `null`
- **holesky**: `null` to `null`
- **sepolia**: `null` to `null`

### Example - Parquet file

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_send_rpc/YYYY/MM/DD/HH.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \
 "SELECT * \
 FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_send_rpc/2024/9/9/0.parquet', 'Parquet') \
 LIMIT 10"
```

### Example - Your Clickhouse

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host \
    clickhouse/clickhouse-server clickhouse client -q \
    "SELECT \
        * \
    FROM default.libp2p_send_rpc FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
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
    FROM default.libp2p_send_rpc FINAL \
    WHERE \
        event_date_time >= NOW() - INTERVAL '1 HOUR' \
    LIMIT 3 \
    FORMAT Pretty \
    "
```

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer receiver* |
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

<!-- schema_end -->
