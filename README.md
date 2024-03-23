## Table of contents

- [How to use](#how-to-use)
- [Schema](#schema)
  - [beacon_api_eth_v1_beacon_committee](#beacon_api_eth_v1_beacon_committee)
  - [beacon_api_eth_v1_events_attestation](#beacon_api_eth_v1_events_attestation)
  - [beacon_api_eth_v1_events_blob_sidecar](#beacon_api_eth_v1_events_blob_sidecar)
  - [beacon_api_eth_v1_events_block](#beacon_api_eth_v1_events_block)
  - [beacon_api_eth_v1_events_chain_reorg](#beacon_api_eth_v1_events_chain_reorg)
  - [beacon_api_eth_v1_events_contribution_and_proof](#beacon_api_eth_v1_events_contribution_and_proof)
  - [beacon_api_eth_v1_events_finalized_checkpoint](#beacon_api_eth_v1_events_finalized_checkpoint)
  - [beacon_api_eth_v1_events_head](#beacon_api_eth_v1_events_head)
  - [beacon_api_eth_v1_events_voluntary_exit](#beacon_api_eth_v1_events_voluntary_exit)
  - [beacon_api_eth_v1_validator_attestation_data](#beacon_api_eth_v1_validator_attestation_data)
  - [beacon_api_eth_v2_beacon_block](#beacon_api_eth_v2_beacon_block)
  - [beacon_api_slot](#beacon_api_slot)
  - [mempool_transaction](#mempool_transaction)
- [Credits](#credits)

## How to use

{{< badge >}} 🌍 Public{{< /badge >}}

## Schema

### beacon_api_eth_v1_beacon_committee

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API /eth/v1/beacon/states/{state_id}/committees data from each sentry client attached to a beacon node. {{< /lead >}}

| Column                                             | Type                          | Description                                                                                                  |
| -------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `sql DateTime64(3) `          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `sql UInt32 `                 | _Slot number in the beacon API committee payload_                                                            |
| **slot_start_date_time**                           | `sql DateTime `               | _The wall clock time when the slot started_                                                                  |
| **committee_index**                                | `sql LowCardinality(String) ` | _The committee index in the beacon API committee payload_                                                    |
| **validators**                                     | `sql Array(UInt32) `          | _The validator indices in the beacon API committee payload_                                                  |
| **epoch**                                          | `sql UInt32 `                 | _The epoch number in the beacon API committee payload_                                                       |
| **epoch_start_date_time**                          | `sql DateTime `               | _The wall clock time when the epoch started_                                                                 |
| **meta_client_name**                               | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_attestation

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "attestation" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column                                             | Type                          | Description                                                                                                  |
| -------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `sql DateTime64(3) `          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `sql UInt32 `                 | _Slot number in the beacon API event stream payload_                                                         |
| **slot_start_date_time**                           | `sql DateTime `               | _The wall clock time when the slot started_                                                                  |
| **propagation_slot_start_diff**                    | `sql UInt32 `                 | _The difference between the event_date_time and the slot_start_date_time_                                    |
| **committee_index**                                | `sql LowCardinality(String) ` | _The committee index in the beacon API event stream payload_                                                 |
| **attesting_validator_index**                      | `sql Nullable(UInt32) `       | _The index of the validator attesting to the event_                                                          |
| **attesting_validator_committee_index**            | `sql LowCardinality(String) ` | _The committee index of the attesting validator_                                                             |
| **aggregation_bits**                               | `sql String `                 | _The aggregation bits of the event in the beacon API event stream payload_                                   |
| **beacon_block_root**                              | `sql FixedString(66) `        | _The beacon block root hash in the beacon API event stream payload_                                          |
| **epoch**                                          | `sql UInt32 `                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `sql DateTime `               | _The wall clock time when the epoch started_                                                                 |
| **source_epoch**                                   | `sql UInt32 `                 | _The source epoch number in the beacon API event stream payload_                                             |
| **source_epoch_start_date_time**                   | `sql DateTime `               | _The wall clock time when the source epoch started_                                                          |
| **source_root**                                    | `sql FixedString(66) `        | _The source beacon block root hash in the beacon API event stream payload_                                   |
| **target_epoch**                                   | `sql UInt32 `                 | _The target epoch number in the beacon API event stream payload_                                             |
| **target_epoch_start_date_time**                   | `sql DateTime `               | _The wall clock time when the target epoch started_                                                          |
| **target_root**                                    | `sql FixedString(66) `        | _The target beacon block root hash in the beacon API event stream payload_                                   |
| **meta_client_name**                               | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_blob_sidecar

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "blob_sidecar" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column                                             | Type                          | Description                                                                                                  |
| -------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `sql DateTime64(3) `          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `sql UInt32 `                 | _Slot number in the beacon API event stream payload_                                                         |
| **slot_start_date_time**                           | `sql DateTime `               | _The wall clock time when the slot started_                                                                  |
| **propagation_slot_start_diff**                    | `sql UInt32 `                 | _The difference between the event_date_time and the slot_start_date_time_                                    |
| **epoch**                                          | `sql UInt32 `                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `sql DateTime `               | _The wall clock time when the epoch started_                                                                 |
| **block_root**                                     | `sql FixedString(66) `        | _The beacon block root hash in the beacon API event stream payload_                                          |
| **blob_index**                                     | `sql UInt64 `                 | _The index of blob sidecar in the beacon API event stream payload_                                           |
| **kzg_commitment**                                 | `sql FixedString(98) `        | _The KZG commitment in the beacon API event stream payload_                                                  |
| **versioned_hash**                                 | `sql FixedString(66) `        | _The versioned hash in the beacon API event stream payload_                                                  |
| **meta_client_name**                               | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_block

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "block" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column                                             | Type                          | Description                                                                                                  |
| -------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `sql DateTime64(3) `          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `sql UInt32 `                 | _Slot number in the beacon API event stream payload_                                                         |
| **slot_start_date_time**                           | `sql DateTime `               | _The wall clock time when the slot started_                                                                  |
| **propagation_slot_start_diff**                    | `sql UInt32 `                 | _The difference between the event_date_time and the slot_start_date_time_                                    |
| **block**                                          | `sql FixedString(66) `        | _The beacon block root hash in the beacon API event stream payload_                                          |
| **epoch**                                          | `sql UInt32 `                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `sql DateTime `               | _The wall clock time when the epoch started_                                                                 |
| **execution_optimistic**                           | `sql Bool `                   | _If the attached beacon node is running in execution optimistic mode_                                        |
| **meta_client_name**                               | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_chain_reorg

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "chain reorg" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column                                             | Type                          | Description                                                                                                  |
| -------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `sql DateTime64(3) `          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `sql UInt32 `                 | _The slot number of the chain reorg event in the beacon API event stream payload_                            |
| **slot_start_date_time**                           | `sql DateTime `               | _The wall clock time when the reorg slot started_                                                            |
| **propagation_slot_start_diff**                    | `sql UInt32 `                 | _Difference in slots between when the reorg occurred and when the sentry received the event_                 |
| **depth**                                          | `sql UInt16 `                 | _The depth of the chain reorg in the beacon API event stream payload_                                        |
| **old_head_block**                                 | `sql FixedString(66) `        | _The old head block root hash in the beacon API event stream payload_                                        |
| **new_head_block**                                 | `sql FixedString(66) `        | _The new head block root hash in the beacon API event stream payload_                                        |
| **old_head_state**                                 | `sql FixedString(66) `        | _The old head state root hash in the beacon API event stream payload_                                        |
| **new_head_state**                                 | `sql FixedString(66) `        | _The new head state root hash in the beacon API event stream payload_                                        |
| **epoch**                                          | `sql UInt32 `                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `sql DateTime `               | _The wall clock time when the epoch started_                                                                 |
| **execution_optimistic**                           | `sql Bool `                   | _Whether the execution of the epoch was optimistic_                                                          |
| **meta_client_name**                               | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_contribution_and_proof

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "contribution and proof" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column                                             | Type                          | Description                                                                                                  |
| -------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `sql DateTime64(3) `          | _When the sentry received the event from a beacon node_                                                      |
| **aggregator_index**                               | `sql UInt32 `                 | _The validator index of the aggregator in the beacon API event stream payload_                               |
| **contribution_slot**                              | `sql UInt32 `                 | _The slot number of the contribution in the beacon API event stream payload_                                 |
| **contribution_slot_start_date_time**              | `sql DateTime `               | _The wall clock time when the contribution slot started_                                                     |
| **contribution_propagation_slot_start_diff**       | `sql UInt32 `                 | _Difference in slots between when the contribution occurred and when the sentry received the event_          |
| **contribution_beacon_block_root**                 | `sql FixedString(66) `        | _The beacon block root hash in the beacon API event stream payload_                                          |
| **contribution_subcommittee_index**                | `sql LowCardinality(String) ` | _The subcommittee index of the contribution in the beacon API event stream payload_                          |
| **contribution_aggregation_bits**                  | `sql String `                 | _The aggregation bits of the contribution in the beacon API event stream payload_                            |
| **contribution_signature**                         | `sql String `                 | _The signature of the contribution in the beacon API event stream payload_                                   |
| **contribution_epoch**                             | `sql UInt32 `                 | _The epoch number of the contribution in the beacon API event stream payload_                                |
| **contribution_epoch_start_date_time**             | `sql DateTime `               | _The wall clock time when the contribution epoch started_                                                    |
| **selection_proof**                                | `sql String `                 | _The selection proof in the beacon API event stream payload_                                                 |
| **signature**                                      | `sql String `                 | _The signature in the beacon API event stream payload_                                                       |
| **meta_client_name**                               | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_finalized_checkpoint

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "finalized checkpoint" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column                                             | Type                          | Description                                                                                                  |
| -------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `sql DateTime64(3) `          | _When the sentry received the event from a beacon node_                                                      |
| **block**                                          | `sql FixedString(66) `        | _The finalized block root hash in the beacon API event stream payload_                                       |
| **state**                                          | `sql FixedString(66) `        | _The finalized state root hash in the beacon API event stream payload_                                       |
| **epoch**                                          | `sql UInt32 `                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `sql DateTime `               | _The wall clock time when the epoch started_                                                                 |
| **execution_optimistic**                           | `sql Bool `                   | _Whether the execution of the epoch was optimistic_                                                          |
| **meta_client_name**                               | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_head

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "head" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column                                             | Type                          | Description                                                                                                  |
| -------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `sql DateTime64(3) `          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `sql UInt32 `                 | _Slot number in the beacon API event stream payload_                                                         |
| **slot_start_date_time**                           | `sql DateTime `               | _The wall clock time when the slot started_                                                                  |
| **propagation_slot_start_diff**                    | `sql UInt32 `                 | _The difference between the event_date_time and the slot_start_date_time_                                    |
| **block**                                          | `sql FixedString(66) `        | _The beacon block root hash in the beacon API event stream payload_                                          |
| **epoch**                                          | `sql UInt32 `                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `sql DateTime `               | _The wall clock time when the epoch started_                                                                 |
| **epoch_transition**                               | `sql Bool `                   | _If the event is an epoch transition_                                                                        |
| **execution_optimistic**                           | `sql Bool `                   | _If the attached beacon node is running in execution optimistic mode_                                        |
| **previous_duty_dependent_root**                   | `sql FixedString(66) `        | _The previous duty dependent root in the beacon API event stream payload_                                    |
| **current_duty_dependent_root**                    | `sql FixedString(66) `        | _The current duty dependent root in the beacon API event stream payload_                                     |
| **meta_client_name**                               | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_events_voluntary_exit

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "voluntary exit" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column                                             | Type                          | Description                                                                                                  |
| -------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `sql DateTime64(3) `          | _When the sentry received the event from a beacon node_                                                      |
| **epoch**                                          | `sql UInt32 `                 | _The epoch number in the beacon API event stream payload_                                                    |
| **epoch_start_date_time**                          | `sql DateTime `               | _The wall clock time when the epoch started_                                                                 |
| **validator_index**                                | `sql UInt32 `                 | _The index of the validator making the voluntary exit_                                                       |
| **signature**                                      | `sql String `                 | _The signature of the voluntary exit in the beacon API event stream payload_                                 |
| **meta_client_name**                               | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v1_validator_attestation_data

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API /eth/v1/validator/attestation_data data from each sentry client attached to a beacon node. {{< /lead >}}

| Column                                             | Type                          | Description                                                                                                  |
| -------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `sql DateTime64(3) `          | _When the sentry received the event from a beacon node_                                                      |
| **slot**                                           | `sql UInt32 `                 | _Slot number in the beacon API validator attestation data payload_                                           |
| **slot_start_date_time**                           | `sql DateTime `               | _The wall clock time when the slot started_                                                                  |
| **committee_index**                                | `sql LowCardinality(String) ` | _The committee index in the beacon API validator attestation data payload_                                   |
| **beacon_block_root**                              | `sql FixedString(66) `        | _The beacon block root hash in the beacon API validator attestation data payload_                            |
| **epoch**                                          | `sql UInt32 `                 | _The epoch number in the beacon API validator attestation data payload_                                      |
| **epoch_start_date_time**                          | `sql DateTime `               | _The wall clock time when the epoch started_                                                                 |
| **source_epoch**                                   | `sql UInt32 `                 | _The source epoch number in the beacon API validator attestation data payload_                               |
| **source_epoch_start_date_time**                   | `sql DateTime `               | _The wall clock time when the source epoch started_                                                          |
| **source_root**                                    | `sql FixedString(66) `        | _The source beacon block root hash in the beacon API validator attestation data payload_                     |
| **target_epoch**                                   | `sql UInt32 `                 | _The target epoch number in the beacon API validator attestation data payload_                               |
| **target_epoch_start_date_time**                   | `sql DateTime `               | _The wall clock time when the target epoch started_                                                          |
| **target_root**                                    | `sql FixedString(66) `        | _The target beacon block root hash in the beacon API validator attestation data payload_                     |
| **request_date_time**                              | `sql DateTime `               | _When the request was sent to the beacon node_                                                               |
| **request_duration**                               | `sql UInt32 `                 | _The request duration in milliseconds_                                                                       |
| **request_slot_start_diff**                        | `sql UInt32 `                 | _The difference between the request_date_time and the slot_start_date_time_                                  |
| **meta_client_name**                               | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                         | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                   | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                   | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                   | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                  | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                    | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |

### beacon_api_eth_v2_beacon_block

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API /eth/v2/beacon/blocks/{block_id} data from each sentry client attached to a beacon node.
Contains beacon API /eth/v2/beacon/blocks/{block_id} data from each sentry client attached to a beacon node. {{< /lead >}}

| Column                                                    | Type                          | Description                                                                                                  |
| --------------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                       | `sql DateTime64(3) `          | _When the sentry fetched the beacon block from a beacon node_                                                |
| **slot**                                                  | `sql UInt32 `                 | _The slot number from beacon block payload_                                                                  |
| **slot_start_date_time**                                  | `sql DateTime `               | _The wall clock time when the reorg slot started_                                                            |
| **epoch**                                                 | `sql UInt32 `                 | _The epoch number from beacon block payload_                                                                 |
| **epoch_start_date_time**                                 | `sql DateTime `               | _The wall clock time when the epoch started_                                                                 |
| **block_root**                                            | `sql FixedString(66) `        | _The root hash of the beacon block_                                                                          |
| **block_version**                                         | `sql LowCardinality(String) ` | _The version of the beacon block_                                                                            |
| **block_total_bytes**                                     | `sql Nullable(UInt32) `       | _The total bytes of the beacon block payload_                                                                |
| **block_total_bytes_compressed**                          | `sql Nullable(UInt32) `       | _The total bytes of the beacon block payload when compressed using snappy_                                   |
| **parent_root**                                           | `sql FixedString(66) `        | _The root hash of the parent beacon block_                                                                   |
| **state_root**                                            | `sql FixedString(66) `        | _The root hash of the beacon state at this block_                                                            |
| **proposer_index**                                        | `sql UInt32 `                 | _The index of the validator that proposed the beacon block_                                                  |
| **eth1_data_block_hash**                                  | `sql FixedString(66) `        | _The block hash of the associated execution block_                                                           |
| **eth1_data_deposit_root**                                | `sql FixedString(66) `        | _The root of the deposit tree in the associated execution block_                                             |
| **execution_payload_block_hash**                          | `sql FixedString(66) `        | _The block hash of the execution payload_                                                                    |
| **execution_payload_block_number**                        | `sql UInt32 `                 | _The block number of the execution payload_                                                                  |
| **execution_payload_fee_recipient**                       | `sql String `                 | _The recipient of the fee for this execution payload_                                                        |
| **execution_payload_state_root**                          | `sql FixedString(66) `        | _The state root of the execution payload_                                                                    |
| **execution_payload_parent_hash**                         | `sql FixedString(66) `        | _The parent hash of the execution payload_                                                                   |
| **execution_payload_transactions_count**                  | `sql Nullable(UInt32) `       | _The transaction count of the execution payload_                                                             |
| **execution_payload_transactions_total_bytes**            | `sql Nullable(UInt32) `       | _The transaction total bytes of the execution payload_                                                       |
| **execution_payload_transactions_total_bytes_compressed** | `sql Nullable(UInt32) `       | _The transaction total bytes of the execution payload when compressed using snappy_                          |
| **meta_client_name**                                      | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                        | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                                   | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                            | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                        | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                        | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                                  | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                               | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                          | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                        | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                             | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                              | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**              | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization**        | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                       | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                                     | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_execution_fork_id_hash**                           | `sql LowCardinality(String) ` | \*\*                                                                                                         |
| **meta_execution_fork_id_next**                           | `sql LowCardinality(String) ` | \*\*                                                                                                         |
| **meta_consensus_version**                                | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                          | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                          | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                          | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                         | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                           | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |
| **event_date_time**                                       | `sql DateTime64(3) `          | _When the sentry fetched the beacon block from a beacon node_                                                |
| **slot**                                                  | `sql UInt32 `                 | _The slot number from beacon block payload_                                                                  |
| **slot_start_date_time**                                  | `sql DateTime `               | _The wall clock time when the reorg slot started_                                                            |
| **epoch**                                                 | `sql UInt32 `                 | _The epoch number from beacon block payload_                                                                 |
| **epoch_start_date_time**                                 | `sql DateTime `               | _The wall clock time when the epoch started_                                                                 |
| **block_root**                                            | `sql FixedString(66) `        | _The root hash of the beacon block_                                                                          |
| **parent_root**                                           | `sql FixedString(66) `        | _The root hash of the parent beacon block_                                                                   |
| **state_root**                                            | `sql FixedString(66) `        | _The root hash of the beacon state at this block_                                                            |
| **proposer_index**                                        | `sql UInt32 `                 | _The index of the validator that proposed the beacon block_                                                  |
| **eth1_data_block_hash**                                  | `sql FixedString(66) `        | _The block hash of the associated execution block_                                                           |
| **eth1_data_deposit_root**                                | `sql FixedString(66) `        | _The root of the deposit tree in the associated execution block_                                             |
| **execution_payload_block_hash**                          | `sql FixedString(66) `        | _The block hash of the execution payload_                                                                    |
| **execution_payload_block_number**                        | `sql UInt32 `                 | _The block number of the execution payload_                                                                  |
| **execution_payload_fee_recipient**                       | `sql String `                 | _The recipient of the fee for this execution payload_                                                        |
| **execution_payload_state_root**                          | `sql FixedString(66) `        | _The state root of the execution payload_                                                                    |
| **execution_payload_parent_hash**                         | `sql FixedString(66) `        | _The parent hash of the execution payload_                                                                   |
| **execution_payload_transactions_count**                  | `sql Nullable(UInt32) `       | _The transaction count of the execution payload_                                                             |
| **execution_payload_transactions_total_bytes**            | `sql Nullable(UInt32) `       | _The transaction total bytes of the execution payload_                                                       |
| **meta_client_name**                                      | `sql LowCardinality(String) ` | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                        | `sql String `                 | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                                   | `sql LowCardinality(String) ` | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                            | `sql LowCardinality(String) ` | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                        | `sql LowCardinality(String) ` | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                        | `sql Nullable(IPv6) `         | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                                  | `sql LowCardinality(String) ` | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                               | `sql LowCardinality(String) ` | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                          | `sql LowCardinality(String) ` | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                        | `sql LowCardinality(String) ` | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                             | `sql Nullable(Float64) `      | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                              | `sql Nullable(Float64) `      | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**              | `sql Nullable(UInt32) `       | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization**        | `sql Nullable(String) `       | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                       | `sql Int32 `                  | _Ethereum network ID_                                                                                        |
| **meta_network_name**                                     | `sql LowCardinality(String) ` | _Ethereum network name_                                                                                      |
| **meta_consensus_version**                                | `sql LowCardinality(String) ` | _Ethereum consensus client version that generated the event_                                                 |
| **meta_consensus_version_major**                          | `sql LowCardinality(String) ` | _Ethereum consensus client major version that generated the event_                                           |
| **meta_consensus_version_minor**                          | `sql LowCardinality(String) ` | _Ethereum consensus client minor version that generated the event_                                           |
| **meta_consensus_version_patch**                          | `sql LowCardinality(String) ` | _Ethereum consensus client patch version that generated the event_                                           |
| **meta_consensus_implementation**                         | `sql LowCardinality(String) ` | _Ethereum consensus client implementation that generated the event_                                          |
| **meta_labels**                                           | `sql Map(String, String) `    | _Labels associated with the event_                                                                           |

### beacon_api_slot

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Aggregated beacon API slot data. Each row represents a slot from each sentry client attached to a beacon node. {{< /lead >}}

| Column                             | Type                                  | Description                                                         |
| ---------------------------------- | ------------------------------------- | ------------------------------------------------------------------- |
| **slot**                           | `sql UInt32 `                         | _Slot number_                                                       |
| **slot_start_date_time**           | `sql DateTime `                       | _The wall clock time when the slot started_                         |
| **epoch**                          | `sql UInt32 `                         | _Epoch number_                                                      |
| **epoch_start_date_time**          | `sql DateTime `                       | _The wall clock time when the epoch started_                        |
| **meta_client_name**               | `sql LowCardinality(String) `         | _Name of the client that generated the event_                       |
| **meta_network_name**              | `sql LowCardinality(String) `         | _Ethereum network name_                                             |
| **meta_client_geo_city**           | `sql LowCardinality(String) `         | _City of the client that generated the event_                       |
| **meta_client_geo_continent_code** | `sql LowCardinality(String) `         | _Continent code of the client that generated the event_             |
| **meta_client_geo_longitude**      | `sql Nullable(Float64) `              | _Longitude of the client that generated the event_                  |
| **meta_client_geo_latitude**       | `sql Nullable(Float64) `              | _Latitude of the client that generated the event_                   |
| **meta_consensus_implementation**  | `sql LowCardinality(String) `         | _Ethereum consensus client implementation that generated the event_ |
| **meta_consensus_version**         | `sql LowCardinality(String) `         | _Ethereum consensus client version that generated the event_        |
| **blocks**                         | `sql AggregateFunction(sum, UInt16) ` | _The number of beacon blocks seen in the slot_                      |
| **attestations**                   | `sql AggregateFunction(sum, UInt32) ` | _The number of attestations seen in the slot_                       |

### mempool_transaction

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Each row represents a transaction that was seen in the mempool by a sentry client. Sentries can report the same transaction multiple times if it has been long enough since the last report. {{< /lead >}}

| Column                                             | Type                             | Description                                                                                                  |
| -------------------------------------------------- | -------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **event_date_time**                                | `sql DateTime64(3) `             | _The time when the sentry saw the transaction in the mempool_                                                |
| **hash**                                           | `sql FixedString(66) `           | _The hash of the transaction_                                                                                |
| **from**                                           | `sql FixedString(42) `           | _The address of the account that sent the transaction_                                                       |
| **to**                                             | `sql Nullable(FixedString(42)) ` | _The address of the account that is the transaction recipient_                                               |
| **nonce**                                          | `sql UInt64 `                    | _The nonce of the sender account at the time of the transaction_                                             |
| **gas_price**                                      | `sql UInt128 `                   | _The gas price of the transaction in wei_                                                                    |
| **gas**                                            | `sql UInt64 `                    | _The maximum gas provided for the transaction execution_                                                     |
| **gas_tip_cap**                                    | `sql Nullable(UInt128) `         | _The priority fee (tip) the user has set for the transaction_                                                |
| **gas_fee_cap**                                    | `sql Nullable(UInt128) `         | _The max fee the user has set for the transaction_                                                           |
| **value**                                          | `sql UInt128 `                   | _The value transferred with the transaction in wei_                                                          |
| **type**                                           | `sql Nullable(UInt8) `           | _The type of the transaction_                                                                                |
| **size**                                           | `sql UInt32 `                    | _The size of the transaction data in bytes_                                                                  |
| **call_data_size**                                 | `sql UInt32 `                    | _The size of the call data of the transaction in bytes_                                                      |
| **blob_gas**                                       | `sql Nullable(UInt64) `          | _The maximum gas provided for the blob transaction execution_                                                |
| **blob_gas_fee_cap**                               | `sql Nullable(UInt128) `         | _The max fee the user has set for the transaction_                                                           |
| **blob_hashes**                                    | `sql Array(String) `             | _The hashes of the blob commitments for blob transactions_                                                   |
| **blob_sidecars_size**                             | `sql Nullable(UInt32) `          | _The total size of the sidecars for blob transactions in bytes_                                              |
| **blob_sidecars_empty_size**                       | `sql Nullable(UInt32) `          | _The total empty size of the sidecars for blob transactions in bytes_                                        |
| **meta_client_name**                               | `sql LowCardinality(String) `    | _Name of the client that generated the event_                                                                |
| **meta_client_id**                                 | `sql String `                    | _Unique Session ID of the client that generated the event. This changes every time the client is restarted._ |
| **meta_client_version**                            | `sql LowCardinality(String) `    | _Version of the client that generated the event_                                                             |
| **meta_client_implementation**                     | `sql LowCardinality(String) `    | _Implementation of the client that generated the event_                                                      |
| **meta_client_os**                                 | `sql LowCardinality(String) `    | _Operating system of the client that generated the event_                                                    |
| **meta_client_ip**                                 | `sql Nullable(IPv6) `            | _IP address of the client that generated the event_                                                          |
| **meta_client_geo_city**                           | `sql LowCardinality(String) `    | _City of the client that generated the event_                                                                |
| **meta_client_geo_country**                        | `sql LowCardinality(String) `    | _Country of the client that generated the event_                                                             |
| **meta_client_geo_country_code**                   | `sql LowCardinality(String) `    | _Country code of the client that generated the event_                                                        |
| **meta_client_geo_continent_code**                 | `sql LowCardinality(String) `    | _Continent code of the client that generated the event_                                                      |
| **meta_client_geo_longitude**                      | `sql Nullable(Float64) `         | _Longitude of the client that generated the event_                                                           |
| **meta_client_geo_latitude**                       | `sql Nullable(Float64) `         | _Latitude of the client that generated the event_                                                            |
| **meta_client_geo_autonomous_system_number**       | `sql Nullable(UInt32) `          | _Autonomous system number of the client that generated the event_                                            |
| **meta_client_geo_autonomous_system_organization** | `sql Nullable(String) `          | _Autonomous system organization of the client that generated the event_                                      |
| **meta_network_id**                                | `sql Int32 `                     | _Ethereum network ID_                                                                                        |
| **meta_network_name**                              | `sql LowCardinality(String) `    | _Ethereum network name_                                                                                      |
| **meta_execution_fork_id_hash**                    | `sql LowCardinality(String) `    | _The hash of the fork ID of the current Ethereum network_                                                    |
| **meta_execution_fork_id_next**                    | `sql LowCardinality(String) `    | _The fork ID of the next planned Ethereum network upgrade_                                                   |
| **meta_labels**                                    | `sql Map(String, String) `       | _Labels associated with the event_                                                                           |

## Credits

John Smith
