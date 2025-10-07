# Xatu Dataset Schema

<p xmlns:cc="http://creativecommons.org/ns#" >This work is licensed under <a href="http://creativecommons.org/licenses/by/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"></a></p>

## Classes of Data
Xatu data is organized in to different datasets.

<!-- schema_toc_start -->
| Dataset Name | Schema Link | Description | Prefix | EthPandaOps Clickhouse|Public Parquet Files |
|--------------|-------------|-------------|--------|---|---|
| **Beacon API Event Stream** | [Schema](./schema/beacon_api_.md) | Events derived from the Beacon API event stream. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances. These tables are usually fairly slim and contain only a few columns. These tables can be joined with the canonical tables to get a more complete view of the data. For example, you can join the beacon_api_eth_v1_events_block table on block_root or slot with the canonical_beacon_block table to get the block data for each block. | beacon_api_ | ✅ | ✅ |
| **Execution Layer P2P** | [Schema](./schema/mempool_.md) | Events from the execution layer p2p network. This data is usually useful for 'timing' events, such as when a transaction was seen in the mempool by an instance. Because of this it usually has the same data but from many different instances. | mempool_ | ✅ | ✅ |
| **Canonical Beacon** | [Schema](./schema/canonical_beacon_.md) | Events derived from the finalized beacon chain. This data is only derived by a single instance, are deduped, and are more complete and reliable than the beacon_api_ tables. These tables can be reliably JOINed on to hydrate other tables with information | canonical_beacon_ | ✅ | ✅ |
| **Canonical Execution** | [Schema](./schema/canonical_execution_.md) | Data extracted from the execution layer. This data is only derived by a single instance, are deduped, and are more complete and reliable than the execution_layer_p2p tables. These tables can be reliably JOINed on to hydrate other tables with information | canonical_execution_ | ✅ | ✅ |
| **Consensus Layer P2P** | [Schema](./schema/libp2p_.md) | Events from the consensus layer p2p network. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances. | libp2p_ | ✅ | ✅ |
| **MEV Relay** | [Schema](./schema/mev_relay_.md) | Events derived from MEV relays. Data is scraped from multiple MEV Relays by multiple instances. | mev_relay_ | ✅ | ✅ |
| **CBT (ClickHouse Build Tools)** | [Schema](./schema/cbt.md) | Pre-aggregated analytical tables for common blockchain queries. These tables are transformation tables similar to DBT, powered by [xatu-cbt](https://github.com/ethpandaops/xatu-cbt) using [ClickHouse Build Tools (CBT)](https://github.com/ethpandaops/cbt). |  | ✅ | ❌ |
<!-- schema_toc_end -->
<!-- schema_start -->
# 

Events derived from the Beacon API event stream. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances. These tables are usually fairly slim and contain only a few columns. These tables can be joined with the canonical tables to get a more complete view of the data. For example, you can join the beacon_api_eth_v1_events_block table on block_root or slot with the canonical_beacon_block table to get the block data for each block.

## Availability
- Public Parquet Files
- EthPandaOps Clickhouse

## Tables

<!-- schema_toc_start -->
- [`beacon_api_eth_v1_beacon_committee`](#beacon_api_eth_v1_beacon_committee)
- [`beacon_api_eth_v1_events_attestation`](#beacon_api_eth_v1_events_attestation)
- [`beacon_api_eth_v1_events_blob_sidecar`](#beacon_api_eth_v1_events_blob_sidecar)
- [`beacon_api_eth_v1_events_block`](#beacon_api_eth_v1_events_block)
- [`beacon_api_eth_v1_events_block_gossip`](#beacon_api_eth_v1_events_block_gossip)
- [`beacon_api_eth_v1_events_chain_reorg`](#beacon_api_eth_v1_events_chain_reorg)
- [`beacon_api_eth_v1_events_contribution_and_proof`](#beacon_api_eth_v1_events_contribution_and_proof)
- [`beacon_api_eth_v1_events_finalized_checkpoint`](#beacon_api_eth_v1_events_finalized_checkpoint)
- [`beacon_api_eth_v1_events_head`](#beacon_api_eth_v1_events_head)
- [`beacon_api_eth_v1_events_voluntary_exit`](#beacon_api_eth_v1_events_voluntary_exit)
- [`beacon_api_eth_v1_validator_attestation_data`](#beacon_api_eth_v1_validator_attestation_data)
- [`beacon_api_eth_v2_beacon_block`](#beacon_api_eth_v2_beacon_block)
- [`beacon_api_eth_v1_proposer_duty`](#beacon_api_eth_v1_proposer_duty)
- [`beacon_api_eth_v3_validator_block`](#beacon_api_eth_v3_validator_block)
<!-- schema_toc_end -->

<!-- schema_start -->
## beacon_api_eth_v1_beacon_committee

Contains beacon API /eth/v1/beacon/states/{state_id}/committees data from each sentry client attached to a beacon node.


> Sometimes sentries may [publish different committees](https://github.com/ethpandaops/xatu/issues/288) for the same epoch.

### Availability
Data is partitioned **hourly** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-09-04` to `2025-10-05`
- **holesky**: `2023-09-28` to `2025-10-05`
- **sepolia**: `2022-06-25` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_beacon_committee/YYYY/M/D/H.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_beacon_committee/2025/10/5/0.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_beacon_committee FINAL
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
    FROM default.beacon_api_eth_v1_beacon_committee FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **slot** | `UInt32` | *Slot number in the beacon API committee payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **committee_index** | `LowCardinality(String)` | *The committee index in the beacon API committee payload* |
| **validators** | `Array(UInt32)` | *The validator indices in the beacon API committee payload* |
| **epoch** | `UInt32` | *The epoch number in the beacon API committee payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v1_events_attestation

Contains beacon API eventstream "attestation" data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **hourly** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-06-01` to `2025-10-05`
- **holesky**: `2023-09-18` to `2025-10-05`
- **sepolia**: `2023-08-31` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_attestation/YYYY/M/D/H.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_attestation/2025/10/5/0.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.beacon_api_eth_v1_events_attestation
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.beacon_api_eth_v1_events_attestation
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
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **slot** | `UInt32` | *Slot number in the beacon API event stream payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **propagation_slot_start_diff** | `UInt32` | *The difference between the event_date_time and the slot_start_date_time* |
| **committee_index** | `LowCardinality(String)` | *The committee index in the beacon API event stream payload* |
| **attesting_validator_index** | `Nullable(UInt32)` | *The index of the validator attesting to the event* |
| **attesting_validator_committee_index** | `LowCardinality(String)` | *The committee index of the attesting validator* |
| **aggregation_bits** | `String` | *The aggregation bits of the event in the beacon API event stream payload* |
| **beacon_block_root** | `FixedString(66)` | *The beacon block root hash in the beacon API event stream payload* |
| **epoch** | `UInt32` | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **source_epoch** | `UInt32` | *The source epoch number in the beacon API event stream payload* |
| **source_epoch_start_date_time** | `DateTime` | *The wall clock time when the source epoch started* |
| **source_root** | `FixedString(66)` | *The source beacon block root hash in the beacon API event stream payload* |
| **target_epoch** | `UInt32` | *The target epoch number in the beacon API event stream payload* |
| **target_epoch_start_date_time** | `DateTime` | *The wall clock time when the target epoch started* |
| **target_root** | `FixedString(66)` | *The target beacon block root hash in the beacon API event stream payload* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v1_events_blob_sidecar

Contains beacon API eventstream "blob_sidecar" data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-03-13` to `2025-10-05`
- **holesky**: `2024-02-07` to `2025-10-05`
- **sepolia**: `2024-01-30` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_blob_sidecar/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_blob_sidecar/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_blob_sidecar FINAL
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
    FROM default.beacon_api_eth_v1_events_blob_sidecar FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **slot** | `UInt32` | *Slot number in the beacon API event stream payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **propagation_slot_start_diff** | `UInt32` | *The difference between the event_date_time and the slot_start_date_time* |
| **epoch** | `UInt32` | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The beacon block root hash in the beacon API event stream payload* |
| **blob_index** | `UInt64` | *The index of blob sidecar in the beacon API event stream payload* |
| **kzg_commitment** | `FixedString(98)` | *The KZG commitment in the beacon API event stream payload* |
| **versioned_hash** | `FixedString(66)` | *The versioned hash in the beacon API event stream payload* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v1_events_block

Contains beacon API eventstream "block" data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2020-12-02` to `2025-10-05`
- **sepolia**: `2023-12-24` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_block/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_block FINAL
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
    FROM default.beacon_api_eth_v1_events_block FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **slot** | `UInt32` | *Slot number in the beacon API event stream payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **propagation_slot_start_diff** | `UInt32` | *The difference between the event_date_time and the slot_start_date_time* |
| **block** | `FixedString(66)` | *The beacon block root hash in the beacon API event stream payload* |
| **epoch** | `UInt32` | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **execution_optimistic** | `Bool` | *If the attached beacon node is running in execution optimistic mode* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v1_events_block_gossip

Contains beacon API eventstream "block_gossip" data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2025-05-14` to `2025-10-05`
- **holesky**: `2025-05-14` to `2025-10-05`
- **sepolia**: `2025-05-14` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_block_gossip/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block_gossip/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_block_gossip FINAL
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
    FROM default.beacon_api_eth_v1_events_block_gossip FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **slot** | `UInt32` | *Slot number in the beacon API event stream payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **propagation_slot_start_diff** | `UInt32` | *The difference between the event_date_time and the slot_start_date_time* |
| **block** | `FixedString(66)` | *The beacon block root hash in the beacon API event stream payload* |
| **epoch** | `UInt32` | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v1_events_chain_reorg

Contains beacon API eventstream "chain reorg" data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-03-01` to `2025-10-05`
- **holesky**: `2024-02-05` to `2025-10-05`
- **sepolia**: `2023-12-30` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_chain_reorg/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_chain_reorg/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_chain_reorg FINAL
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
    FROM default.beacon_api_eth_v1_events_chain_reorg FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **slot** | `UInt32` | *The slot number of the chain reorg event in the beacon API event stream payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the reorg slot started* |
| **propagation_slot_start_diff** | `UInt32` | *Difference in slots between when the reorg occurred and when the sentry received the event* |
| **depth** | `UInt16` | *The depth of the chain reorg in the beacon API event stream payload* |
| **old_head_block** | `FixedString(66)` | *The old head block root hash in the beacon API event stream payload* |
| **new_head_block** | `FixedString(66)` | *The new head block root hash in the beacon API event stream payload* |
| **old_head_state** | `FixedString(66)` | *The old head state root hash in the beacon API event stream payload* |
| **new_head_state** | `FixedString(66)` | *The new head state root hash in the beacon API event stream payload* |
| **epoch** | `UInt32` | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **execution_optimistic** | `Bool` | *Whether the execution of the epoch was optimistic* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v1_events_contribution_and_proof

Contains beacon API eventstream "contribution and proof" data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **daily** on **contribution_slot_start_date_time** for the following networks:

- **mainnet**: `2023-08-31` to `2025-10-05`
- **holesky**: `2023-12-24` to `2025-10-05`
- **sepolia**: `2023-12-24` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_contribution_and_proof/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_contribution_and_proof/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_contribution_and_proof FINAL
    WHERE
        contribution_slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_contribution_and_proof FINAL
    WHERE
        contribution_slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **aggregator_index** | `UInt32` | *The validator index of the aggregator in the beacon API event stream payload* |
| **contribution_slot** | `UInt32` | *The slot number of the contribution in the beacon API event stream payload* |
| **contribution_slot_start_date_time** | `DateTime` | *The wall clock time when the contribution slot started* |
| **contribution_propagation_slot_start_diff** | `UInt32` | *Difference in slots between when the contribution occurred and when the sentry received the event* |
| **contribution_beacon_block_root** | `FixedString(66)` | *The beacon block root hash in the beacon API event stream payload* |
| **contribution_subcommittee_index** | `LowCardinality(String)` | *The subcommittee index of the contribution in the beacon API event stream payload* |
| **contribution_aggregation_bits** | `String` | *The aggregation bits of the contribution in the beacon API event stream payload* |
| **contribution_signature** | `String` | *The signature of the contribution in the beacon API event stream payload* |
| **contribution_epoch** | `UInt32` | *The epoch number of the contribution in the beacon API event stream payload* |
| **contribution_epoch_start_date_time** | `DateTime` | *The wall clock time when the contribution epoch started* |
| **selection_proof** | `String` | *The selection proof in the beacon API event stream payload* |
| **signature** | `String` | *The signature in the beacon API event stream payload* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v1_events_finalized_checkpoint

Contains beacon API eventstream "finalized checkpoint" data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **daily** on **epoch_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2023-03-26` to `2025-10-05`
- **sepolia**: `2023-03-26` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_finalized_checkpoint/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_finalized_checkpoint/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_finalized_checkpoint FINAL
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_finalized_checkpoint FINAL
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **block** | `FixedString(66)` | *The finalized block root hash in the beacon API event stream payload* |
| **state** | `FixedString(66)` | *The finalized state root hash in the beacon API event stream payload* |
| **epoch** | `UInt32` | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **execution_optimistic** | `Bool` | *Whether the execution of the epoch was optimistic* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v1_events_head

Contains beacon API eventstream "head" data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2023-12-05` to `2025-10-05`
- **sepolia**: `2023-12-05` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_head/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_head/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_head FINAL
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
    FROM default.beacon_api_eth_v1_events_head FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **slot** | `UInt32` | *Slot number in the beacon API event stream payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **propagation_slot_start_diff** | `UInt32` | *The difference between the event_date_time and the slot_start_date_time* |
| **block** | `FixedString(66)` | *The beacon block root hash in the beacon API event stream payload* |
| **epoch** | `UInt32` | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **epoch_transition** | `Bool` | *If the event is an epoch transition* |
| **execution_optimistic** | `Bool` | *If the attached beacon node is running in execution optimistic mode* |
| **previous_duty_dependent_root** | `FixedString(66)` | *The previous duty dependent root in the beacon API event stream payload* |
| **current_duty_dependent_root** | `FixedString(66)` | *The current duty dependent root in the beacon API event stream payload* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v1_events_voluntary_exit

Contains beacon API eventstream "voluntary exit" data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **daily** on **wallclock_epoch_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2023-09-28` to `2025-08-12`
- **sepolia**: `2023-10-01` to `null`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_voluntary_exit/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_voluntary_exit/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_voluntary_exit FINAL
    WHERE
        wallclock_epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_voluntary_exit FINAL
    WHERE
        wallclock_epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **epoch** | `UInt32` | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **wallclock_slot** | `UInt32` | *Slot number of the wall clock when the event was received* |
| **wallclock_slot_start_date_time** | `DateTime` | *Start date and time of the wall clock slot when the event was received* |
| **wallclock_epoch** | `UInt32` | *Epoch number of the wall clock when the event was received* |
| **wallclock_epoch_start_date_time** | `DateTime` | *Start date and time of the wall clock epoch when the event was received* |
| **validator_index** | `UInt32` | *The index of the validator making the voluntary exit* |
| **signature** | `String` | *The signature of the voluntary exit in the beacon API event stream payload* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v1_validator_attestation_data

Contains beacon API validator attestation data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-08-31` to `2025-10-05`
- **holesky**: `2023-12-24` to `2025-10-05`
- **sepolia**: `2023-12-24` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_validator_attestation_data/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_validator_attestation_data/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_validator_attestation_data FINAL
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
    FROM default.beacon_api_eth_v1_validator_attestation_data FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **slot** | `UInt32` | *Slot number in the beacon API validator attestation data payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **committee_index** | `LowCardinality(String)` | *The committee index in the beacon API validator attestation data payload* |
| **beacon_block_root** | `FixedString(66)` | *The beacon block root hash in the beacon API validator attestation data payload* |
| **epoch** | `UInt32` | *The epoch number in the beacon API validator attestation data payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **source_epoch** | `UInt32` | *The source epoch number in the beacon API validator attestation data payload* |
| **source_epoch_start_date_time** | `DateTime` | *The wall clock time when the source epoch started* |
| **source_root** | `FixedString(66)` | *The source beacon block root hash in the beacon API validator attestation data payload* |
| **target_epoch** | `UInt32` | *The target epoch number in the beacon API validator attestation data payload* |
| **target_epoch_start_date_time** | `DateTime` | *The wall clock time when the target epoch started* |
| **target_root** | `FixedString(66)` | *The target beacon block root hash in the beacon API validator attestation data payload* |
| **request_date_time** | `DateTime` | *When the request was sent to the beacon node* |
| **request_duration** | `UInt32` | *The request duration in milliseconds* |
| **request_slot_start_diff** | `UInt32` | *The difference between the request_date_time and the slot_start_date_time* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v2_beacon_block

Contains beacon API /eth/v2/beacon/blocks/{block_id} data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2023-09-28` to `2025-10-05`
- **sepolia**: `2022-06-20` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v2_beacon_block/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v2_beacon_block/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v2_beacon_block FINAL
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
    FROM default.beacon_api_eth_v2_beacon_block FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the sentry fetched the beacon block from a beacon node* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the reorg slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **parent_root** | `FixedString(66)` | *The root hash of the parent beacon block* |
| **state_root** | `FixedString(66)` | *The root hash of the beacon state at this block* |
| **proposer_index** | `UInt32` | *The index of the validator that proposed the beacon block* |
| **eth1_data_block_hash** | `FixedString(66)` | *The block hash of the associated execution block* |
| **eth1_data_deposit_root** | `FixedString(66)` | *The root of the deposit tree in the associated execution block* |
| **execution_payload_block_hash** | `FixedString(66)` | *The block hash of the execution payload* |
| **execution_payload_block_number** | `UInt32` | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | `String` | *The recipient of the fee for this execution payload* |
| **execution_payload_base_fee_per_gas** | `Nullable(UInt128)` | *Base fee per gas for execution payload* |
| **execution_payload_blob_gas_used** | `Nullable(UInt64)` | *Gas used for blobs in execution payload* |
| **execution_payload_excess_blob_gas** | `Nullable(UInt64)` | *Excess gas used for blobs in execution payload* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_state_root** | `FixedString(66)` | *The state root of the execution payload* |
| **execution_payload_parent_hash** | `FixedString(66)` | *The parent hash of the execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |
| **execution_payload_transactions_total_bytes_compressed** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload when compressed using snappy* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v1_proposer_duty

Contains a proposer duty from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-04-03` to `2025-10-05`
- **holesky**: `2024-04-03` to `2025-10-05`
- **sepolia**: `2024-04-03` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_proposer_duty/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_proposer_duty/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_proposer_duty FINAL
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
    FROM default.beacon_api_eth_v1_proposer_duty FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the beacon block from a beacon node* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **proposer_validator_index** | `UInt32` | *The validator index from the proposer duty payload* |
| **proposer_pubkey** | `String` | *The BLS public key of the validator from the proposer duty payload* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## beacon_api_eth_v3_validator_block

Contains beacon API /eth/v3/validator/blocks/{slot} data from each sentry client attached to a beacon node.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-11-25` to `2025-10-05`
- **holesky**: `2024-11-25` to `2025-10-05`
- **sepolia**: `2024-11-25` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v3_validator_block/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v3_validator_block/2025/10/5.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v3_validator_block FINAL
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
    FROM default.beacon_api_eth_v3_validator_block FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **slot** | `UInt32` | *Slot number within the payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the reorg slot started* |
| **epoch** | `UInt32` | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **consensus_payload_value** | `Nullable(UInt64)` | *Consensus rewards paid to the proposer for this block, in Wei. Use to determine relative value of consensus blocks.* |
| **execution_payload_value** | `Nullable(UInt64)` | *Execution payload value in Wei. Use to determine relative value of execution payload.* |
| **execution_payload_block_number** | `UInt32` | *The block number of the execution payload* |
| **execution_payload_base_fee_per_gas** | `Nullable(UInt128)` | *Base fee per gas for execution payload* |
| **execution_payload_blob_gas_used** | `Nullable(UInt64)` | *Gas used for blobs in execution payload* |
| **execution_payload_excess_blob_gas** | `Nullable(UInt64)` | *Excess gas used for blobs in execution payload* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |
| **execution_payload_transactions_total_bytes_compressed** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload when compressed using snappy* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

<!-- schema_end -->
# 

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

- **mainnet**: `2023-03-03` to `2025-10-05`
- **holesky**: `2024-01-08` to `2025-10-05`
- **sepolia**: `2024-01-08` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mempool_transaction/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mempool_transaction/2025/10/5.parquet', 'Parquet')
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
# 

Events derived from the finalized beacon chain. This data is only derived by a single instance, are deduped, and are more complete and reliable than the beacon_api_ tables. These tables can be reliably JOINed on to hydrate other tables with information

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`canonical_beacon_block`](#canonical_beacon_block)
- [`canonical_beacon_committee`](#canonical_beacon_committee)
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
- [`canonical_beacon_validators`](#canonical_beacon_validators)
- [`canonical_beacon_validators_pubkeys`](#canonical_beacon_validators_pubkeys)
<!-- schema_toc_end -->

<!-- schema_start -->
## canonical_beacon_block

Contains beacon block from a beacon node.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2023-09-23` to `2025-10-05`
- **sepolia**: `2022-06-20` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block/2025/10/5.parquet', 'Parquet')
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
    FROM default.canonical_beacon_block FINAL
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
    FROM default.canonical_beacon_block FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **parent_root** | `FixedString(66)` | *The root hash of the parent beacon block* |
| **state_root** | `FixedString(66)` | *The root hash of the beacon state at this block* |
| **proposer_index** | `UInt32` | *The index of the validator that proposed the beacon block* |
| **eth1_data_block_hash** | `FixedString(66)` | *The block hash of the associated execution block* |
| **eth1_data_deposit_root** | `FixedString(66)` | *The root of the deposit tree in the associated execution block* |
| **execution_payload_block_hash** | `Nullable(FixedString(66))` | *The block hash of the execution payload* |
| **execution_payload_block_number** | `Nullable(UInt32)` | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | `Nullable(String)` | *The recipient of the fee for this execution payload* |
| **execution_payload_base_fee_per_gas** | `Nullable(UInt128)` | *Base fee per gas for execution payload* |
| **execution_payload_blob_gas_used** | `Nullable(UInt64)` | *Gas used for blobs in execution payload* |
| **execution_payload_excess_blob_gas** | `Nullable(UInt64)` | *Excess gas used for blobs in execution payload* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_state_root** | `Nullable(FixedString(66))` | *The state root of the execution payload* |
| **execution_payload_parent_hash** | `Nullable(FixedString(66))` | *The parent hash of the execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |
| **execution_payload_transactions_total_bytes_compressed** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload when compressed using snappy* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_committee

Contains canonical beacon API /eth/v1/beacon/committees data.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2023-09-23` to `2025-10-05`
- **sepolia**: `2022-06-20` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_committee/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_committee/2025/10/5.parquet', 'Parquet')
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
    FROM default.canonical_beacon_committee FINAL
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
    FROM default.canonical_beacon_committee FINAL
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
| **slot** | `UInt32` | *Slot number in the beacon API committee payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **committee_index** | `LowCardinality(String)` | *The committee index in the beacon API committee payload* |
| **validators** | `Array(UInt32)` | *The validator indices in the beacon API committee payload* |
| **epoch** | `UInt32` | *The epoch number in the beacon API committee payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_block_attester_slashing

Contains attester slashing from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-02`
- **holesky**: `2023-09-23` to `2025-10-03`
- **sepolia**: `2022-06-22` to `null`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_attester_slashing/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_attester_slashing/2025/10/2.parquet', 'Parquet')
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
    FROM default.canonical_beacon_block_attester_slashing FINAL
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
    FROM default.canonical_beacon_block_attester_slashing FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **attestation_1_attesting_indices** | `Array(UInt32)` | *The attesting indices from the first attestation in the slashing payload* |
| **attestation_1_signature** | `String` | *The signature from the first attestation in the slashing payload* |
| **attestation_1_data_beacon_block_root** | `FixedString(66)` | *The beacon block root from the first attestation in the slashing payload* |
| **attestation_1_data_slot** | `UInt32` | *The slot number from the first attestation in the slashing payload* |
| **attestation_1_data_index** | `UInt32` | *The attestor index from the first attestation in the slashing payload* |
| **attestation_1_data_source_epoch** | `UInt32` | *The source epoch number from the first attestation in the slashing payload* |
| **attestation_1_data_source_root** | `FixedString(66)` | *The source root from the first attestation in the slashing payload* |
| **attestation_1_data_target_epoch** | `UInt32` | *The target epoch number from the first attestation in the slashing payload* |
| **attestation_1_data_target_root** | `FixedString(66)` | *The target root from the first attestation in the slashing payload* |
| **attestation_2_attesting_indices** | `Array(UInt32)` | *The attesting indices from the second attestation in the slashing payload* |
| **attestation_2_signature** | `String` | *The signature from the second attestation in the slashing payload* |
| **attestation_2_data_beacon_block_root** | `FixedString(66)` | *The beacon block root from the second attestation in the slashing payload* |
| **attestation_2_data_slot** | `UInt32` | *The slot number from the second attestation in the slashing payload* |
| **attestation_2_data_index** | `UInt32` | *The attestor index from the second attestation in the slashing payload* |
| **attestation_2_data_source_epoch** | `UInt32` | *The source epoch number from the second attestation in the slashing payload* |
| **attestation_2_data_source_root** | `FixedString(66)` | *The source root from the second attestation in the slashing payload* |
| **attestation_2_data_target_epoch** | `UInt32` | *The target epoch number from the second attestation in the slashing payload* |
| **attestation_2_data_target_root** | `FixedString(66)` | *The target root from the second attestation in the slashing payload* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_block_proposer_slashing

Contains proposer slashing from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-04-27`
- **holesky**: `2023-09-23` to `2025-04-27`
- **sepolia**: `2022-06-22` to `null`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_proposer_slashing/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_proposer_slashing/2025/4/27.parquet', 'Parquet')
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
    FROM default.canonical_beacon_block_proposer_slashing FINAL
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
    FROM default.canonical_beacon_block_proposer_slashing FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **signed_header_1_message_slot** | `UInt32` | *The slot number from the first signed header in the slashing payload* |
| **signed_header_1_message_proposer_index** | `UInt32` | *The proposer index from the first signed header in the slashing payload* |
| **signed_header_1_message_body_root** | `FixedString(66)` | *The body root from the first signed header in the slashing payload* |
| **signed_header_1_message_parent_root** | `FixedString(66)` | *The parent root from the first signed header in the slashing payload* |
| **signed_header_1_message_state_root** | `FixedString(66)` | *The state root from the first signed header in the slashing payload* |
| **signed_header_1_signature** | `String` | *The signature for the first signed header in the slashing payload* |
| **signed_header_2_message_slot** | `UInt32` | *The slot number from the second signed header in the slashing payload* |
| **signed_header_2_message_proposer_index** | `UInt32` | *The proposer index from the second signed header in the slashing payload* |
| **signed_header_2_message_body_root** | `FixedString(66)` | *The body root from the second signed header in the slashing payload* |
| **signed_header_2_message_parent_root** | `FixedString(66)` | *The parent root from the second signed header in the slashing payload* |
| **signed_header_2_message_state_root** | `FixedString(66)` | *The state root from the second signed header in the slashing payload* |
| **signed_header_2_signature** | `String` | *The signature for the second signed header in the slashing payload* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_block_bls_to_execution_change

Contains bls to execution change from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-04-12` to `2025-10-05`
- **holesky**: `2023-09-28` to `2025-05-09`
- **sepolia**: `2022-06-22` to `2025-05-16`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_bls_to_execution_change/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_bls_to_execution_change/2025/10/5.parquet', 'Parquet')
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
    FROM default.canonical_beacon_block_bls_to_execution_change FINAL
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
    FROM default.canonical_beacon_block_bls_to_execution_change FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **exchanging_message_validator_index** | `UInt32` | *The validator index from the exchanging message* |
| **exchanging_message_from_bls_pubkey** | `String` | *The BLS public key from the exchanging message* |
| **exchanging_message_to_execution_address** | `FixedString(42)` | *The execution address from the exchanging message* |
| **exchanging_signature** | `String` | *The signature for the exchanging message* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_block_execution_transaction

Contains execution transaction from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2022-09-06` to `2025-10-05`
- **holesky**: `2023-09-23` to `2025-10-05`
- **sepolia**: `2022-06-22` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_execution_transaction/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_execution_transaction/2025/10/5.parquet', 'Parquet')
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
    FROM default.canonical_beacon_block_execution_transaction FINAL
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
    FROM default.canonical_beacon_block_execution_transaction FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **position** | `UInt32` | *The position of the transaction in the beacon block* |
| **hash** | `FixedString(66)` | *The hash of the transaction* |
| **from** | `FixedString(42)` | *The address of the account that sent the transaction* |
| **to** | `Nullable(FixedString(42))` | *The address of the account that is the transaction recipient* |
| **nonce** | `UInt64` | *The nonce of the sender account at the time of the transaction* |
| **gas_price** | `UInt128` | *The gas price of the transaction in wei* |
| **gas** | `UInt64` | *The maximum gas provided for the transaction execution* |
| **gas_tip_cap** | `Nullable(UInt128)` | *The priority fee (tip) the user has set for the transaction* |
| **gas_fee_cap** | `Nullable(UInt128)` | *The max fee the user has set for the transaction* |
| **value** | `UInt128` | *The value transferred with the transaction in wei* |
| **type** | `UInt8` | *The type of the transaction* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_block_voluntary_exit

Contains a voluntary exit from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2023-09-23` to `2025-08-06`
- **sepolia**: `2022-06-22` to `2025-04-27`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_voluntary_exit/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_voluntary_exit/2025/10/5.parquet', 'Parquet')
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
    FROM default.canonical_beacon_block_voluntary_exit FINAL
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
    FROM default.canonical_beacon_block_voluntary_exit FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **voluntary_exit_message_epoch** | `UInt32` | *The epoch number from the exit message* |
| **voluntary_exit_message_validator_index** | `UInt32` | *The validator index from the exit message* |
| **voluntary_exit_signature** | `String` | *The signature of the exit message* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_block_deposit

Contains a deposit from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-05-14`
- **holesky**: `2023-09-23` to `2025-04-27`
- **sepolia**: `2022-06-22` to `2025-04-27`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_deposit/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_deposit/2025/5/14.parquet', 'Parquet')
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
    FROM default.canonical_beacon_block_deposit FINAL
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
    FROM default.canonical_beacon_block_deposit FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **deposit_proof** | `Array(String)` | *The proof of the deposit data* |
| **deposit_data_pubkey** | `String` | *The BLS public key of the validator from the deposit data* |
| **deposit_data_withdrawal_credentials** | `FixedString(66)` | *The withdrawal credentials of the validator from the deposit data* |
| **deposit_data_amount** | `UInt128` | *The amount of the deposit from the deposit data* |
| **deposit_data_signature** | `String` | *The signature of the deposit data* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_block_withdrawal

Contains a withdrawal from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-04-12` to `2025-10-05`
- **holesky**: `2023-09-23` to `2025-10-05`
- **sepolia**: `2023-02-28` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_withdrawal/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_withdrawal/2025/10/5.parquet', 'Parquet')
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
    FROM default.canonical_beacon_block_withdrawal FINAL
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
    FROM default.canonical_beacon_block_withdrawal FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **withdrawal_index** | `UInt32` | *The index of the withdrawal* |
| **withdrawal_validator_index** | `UInt32` | *The validator index from the withdrawal data* |
| **withdrawal_address** | `FixedString(42)` | *The address of the account that is the withdrawal recipient* |
| **withdrawal_amount** | `UInt128` | *The amount of the withdrawal from the withdrawal data* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_blob_sidecar

Contains a blob sidecar from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-03-13` to `2025-10-05`
- **holesky**: `2024-02-07` to `2025-10-05`
- **sepolia**: `2024-01-30` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_blob_sidecar/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_blob_sidecar/2025/10/5.parquet', 'Parquet')
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
    FROM default.canonical_beacon_blob_sidecar FINAL
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
    FROM default.canonical_beacon_blob_sidecar FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_parent_root** | `FixedString(66)` | *The root hash of the parent beacon block* |
| **versioned_hash** | `FixedString(66)` | *The versioned hash in the beacon API event stream payload* |
| **kzg_commitment** | `FixedString(98)` | *The KZG commitment in the blob sidecar payload* |
| **kzg_proof** | `FixedString(98)` | *The KZG proof in the blob sidecar payload* |
| **proposer_index** | `UInt32` | *The index of the validator that proposed the beacon block* |
| **blob_index** | `UInt64` | *The index of blob sidecar in the blob sidecar payload* |
| **blob_size** | `UInt32` | *The total bytes of the blob* |
| **blob_empty_size** | `Nullable(UInt32)` | *The total empty size of the blob in bytes* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_proposer_duty

Contains a proposer duty from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2023-09-23` to `2025-10-05`
- **sepolia**: `2022-06-20` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_proposer_duty/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_proposer_duty/2025/10/5.parquet', 'Parquet')
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
    FROM default.canonical_beacon_proposer_duty FINAL
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
    FROM default.canonical_beacon_proposer_duty FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number for which the proposer duty is assigned* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **proposer_validator_index** | `UInt32` | *The validator index of the proposer for the slot* |
| **proposer_pubkey** | `String` | *The public key of the validator proposer* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the even* |

## canonical_beacon_elaborated_attestation

Contains elaborated attestations from beacon blocks.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2023-09-23` to `2025-10-05`
- **sepolia**: `2022-06-20` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_elaborated_attestation/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_elaborated_attestation/2025/10/5.parquet', 'Parquet')
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
    FROM default.canonical_beacon_elaborated_attestation FINAL
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
    FROM default.canonical_beacon_elaborated_attestation FINAL
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
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **block_slot** | `UInt32` | *The slot number of the block containing the attestation* |
| **block_slot_start_date_time** | `DateTime` | *The wall clock time when the block slot started* |
| **block_epoch** | `UInt32` | *The epoch number of the block containing the attestation* |
| **block_epoch_start_date_time** | `DateTime` | *The wall clock time when the block epoch started* |
| **position_in_block** | `UInt32` | *The position of the attestation in the block* |
| **block_root** | `FixedString(66)` | *The root of the block containing the attestation* |
| **validators** | `Array(UInt32)` | *Array of validator indices participating in the attestation* |
| **committee_index** | `LowCardinality(String)` | *The index of the committee making the attestation* |
| **beacon_block_root** | `FixedString(66)` | *The root of the beacon block being attested to* |
| **slot** | `UInt32` | *The slot number being attested to* |
| **slot_start_date_time** | `DateTime` | ** |
| **epoch** | `UInt32` | ** |
| **epoch_start_date_time** | `DateTime` | ** |
| **source_epoch** | `UInt32` | *The source epoch referenced in the attestation* |
| **source_epoch_start_date_time** | `DateTime` | *The wall clock time when the source epoch started* |
| **source_root** | `FixedString(66)` | *The root of the source checkpoint in the attestation* |
| **target_epoch** | `UInt32` | *The target epoch referenced in the attestation* |
| **target_epoch_start_date_time** | `DateTime` | *The wall clock time when the target epoch started* |
| **target_root** | `FixedString(66)` | *The root of the target checkpoint in the attestation* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_validators

Contains a validator state for an epoch.

### Availability
Data is partitioned **hourly** on **epoch_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2023-09-23` to `2025-10-05`
- **sepolia**: `2022-06-20` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_validators/YYYY/M/D/H.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_validators/2025/10/5/0.parquet', 'Parquet')
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
    FROM default.canonical_beacon_validators FINAL
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.canonical_beacon_validators FINAL
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **index** | `UInt32` | *The index of the validator* |
| **balance** | `Nullable(UInt64)` | *The balance of the validator* |
| **status** | `LowCardinality(String)` | *The status of the validator* |
| **effective_balance** | `Nullable(UInt64)` | *The effective balance of the validator* |
| **slashed** | `Bool` | *Whether the validator is slashed* |
| **activation_epoch** | `Nullable(UInt64)` | *The epoch when the validator was activated* |
| **activation_eligibility_epoch** | `Nullable(UInt64)` | *The epoch when the validator was activated* |
| **exit_epoch** | `Nullable(UInt64)` | *The epoch when the validator exited* |
| **withdrawable_epoch** | `Nullable(UInt64)` | *The epoch when the validator can withdraw* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_validators_pubkeys

Contains a validator state for an epoch.


> A new parquet file is only created once there is 50 new validator index's assigned and finalized. Also available in chunks of 10,000.

### Availability
Data is partitioned in chunks of **50** on **index** for the following networks:

- **mainnet**: `0` to `2105500`
- **holesky**: `0` to `1923800`
- **sepolia**: `0` to `1900`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_validators_pubkeys/50/CHUNK_NUMBER.parquet

To find the parquet file with the `index` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `50`. Take the following examples;

Contains `index` between `0` and `49`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_validators_pubkeys/50/0.parquet

Contains `index` between `2500` and `2549`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_validators_pubkeys/50/500.parquet

Contains `index` between `50000` and `50099`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_validators_pubkeys/50/{1000..1001}0.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_validators_pubkeys/50/{50..51}0.parquet', 'Parquet')
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
    FROM default.canonical_beacon_validators_pubkeys FINAL
    WHERE
        index BETWEEN 2500 AND 2550
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
    FROM default.canonical_beacon_validators_pubkeys FINAL
    WHERE
        index BETWEEN 2500 AND 2550
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **version** | `UInt32` | *Version of this row, to help with de-duplication we want the latest updated_date_time but earliest epoch_start_date_time the pubkey was seen* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **index** | `UInt32` | *The index of the validator* |
| **pubkey** | `String` | *The public key of the validator* |
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
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

<!-- schema_end -->
# 

Data extracted from the execution layer. This data is only derived by a single instance, are deduped, and are more complete and reliable than the execution_layer_p2p tables. These tables can be reliably JOINed on to hydrate other tables with information

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`canonical_execution_block`](#canonical_execution_block)
- [`canonical_execution_transaction`](#canonical_execution_transaction)
- [`canonical_execution_traces`](#canonical_execution_traces)
- [`canonical_execution_logs`](#canonical_execution_logs)
- [`canonical_execution_contracts`](#canonical_execution_contracts)
- [`canonical_execution_four_byte_counts`](#canonical_execution_four_byte_counts)
- [`canonical_execution_address_appearances`](#canonical_execution_address_appearances)
- [`canonical_execution_balance_diffs`](#canonical_execution_balance_diffs)
- [`canonical_execution_balance_reads`](#canonical_execution_balance_reads)
- [`canonical_execution_erc20_transfers`](#canonical_execution_erc20_transfers)
- [`canonical_execution_erc721_transfers`](#canonical_execution_erc721_transfers)
- [`canonical_execution_native_transfers`](#canonical_execution_native_transfers)
- [`canonical_execution_nonce_diffs`](#canonical_execution_nonce_diffs)
- [`canonical_execution_nonce_reads`](#canonical_execution_nonce_reads)
- [`canonical_execution_storage_diffs`](#canonical_execution_storage_diffs)
- [`canonical_execution_storage_reads`](#canonical_execution_storage_reads)
- [`canonical_execution_transaction_structlog`](#canonical_execution_transaction_structlog)
<!-- schema_toc_end -->

<!-- schema_start -->
## canonical_execution_block

Contains canonical execution block data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_block/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_block FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_block FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_date_time** | `DateTime64(3)` | *The block timestamp* |
| **block_number** | `UInt64` | *The block number* |
| **block_hash** | `FixedString(66)` | *The block hash* |
| **author** | `Nullable(String)` | *The block author* |
| **gas_used** | `Nullable(UInt64)` | *The block gas used* |
| **extra_data** | `Nullable(String)` | *The block extra data in hex* |
| **extra_data_string** | `Nullable(String)` | *The block extra data in UTF-8 string* |
| **base_fee_per_gas** | `Nullable(UInt64)` | *The block base fee per gas* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_transaction

Contains canonical execution transaction data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_transaction/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_transaction FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_transaction FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_index** | `UInt64` | *The transaction index* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **nonce** | `UInt64` | *The transaction nonce* |
| **from_address** | `String` | *The transaction from address* |
| **to_address** | `Nullable(String)` | *The transaction to address* |
| **value** | `UInt256` | *The transaction value in float64* |
| **input** | `Nullable(String)` | *The transaction input in hex* |
| **gas_limit** | `UInt64` | *The transaction gas limit* |
| **gas_used** | `UInt64` | *The transaction gas used* |
| **gas_price** | `UInt64` | *The transaction gas price* |
| **transaction_type** | `UInt32` | *The transaction type* |
| **max_priority_fee_per_gas** | `UInt64` | *The transaction max priority fee per gas* |
| **max_fee_per_gas** | `UInt64` | *The transaction max fee per gas* |
| **success** | `Bool` | *The transaction success* |
| **n_input_bytes** | `UInt32` | *The transaction input bytes* |
| **n_input_zero_bytes** | `UInt32` | *The transaction input zero bytes* |
| **n_input_nonzero_bytes** | `UInt32` | *The transaction input nonzero bytes* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_traces

Contains canonical execution traces data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `22627000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_traces/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_traces/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_traces/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_traces/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_traces/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_traces FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_traces FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number* |
| **transaction_index** | `UInt32` | *The transaction index* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **internal_index** | `UInt32` | *The internal index of the trace within the transaction* |
| **action_from** | `String` | *The from address of the action* |
| **action_to** | `Nullable(String)` | *The to address of the action* |
| **action_value** | `String` | *The value of the action* |
| **action_gas** | `UInt32` | *The gas provided for the action* |
| **action_input** | `Nullable(String)` | *The input data for the action* |
| **action_call_type** | `LowCardinality(String)` | *The call type of the action* |
| **action_init** | `Nullable(String)` | *The initialization code for the action* |
| **action_reward_type** | `String` | *The reward type for the action* |
| **action_type** | `LowCardinality(String)` | *The type of the action* |
| **result_gas_used** | `UInt32` | *The gas used in the result* |
| **result_output** | `Nullable(String)` | *The output of the result* |
| **result_code** | `Nullable(String)` | *The code returned in the result* |
| **result_address** | `Nullable(String)` | *The address returned in the result* |
| **trace_address** | `Nullable(String)` | *The trace address* |
| **subtraces** | `UInt32` | *The number of subtraces* |
| **error** | `Nullable(String)` | *The error, if any, in the trace* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_logs

Contains canonical execution logs data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_logs/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_logs/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_logs/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_logs/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_logs/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_logs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_logs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number* |
| **transaction_index** | `UInt32` | *The transaction index* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash associated with the log* |
| **internal_index** | `UInt32` | *The internal index of the log within the transaction* |
| **log_index** | `UInt32` | *The log index within the block* |
| **address** | `String` | *The address associated with the log* |
| **topic0** | `String` | *The first topic of the log* |
| **topic1** | `Nullable(String)` | *The second topic of the log* |
| **topic2** | `Nullable(String)` | *The third topic of the log* |
| **topic3** | `Nullable(String)` | *The fourth topic of the log* |
| **data** | `Nullable(String)` | *The data associated with the log* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_contracts

Contains canonical execution contract data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_contracts/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_contracts/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_contracts/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_contracts/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_contracts/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_contracts FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_contracts FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash that created the contract* |
| **internal_index** | `UInt32` | *The internal index of the contract creation within the transaction* |
| **create_index** | `UInt32` | *The create index* |
| **contract_address** | `String` | *The contract address* |
| **deployer** | `String` | *The address of the contract deployer* |
| **factory** | `String` | *The address of the factory that deployed the contract* |
| **init_code** | `String` | *The initialization code of the contract* |
| **code** | `Nullable(String)` | *The code of the contract* |
| **init_code_hash** | `String` | *The hash of the initialization code* |
| **n_init_code_bytes** | `UInt32` | *Number of bytes in the initialization code* |
| **n_code_bytes** | `UInt32` | *Number of bytes in the contract code* |
| **code_hash** | `String` | *The hash of the contract code* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_four_byte_counts

Contains canonical execution four byte count data.


> Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_four_byte_counts/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_four_byte_counts/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_four_byte_counts/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_four_byte_counts/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_four_byte_counts/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_four_byte_counts FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_four_byte_counts FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **signature** | `String` | *The signature of the four byte count* |
| **size** | `UInt64` | *The size of the four byte count* |
| **count** | `UInt64` | *The count of the four byte count* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_address_appearances

Contains canonical execution address appearance data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_address_appearances/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_address_appearances/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_address_appearances/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_address_appearances/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_address_appearances/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_address_appearances FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_address_appearances FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash that caused the address appearance* |
| **internal_index** | `UInt32` | *The internal index of the address appearance within the transaction* |
| **address** | `String` | *The address of the address appearance* |
| **relationship** | `LowCardinality(String)` | *The relationship of the address to the transaction* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_balance_diffs

Contains canonical execution balance diff data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `8700000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_balance_diffs/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_diffs/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_diffs/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_diffs/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_diffs/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_balance_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_balance_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash that caused the balance diff* |
| **internal_index** | `UInt32` | *The internal index of the balance diff within the transaction* |
| **address** | `String` | *The address of the balance diff* |
| **from_value** | `UInt256` | *The from value of the balance diff* |
| **to_value** | `UInt256` | *The to value of the balance diff* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_balance_reads

Contains canonical execution balance read data.


> Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_balance_reads/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_reads/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_reads/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_reads/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_reads/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_balance_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_balance_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash that caused the balance read* |
| **internal_index** | `UInt32` | *The internal index of the balance read within the transaction* |
| **address** | `String` | *The address of the balance read* |
| **balance** | `UInt256` | *The balance that was read* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_erc20_transfers

Contains canonical execution erc20 transfer data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_erc20_transfers/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc20_transfers/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc20_transfers/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc20_transfers/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc20_transfers/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_erc20_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_erc20_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **internal_index** | `UInt32` | *The internal index of the transfer within the transaction* |
| **log_index** | `UInt64` | *The log index in the block* |
| **erc20** | `String` | *The erc20 address* |
| **from_address** | `String` | *The from address* |
| **to_address** | `String` | *The to address* |
| **value** | `UInt256` | *The value of the transfer* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_erc721_transfers

Contains canonical execution erc721 transfer data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_erc721_transfers/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc721_transfers/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc721_transfers/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc721_transfers/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc721_transfers/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_erc721_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_erc721_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **internal_index** | `UInt32` | *The internal index of the transfer within the transaction* |
| **log_index** | `UInt64` | *The log index in the block* |
| **erc20** | `String` | *The erc20 address* |
| **from_address** | `String` | *The from address* |
| **to_address** | `String` | *The to address* |
| **token** | `UInt256` | *The token id* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_native_transfers

Contains canonical execution native transfer data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_native_transfers/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_native_transfers/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_native_transfers/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_native_transfers/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_native_transfers/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_native_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_native_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **internal_index** | `UInt32` | *The internal index of the transfer within the transaction* |
| **transfer_index** | `UInt64` | *The transfer index* |
| **from_address** | `String` | *The from address* |
| **to_address** | `String` | *The to address* |
| **value** | `UInt256` | *The value of the approval* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_nonce_diffs

Contains canonical execution nonce diff data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_nonce_diffs/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_diffs/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_diffs/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_diffs/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_diffs/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_nonce_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_nonce_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash that caused the nonce diff* |
| **internal_index** | `UInt32` | *The internal index of the nonce diff within the transaction* |
| **address** | `String` | *The address of the nonce diff* |
| **from_value** | `UInt64` | *The from value of the nonce diff* |
| **to_value** | `UInt64` | *The to value of the nonce diff* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_nonce_reads

Contains canonical execution nonce read data.


> Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_nonce_reads/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_reads/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_reads/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_reads/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_reads/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_nonce_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_nonce_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash that caused the nonce read* |
| **internal_index** | `UInt32` | *The internal index of the nonce read within the transaction* |
| **address** | `String` | *The address of the nonce read* |
| **nonce** | `UInt64` | *The nonce that was read* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_storage_diffs

Contains canonical execution storage diffs data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `23271000`
- **holesky**: `0` to `4630000`
- **sepolia**: `0` to `9351000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_storage_diffs/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_diffs/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_diffs/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_diffs/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_diffs/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_storage_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_storage_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number* |
| **transaction_index** | `UInt32` | *The transaction index* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash associated with the storage diff* |
| **internal_index** | `UInt32` | *The internal index of the storage diff within the transaction* |
| **address** | `String` | *The address associated with the storage diff* |
| **slot** | `String` | *The storage slot key* |
| **from_value** | `String` | *The original value before the storage diff* |
| **to_value** | `String` | *The new value after the storage diff* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_storage_reads

Contains canonical execution storage reads data.


> Mainnet is currently back-filling and not yet available publicly. Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **holesky**: `0` to `4631000`
- **sepolia**: `0` to `9352000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_storage_reads/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_reads/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_reads/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_reads/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_reads/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_storage_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
    FROM default.canonical_execution_storage_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number* |
| **transaction_index** | `UInt32` | *The transaction index* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash associated with the storage read* |
| **internal_index** | `UInt32` | *The internal index of the storage read within the transaction* |
| **contract_address** | `String` | *The contract address associated with the storage read* |
| **slot** | `String` | *The storage slot key* |
| **value** | `String` | *The value read from the storage slot* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_transaction_structlog

Contains canonical execution transaction structlog data.

### Availability
Data is partitioned in chunks of **100** on **block_number** for the following networks:

- **mainnet**: `22731300` to `23514400`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_transaction_structlog/100/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `100`. Take the following examples;

Contains `block_number` between `0` and `99`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction_structlog/100/0.parquet

Contains `block_number` between `22731300` and `22731399`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction_structlog/100/22731300.parquet

Contains `block_number` between `100000` and `100199`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction_structlog/100/{1000..1001}00.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction_structlog/100/{227313..227314}00.parquet', 'Parquet')
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
    FROM default.canonical_execution_transaction_structlog FINAL
    WHERE
        block_number BETWEEN 5000 AND 5100
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
    FROM default.canonical_execution_transaction_structlog FINAL
    WHERE
        block_number BETWEEN 5000 AND 5100
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **transaction_index** | `UInt32` | *The transaction position in the block* |
| **transaction_gas** | `UInt64` | *The transaction gas* |
| **transaction_failed** | `Bool` | *The transaction failed* |
| **transaction_return_value** | `Nullable(String)` | *The transaction return value* |
| **index** | `UInt32` | *The index of this structlog in this transaction* |
| **program_counter** | `UInt32` | *The program counter* |
| **operation** | `LowCardinality(String)` | *The operation* |
| **gas** | `UInt64` | *The gas* |
| **gas_cost** | `UInt64` | *The gas cost* |
| **depth** | `UInt64` | *The depth* |
| **return_data** | `Nullable(String)` | *The return data* |
| **refund** | `Nullable(UInt64)` | *The refund* |
| **error** | `Nullable(String)` | *The error* |
| **call_to_address** | `Nullable(String)` | *Address of a CALL operation* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

<!-- schema_end -->
# 

Events from the consensus layer p2p network. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances.


The libp2p dataset captures peer-to-peer network events from the consensus layer, however due to the large volume of network traffic, data is sampled using a sharding strategy. This ensures manageable data sizes while maintaining significance. Not all events are captured - the sampling rate varies by event type and topic, with high-volume topics being more aggressively sampled.

## Event Categorization

Events are categorized into four groups based on their available sharding keys:

### Group A: Topic + MsgID Events
Events with both topic and message ID, enabling full sharding flexibility:
- `PUBLISH_MESSAGE`, `DELIVER_MESSAGE`, `DUPLICATE_MESSAGE`, `REJECT_MESSAGE`
- `GOSSIPSUB_BEACON_BLOCK`, `GOSSIPSUB_BEACON_ATTESTATION`, `GOSSIPSUB_BLOB_SIDECAR`
- `RPC_META_MESSAGE`, `RPC_META_CONTROL_IHAVE`

**Sharding**: Uses message ID for sharding, with topic-based configuration

### Group B: Topic-Only Events
Events with only topic information:
- `JOIN`, `LEAVE`, `GRAFT`, `PRUNE`
- `RPC_META_CONTROL_GRAFT`, `RPC_META_CONTROL_PRUNE`, `RPC_META_SUBSCRIPTION`

**Sharding**: Uses topic hash for sharding decisions

### Group C: MsgID-Only Events
Events with only message ID:
- `RPC_META_CONTROL_IWANT`, `RPC_META_CONTROL_IDONTWANT`

**Sharding**: Uses message ID with default configuration

### Group D: No Sharding Key Events
Events without sharding keys:
- `ADD_PEER`, `REMOVE_PEER`, `CONNECTED`, `DISCONNECTED`
- `RECV_RPC`, `SEND_RPC`, `DROP_RPC` (parent events only)
- `HANDLE_METADATA`, `HANDLE_STATUS`

**Sharding**: All-or-nothing based on configuration

### Sharding Decision Flow
```
┌─────────────┐
│Event Arrives│
└──────┬──────┘
       │
       ▼
┌──────────────┐     ┌─────────────────┐
│Get Event Info├────►│ Event Category? │
└──────────────┘     └────────┬────────┘
                              │
        ┌─────────────────────┼─────────────────────┬─────────────────────┐
        ▼                     ▼                     ▼                     ▼
   ┌─────────┐         ┌─────────┐           ┌─────────┐           ┌─────────┐
   │ Group A │         │ Group B │           │ Group C │           │ Group D │
   │Topic+Msg│         │Topic Only│          │Msg Only │           │ No Keys │
   └────┬────┘         └────┬────┘           └────┬────┘           └────┬────┘
        │                   │                     │                     │
        ▼                   ▼                     ▼                     ▼
   Topic Config?       Topic Config?         Default Shard         Enabled?
        │                   │                     │                     │
     Yes/No              Yes/No                   │                  Yes/No
        │                   │                     │                     │
        ▼                   ▼                     ▼                     ▼
   Shard by Msg       Shard by Topic        Shard by Msg         Process/Drop
```

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`libp2p_gossipsub_beacon_attestation`](#libp2p_gossipsub_beacon_attestation)
- [`libp2p_gossipsub_beacon_block`](#libp2p_gossipsub_beacon_block)
- [`libp2p_gossipsub_blob_sidecar`](#libp2p_gossipsub_blob_sidecar)
- [`libp2p_gossipsub_aggregate_and_proof`](#libp2p_gossipsub_aggregate_and_proof)
- [`libp2p_connected`](#libp2p_connected)
- [`libp2p_disconnected`](#libp2p_disconnected)
- [`libp2p_add_peer`](#libp2p_add_peer)
- [`libp2p_remove_peer`](#libp2p_remove_peer)
- [`libp2p_recv_rpc`](#libp2p_recv_rpc)
- [`libp2p_send_rpc`](#libp2p_send_rpc)
- [`libp2p_drop_rpc`](#libp2p_drop_rpc)
- [`libp2p_join`](#libp2p_join)
- [`libp2p_leave`](#libp2p_leave)
- [`libp2p_graft`](#libp2p_graft)
- [`libp2p_prune`](#libp2p_prune)
- [`libp2p_duplicate_message`](#libp2p_duplicate_message)
- [`libp2p_deliver_message`](#libp2p_deliver_message)
- [`libp2p_handle_metadata`](#libp2p_handle_metadata)
- [`libp2p_handle_status`](#libp2p_handle_status)
- [`libp2p_rpc_meta_control_ihave`](#libp2p_rpc_meta_control_ihave)
- [`libp2p_rpc_meta_control_iwant`](#libp2p_rpc_meta_control_iwant)
- [`libp2p_rpc_meta_control_idontwant`](#libp2p_rpc_meta_control_idontwant)
- [`libp2p_rpc_meta_control_graft`](#libp2p_rpc_meta_control_graft)
- [`libp2p_rpc_meta_control_prune`](#libp2p_rpc_meta_control_prune)
- [`libp2p_rpc_meta_subscription`](#libp2p_rpc_meta_subscription)
- [`libp2p_rpc_meta_message`](#libp2p_rpc_meta_message)
<!-- schema_toc_end -->

<!-- schema_start -->
## libp2p_gossipsub_beacon_attestation

Table for libp2p gossipsub beacon attestation data.

### Availability
Data is partitioned **hourly** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-05-01` to `2025-10-05`
- **holesky**: `2024-05-01` to `2025-10-05`
- **sepolia**: `2024-05-01` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_beacon_attestation/YYYY/M/D/H.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_beacon_attestation/2025/10/5/0.parquet', 'Parquet')
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

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2024-04-26` to `2025-10-05`
- **sepolia**: `2024-04-26` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_beacon_block/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_beacon_block/2025/10/5.parquet', 'Parquet')
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

- **mainnet**: `2020-12-01` to `2025-10-05`
- **holesky**: `2024-06-03` to `2025-10-05`
- **sepolia**: `2024-06-03` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_blob_sidecar/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_blob_sidecar/2025/10/5.parquet', 'Parquet')
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
| **beacon_block_root** | `FixedString(66)` | ** |
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

## libp2p_gossipsub_aggregate_and_proof

Table for libp2p gossipsub aggregate and proof data.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2025-07-11` to `2025-10-05`
- **holesky**: `2025-07-11` to `2025-10-05`
- **sepolia**: `2025-07-11` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_aggregate_and_proof/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_aggregate_and_proof/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_gossipsub_aggregate_and_proof FINAL
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
    FROM default.libp2p_gossipsub_aggregate_and_proof FINAL
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
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer* |
| **message_id** | `String` | *Identifier of the message* |
| **message_size** | `UInt32` | *Size of the message in bytes* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic in the gossipsub protocol* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding used for the topic* |
| **aggregator_index** | `UInt32` | *Index of the validator who created this aggregate* |
| **committee_index** | `LowCardinality(String)` | *Committee index from the attestation* |
| **aggregation_bits** | `String` | *Bitfield of aggregated attestation* |
| **beacon_block_root** | `FixedString(66)` | *Root of the beacon block being attested to* |
| **source_epoch** | `UInt32` | *Source epoch from the attestation* |
| **source_root** | `FixedString(66)` | *Source root from the attestation* |
| **target_epoch** | `UInt32` | *Target epoch from the attestation* |
| **target_root** | `FixedString(66)` | *Target root from the attestation* |
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

## libp2p_connected

Contains the details of the CONNECTED events from the libp2p client.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2024-04-24` to `2025-10-05`
- **hoodi**: `2025-03-17` to `2025-10-05`
- **sepolia**: `2024-04-22` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_connected/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_connected/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_connected FINAL
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
    FROM default.libp2p_connected FINAL
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

Contains the details of the DISCONNECTED events from the libp2p client.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2024-04-24` to `2025-10-05`
- **hoodi**: `2025-03-17` to `2025-10-05`
- **sepolia**: `2024-04-22` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_disconnected/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_disconnected/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_disconnected FINAL
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
    FROM default.libp2p_disconnected FINAL
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

## libp2p_add_peer

Contains the details of the peers added to the libp2p client.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2024-04-24` to `2025-10-05`
- **hoodi**: `2025-03-17` to `2025-10-05`
- **sepolia**: `2024-04-22` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_add_peer/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_add_peer/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_add_peer FINAL
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
    FROM default.libp2p_add_peer FINAL
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

## libp2p_remove_peer

Contains the details of the peers removed from the libp2p client.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2024-04-24` to `2025-10-05`
- **hoodi**: `2025-03-17` to `2025-10-05`
- **sepolia**: `2024-04-22` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_remove_peer/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_remove_peer/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_remove_peer FINAL
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
    FROM default.libp2p_remove_peer FINAL
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

## libp2p_recv_rpc

Contains the details of the RPC messages received by the peer.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_recv_rpc/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_recv_rpc/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_recv_rpc FINAL
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
    FROM default.libp2p_recv_rpc FINAL
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

## libp2p_send_rpc

Contains the details of the RPC messages sent by the peer.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_send_rpc/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_send_rpc/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_send_rpc FINAL
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
    FROM default.libp2p_send_rpc FINAL
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

## libp2p_drop_rpc

Contains the details of the RPC messages dropped by the peer.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-30` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_drop_rpc/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_drop_rpc/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_drop_rpc FINAL
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
    FROM default.libp2p_drop_rpc FINAL
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

## libp2p_join

Contains the details of the JOIN events from the libp2p client.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2024-05-01` to `2025-10-05`
- **hoodi**: `2025-03-17` to `2025-10-05`
- **sepolia**: `2024-05-01` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_join/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_join/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_join FINAL
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
    FROM default.libp2p_join FINAL
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

## libp2p_leave

Contains the details of the LEAVE events from the libp2p client.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-06-01` to `2025-10-05`
- **hoodi**: `2025-06-01` to `2025-06-01`
- **sepolia**: `2025-06-01` to `2025-06-01`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_leave/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_leave/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_leave FINAL
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
    FROM default.libp2p_leave FINAL
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
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding of the topic* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer that left the topic* |
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

## libp2p_graft

Contains the details of the GRAFT events from the libp2p client.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_graft/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_graft/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_graft FINAL
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
    FROM default.libp2p_graft FINAL
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
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding of the topic* |
| **peer_id_unique_key** | `Int64` | *Unique key for the peer that initiated the GRAFT (eg joined the mesh for this topic) identifies mesh membership changes per peer.* |
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

## libp2p_prune

Contains the details of the PRUNE events from the libp2p client.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_prune/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_prune/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_prune FINAL
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
    FROM default.libp2p_prune FINAL
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
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding of the topic* |
| **peer_id_unique_key** | `Int64` | *Unique key for the peer that was PRUNED (eg removed from the mesh for this topic) identifies mesh membership changes per peer.* |
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

## libp2p_duplicate_message

Contains the details of the DUPLICATE_MESSAGE events from the libp2p client.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_duplicate_message/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_duplicate_message/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_duplicate_message FINAL
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
    FROM default.libp2p_duplicate_message FINAL
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
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding of the topic* |
| **seq_number** | `UInt64` | *A linearly increasing number that is unique among messages originating from the given peer* |
| **local_delivery** | `Bool` | *Indicates if the message was duplicated locally* |
| **peer_id_unique_key** | `Int64` | *Unique key for the peer that sent the duplicate message* |
| **message_id** | `String` | *Identifier of the message* |
| **message_size** | `UInt32` | *Size of the message in bytes* |
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

## libp2p_deliver_message

Contains the details of the DELIVER_MESSAGE events from the libp2p client.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_deliver_message/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_deliver_message/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_deliver_message FINAL
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
    FROM default.libp2p_deliver_message FINAL
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
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **topic_layer** | `LowCardinality(String)` | *Layer of the topic* |
| **topic_fork_digest_value** | `LowCardinality(String)` | *Fork digest value of the topic* |
| **topic_name** | `LowCardinality(String)` | *Name of the topic* |
| **topic_encoding** | `LowCardinality(String)` | *Encoding of the topic* |
| **seq_number** | `UInt64` | *A linearly increasing number that is unique among messages originating from the given peer* |
| **local_delivery** | `Bool` | *Indicates if the message was delivered to in-process subscribers only* |
| **peer_id_unique_key** | `Int64` | *Unique key for the peer that delivered the message* |
| **message_id** | `String` | *Identifier of the message* |
| **message_size** | `UInt32` | *Size of the message in bytes* |
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

## libp2p_handle_metadata

Contains the metadata handling events for libp2p peers.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2024-04-24` to `2025-10-05`
- **hoodi**: `2025-03-17` to `2025-10-05`
- **sepolia**: `2024-04-22` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_handle_metadata/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_handle_metadata/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_handle_metadata FINAL
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
    FROM default.libp2p_handle_metadata FINAL
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
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer involved in the RPC* |
| **error** | `Nullable(String)` | *Error message if the metadata handling failed* |
| **protocol** | `LowCardinality(String)` | *The protocol of the metadata handling event* |
| **direction** | `LowCardinality(Nullable(String))` | *Direction of the RPC request (inbound or outbound)* |
| **attnets** | `String` | *Attestation subnets the peer is subscribed to* |
| **seq_number** | `UInt64` | *Sequence number of the metadata* |
| **syncnets** | `String` | *Sync subnets the peer is subscribed to* |
| **custody_group_count** | `Nullable(UInt8)` | *Number of custody groups (0-127)* |
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

Contains the status handling events for libp2p peers.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2024-04-24` to `2025-10-05`
- **hoodi**: `2025-03-17` to `2025-10-05`
- **sepolia**: `2024-04-22` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_handle_status/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_handle_status/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_handle_status FINAL
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
    FROM default.libp2p_handle_status FINAL
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
| **event_date_time** | `DateTime64(3)` | *Timestamp of the event* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer* |
| **error** | `Nullable(String)` | *Error message if the status handling failed* |
| **protocol** | `LowCardinality(String)` | *The protocol of the status handling event* |
| **direction** | `LowCardinality(Nullable(String))` | *Direction of the RPC request (inbound or outbound)* |
| **request_finalized_epoch** | `Nullable(UInt32)` | *Requested finalized epoch* |
| **request_finalized_root** | `Nullable(String)` | *Requested finalized root* |
| **request_fork_digest** | `LowCardinality(String)` | *Requested fork digest* |
| **request_head_root** | `Nullable(FixedString(66))` | *Requested head root* |
| **request_head_slot** | `Nullable(UInt32)` | *Requested head slot* |
| **request_earliest_available_slot** | `Nullable(UInt32)` | *Requested earliest available slot* |
| **response_finalized_epoch** | `Nullable(UInt32)` | *Response finalized epoch* |
| **response_finalized_root** | `Nullable(FixedString(66))` | *Response finalized root* |
| **response_fork_digest** | `LowCardinality(String)` | *Response fork digest* |
| **response_head_root** | `Nullable(FixedString(66))` | *Response head root* |
| **response_head_slot** | `Nullable(UInt32)` | *Response head slot* |
| **response_earliest_available_slot** | `Nullable(UInt32)` | *Response earliest available slot* |
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

## libp2p_rpc_meta_control_ihave

Contains the details of the "I have" control messages from the peer.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_ihave/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_ihave/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_control_ihave FINAL
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
    FROM default.libp2p_rpc_meta_control_ihave FINAL
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

Contains the details of the "I want" control messages from the peer.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_iwant/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_iwant/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_control_iwant FINAL
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
    FROM default.libp2p_rpc_meta_control_iwant FINAL
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

## libp2p_rpc_meta_control_idontwant

Contains the details of the IDONTWANT control messages from the peer.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_idontwant/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_idontwant/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_control_idontwant FINAL
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
    FROM default.libp2p_rpc_meta_control_idontwant FINAL
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
| **unique_key** | `Int64` | *Unique identifier for each IDONTWANT control record* |
| **updated_date_time** | `DateTime` | *Timestamp when the IDONTWANT control record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the IDONTWANT control event* |
| **control_index** | `Int32` | *Position in the RPC meta control idontwant array* |
| **message_index** | `Int32` | *Position in the RPC meta control idontwant message_ids array* |
| **rpc_meta_unique_key** | `Int64` | *Unique key associated with the IDONTWANT control metadata* |
| **message_id** | `String` | *Identifier of the message associated with the IDONTWANT control* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer involved in the IDONTWANT control* |
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

Contains the details of the "Graft" control messages from the peer.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_graft/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_graft/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_control_graft FINAL
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
    FROM default.libp2p_rpc_meta_control_graft FINAL
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

## libp2p_rpc_meta_control_prune

Contains the details of the "Prune" control messages from the peer.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-07-02` to `2025-10-05`
- **hoodi**: `2025-06-23` to `2025-10-05`
- **sepolia**: `2025-06-23` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_prune/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_prune/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_control_prune FINAL
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
    FROM default.libp2p_rpc_meta_control_prune FINAL
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
| **unique_key** | `Int64` | *Unique identifier for each "Prune" control record* |
| **updated_date_time** | `DateTime` | *Timestamp when the "Prune" control record was last updated* |
| **event_date_time** | `DateTime64(3)` | *Timestamp of the "Prune" control event* |
| **control_index** | `Int32` | *Position in the RPC meta control PRUNE array* |
| **rpc_meta_unique_key** | `Int64` | *Unique key associated with the "Prune" control metadata* |
| **peer_id_index** | `Int32` | ** |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer involved in the Prune control* |
| **graft_peer_id_unique_key** | `Nullable(Int64)` | *Unique key associated with the identifier of the graft peer involved in the Prune control* |
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

## libp2p_rpc_meta_subscription

Contains the details of the RPC subscriptions from the peer.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_subscription/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_subscription/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_subscription FINAL
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
    FROM default.libp2p_rpc_meta_subscription FINAL
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

## libp2p_rpc_meta_message

Contains the details of the RPC meta messages from the peer

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2025-05-30` to `2025-10-05`
- **hoodi**: `2025-05-29` to `2025-10-05`
- **sepolia**: `2025-05-29` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_message/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_message/2025/10/5.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_message FINAL
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
    FROM default.libp2p_rpc_meta_message FINAL
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

<!-- schema_end -->
# 

Events derived from MEV relays. Data is scraped from multiple MEV Relays by multiple instances.

## Availability
- Public Parquet Files
- EthPandaOps Clickhouse

## Tables

<!-- schema_toc_start -->
- [`mev_relay_bid_trace`](#mev_relay_bid_trace)
- [`mev_relay_proposer_payload_delivered`](#mev_relay_proposer_payload_delivered)
- [`mev_relay_validator_registration`](#mev_relay_validator_registration)
<!-- schema_toc_end -->

<!-- schema_start -->
## mev_relay_bid_trace

Contains MEV relay block bids data.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-09-13` to `2025-10-05`
- **holesky**: `2024-09-13` to `2025-10-05`
- **sepolia**: `2024-09-13` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mev_relay_bid_trace/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mev_relay_bid_trace/2025/10/5.parquet', 'Parquet')
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
    FROM default.mev_relay_bid_trace FINAL
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
    FROM default.mev_relay_bid_trace FINAL
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

- **mainnet**: `2024-09-16` to `2025-10-05`
- **holesky**: `2024-09-16` to `2025-08-17`
- **sepolia**: `2024-09-16` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mev_relay_proposer_payload_delivered/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mev_relay_proposer_payload_delivered/2025/10/5.parquet', 'Parquet')
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
    FROM default.mev_relay_proposer_payload_delivered FINAL
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
    FROM default.mev_relay_proposer_payload_delivered FINAL
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

## mev_relay_validator_registration

Contains MEV relay validator registrations data.

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2024-12-11` to `2025-10-05`
- **holesky**: `2024-12-11` to `2025-04-27`
- **sepolia**: `2024-12-11` to `2025-10-05`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mev_relay_validator_registration/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mev_relay_validator_registration/2025/10/5.parquet', 'Parquet')
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
    FROM default.mev_relay_validator_registration FINAL
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
    FROM default.mev_relay_validator_registration FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the registration was fetched* |
| **timestamp** | `Int64` | *The timestamp of the registration* |
| **relay_name** | `String` | *The relay that the registration was fetched from* |
| **validator_index** | `UInt32` | *The validator index of the validator registration* |
| **gas_limit** | `UInt64` | *The gas limit of the validator registration* |
| **fee_recipient** | `String` | *The fee recipient of the validator registration* |
| **slot** | `UInt32` | *Slot number derived from the validator registration `timestamp` field* |
| **slot_start_date_time** | `DateTime` | *The slot start time derived from the validator registration `timestamp` field* |
| **epoch** | `UInt32` | *Epoch number derived from the validator registration `timestamp` field* |
| **epoch_start_date_time** | `DateTime` | *The epoch start time derived from the validator registration `timestamp` field* |
| **wallclock_slot** | `UInt32` | *The wallclock slot when the request was sent* |
| **wallclock_slot_start_date_time** | `DateTime` | *The start time for the slot when the request was sent* |
| **wallclock_epoch** | `UInt32` | *The wallclock epoch when the request was sent* |
| **wallclock_epoch_start_date_time** | `DateTime` | *The start time for the wallclock epoch when the request was sent* |
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
# 

Pre-aggregated analytical tables for common blockchain queries. These tables are transformation tables similar to DBT, powered by [xatu-cbt](https://github.com/ethpandaops/xatu-cbt) using [ClickHouse Build Tools (CBT)](https://github.com/ethpandaops/cbt).


CBT tables are organized by network-specific databases. To query these tables, you must target the correct database for your network:
- `mainnet.table_name` for Mainnet data
- `sepolia.table_name` for Sepolia data
- `holesky.table_name` for Holesky data
- `hoodi.table_name` for Hoodi data

Unlike other Xatu datasets, CBT tables do not use `meta_network_name` for filtering. The network is determined by the database you query.

CBT tables include dimension tables (prefixed with `dim_`), fact tables (prefixed with `fct_`), and intermediate tables (prefixed with `int_`).

## Availability
- EthPandaOps Clickhouse

## Tables

<!-- schema_toc_start -->
- [`dim_node`](#dim_node)
- [`fct_address_access_chunked_10000`](#fct_address_access_chunked_10000)
- [`fct_address_access_total`](#fct_address_access_total)
- [`fct_address_storage_slot_chunked_10000`](#fct_address_storage_slot_chunked_10000)
- [`fct_address_storage_slot_expired_top_100_by_contract`](#fct_address_storage_slot_expired_top_100_by_contract)
- [`fct_address_storage_slot_top_100_by_contract`](#fct_address_storage_slot_top_100_by_contract)
- [`fct_address_storage_slot_total`](#fct_address_storage_slot_total)
- [`fct_attestation_correctness_by_validator_canonical`](#fct_attestation_correctness_by_validator_canonical)
- [`fct_attestation_correctness_by_validator_head`](#fct_attestation_correctness_by_validator_head)
- [`fct_attestation_correctness_canonical`](#fct_attestation_correctness_canonical)
- [`fct_attestation_correctness_head`](#fct_attestation_correctness_head)
- [`fct_attestation_first_seen_chunked_50ms`](#fct_attestation_first_seen_chunked_50ms)
- [`fct_block`](#fct_block)
- [`fct_block_blob_count`](#fct_block_blob_count)
- [`fct_block_blob_count_head`](#fct_block_blob_count_head)
- [`fct_block_blob_first_seen_by_node`](#fct_block_blob_first_seen_by_node)
- [`fct_block_first_seen_by_node`](#fct_block_first_seen_by_node)
- [`fct_block_head`](#fct_block_head)
- [`fct_block_mev`](#fct_block_mev)
- [`fct_block_mev_head`](#fct_block_mev_head)
- [`fct_block_proposer`](#fct_block_proposer)
- [`fct_block_proposer_entity`](#fct_block_proposer_entity)
- [`fct_block_proposer_head`](#fct_block_proposer_head)
- [`fct_mev_bid_count_by_builder`](#fct_mev_bid_count_by_builder)
- [`fct_mev_bid_count_by_relay`](#fct_mev_bid_count_by_relay)
- [`fct_mev_bid_highest_value_by_builder_chunked_50ms`](#fct_mev_bid_highest_value_by_builder_chunked_50ms)
- [`fct_node_active_last_24h`](#fct_node_active_last_24h)
- [`fct_prepared_block`](#fct_prepared_block)
- [`int_address_first_access`](#int_address_first_access)
- [`int_address_last_access`](#int_address_last_access)
- [`int_address_storage_slot_first_access`](#int_address_storage_slot_first_access)
- [`int_address_storage_slot_last_access`](#int_address_storage_slot_last_access)
- [`int_attestation_attested_canonical`](#int_attestation_attested_canonical)
- [`int_attestation_attested_head`](#int_attestation_attested_head)
- [`int_attestation_first_seen`](#int_attestation_first_seen)
- [`int_beacon_committee_head`](#int_beacon_committee_head)
- [`int_block_blob_count_canonical`](#int_block_blob_count_canonical)
- [`int_block_canonical`](#int_block_canonical)
- [`int_block_mev_canonical`](#int_block_mev_canonical)
- [`int_block_proposer_canonical`](#int_block_proposer_canonical)
<!-- schema_toc_end -->

<!-- schema_start -->
## dim_node

Node information for validators

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.dim_node`
- **sepolia**: `sepolia.dim_node`
- **holesky**: `holesky.dim_node`
- **hoodi**: `hoodi.dim_node`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.dim_node FINAL
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
    FROM cbt.dim_node FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **validator_index** | `UInt32` | *The index of the validator* |
| **name** | `Nullable(String)` | *The name of the node* |
| **groups** | `Array(String)` | *Groups the node belongs to* |
| **tags** | `Array(String)` | *Tags associated with the node* |
| **attributes** | `Map(String, String)` | *Additional attributes of the node* |
| **source** | `String` | *The source entity of the node* |

## fct_address_access_chunked_10000

Address access totals chunked by 10000 blocks

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_access_chunked_10000`
- **sepolia**: `sepolia.fct_address_access_chunked_10000`
- **holesky**: `holesky.fct_address_access_chunked_10000`
- **hoodi**: `hoodi.fct_address_access_chunked_10000`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_address_access_chunked_10000 FINAL
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
    FROM cbt.fct_address_access_chunked_10000 FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **chunk_start_block_number** | `UInt32` | *Start block number of the chunk* |
| **first_accessed_accounts** | `UInt32` | *Number of accounts first accessed in the chunk* |
| **last_accessed_accounts** | `UInt32` | *Number of accounts last accessed in the chunk* |

## fct_address_access_total

Address access totals and expiry statistics

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_access_total`
- **sepolia**: `sepolia.fct_address_access_total`
- **holesky**: `holesky.fct_address_access_total`
- **hoodi**: `hoodi.fct_address_access_total`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_address_access_total FINAL
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
    FROM cbt.fct_address_access_total FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **total_accounts** | `UInt64` | *Total number of accounts accessed in last 365 days* |
| **expired_accounts** | `UInt64` | *Number of expired accounts (not accessed in last 365 days)* |
| **total_contract_accounts** | `UInt64` | *Total number of contract accounts accessed in last 365 days* |
| **expired_contracts** | `UInt64` | *Number of expired contracts (not accessed in last 365 days)* |

## fct_address_storage_slot_chunked_10000

Storage slot totals chunked by 10000 blocks

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_storage_slot_chunked_10000`
- **sepolia**: `sepolia.fct_address_storage_slot_chunked_10000`
- **holesky**: `holesky.fct_address_storage_slot_chunked_10000`
- **hoodi**: `hoodi.fct_address_storage_slot_chunked_10000`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_address_storage_slot_chunked_10000 FINAL
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
    FROM cbt.fct_address_storage_slot_chunked_10000 FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **chunk_start_block_number** | `UInt32` | *Start block number of the chunk* |
| **first_accessed_slots** | `UInt32` | *Number of slots first accessed in the chunk* |
| **last_accessed_slots** | `UInt32` | *Number of slots last accessed in the chunk* |

## fct_address_storage_slot_expired_top_100_by_contract

Top 100 contracts by expired storage slots (not accessed in last 365 days)

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_storage_slot_expired_top_100_by_contract`
- **sepolia**: `sepolia.fct_address_storage_slot_expired_top_100_by_contract`
- **holesky**: `holesky.fct_address_storage_slot_expired_top_100_by_contract`
- **hoodi**: `hoodi.fct_address_storage_slot_expired_top_100_by_contract`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_address_storage_slot_expired_top_100_by_contract FINAL
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
    FROM cbt.fct_address_storage_slot_expired_top_100_by_contract FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **rank** | `UInt32` | *Rank by expired storage slots (1=highest)* |
| **contract_address** | `String` | *The contract address* |
| **expired_slots** | `UInt64` | *Number of expired storage slots for this contract* |

## fct_address_storage_slot_top_100_by_contract

Top 100 contracts by storage slots

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_storage_slot_top_100_by_contract`
- **sepolia**: `sepolia.fct_address_storage_slot_top_100_by_contract`
- **holesky**: `holesky.fct_address_storage_slot_top_100_by_contract`
- **hoodi**: `hoodi.fct_address_storage_slot_top_100_by_contract`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_address_storage_slot_top_100_by_contract FINAL
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
    FROM cbt.fct_address_storage_slot_top_100_by_contract FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **rank** | `UInt32` | *Rank by total storage slots (1=highest)* |
| **contract_address** | `String` | *The contract address* |
| **total_storage_slots** | `UInt64` | *Total number of storage slots for this contract* |

## fct_address_storage_slot_total

Storage slot totals and expiry statistics

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_storage_slot_total`
- **sepolia**: `sepolia.fct_address_storage_slot_total`
- **holesky**: `holesky.fct_address_storage_slot_total`
- **hoodi**: `hoodi.fct_address_storage_slot_total`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_address_storage_slot_total FINAL
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
    FROM cbt.fct_address_storage_slot_total FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **total_storage_slots** | `UInt64` | *Total number of storage slots accessed in last 365 days* |
| **expired_storage_slots** | `UInt64` | *Number of expired storage slots (not accessed in last 365 days)* |

## fct_attestation_correctness_by_validator_canonical

Attestation correctness by validator for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_correctness_by_validator_canonical`
- **sepolia**: `sepolia.fct_attestation_correctness_by_validator_canonical`
- **holesky**: `holesky.fct_attestation_correctness_by_validator_canonical`
- **hoodi**: `hoodi.fct_attestation_correctness_by_validator_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_attestation_correctness_by_validator_canonical FINAL
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
    FROM cbt.fct_attestation_correctness_by_validator_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **attesting_validator_index** | `UInt32` | *The index of the validator attesting* |
| **block_root** | `Nullable(String)` | *The beacon block root hash that was attested* |
| **slot_distance** | `Nullable(UInt32)` | *The distance from the slot to the attested block. If the attested block is the same as the slot, the distance is 0, if the attested block is the previous slot, the distance is 1, etc. If null, the attestation was missed, the block was orphaned and never seen by a sentry or the block was more than 64 slots ago* |
| **inclusion_distance** | `Nullable(UInt32)` | *The distance from the slot when the attestation was included in a block* |
| **status** | `LowCardinality(String)` | *Can be "canonical", "orphaned", "missed" or "unknown" (validator attested but block data not available)* |

## fct_attestation_correctness_by_validator_head

Attestation correctness by validator for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_correctness_by_validator_head`
- **sepolia**: `sepolia.fct_attestation_correctness_by_validator_head`
- **holesky**: `holesky.fct_attestation_correctness_by_validator_head`
- **hoodi**: `hoodi.fct_attestation_correctness_by_validator_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_attestation_correctness_by_validator_head FINAL
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
    FROM cbt.fct_attestation_correctness_by_validator_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **attesting_validator_index** | `UInt32` | *The index of the validator attesting* |
| **block_root** | `Nullable(String)` | *The beacon block root hash that was attested, null means the attestation was missed* |
| **slot_distance** | `Nullable(UInt32)` | *The distance from the slot to the attested block. If the attested block is the same as the slot, the distance is 0, if the attested block is the previous slot, the distance is 1, etc. If null, the attestation was missed, the block was orphaned and never seen by a sentry or the block was more than 64 slots ago* |
| **propagation_distance** | `Nullable(UInt32)` | *The distance from the slot when the attestation was propagated. 0 means the attestation was propagated within the same slot as its duty was assigned, 1 means the attestation was propagated within the next slot, etc.* |

## fct_attestation_correctness_canonical

Attestation correctness of a block for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_correctness_canonical`
- **sepolia**: `sepolia.fct_attestation_correctness_canonical`
- **holesky**: `holesky.fct_attestation_correctness_canonical`
- **hoodi**: `hoodi.fct_attestation_correctness_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_attestation_correctness_canonical FINAL
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
    FROM cbt.fct_attestation_correctness_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `Nullable(String)` | *The beacon block root hash* |
| **votes_max** | `UInt32` | *The maximum number of scheduled votes for the block* |
| **votes_head** | `Nullable(UInt32)` | *The number of votes for the block proposed in the current slot* |
| **votes_other** | `Nullable(UInt32)` | *The number of votes for any blocks proposed in previous slots* |

## fct_attestation_correctness_head

Attestation correctness of a block for the unfinalized chain. Forks in the chain may cause multiple block roots for the same slot to be present

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_correctness_head`
- **sepolia**: `sepolia.fct_attestation_correctness_head`
- **holesky**: `holesky.fct_attestation_correctness_head`
- **hoodi**: `hoodi.fct_attestation_correctness_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_attestation_correctness_head FINAL
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
    FROM cbt.fct_attestation_correctness_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `Nullable(String)` | *The beacon block root hash* |
| **votes_max** | `UInt32` | *The maximum number of scheduled votes for the block* |
| **votes_head** | `Nullable(UInt32)` | *The number of votes for the block proposed in the current slot* |
| **votes_other** | `Nullable(UInt32)` | *The number of votes for any blocks proposed in previous slots* |

## fct_attestation_first_seen_chunked_50ms

Attestations first seen on the unfinalized chain broken down by 50ms chunks. Only includes attestations that were seen within 12000ms of the slot start time. There can be multiple block roots + chunk_slot_start_diff for the same slot, it most likely means votes for prior slot blocks

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_first_seen_chunked_50ms`
- **sepolia**: `sepolia.fct_attestation_first_seen_chunked_50ms`
- **holesky**: `holesky.fct_attestation_first_seen_chunked_50ms`
- **hoodi**: `hoodi.fct_attestation_first_seen_chunked_50ms`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_attestation_first_seen_chunked_50ms FINAL
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
    FROM cbt.fct_attestation_first_seen_chunked_50ms FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `String` | *The beacon block root hash that was attested, null means the attestation was missed* |
| **chunk_slot_start_diff** | `UInt32` | *The different between the chunk start time and slot_start_date_time. "1500" would mean this chunk contains attestations first seen between 1500ms 1550ms into the slot* |
| **attestation_count** | `UInt32` | *The number of attestations in this chunk* |

## fct_block

Block details for the finalized chain including orphaned blocks

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block`
- **sepolia**: `sepolia.fct_block`
- **holesky**: `holesky.fct_block`
- **hoodi**: `hoodi.fct_block`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_block FINAL
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
    FROM cbt.fct_block FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the reorg slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **parent_root** | `FixedString(66)` | *The root hash of the parent beacon block* |
| **state_root** | `FixedString(66)` | *The root hash of the beacon state at this block* |
| **proposer_index** | `UInt32` | *The index of the validator that proposed the beacon block* |
| **eth1_data_block_hash** | `FixedString(66)` | *The block hash of the associated execution block* |
| **eth1_data_deposit_root** | `FixedString(66)` | *The root of the deposit tree in the associated execution block* |
| **execution_payload_block_hash** | `FixedString(66)` | *The block hash of the execution payload* |
| **execution_payload_block_number** | `UInt32` | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | `String` | *The recipient of the fee for this execution payload* |
| **execution_payload_base_fee_per_gas** | `Nullable(UInt128)` | *Base fee per gas for execution payload* |
| **execution_payload_blob_gas_used** | `Nullable(UInt64)` | *Gas used for blobs in execution payload* |
| **execution_payload_excess_blob_gas** | `Nullable(UInt64)` | *Excess gas used for blobs in execution payload* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_state_root** | `FixedString(66)` | *The state root of the execution payload* |
| **execution_payload_parent_hash** | `FixedString(66)` | *The parent hash of the execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |
| **execution_payload_transactions_total_bytes_compressed** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload when compressed using snappy* |
| **status** | `LowCardinality(String)` | *Can be "canonical" or "orphaned"* |

## fct_block_blob_count

Blob count of a block for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_blob_count`
- **sepolia**: `sepolia.fct_block_blob_count`
- **holesky**: `holesky.fct_block_blob_count`
- **hoodi**: `hoodi.fct_block_blob_count`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_block_blob_count FINAL
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
    FROM cbt.fct_block_blob_count FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `String` | *The beacon block root hash* |
| **blob_count** | `UInt32` | *The number of blobs in the block* |
| **status** | `LowCardinality(String)` | *Can be "canonical" or "orphaned"* |

## fct_block_blob_count_head

Blob count of a block for the unfinalized chain. Forks in the chain may cause multiple block roots for the same slot to be present

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_blob_count_head`
- **sepolia**: `sepolia.fct_block_blob_count_head`
- **holesky**: `holesky.fct_block_blob_count_head`
- **hoodi**: `hoodi.fct_block_blob_count_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_block_blob_count_head FINAL
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
    FROM cbt.fct_block_blob_count_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `String` | *The beacon block root hash* |
| **blob_count** | `UInt32` | *The number of blobs in the block* |

## fct_block_blob_first_seen_by_node

When the block was first seen on the network by a sentry node

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_blob_first_seen_by_node`
- **sepolia**: `sepolia.fct_block_blob_first_seen_by_node`
- **holesky**: `holesky.fct_block_blob_first_seen_by_node`
- **hoodi**: `hoodi.fct_block_blob_first_seen_by_node`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_block_blob_first_seen_by_node FINAL
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
    FROM cbt.fct_block_blob_first_seen_by_node FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **source** | `LowCardinality(String)` | *Source of the event* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **seen_slot_start_diff** | `UInt32` | *The time from slot start for the client to see the block* |
| **block_root** | `String` | *The beacon block root hash* |
| **blob_index** | `UInt32` | *The blob index* |
| **username** | `LowCardinality(String)` | *Username of the node* |
| **node_id** | `String` | *ID of the node* |
| **classification** | `LowCardinality(String)` | *Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation* |

## fct_block_first_seen_by_node

When the block was first seen on the network by a sentry node

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_first_seen_by_node`
- **sepolia**: `sepolia.fct_block_first_seen_by_node`
- **holesky**: `holesky.fct_block_first_seen_by_node`
- **hoodi**: `hoodi.fct_block_first_seen_by_node`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_block_first_seen_by_node FINAL
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
    FROM cbt.fct_block_first_seen_by_node FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **source** | `LowCardinality(String)` | *Source of the event* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **seen_slot_start_diff** | `UInt32` | *The time from slot start for the client to see the block* |
| **block_root** | `String` | *The beacon block root hash* |
| **username** | `LowCardinality(String)` | *Username of the node* |
| **node_id** | `String` | *ID of the node* |
| **classification** | `LowCardinality(String)` | *Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation* |

## fct_block_head

Block details for the unfinalized chain. Forks in the chain may cause multiple block roots for the same slot to be present

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_head`
- **sepolia**: `sepolia.fct_block_head`
- **holesky**: `holesky.fct_block_head`
- **hoodi**: `hoodi.fct_block_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_block_head FINAL
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
    FROM cbt.fct_block_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the reorg slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **parent_root** | `FixedString(66)` | *The root hash of the parent beacon block* |
| **state_root** | `FixedString(66)` | *The root hash of the beacon state at this block* |
| **proposer_index** | `UInt32` | *The index of the validator that proposed the beacon block* |
| **eth1_data_block_hash** | `FixedString(66)` | *The block hash of the associated execution block* |
| **eth1_data_deposit_root** | `FixedString(66)` | *The root of the deposit tree in the associated execution block* |
| **execution_payload_block_hash** | `FixedString(66)` | *The block hash of the execution payload* |
| **execution_payload_block_number** | `UInt32` | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | `String` | *The recipient of the fee for this execution payload* |
| **execution_payload_base_fee_per_gas** | `Nullable(UInt128)` | *Base fee per gas for execution payload* |
| **execution_payload_blob_gas_used** | `Nullable(UInt64)` | *Gas used for blobs in execution payload* |
| **execution_payload_excess_blob_gas** | `Nullable(UInt64)` | *Excess gas used for blobs in execution payload* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_state_root** | `FixedString(66)` | *The state root of the execution payload* |
| **execution_payload_parent_hash** | `FixedString(66)` | *The parent hash of the execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |
| **execution_payload_transactions_total_bytes_compressed** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload when compressed using snappy* |

## fct_block_mev

MEV relay proposer payload delivered for a block on the finalized chain including orphaned blocks

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_mev`
- **sepolia**: `sepolia.fct_block_mev`
- **holesky**: `holesky.fct_block_mev`
- **hoodi**: `hoodi.fct_block_mev`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_block_mev FINAL
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
    FROM cbt.fct_block_mev FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block proposer payload* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the proposer payload is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the proposer payload is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the proposer payload is for* |
| **block_root** | `String` | *The root hash of the beacon block* |
| **earliest_bid_date_time** | `Nullable(DateTime64(3))` | *The earliest timestamp of the accepted bid in milliseconds* |
| **relay_names** | `Array(String)` | *The relay names that delivered the proposer payload* |
| **parent_hash** | `FixedString(66)` | *The parent hash of the proposer payload* |
| **block_number** | `UInt64` | *The block number of the proposer payload* |
| **block_hash** | `FixedString(66)` | *The block hash of the proposer payload* |
| **builder_pubkey** | `String` | *The builder pubkey of the proposer payload* |
| **proposer_pubkey** | `String` | *The proposer pubkey of the proposer payload* |
| **proposer_fee_recipient** | `FixedString(42)` | *The proposer fee recipient of the proposer payload* |
| **gas_limit** | `UInt64` | *The gas limit of the proposer payload* |
| **gas_used** | `UInt64` | *The gas used of the proposer payload* |
| **value** | `Nullable(UInt128)` | *The transaction value in wei* |
| **transaction_count** | `UInt32` | *The number of transactions in the proposer payload* |
| **status** | `LowCardinality(String)` | *Can be "canonical" or "orphaned"* |

## fct_block_mev_head

MEV relay proposer payload delivered for a block on the unfinalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_mev_head`
- **sepolia**: `sepolia.fct_block_mev_head`
- **holesky**: `holesky.fct_block_mev_head`
- **hoodi**: `hoodi.fct_block_mev_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_block_mev_head FINAL
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
    FROM cbt.fct_block_mev_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block proposer payload* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the proposer payload is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the proposer payload is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the proposer payload is for* |
| **block_root** | `String` | *The root hash of the beacon block* |
| **earliest_bid_date_time** | `Nullable(DateTime64(3))` | *The earliest timestamp of the accepted bid in milliseconds* |
| **relay_names** | `Array(String)` | *The relay names that delivered the proposer payload* |
| **parent_hash** | `FixedString(66)` | *The parent hash of the proposer payload* |
| **block_number** | `UInt64` | *The block number of the proposer payload* |
| **block_hash** | `FixedString(66)` | *The block hash of the proposer payload* |
| **builder_pubkey** | `String` | *The builder pubkey of the proposer payload* |
| **proposer_pubkey** | `String` | *The proposer pubkey of the proposer payload* |
| **proposer_fee_recipient** | `FixedString(42)` | *The proposer fee recipient of the proposer payload* |
| **gas_limit** | `UInt64` | *The gas limit of the proposer payload* |
| **gas_used** | `UInt64` | *The gas used of the proposer payload* |
| **value** | `Nullable(UInt128)` | *The transaction value in wei* |
| **transaction_count** | `UInt32` | *The number of transactions in the proposer payload* |

## fct_block_proposer

Block proposers for the finalized chain including orphaned blocks

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_proposer`
- **sepolia**: `sepolia.fct_block_proposer`
- **holesky**: `holesky.fct_block_proposer`
- **hoodi**: `hoodi.fct_block_proposer`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_block_proposer FINAL
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
    FROM cbt.fct_block_proposer FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **proposer_validator_index** | `UInt32` | *The validator index of the proposer for the slot* |
| **proposer_pubkey** | `String` | *The public key of the validator proposer* |
| **block_root** | `Nullable(String)` | *The beacon block root hash. Null if a block was never seen by a sentry, aka "missed"* |
| **status** | `LowCardinality(String)` | *Can be "canonical", "orphaned" or "missed"* |

## fct_block_proposer_entity

Block proposer entity for the unfinalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_proposer_entity`
- **sepolia**: `sepolia.fct_block_proposer_entity`
- **holesky**: `holesky.fct_block_proposer_entity`
- **hoodi**: `hoodi.fct_block_proposer_entity`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_block_proposer_entity FINAL
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
    FROM cbt.fct_block_proposer_entity FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **entity** | `Nullable(String)` | *The entity that proposed the block* |

## fct_block_proposer_head

Block proposers for the unfinalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_proposer_head`
- **sepolia**: `sepolia.fct_block_proposer_head`
- **holesky**: `holesky.fct_block_proposer_head`
- **hoodi**: `hoodi.fct_block_proposer_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_block_proposer_head FINAL
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
    FROM cbt.fct_block_proposer_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **proposer_validator_index** | `UInt32` | *The validator index of the proposer for the slot* |
| **proposer_pubkey** | `String` | *The public key of the validator proposer* |
| **block_root** | `Nullable(String)` | *The beacon block root hash. Null if a block was never seen by a sentry* |

## fct_mev_bid_count_by_builder

Total number of MEV builder bids for a slot

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_mev_bid_count_by_builder`
- **sepolia**: `sepolia.fct_mev_bid_count_by_builder`
- **holesky**: `holesky.fct_mev_bid_count_by_builder`
- **hoodi**: `hoodi.fct_mev_bid_count_by_builder`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_mev_bid_count_by_builder FINAL
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
    FROM cbt.fct_mev_bid_count_by_builder FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block bid* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the bid is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the bid is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the bid is for* |
| **builder_pubkey** | `String` | *The relay that the bid was fetched from* |
| **bid_total** | `UInt32` | *The total number of bids from the builder* |

## fct_mev_bid_count_by_relay

Total number of MEV relay bids for a slot by relay

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_mev_bid_count_by_relay`
- **sepolia**: `sepolia.fct_mev_bid_count_by_relay`
- **holesky**: `holesky.fct_mev_bid_count_by_relay`
- **hoodi**: `hoodi.fct_mev_bid_count_by_relay`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_mev_bid_count_by_relay FINAL
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
    FROM cbt.fct_mev_bid_count_by_relay FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block bid* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the bid is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the bid is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the bid is for* |
| **relay_name** | `String` | *The relay that the bid was fetched from* |
| **bid_total** | `UInt32` | *The total number of bids for the relay* |

## fct_mev_bid_highest_value_by_builder_chunked_50ms

Highest value bid from each builder per slot broken down by 50ms chunks. Each block_hash appears in the chunk determined by its earliest bid timestamp. Only includes bids within -12000ms to +12000ms of slot start time

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_mev_bid_highest_value_by_builder_chunked_50ms`
- **sepolia**: `sepolia.fct_mev_bid_highest_value_by_builder_chunked_50ms`
- **holesky**: `holesky.fct_mev_bid_highest_value_by_builder_chunked_50ms`
- **hoodi**: `hoodi.fct_mev_bid_highest_value_by_builder_chunked_50ms`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_mev_bid_highest_value_by_builder_chunked_50ms FINAL
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
    FROM cbt.fct_mev_bid_highest_value_by_builder_chunked_50ms FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block bid* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the bid is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the bid is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the bid is for* |
| **chunk_slot_start_diff** | `Int32` | *The difference between the chunk start time and slot_start_date_time. "1500" would mean the earliest bid for this block_hash was between 1500ms and 1550ms into the slot. Negative values indicate bids received before slot start* |
| **earliest_bid_date_time** | `DateTime64(3)` | *The timestamp of the earliest bid for this block_hash from this builder* |
| **relay_names** | `Array(String)` | *The relay that the bid was fetched from* |
| **block_hash** | `FixedString(66)` | *The execution block hash of the bid* |
| **builder_pubkey** | `String` | *The builder pubkey of the bid* |
| **value** | `UInt128` | *The transaction value in wei* |

## fct_node_active_last_24h

Active nodes for the network

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_node_active_last_24h`
- **sepolia**: `sepolia.fct_node_active_last_24h`
- **holesky**: `holesky.fct_node_active_last_24h`
- **hoodi**: `hoodi.fct_node_active_last_24h`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_node_active_last_24h FINAL
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
    FROM cbt.fct_node_active_last_24h FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **last_seen_date_time** | `DateTime` | *Timestamp when the node was last seen* |
| **username** | `String` | *Username of the node* |
| **node_id** | `String` | *ID of the node* |
| **classification** | `String` | *Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation* |

## fct_prepared_block

Prepared block proposals showing what would have been built if the validator had been selected as proposer

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_prepared_block`
- **sepolia**: `sepolia.fct_prepared_block`
- **holesky**: `holesky.fct_prepared_block`
- **hoodi**: `hoodi.fct_prepared_block`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.fct_prepared_block FINAL
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
    FROM cbt.fct_prepared_block FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **event_date_time** | `DateTime` | *The wall clock time when the event was received* |
| **meta_client_name** | `String` | *Name of the client that generated the event* |
| **meta_client_version** | `String` | *Version of the client that generated the event* |
| **meta_client_implementation** | `String` | *Implementation of the client that generated the event* |
| **meta_consensus_implementation** | `String` | *Consensus implementation of the validator* |
| **meta_consensus_version** | `String` | *Consensus version of the validator* |
| **meta_client_geo_city** | `String` | *City of the client that generated the event* |
| **meta_client_geo_country** | `String` | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | `String` | *Country code of the client that generated the event* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **execution_payload_value** | `Nullable(UInt64)` | *The value of the execution payload in wei* |
| **consensus_payload_value** | `Nullable(UInt64)` | *The value of the consensus payload in wei* |
| **execution_payload_block_number** | `UInt32` | *The block number of the execution payload* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |

## int_address_first_access

Table for accounts first access data

### Availability
Data is partitioned by **cityHash64(address) % 16**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_address_first_access`
- **sepolia**: `sepolia.int_address_first_access`
- **holesky**: `holesky.int_address_first_access`
- **hoodi**: `hoodi.int_address_first_access`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_address_first_access FINAL
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
    FROM cbt.int_address_first_access FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **address** | `String` | *The address of the account* |
| **block_number** | `UInt32` | *The block number of the first access* |
| **version** | `UInt32` | *Version for this address, for internal use in clickhouse to keep first access* |

## int_address_last_access

Table for accounts last access data

### Availability
Data is partitioned by **cityHash64(address) % 16**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_address_last_access`
- **sepolia**: `sepolia.int_address_last_access`
- **holesky**: `holesky.int_address_last_access`
- **hoodi**: `hoodi.int_address_last_access`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_address_last_access FINAL
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
    FROM cbt.int_address_last_access FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **address** | `String` | *The address of the account* |
| **block_number** | `UInt32` | *The block number of the last access* |

## int_address_storage_slot_first_access

Table for storage first access data

### Availability
Data is partitioned by **cityHash64(address) % 16**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_address_storage_slot_first_access`
- **sepolia**: `sepolia.int_address_storage_slot_first_access`
- **holesky**: `holesky.int_address_storage_slot_first_access`
- **hoodi**: `hoodi.int_address_storage_slot_first_access`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_address_storage_slot_first_access FINAL
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
    FROM cbt.int_address_storage_slot_first_access FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **address** | `String` | *The address of the account* |
| **slot_key** | `String` | *The slot key of the storage* |
| **block_number** | `UInt32` | *The block number of the first access* |
| **value** | `String` | *The value of the storage* |
| **version** | `UInt32` | *Version for this address + slot key, for internal use in clickhouse to keep first access* |

## int_address_storage_slot_last_access

Table for storage last access data

### Availability
Data is partitioned by **cityHash64(address) % 16**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_address_storage_slot_last_access`
- **sepolia**: `sepolia.int_address_storage_slot_last_access`
- **holesky**: `holesky.int_address_storage_slot_last_access`
- **hoodi**: `hoodi.int_address_storage_slot_last_access`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_address_storage_slot_last_access FINAL
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
    FROM cbt.int_address_storage_slot_last_access FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **address** | `String` | *The address of the account* |
| **slot_key** | `String` | *The slot key of the storage* |
| **block_number** | `UInt32` | *The block number of the last access* |
| **value** | `String` | *The value of the storage* |

## int_attestation_attested_canonical

Attested head of a block for the unfinalized chain.

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_attestation_attested_canonical`
- **sepolia**: `sepolia.int_attestation_attested_canonical`
- **holesky**: `holesky.int_attestation_attested_canonical`
- **hoodi**: `hoodi.int_attestation_attested_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_attestation_attested_canonical FINAL
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
    FROM cbt.int_attestation_attested_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **source_epoch** | `UInt32` | *The source epoch number in the attestation group* |
| **source_epoch_start_date_time** | `DateTime` | *The wall clock time when the source epoch started* |
| **source_root** | `FixedString(66)` | *The source beacon block root hash in the attestation group* |
| **target_epoch** | `UInt32` | *The target epoch number in the attestation group* |
| **target_epoch_start_date_time** | `DateTime` | *The wall clock time when the target epoch started* |
| **target_root** | `FixedString(66)` | *The target beacon block root hash in the attestation group* |
| **block_root** | `String` | *The beacon block root hash* |
| **attesting_validator_index** | `UInt32` | *The index of the validator attesting* |
| **inclusion_distance** | `UInt32` | *The distance from the slot when the attestation was included* |

## int_attestation_attested_head

Attested head of a block for the unfinalized chain.

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_attestation_attested_head`
- **sepolia**: `sepolia.int_attestation_attested_head`
- **holesky**: `holesky.int_attestation_attested_head`
- **hoodi**: `hoodi.int_attestation_attested_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_attestation_attested_head FINAL
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
    FROM cbt.int_attestation_attested_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **source_epoch** | `UInt32` | *The source epoch number in the attestation group* |
| **source_epoch_start_date_time** | `DateTime` | *The wall clock time when the source epoch started* |
| **source_root** | `FixedString(66)` | *The source beacon block root hash in the attestation group* |
| **target_epoch** | `UInt32` | *The target epoch number in the attestation group* |
| **target_epoch_start_date_time** | `DateTime` | *The wall clock time when the target epoch started* |
| **target_root** | `FixedString(66)` | *The target beacon block root hash in the attestation group* |
| **block_root** | `String` | *The beacon block root hash* |
| **attesting_validator_index** | `UInt32` | *The index of the validator attesting* |
| **propagation_distance** | `UInt32` | *The distance from the slot when the attestation was propagated. 0 means the attestation was propagated within the same slot as its duty was assigned, 1 means the attestation was propagated within the next slot, etc.* |

## int_attestation_first_seen

When the attestation was first seen on the network by a sentry node

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_attestation_first_seen`
- **sepolia**: `sepolia.int_attestation_first_seen`
- **holesky**: `holesky.int_attestation_first_seen`
- **hoodi**: `hoodi.int_attestation_first_seen`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_attestation_first_seen FINAL
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
    FROM cbt.int_attestation_first_seen FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **source** | `LowCardinality(String)` | *Source of the event* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **seen_slot_start_diff** | `UInt32` | *The time from slot start for the client to see the block* |
| **block_root** | `String` | *The beacon block root hash* |
| **attesting_validator_index** | `UInt32` | *The index of the validator attesting* |
| **attesting_validator_committee_index** | `LowCardinality(String)` | *The committee index of the attesting validator* |
| **username** | `LowCardinality(String)` | *Username of the node* |
| **node_id** | `String` | *ID of the node* |
| **classification** | `LowCardinality(String)` | *Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation* |

## int_beacon_committee_head

Beacon committee head for the unfinalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_beacon_committee_head`
- **sepolia**: `sepolia.int_beacon_committee_head`
- **holesky**: `holesky.int_beacon_committee_head`
- **hoodi**: `hoodi.int_beacon_committee_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_beacon_committee_head FINAL
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
    FROM cbt.int_beacon_committee_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **committee_index** | `LowCardinality(String)` | *The committee index in the beacon API committee payload* |
| **validators** | `Array(UInt32)` | *The validator indices in the beacon API committee payload* |

## int_block_blob_count_canonical

Blob count of a block for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_block_blob_count_canonical`
- **sepolia**: `sepolia.int_block_blob_count_canonical`
- **holesky**: `holesky.int_block_blob_count_canonical`
- **hoodi**: `hoodi.int_block_blob_count_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_block_blob_count_canonical FINAL
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
    FROM cbt.int_block_blob_count_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `String` | *The beacon block root hash* |
| **blob_count** | `UInt32` | *The number of blobs in the block* |

## int_block_canonical

Block details for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_block_canonical`
- **sepolia**: `sepolia.int_block_canonical`
- **holesky**: `holesky.int_block_canonical`
- **hoodi**: `hoodi.int_block_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_block_canonical FINAL
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
    FROM cbt.int_block_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the reorg slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **parent_root** | `FixedString(66)` | *The root hash of the parent beacon block* |
| **state_root** | `FixedString(66)` | *The root hash of the beacon state at this block* |
| **proposer_index** | `UInt32` | *The index of the validator that proposed the beacon block* |
| **eth1_data_block_hash** | `FixedString(66)` | *The block hash of the associated execution block* |
| **eth1_data_deposit_root** | `FixedString(66)` | *The root of the deposit tree in the associated execution block* |
| **execution_payload_block_hash** | `FixedString(66)` | *The block hash of the execution payload* |
| **execution_payload_block_number** | `UInt32` | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | `String` | *The recipient of the fee for this execution payload* |
| **execution_payload_base_fee_per_gas** | `Nullable(UInt128)` | *Base fee per gas for execution payload* |
| **execution_payload_blob_gas_used** | `Nullable(UInt64)` | *Gas used for blobs in execution payload* |
| **execution_payload_excess_blob_gas** | `Nullable(UInt64)` | *Excess gas used for blobs in execution payload* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_state_root** | `FixedString(66)` | *The state root of the execution payload* |
| **execution_payload_parent_hash** | `FixedString(66)` | *The parent hash of the execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |
| **execution_payload_transactions_total_bytes_compressed** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload when compressed using snappy* |

## int_block_mev_canonical

MEV relay proposer payload delivered for a block on the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_block_mev_canonical`
- **sepolia**: `sepolia.int_block_mev_canonical`
- **holesky**: `holesky.int_block_mev_canonical`
- **hoodi**: `hoodi.int_block_mev_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_block_mev_canonical FINAL
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
    FROM cbt.int_block_mev_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block proposer payload* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the proposer payload is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the proposer payload is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the proposer payload is for* |
| **block_root** | `String` | *The root hash of the beacon block* |
| **earliest_bid_date_time** | `Nullable(DateTime64(3))` | *The earliest timestamp of the accepted bid in milliseconds* |
| **relay_names** | `Array(String)` | *The relay names that delivered the proposer payload* |
| **parent_hash** | `FixedString(66)` | *The parent hash of the proposer payload* |
| **block_number** | `UInt64` | *The block number of the proposer payload* |
| **block_hash** | `FixedString(66)` | *The block hash of the proposer payload* |
| **builder_pubkey** | `String` | *The builder pubkey of the proposer payload* |
| **proposer_pubkey** | `String` | *The proposer pubkey of the proposer payload* |
| **proposer_fee_recipient** | `FixedString(42)` | *The proposer fee recipient of the proposer payload* |
| **gas_limit** | `UInt64` | *The gas limit of the proposer payload* |
| **gas_used** | `UInt64` | *The gas used of the proposer payload* |
| **value** | `Nullable(UInt128)` | *The transaction value in wei* |
| **transaction_count** | `UInt32` | *The number of transactions in the proposer payload* |

## int_block_proposer_canonical

Block proposers for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_block_proposer_canonical`
- **sepolia**: `sepolia.int_block_proposer_canonical`
- **holesky**: `holesky.int_block_proposer_canonical`
- **hoodi**: `hoodi.int_block_proposer_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM cbt.int_block_proposer_canonical FINAL
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
    FROM cbt.int_block_proposer_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **proposer_validator_index** | `UInt32` | *The validator index of the proposer for the slot* |
| **proposer_pubkey** | `String` | *The public key of the validator proposer* |
| **block_root** | `Nullable(String)` | *The beacon block root hash. Null if a slot was missed* |

<!-- schema_end -->
<!-- schema_end -->
