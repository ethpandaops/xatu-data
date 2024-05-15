{{< alert icon="circle-info" >}}
This **dataset** contains a wealth of information about the **Ethereum network**, including detailed data on **beacon chain** events, **mempool** activity, and **canonical chain** events. Read more in our [announcement post]({{< ref "/posts/open-source-xatu-data" >}} "Announcement post").
{{< /alert >}}
&nbsp;
{{< article link="/posts/open-source-xatu-data/" >}}

<div class="flex gap-1">
  <span class="font-bold text-primary-100">Xatu data is licensed under</span>
  <a href="http://creativecommons.org/licenses/by/4.0" target="_blank" rel="license noopener noreferrer" class="flex gap-1 items-center font-bold"><span>CC BY 4.0</span><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"></a>
</div>

## Table of contents

<div class="bg-neutral-500/10 rounded-xl py-4 px-2 text-base sm:text-lg md:text-xl">

- [Working with the data](#working-with-the-data)
  - [Setup clickhouse locally to import and query the data](#setup-clickhouse-locally-to-import-and-query-the-data)
  - [Jupyter Notebooks](#jupyter-notebooks)
- [Schema](#schema)<!-- schema_toc_start -->
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
  - [`mempool_transaction`](#mempool_transaction)
  - [`beacon_api_eth_v1_proposer_duty`](#beacon_api_eth_v1_proposer_duty)
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
- [Issues](#issues)
- [License](#license)
- [Maintainers](#maintainers)

</div>

## Working with the data

Data is stored in the [Apache Parquet](https://parquet.apache.org) format and can be consumed using a variety of tools. Here's some examples of how to query the data using [ClickHouse client](https://clickhouse.com/docs/en/install);

```bash
# Query the first 10 rows of the beacon_api_eth_v1_events_block table for 2024-03-20
clickhouse client ---query="$(<< 'EOF'

SELECT
  *
FROM
  url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/20.parquet', 'Parquet')
LIMIT 10

EOF
)"
```

```bash
# Use globs to query multiple files eg. 15th to 20th March
clickhouse client --query="$(<< 'EOF'

SELECT
  *
FROM
  url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/{15..20}.parquet', 'Parquet')
LIMIT 10

EOF
)"
```

### Setup clickhouse locally to import and query the data

You might want to download data from multiple tables and query the data. You can use our docker compose setup to run ClickHouse locally and have the schema migrations already applied for ease of use.

1. Run xatu [local clickhouse](https://github.com/ethpandaops/xatu?tab=readme-ov-file#local-clickhouse) to stand up a local ClickHouse cluster with the xatu [migrations](https://github.com/ethpandaops/xatu/tree/master/deploy/migrations/clickhouse) automatically applied.
   {{< github repo="ethpandaops/xatu" >}}
2. To import data you have 2 options:

  - Use the [import-clickhouse.sh](https://github.com/ethpandaops/xatu-data/blob/master/import-clickhouse.sh) script. 
```bash
```bash
./import-clickhouse.sh mainnet default beacon_api_eth_v1_events_block 2024-03-20
```

  -  Import the data you want directly using the [`clickhouse client`](https://clickhouse.com/docs/en/interfaces/cli) CLI tool.
```bash
clickhouse client --query="$(<< 'EOF'

INSERT INTO
  default.beacon_api_eth_v1_events_block
SELECT *
  FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/{10..20}.parquet', 'Parquet');

EOF
)"
```

3. Query the data using the [`clickhouse client`](https://clickhouse.com/docs/en/interfaces/cli) CLI tool.

```bash
clickhouse client --query="$(<< 'EOF'

SELECT
  *
FROM
  default.beacon_api_eth_v1_events_block
LIMIT 10

EOF
)"
```

### Jupyter Notebooks

[Example notebook](https://github.com/ethpandaops/xatu-data/blob/master/examples/jupyter-notebooks.ipynb)

## Schema

<!-- schema_start -->
### beacon_api_eth_v1_beacon_committee
{{< lead >}} Contains beacon API /eth/v1/beacon/states/{state_id}/committees data from each sentry client attached to a beacon node. {{< /lead >}}
{{<alert >}} Sometimes sentries may [publish different committees](https://github.com/ethpandaops/xatu/issues/288) for the same epoch. {{< /alert >}}

#### Availability
Data is partitioned **hourly** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-09-05` to `2024-05-13`
- **holesky**: `2023-12-25` to `2024-05-13`
- **sepolia**: `2023-12-24` to `2024-05-13`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_beacon_committee/YYYY/MM/DD/HH.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_beacon_committee/2024/5/8/0.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
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

### beacon_api_eth_v1_events_attestation
{{< lead >}} Contains beacon API eventstream "attestation" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability
Data is partitioned **hourly** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-06-05` to `2024-05-12`
- **holesky**: `2023-09-29` to `2024-05-12`
- **sepolia**: `2023-09-01` to `2024-05-12`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_attestation/YYYY/MM/DD/HH.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_attestation/2024/5/8/0.parquet', 'Parquet') LIMIT 10"
```

#### Columns
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

### beacon_api_eth_v1_events_blob_sidecar
{{< lead >}} Contains beacon API eventstream "blob_sidecar" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-03-13` to `2024-05-12`
- **holesky**: `2024-02-07` to `2024-05-12`
- **sepolia**: `2024-01-30` to `2024-05-12`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_blob_sidecar/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_blob_sidecar/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
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

### beacon_api_eth_v1_events_block
{{< lead >}} Contains beacon API eventstream "block" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-02-28` to `2024-05-12`
- **holesky**: `2023-12-24` to `2024-05-12`
- **sepolia**: `2023-12-24` to `2024-05-12`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_block/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
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

### beacon_api_eth_v1_events_chain_reorg
{{< lead >}} Contains beacon API eventstream "chain reorg" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-03-01` to `2024-05-12`
- **holesky**: `2024-02-05` to `2024-05-12`
- **sepolia**: `2024-05-07` to `2024-05-07`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_chain_reorg/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_chain_reorg/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
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

### beacon_api_eth_v1_events_contribution_and_proof
{{< lead >}} Contains beacon API eventstream "contribution and proof" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **contribution_slot_start_date_time** for the following networks:

- **mainnet**: `2023-08-31` to `2024-05-12`
- **holesky**: `2023-12-24` to `2024-05-12`
- **sepolia**: `2023-12-24` to `2024-05-12`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_contribution_and_proof/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_contribution_and_proof/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
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

### beacon_api_eth_v1_events_finalized_checkpoint
{{< lead >}} Contains beacon API eventstream "finalized checkpoint" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **epoch_start_date_time** for the following networks:

- **mainnet**: `2023-04-10` to `2024-05-12`
- **holesky**: `2023-03-26` to `2024-05-12`
- **sepolia**: `2023-03-26` to `2024-05-12`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_finalized_checkpoint/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_finalized_checkpoint/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
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

### beacon_api_eth_v1_events_head
{{< lead >}} Contains beacon API eventstream "head" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-08-30` to `2024-05-12`
- **holesky**: `2023-12-05` to `2024-05-12`
- **sepolia**: `2023-12-05` to `2024-05-12`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_head/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_head/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
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

### beacon_api_eth_v1_events_voluntary_exit
{{< lead >}} Contains beacon API eventstream "voluntary exit" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **epoch_start_date_time** for the following networks:

- **mainnet**: `2024-01-01` to `2024-03-25`
- **holesky**: `2023-10-01` to `2023-10-05`
- **sepolia**: `Coming soon!` to `Coming soon!`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_voluntary_exit/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_voluntary_exit/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event from a beacon node* |
| **epoch** | `UInt32` | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
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

### beacon_api_eth_v1_validator_attestation_data
{{< lead >}} Contains beacon API validator attestation data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-08-31` to `2024-05-12`
- **holesky**: `2023-12-24` to `2024-05-12`
- **sepolia**: `2023-12-24` to `2024-05-12`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_validator_attestation_data/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_validator_attestation_data/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
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

### beacon_api_eth_v2_beacon_block
{{< lead >}} Contains beacon API /eth/v2/beacon/blocks/{block_id} data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-11-14` to `2024-05-11`
- **holesky**: `2023-12-24` to `2024-05-11`
- **sepolia**: `2023-12-24` to `2024-05-11`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v2_beacon_block/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v2_beacon_block/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
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

### mempool_transaction
{{< lead >}} Each row represents a transaction that was seen in the mempool by a sentry client. Sentries can report the same transaction multiple times if it has been long enough since the last report. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2023-07-22` to `2024-05-13`
- **holesky**: `2024-01-08` to `2024-05-13`
- **sepolia**: `2024-01-08` to `2024-05-13`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mempool_transaction/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mempool_transaction/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique identifier for each record* |
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

### beacon_api_eth_v1_proposer_duty
{{< lead >}} Contains a proposer duty from a beacon block. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-04-03` to `2024-05-11`
- **holesky**: `2024-04-03` to `2024-05-11`
- **sepolia**: `2024-04-03` to `2024-05-11`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_proposer_duty/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_proposer_duty/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique key for the row generated from seahash* |
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

### canonical_beacon_block
{{< lead >}} Contains beacon block from a beacon node. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2024-05-12`
- **holesky**: `2023-09-28` to `2024-05-12`
- **sepolia**: `2022-06-20` to `2024-05-12`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the beacon block from a beacon node* |
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
| **execution_payload_block_hash** | `FixedString(66)` | *The block hash of the execution payload* |
| **execution_payload_block_number** | `UInt32` | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | `String` | *The recipient of the fee for this execution payload* |
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

### canonical_beacon_block_attester_slashing
{{< lead >}} Contains attester slashing from a beacon block. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-04-11` to `2024-04-11`
- **holesky**: `2024-05-10` to `2024-05-11`
- **sepolia**: `Coming soon!` to `Coming soon!`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_attester_slashing/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_attester_slashing/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique key for the row generated from seahash* |
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the beacon block from a beacon node* |
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

### canonical_beacon_block_proposer_slashing
{{< lead >}} Contains proposer slashing from a beacon block. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-04-03` to `2023-04-03`
- **holesky**: `2024-03-26` to `2024-03-26`
- **sepolia**: `Coming soon!` to `Coming soon!`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_proposer_slashing/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_proposer_slashing/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique key for the row generated from seahash* |
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the beacon block from a beacon node* |
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

### canonical_beacon_block_bls_to_execution_change
{{< lead >}} Contains bls to execution change from a beacon block. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-05-06` to `2024-05-12`
- **holesky**: `2024-05-12` to `2024-05-12`
- **sepolia**: `2024-04-08` to `2024-04-08`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_bls_to_execution_change/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_bls_to_execution_change/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique key for the row generated from seahash* |
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the beacon block from a beacon node* |
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

### canonical_beacon_block_execution_transaction
{{< lead >}} Contains execution transaction from a beacon block. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2022-09-15` to `2024-05-12`
- **holesky**: `2023-09-28` to `2024-05-12`
- **sepolia**: `2022-07-06` to `2024-05-12`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_execution_transaction/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_execution_transaction/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique key for the row generated from seahash* |
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the beacon block from a beacon node* |
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

### canonical_beacon_block_voluntary_exit
{{< lead >}} Contains a voluntary exit from a beacon block. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-04-02` to `2024-05-12`
- **holesky**: `2024-02-11` to `2024-05-13`
- **sepolia**: `2024-03-28` to `2024-03-28`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_voluntary_exit/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_voluntary_exit/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique key for the row generated from seahash* |
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the beacon block from a beacon node* |
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

### canonical_beacon_block_deposit
{{< lead >}} Contains a deposit from a beacon block. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2024-05-12`
- **holesky**: `2023-09-29` to `2024-05-12`
- **sepolia**: `2022-07-01` to `2022-07-01`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_deposit/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_deposit/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique key for the row generated from seahash* |
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the beacon block from a beacon node* |
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

### canonical_beacon_block_withdrawal
{{< lead >}} Contains a withdrawal from a beacon block. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-04-12` to `2024-05-13`
- **holesky**: `2023-09-29` to `2024-05-13`
- **sepolia**: `2023-02-28` to `2024-05-13`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_withdrawal/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_withdrawal/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique key for the row generated from seahash* |
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the beacon block from a beacon node* |
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

### canonical_beacon_blob_sidecar
{{< lead >}} Contains a blob sidecar from a beacon block. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-03-13` to `2024-05-13`
- **holesky**: `2024-02-07` to `2024-05-13`
- **sepolia**: `2024-01-30` to `2024-05-13`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_blob_sidecar/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_blob_sidecar/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique key for the row generated from seahash* |
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the beacon block from a beacon node* |
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

### canonical_beacon_proposer_duty
{{< lead >}} Contains a proposer duty from a beacon block. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2024-05-13`
- **holesky**: `2023-09-28` to `2024-05-13`
- **sepolia**: `2022-06-20` to `2024-05-13`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_proposer_duty/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_proposer_duty/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique key for the row* |
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the proposer duty information from a beacon node* |
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

### canonical_beacon_elaborated_attestation
{{< lead >}} Contains elaborated attestations from beacon blocks. {{< /lead >}}

#### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-05-03` to `2024-05-13`
- **holesky**: `2023-09-28` to `2024-05-13`
- **sepolia**: `2023-04-05` to `2024-05-13`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_elaborated_attestation/YYYY/MM/DD.parquet

```bash
clickhouse client -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_elaborated_attestation/2024/5/8.parquet', 'Parquet') LIMIT 10"
```

#### Columns
| Name | Type | Description |
|--------|------|-------------|
| **unique_key** | `Int64` | *Unique key for the row generated from seahash* |
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the client fetched the elaborated attestation from a beacon node* |
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

<!-- schema_end -->

## Issues

{{< github repo="ethpandaops/xatu-data" >}}

## License

- Code: [MIT](./LICENSE)
- Data: [CC BY](https://creativecommons.org/licenses/by/4.0/deed.en)

## Maintainers

Sam - [@samcmau](https://twitter.com/samcmau)

Andrew - [@savid](https://twitter.com/Savid)
