{{< alert icon="circle-info" >}}
This **dataset** contains a wealth of information about the **Ethereum network**, including detailed data on **beacon chain** events, **mempool** activity, and **canonical chain** events. Read more in our [announcement post]({{< ref "/posts/open-source-xatu-data" >}} "Announcement post").
{{< /alert >}}
&nbsp;
{{< article link="/posts/open-source-xatu-data/" >}}

<div class="flex gap-1">
  <span class="font-bold text-primary-100">Xatu data is licensed under</span>
  <a href="http://creativecommons.org/licenses/by-nc/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" class="flex gap-1 items-center font-bold"><span>CC BY-NC 4.0</span><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"></a>
</div>

## Table of contents

<div class="bg-neutral-500/10 rounded-xl py-4 px-2 text-base sm:text-lg md:text-xl">

- [Working with the data](#working-with-the-data)
  - [Setup clickhouse locally to import and query the data](#setup-clickhouse-locally-to-import-and-query-the-data)
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
  <!-- schema_toc_end -->
- [Issues](#issues)
- [License](#license)
- [Maintainers](#maintainers)

</div>

## Working with the data

Data is stored in the [Apache Parquet](https://parquet.apache.org) format and can be consumed using a variety of tools. Here's some examples of how to query the data using [ClickHouse-local](https://clickhouse.com/docs/en/install);

```bash
# Query the first 10 rows of the beacon_api_eth_v1_events_block table for 2024-03-20
clickhouse-local ---query="$(<< 'EOF'

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
clickhouse-local --query="$(<< 'EOF'

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
2. Import the data you want using the [`clickhouse-client`](https://clickhouse.com/docs/en/interfaces/cli) CLI tool.

```bash
clickhouse-client --query="$(<< 'EOF'

INSERT INTO
  default.beacon_api_eth_v1_events_block
SELECT *
  FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/{10..20}.parquet', 'Parquet');

EOF
)"
```

3. Query the data using the [`clickhouse-client`](https://clickhouse.com/docs/en/interfaces/cli) CLI tool.

```bash
clickhouse-client --query="$(<< 'EOF'

SELECT
  *
FROM
  default.beacon_api_eth_v1_events_block
LIMIT 10

EOF
)"
```

## Schema

<!-- schema_start -->

### beacon_api_eth_v1_beacon_committee

{{< lead >}} Contains beacon API /eth/v1/beacon/states/{state_id}/committees data from each sentry client attached to a beacon node. {{< /lead >}}
{{<alert >}} Sometimes sentries may [publish different committees](https://github.com/ethpandaops/xatu/issues/288) for the same epoch. {{< /alert >}}

#### Availability

Data is available **hourly** on the following networks;

- **mainnet**: `2023-12-24 03:00:00` to `NOW() - INTERVAL '1 DAY'`
- **holesky**: `2023-12-24 03:00:00` to `NOW() - INTERVAL '1 DAY'`
- **sepolia**: `2023-12-24 03:00:00` to `NOW() - INTERVAL '1 DAY'`
- **goerli**: `2023-12-24 03:00:00` to `2024-03-18 00:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_beacon_committee/YYYY/MM/DD/HH.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_beacon_committee/2024/3/18/00.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                               | Type                     | Description                                                                                                  |
| -------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `DateTime64(3)`          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `UInt32`                 | _Slot number in the beacon API committee payload_                                                            |
| **slot_start_date_time**                           | `DateTime`               | _The wall clock time when the slot started_                                                                  |
| **committee_index**                                | `LowCardinality(String)` | _The committee index in the beacon API committee payload_                                                    |
| **validators**                                     | `Array(UInt32)`          | _The validator indices in the beacon API committee payload_                                                  |
| **epoch**                                          | `UInt32`                 | _The epoch number in the beacon API committee payload_                                                       |
| **epoch_start_date_time**                          | `DateTime`               | _The wall clock time when the epoch started_                                                                 |
| **meta_client_name**                               | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `Map(String, String)`    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_attestation

{{< lead >}} Contains beacon API eventstream "attestation" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability

Data is available **hourly** on the following networks;

- **mainnet**: `2023-06-01 00:00:00` to `NOW() - INTERVAL '1 DAY'`
- **holesky**: `2023-09-18 00:00:00` to `NOW() - INTERVAL '1 DAY'`
- **sepolia**: `2023-08-31 12:00:00` to `NOW() - INTERVAL '1 DAY'`
- **goerli**: `2023-08-31 12:00:00` to `2024-03-18 00:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_attestation/YYYY/MM/DD/HH.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_attestation/2024/3/18/00.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                               | Type                     | Description                                                                                                  |
| -------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `DateTime64(3)`          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `UInt32`                 | _Slot number in the beacon API event stream payload_                                                         |
| **slot_start_date_time**                           | `DateTime`               | _The wall clock time when the slot started_                                                                  |
| **propagation_slot_start_diff**                    | `UInt32`                 | _The difference between the event_date_time and the slot_start_date_time_                                    |
| **committee_index**                                | `LowCardinality(String)` | _The committee index in the beacon API event stream payload_                                                 |
| **attesting_validator_index**                      | `Nullable(UInt32)`       | _The index of the validator attesting to the event_                                                          |
| **attesting_validator_committee_index**            | `LowCardinality(String)` | _The committee index of the attesting validator_                                                             |
| **aggregation_bits**                               | `String`                 | _The aggregation bits of the event in the beacon API event stream payload_                                   |
| **beacon_block_root**                              | `FixedString(66)`        | _The beacon block root hash in the beacon API event stream payload_                                          |
| **epoch**                                          | `UInt32`                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `DateTime`               | _The wall clock time when the epoch started_                                                                 |
| **source_epoch**                                   | `UInt32`                 | _The source epoch number in the beacon API event stream payload_                                             |
| **source_epoch_start_date_time**                   | `DateTime`               | _The wall clock time when the source epoch started_                                                          |
| **source_root**                                    | `FixedString(66)`        | _The source beacon block root hash in the beacon API event stream payload_                                   |
| **target_epoch**                                   | `UInt32`                 | _The target epoch number in the beacon API event stream payload_                                             |
| **target_epoch_start_date_time**                   | `DateTime`               | _The wall clock time when the target epoch started_                                                          |
| **target_root**                                    | `FixedString(66)`        | _The target beacon block root hash in the beacon API event stream payload_                                   |
| **meta_client_name**                               | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `Map(String, String)`    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_blob_sidecar

{{< lead >}} Contains beacon API eventstream "blob_sidecar" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability

Data is available **daily** on the following networks;

- **mainnet**: `2024-03-13 13:00:00` to `NOW() - INTERVAL '1 DAY'`
- **holesky**: `2024-02-07 11:00:00` to `NOW() - INTERVAL '1 DAY'`
- **sepolia**: `2024-01-30 22:00:00` to `NOW() - INTERVAL '1 DAY'`
- **goerli**: `2024-01-17 06:00:00` to `2024-03-18 00:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_blob_sidecar/YYYY/MM/DD.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_blob_sidecar/2024/3/18.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                               | Type                     | Description                                                                                                  |
| -------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `DateTime64(3)`          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `UInt32`                 | _Slot number in the beacon API event stream payload_                                                         |
| **slot_start_date_time**                           | `DateTime`               | _The wall clock time when the slot started_                                                                  |
| **propagation_slot_start_diff**                    | `UInt32`                 | _The difference between the event_date_time and the slot_start_date_time_                                    |
| **epoch**                                          | `UInt32`                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `DateTime`               | _The wall clock time when the epoch started_                                                                 |
| **block_root**                                     | `FixedString(66)`        | _The beacon block root hash in the beacon API event stream payload_                                          |
| **blob_index**                                     | `UInt64`                 | _The index of blob sidecar in the beacon API event stream payload_                                           |
| **kzg_commitment**                                 | `FixedString(98)`        | _The KZG commitment in the beacon API event stream payload_                                                  |
| **versioned_hash**                                 | `FixedString(66)`        | _The versioned hash in the beacon API event stream payload_                                                  |
| **meta_client_name**                               | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `Map(String, String)`    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_block

{{< lead >}} Contains beacon API eventstream "block" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability

Data is available **daily** on the following networks;

- **mainnet**: `2023-03-01 00:00:00` to `NOW() - INTERVAL '1 DAY'`
- **holesky**: `2023-12-24 00:00:00` to `NOW() - INTERVAL '1 DAY'`
- **sepolia**: `2023-12-24 00:00:00` to `NOW() - INTERVAL '1 DAY'`
- **goerli**: `2023-12-24 00:00:00` to `2024-03-18 00:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_block/YYYY/MM/DD.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/18.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                               | Type                     | Description                                                                                                  |
| -------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `DateTime64(3)`          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `UInt32`                 | _Slot number in the beacon API event stream payload_                                                         |
| **slot_start_date_time**                           | `DateTime`               | _The wall clock time when the slot started_                                                                  |
| **propagation_slot_start_diff**                    | `UInt32`                 | _The difference between the event_date_time and the slot_start_date_time_                                    |
| **block**                                          | `FixedString(66)`        | _The beacon block root hash in the beacon API event stream payload_                                          |
| **epoch**                                          | `UInt32`                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `DateTime`               | _The wall clock time when the epoch started_                                                                 |
| **execution_optimistic**                           | `Bool`                   | _If the attached beacon node is running in execution optimistic mode_                                        |
| **meta_client_name**                               | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `Map(String, String)`    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_chain_reorg

{{< lead >}} Contains beacon API eventstream "chain reorg" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability

Data is available **daily** on the following networks;

- **mainnet**: `2023-03-01 02:00:00` to `NOW() - INTERVAL '1 DAY'`
- **holesky**: `2024-02-05 02:00:00` to `NOW() - INTERVAL '1 DAY'`
- **sepolia**: `2023-12-30 10:00:00` to `NOW() - INTERVAL '1 DAY'`
- **goerli**: `2023-12-24 04:00:00` to `2024-03-18 00:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_chain_reorg/YYYY/MM/DD.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_chain_reorg/2024/3/18.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                               | Type                     | Description                                                                                                  |
| -------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `DateTime64(3)`          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `UInt32`                 | _The slot number of the chain reorg event in the beacon API event stream payload_                            |
| **slot_start_date_time**                           | `DateTime`               | _The wall clock time when the reorg slot started_                                                            |
| **propagation_slot_start_diff**                    | `UInt32`                 | _Difference in slots between when the reorg occurred and when the sentry received the event_                 |
| **depth**                                          | `UInt16`                 | _The depth of the chain reorg in the beacon API event stream payload_                                        |
| **old_head_block**                                 | `FixedString(66)`        | _The old head block root hash in the beacon API event stream payload_                                        |
| **new_head_block**                                 | `FixedString(66)`        | _The new head block root hash in the beacon API event stream payload_                                        |
| **old_head_state**                                 | `FixedString(66)`        | _The old head state root hash in the beacon API event stream payload_                                        |
| **new_head_state**                                 | `FixedString(66)`        | _The new head state root hash in the beacon API event stream payload_                                        |
| **epoch**                                          | `UInt32`                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `DateTime`               | _The wall clock time when the epoch started_                                                                 |
| **execution_optimistic**                           | `Bool`                   | _Whether the execution of the epoch was optimistic_                                                          |
| **meta_client_name**                               | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `Map(String, String)`    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_contribution_and_proof

{{< lead >}} Contains beacon API eventstream "contribution and proof" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability

Data is available **daily** on the following networks;

- **mainnet**: `2023-08-31 04:00:00` to `NOW() - INTERVAL '1 DAY'`
- **holesky**: `2023-12-24 04:00:00` to `NOW() - INTERVAL '1 DAY'`
- **sepolia**: `2023-12-24 04:00:00` to `NOW() - INTERVAL '1 DAY'`
- **goerli**: `2023-12-24 04:00:00` to `2024-03-18 00:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_contribution_and_proof/YYYY/MM/DD.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_contribution_and_proof/2024/3/18.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                               | Type                     | Description                                                                                                  |
| -------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `DateTime64(3)`          | _When the sentry received the event from a beacon node_                                                      |
| **aggregator_index**                               | `UInt32`                 | _The validator index of the aggregator in the beacon API event stream payload_                               |
| **contribution_slot**                              | `UInt32`                 | _The slot number of the contribution in the beacon API event stream payload_                                 |
| **contribution_slot_start_date_time**              | `DateTime`               | _The wall clock time when the contribution slot started_                                                     |
| **contribution_propagation_slot_start_diff**       | `UInt32`                 | _Difference in slots between when the contribution occurred and when the sentry received the event_          |
| **contribution_beacon_block_root**                 | `FixedString(66)`        | _The beacon block root hash in the beacon API event stream payload_                                          |
| **contribution_subcommittee_index**                | `LowCardinality(String)` | _The subcommittee index of the contribution in the beacon API event stream payload_                          |
| **contribution_aggregation_bits**                  | `String`                 | _The aggregation bits of the contribution in the beacon API event stream payload_                            |
| **contribution_signature**                         | `String`                 | _The signature of the contribution in the beacon API event stream payload_                                   |
| **contribution_epoch**                             | `UInt32`                 | _The epoch number of the contribution in the beacon API event stream payload_                                |
| **contribution_epoch_start_date_time**             | `DateTime`               | _The wall clock time when the contribution epoch started_                                                    |
| **selection_proof**                                | `String`                 | _The selection proof in the beacon API event stream payload_                                                 |
| **signature**                                      | `String`                 | _The signature in the beacon API event stream payload_                                                       |
| **meta_client_name**                               | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `Map(String, String)`    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_finalized_checkpoint

{{< lead >}} Contains beacon API eventstream "finalized checkpoint" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability

Data is available **daily** on the following networks;

- **mainnet**: `2023-08-31 23:00:00` to `NOW() - INTERVAL '1 DAY'`
- **holesky**: `2023-12-24 03:00:00` to `NOW() - INTERVAL '1 DAY'`
- **sepolia**: `2023-12-24 03:00:00` to `NOW() - INTERVAL '1 DAY'`
- **goerli**: `2023-12-24 03:00:00` to `2024-03-18 00:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_finalized_checkpoint/YYYY/MM/DD.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_finalized_checkpoint/2024/3/18.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                               | Type                     | Description                                                                                                  |
| -------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `DateTime64(3)`          | _When the sentry received the event from a beacon node_                                                      |
| **block**                                          | `FixedString(66)`        | _The finalized block root hash in the beacon API event stream payload_                                       |
| **state**                                          | `FixedString(66)`        | _The finalized state root hash in the beacon API event stream payload_                                       |
| **epoch**                                          | `UInt32`                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `DateTime`               | _The wall clock time when the epoch started_                                                                 |
| **execution_optimistic**                           | `Bool`                   | _Whether the execution of the epoch was optimistic_                                                          |
| **meta_client_name**                               | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `Map(String, String)`    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_head

{{< lead >}} Contains beacon API eventstream "head" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability

Data is available **daily** on the following networks;

- **mainnet**: `2023-08-30 19:00:00` to `NOW() - INTERVAL '1 DAY'`
- **holesky**: `2023-12-05 00:00:00` to `NOW() - INTERVAL '1 DAY'`
- **sepolia**: `2023-12-05 00:00:00` to `NOW() - INTERVAL '1 DAY'`
- **goerli**: `2023-12-05 00:00:00` to `2024-03-18 00:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_head/YYYY/MM/DD.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_head/2024/3/18.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                               | Type                     | Description                                                                                                  |
| -------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `DateTime64(3)`          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `UInt32`                 | _Slot number in the beacon API event stream payload_                                                         |
| **slot_start_date_time**                           | `DateTime`               | _The wall clock time when the slot started_                                                                  |
| **propagation_slot_start_diff**                    | `UInt32`                 | _The difference between the event_date_time and the slot_start_date_time_                                    |
| **block**                                          | `FixedString(66)`        | _The beacon block root hash in the beacon API event stream payload_                                          |
| **epoch**                                          | `UInt32`                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `DateTime`               | _The wall clock time when the epoch started_                                                                 |
| **epoch_transition**                               | `Bool`                   | _If the event is an epoch transition_                                                                        |
| **execution_optimistic**                           | `Bool`                   | _If the attached beacon node is running in execution optimistic mode_                                        |
| **previous_duty_dependent_root**                   | `FixedString(66)`        | _The previous duty dependent root in the beacon API event stream payload_                                    |
| **current_duty_dependent_root**                    | `FixedString(66)`        | _The current duty dependent root in the beacon API event stream payload_                                     |
| **meta_client_name**                               | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `Map(String, String)`    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_voluntary_exit

{{< lead >}} Contains beacon API eventstream "voluntary exit" data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability

Data is available **daily** on the following networks;

- **mainnet**: `2020-12-01 12:00:00` to `2021-01-08 07:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_voluntary_exit/YYYY/MM/DD.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_voluntary_exit/2024/3/18.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                               | Type                     | Description                                                                                                  |
| -------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `DateTime64(3)`          | _When the sentry received the event from a beacon node_                                                      |
| **epoch**                                          | `UInt32`                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `DateTime`               | _The wall clock time when the epoch started_                                                                 |
| **validator_index**                                | `UInt32`                 | _The index of the validator making the voluntary exit_                                                       |
| **signature**                                      | `String`                 | _The signature of the voluntary exit in the beacon API event stream payload_                                 |
| **meta_client_name**                               | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `Map(String, String)`    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_validator_attestation_data

{{< lead >}} Contains beacon API /eth/v1/validator/attestation_data data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability

Data is available **daily** on the following networks;

- **mainnet**: `2023-08-31 04:00:00` to `NOW() - INTERVAL '1 DAY'`
- **holesky**: `2023-12-24 02:00:00` to `NOW() - INTERVAL '1 DAY'`
- **sepolia**: `2023-12-24 02:00:00` to `NOW() - INTERVAL '1 DAY'`
- **goerli**: `2023-12-24 02:00:00` to `2024-03-16 01:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_validator_attestation_data/YYYY/MM/DD.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_validator_attestation_data/2024/3/18.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                               | Type                     | Description                                                                                                  |
| -------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `DateTime64(3)`          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `UInt32`                 | _Slot number in the beacon API validator attestation data payload_                                           |
| **slot_start_date_time**                           | `DateTime`               | _The wall clock time when the slot started_                                                                  |
| **committee_index**                                | `LowCardinality(String)` | _The committee index in the beacon API validator attestation data payload_                                   |
| **beacon_block_root**                              | `FixedString(66)`        | _The beacon block root hash in the beacon API validator attestation data payload_                            |
| **epoch**                                          | `UInt32`                 | _The epoch number in the beacon API validator attestation data payload_                                      |
| **epoch_start_date_time**                          | `DateTime`               | _The wall clock time when the epoch started_                                                                 |
| **source_epoch**                                   | `UInt32`                 | _The source epoch number in the beacon API validator attestation data payload_                               |
| **source_epoch_start_date_time**                   | `DateTime`               | _The wall clock time when the source epoch started_                                                          |
| **source_root**                                    | `FixedString(66)`        | _The source beacon block root hash in the beacon API validator attestation data payload_                     |
| **target_epoch**                                   | `UInt32`                 | _The target epoch number in the beacon API validator attestation data payload_                               |
| **target_epoch_start_date_time**                   | `DateTime`               | _The wall clock time when the target epoch started_                                                          |
| **target_root**                                    | `FixedString(66)`        | _The target beacon block root hash in the beacon API validator attestation data payload_                     |
| **request_date_time**                              | `DateTime`               | _When the request was sent to the beacon node_                                                               |
| **request_duration**                               | `UInt32`                 | _The request duration in milliseconds_                                                                       |
| **request_slot_start_diff**                        | `UInt32`                 | _The difference between the request_date_time and the slot_start_date_time_                                  |
| **meta_client_name**                               | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `Map(String, String)`    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v2_beacon_block

{{< lead >}} Contains beacon API /eth/v2/beacon/blocks/{block_id} data from each sentry client attached to a beacon node.
Contains beacon API /eth/v2/beacon/blocks/{block_id} data from each sentry client attached to a beacon node. {{< /lead >}}

#### Availability

Data is available **daily** on the following networks;

- **mainnet**: `2020-12-01 12:00:00` to `NOW() - INTERVAL '1 DAY'`
- **holesky**: `2023-12-24 03:00:00` to `NOW() - INTERVAL '1 DAY'`
- **sepolia**: `2023-12-24 03:00:00` to `NOW() - INTERVAL '1 DAY'`
- **goerli**: `2023-12-24 03:00:00` to `2024-03-18 00:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v2_beacon_block/YYYY/MM/DD.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v2_beacon_block/2024/3/18.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                                      | Type                     | Description                                                                                                  |
| --------------------------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                       | `DateTime64(3)`          | _When the sentry fetched the beacon block from a beacon node_                                                |
| **slot**                                                  | `UInt32`                 | _The slot number from beacon block payload_                                                                  |
| **slot_start_date_time**                                  | `DateTime`               | _The wall clock time when the reorg slot started_                                                            |
| **epoch**                                                 | `UInt32`                 | _The epoch number from beacon block payload_                                                                 |
| **epoch_start_date_time**                                 | `DateTime`               | _The wall clock time when the epoch started_                                                                 |
| **block_root**                                            | `FixedString(66)`        | _The root hash of the beacon block_                                                                          |
| **block_version**                                         | `LowCardinality(String)` | _The version of the beacon block_                                                                            |
| **block_total_bytes**                                     | `Nullable(UInt32)`       | _The total bytes of the beacon block payload_                                                                |
| **block_total_bytes_compressed**                          | `Nullable(UInt32)`       | _The total bytes of the beacon block payload when compressed using snappy_                                   |
| **parent_root**                                           | `FixedString(66)`        | _The root hash of the parent beacon block_                                                                   |
| **state_root**                                            | `FixedString(66)`        | _The root hash of the beacon state at this block_                                                            |
| **proposer_index**                                        | `UInt32`                 | _The index of the validator that proposed the beacon block_                                                  |
| **eth1_data_block_hash**                                  | `FixedString(66)`        | _The block hash of the associated execution block_                                                           |
| **eth1_data_deposit_root**                                | `FixedString(66)`        | _The root of the deposit tree in the associated execution block_                                             |
| **execution_payload_block_hash**                          | `FixedString(66)`        | _The block hash of the execution payload_                                                                    |
| **execution_payload_block_number**                        | `UInt32`                 | _The block number of the execution payload_                                                                  |
| **execution_payload_fee_recipient**                       | `String`                 | _The recipient of the fee for this execution payload_                                                        |
| **execution_payload_state_root**                          | `FixedString(66)`        | _The state root of the execution payload_                                                                    |
| **execution_payload_parent_hash**                         | `FixedString(66)`        | _The parent hash of the execution payload_                                                                   |
| **execution_payload_transactions_count**                  | `Nullable(UInt32)`       | _The transaction count of the execution payload_                                                             |
| **execution_payload_transactions_total_bytes**            | `Nullable(UInt32)`       | _The transaction total bytes of the execution payload_                                                       |
| **execution_payload_transactions_total_bytes_compressed** | `Nullable(UInt32)`       | _The transaction total bytes of the execution payload when compressed using snappy_                          |
| **meta_client_name**                                      | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                        | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                                   | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                            | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                        | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                        | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                                  | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                               | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                          | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                        | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                             | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                              | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**              | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization**        | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                       | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                                     | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_execution_fork_id_hash**                           | `LowCardinality(String)` | \*\*                                                                                                         |
| **meta_execution_fork_id_next**                           | `LowCardinality(String)` | \*\*                                                                                                         |
| **meta_consensus_version**                                | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                          | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                          | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                          | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                         | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                           | `Map(String, String)`    | _Labels associated with the event_                                                                           |
| **event_date_time**                                       | `DateTime64(3)`          | _When the sentry fetched the beacon block from a beacon node_                                                |
| **slot**                                                  | `UInt32`                 | _The slot number from beacon block payload_                                                                  |
| **slot_start_date_time**                                  | `DateTime`               | _The wall clock time when the reorg slot started_                                                            |
| **epoch**                                                 | `UInt32`                 | _The epoch number from beacon block payload_                                                                 |
| **epoch_start_date_time**                                 | `DateTime`               | _The wall clock time when the epoch started_                                                                 |
| **block_root**                                            | `FixedString(66)`        | _The root hash of the beacon block_                                                                          |
| **parent_root**                                           | `FixedString(66)`        | _The root hash of the parent beacon block_                                                                   |
| **state_root**                                            | `FixedString(66)`        | _The root hash of the beacon state at this block_                                                            |
| **proposer_index**                                        | `UInt32`                 | _The index of the validator that proposed the beacon block_                                                  |
| **eth1_data_block_hash**                                  | `FixedString(66)`        | _The block hash of the associated execution block_                                                           |
| **eth1_data_deposit_root**                                | `FixedString(66)`        | _The root of the deposit tree in the associated execution block_                                             |
| **execution_payload_block_hash**                          | `FixedString(66)`        | _The block hash of the execution payload_                                                                    |
| **execution_payload_block_number**                        | `UInt32`                 | _The block number of the execution payload_                                                                  |
| **execution_payload_fee_recipient**                       | `String`                 | _The recipient of the fee for this execution payload_                                                        |
| **execution_payload_state_root**                          | `FixedString(66)`        | _The state root of the execution payload_                                                                    |
| **execution_payload_parent_hash**                         | `FixedString(66)`        | _The parent hash of the execution payload_                                                                   |
| **execution_payload_transactions_count**                  | `Nullable(UInt32)`       | _The transaction count of the execution payload_                                                             |
| **execution_payload_transactions_total_bytes**            | `Nullable(UInt32)`       | _The transaction total bytes of the execution payload_                                                       |
| **meta_client_name**                                      | `LowCardinality(String)` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                        | `String`                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                                   | `LowCardinality(String)` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                            | `LowCardinality(String)` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                        | `LowCardinality(String)` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                        | `Nullable(IPv6)`         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                                  | `LowCardinality(String)` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                               | `LowCardinality(String)` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                          | `LowCardinality(String)` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                        | `LowCardinality(String)` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                             | `Nullable(Float64)`      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                              | `Nullable(Float64)`      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**              | `Nullable(UInt32)`       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization**        | `Nullable(String)`       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                       | `Int32`                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                                     | `LowCardinality(String)` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                                | `LowCardinality(String)` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                          | `LowCardinality(String)` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                          | `LowCardinality(String)` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                          | `LowCardinality(String)` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                         | `LowCardinality(String)` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                           | `Map(String, String)`    | _Labels associated with the event_                                                                           |

### mempool_transaction

{{< lead >}} Each row represents a transaction that was seen in the mempool by a sentry client. Sentries can report the same transaction multiple times if it has been long enough since the last report. {{< /lead >}}

#### Availability

Data is available **daily** on the following networks;

- **mainnet**: `2023-03-03 03:00:00` to `NOW() - INTERVAL '1 DAY'`
- **holesky**: `2023-12-24 02:00:00` to `NOW() - INTERVAL '1 DAY'`
- **sepolia**: `2023-12-24 02:00:00` to `NOW() - INTERVAL '1 DAY'`
- **goerli**: `2023-12-24 02:00:00` to `2024-03-18 00:00:00`

#### Example

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mempool_transaction/YYYY/MM/DD.parquet

```bash
clickhouse local -q "SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mempool_transaction/2024/3/18.parquet', 'Parquet') LIMIT 10"
```

#### Columns

| Name                                               | Type                        | Description                                                                                                  |
| -------------------------------------------------- | --------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `DateTime64(3)`             | _The time when the sentry saw the transaction in the mempool_                                                |
| **hash**                                           | `FixedString(66)`           | _The hash of the transaction_                                                                                |
| **from**                                           | `FixedString(42)`           | _The address of the account that sent the transaction_                                                       |
| **to**                                             | `Nullable(FixedString(42))` | _The address of the account that is the transaction recipient_                                               |
| **nonce**                                          | `UInt64`                    | _The nonce of the sender account at the time of the transaction_                                             |
| **gas_price**                                      | `UInt128`                   | _The gas price of the transaction in wei_                                                                    |
| **gas**                                            | `UInt64`                    | _The maximum gas provided for the transaction execution_                                                     |
| **gas_tip_cap**                                    | `Nullable(UInt128)`         | _The priority fee (tip) the user has set for the transaction_                                                |
| **gas_fee_cap**                                    | `Nullable(UInt128)`         | _The max fee the user has set for the transaction_                                                           |
| **value**                                          | `UInt128`                   | _The value transferred with the transaction in wei_                                                          |
| **type**                                           | `Nullable(UInt8)`           | _The type of the transaction_                                                                                |
| **size**                                           | `UInt32`                    | _The size of the transaction data in bytes_                                                                  |
| **call_data_size**                                 | `UInt32`                    | _The size of the call data of the transaction in bytes_                                                      |
| **blob_gas**                                       | `Nullable(UInt64)`          | _The maximum gas provided for the blob transaction execution_                                                |
| **blob_gas_fee_cap**                               | `Nullable(UInt128)`         | _The max fee the user has set for the transaction_                                                           |
| **blob_hashes**                                    | `Array(String)`             | _The hashes of the blob commitments for blob transactions_                                                   |
| **blob_sidecars_size**                             | `Nullable(UInt32)`          | _The total size of the sidecars for blob transactions in bytes_                                              |
| **blob_sidecars_empty_size**                       | `Nullable(UInt32)`          | _The total empty size of the sidecars for blob transactions in bytes_                                        |
| **meta_client_name**                               | `LowCardinality(String)`    | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `String`                    | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `LowCardinality(String)`    | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `LowCardinality(String)`    | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `LowCardinality(String)`    | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `Nullable(IPv6)`            | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `LowCardinality(String)`    | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `LowCardinality(String)`    | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `LowCardinality(String)`    | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `LowCardinality(String)`    | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `Nullable(Float64)`         | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `Nullable(Float64)`         | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `Nullable(UInt32)`          | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)`          | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `Int32`                     | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `LowCardinality(String)`    | _Ethereum network name_                                                                                      |
| **meta_execution_fork_id_hash**                    | `LowCardinality(String)`    | _The hash of the fork ID of the current Ethereum network_                                                    |
| **meta_execution_fork_id_next**                    | `LowCardinality(String)`    | _The fork ID of the next planned Ethereum network upgrade_                                                   |
| **meta_labels**                                    | `Map(String, String)`       | _Labels associated with the event_                                                                           |

<!-- schema_end -->

## Issues

{{< github repo="ethpandaops/xatu-data" >}}

## License

- Code: [MIT](./LICENSE)
- Data: [CC BY-NC](https://creativecommons.org/licenses/by-nc/4.0/deed.en)

## Maintainers

Sam - [@samcmau](https://twitter.com/samcmau)

Andrew - [@savid](https://twitter.com/Savid)
