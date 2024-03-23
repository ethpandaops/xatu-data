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
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Contains beacon API /eth/v1/beacon/states/{state_id}/committees data from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | When the sentry received the event from a beacon node |
| slot | UInt32 | Slot number in the beacon API committee payload |
| slot_start_date_time | DateTime | The wall clock time when the slot started |
| committee_index | LowCardinality(String) | The committee index in the beacon API committee payload |
| validators | Array(UInt32) | The validator indices in the beacon API committee payload |
| epoch | UInt32 | The epoch number in the beacon API committee payload |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |

### beacon_api_eth_v1_events_attestation
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Contains beacon API eventstream "attestation" data from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | When the sentry received the event from a beacon node |
| slot | UInt32 | Slot number in the beacon API event stream payload |
| slot_start_date_time | DateTime | The wall clock time when the slot started |
| propagation_slot_start_diff | UInt32 | The difference between the event_date_time and the slot_start_date_time |
| committee_index | LowCardinality(String) | The committee index in the beacon API event stream payload |
| attesting_validator_index | Nullable(UInt32) | The index of the validator attesting to the event |
| attesting_validator_committee_index | LowCardinality(String) | The committee index of the attesting validator |
| aggregation_bits | String | The aggregation bits of the event in the beacon API event stream payload |
| beacon_block_root | FixedString(66) | The beacon block root hash in the beacon API event stream payload |
| epoch | UInt32 | The epoch number in the beacon API event stream payload |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| source_epoch | UInt32 | The source epoch number in the beacon API event stream payload |
| source_epoch_start_date_time | DateTime | The wall clock time when the source epoch started |
| source_root | FixedString(66) | The source beacon block root hash in the beacon API event stream payload |
| target_epoch | UInt32 | The target epoch number in the beacon API event stream payload |
| target_epoch_start_date_time | DateTime | The wall clock time when the target epoch started |
| target_root | FixedString(66) | The target beacon block root hash in the beacon API event stream payload |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |

### beacon_api_eth_v1_events_blob_sidecar
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Contains beacon API eventstream "blob_sidecar" data from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | When the sentry received the event from a beacon node |
| slot | UInt32 | Slot number in the beacon API event stream payload |
| slot_start_date_time | DateTime | The wall clock time when the slot started |
| propagation_slot_start_diff | UInt32 | The difference between the event_date_time and the slot_start_date_time |
| epoch | UInt32 | The epoch number in the beacon API event stream payload |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| block_root | FixedString(66) | The beacon block root hash in the beacon API event stream payload |
| blob_index | UInt64 | The index of blob sidecar in the beacon API event stream payload |
| kzg_commitment | FixedString(98) | The KZG commitment in the beacon API event stream payload |
| versioned_hash | FixedString(66) | The versioned hash in the beacon API event stream payload |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |

### beacon_api_eth_v1_events_block
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Contains beacon API eventstream "block" data from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | When the sentry received the event from a beacon node |
| slot | UInt32 | Slot number in the beacon API event stream payload |
| slot_start_date_time | DateTime | The wall clock time when the slot started |
| propagation_slot_start_diff | UInt32 | The difference between the event_date_time and the slot_start_date_time |
| block | FixedString(66) | The beacon block root hash in the beacon API event stream payload |
| epoch | UInt32 | The epoch number in the beacon API event stream payload |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| execution_optimistic | Bool | If the attached beacon node is running in execution optimistic mode |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |

### beacon_api_eth_v1_events_chain_reorg
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Contains beacon API eventstream "chain reorg" data from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | When the sentry received the event from a beacon node |
| slot | UInt32 | The slot number of the chain reorg event in the beacon API event stream payload |
| slot_start_date_time | DateTime | The wall clock time when the reorg slot started |
| propagation_slot_start_diff | UInt32 | Difference in slots between when the reorg occurred and when the sentry received the event |
| depth | UInt16 | The depth of the chain reorg in the beacon API event stream payload |
| old_head_block | FixedString(66) | The old head block root hash in the beacon API event stream payload |
| new_head_block | FixedString(66) | The new head block root hash in the beacon API event stream payload |
| old_head_state | FixedString(66) | The old head state root hash in the beacon API event stream payload |
| new_head_state | FixedString(66) | The new head state root hash in the beacon API event stream payload |
| epoch | UInt32 | The epoch number in the beacon API event stream payload |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| execution_optimistic | Bool | Whether the execution of the epoch was optimistic |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |

### beacon_api_eth_v1_events_contribution_and_proof
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Contains beacon API eventstream "contribution and proof" data from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | When the sentry received the event from a beacon node |
| aggregator_index | UInt32 | The validator index of the aggregator in the beacon API event stream payload |
| contribution_slot | UInt32 | The slot number of the contribution in the beacon API event stream payload |
| contribution_slot_start_date_time | DateTime | The wall clock time when the contribution slot started |
| contribution_propagation_slot_start_diff | UInt32 | Difference in slots between when the contribution occurred and when the sentry received the event |
| contribution_beacon_block_root | FixedString(66) | The beacon block root hash in the beacon API event stream payload |
| contribution_subcommittee_index | LowCardinality(String) | The subcommittee index of the contribution in the beacon API event stream payload |
| contribution_aggregation_bits | String | The aggregation bits of the contribution in the beacon API event stream payload |
| contribution_signature | String | The signature of the contribution in the beacon API event stream payload |
| contribution_epoch | UInt32 | The epoch number of the contribution in the beacon API event stream payload |
| contribution_epoch_start_date_time | DateTime | The wall clock time when the contribution epoch started |
| selection_proof | String | The selection proof in the beacon API event stream payload |
| signature | String | The signature in the beacon API event stream payload |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |

### beacon_api_eth_v1_events_finalized_checkpoint
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Contains beacon API eventstream "finalized checkpoint" data from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | When the sentry received the event from a beacon node |
| block | FixedString(66) | The finalized block root hash in the beacon API event stream payload |
| state | FixedString(66) | The finalized state root hash in the beacon API event stream payload |
| epoch | UInt32 | The epoch number in the beacon API event stream payload |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| execution_optimistic | Bool | Whether the execution of the epoch was optimistic |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |

### beacon_api_eth_v1_events_head
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Contains beacon API eventstream "head" data from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | When the sentry received the event from a beacon node |
| slot | UInt32 | Slot number in the beacon API event stream payload |
| slot_start_date_time | DateTime | The wall clock time when the slot started |
| propagation_slot_start_diff | UInt32 | The difference between the event_date_time and the slot_start_date_time |
| block | FixedString(66) | The beacon block root hash in the beacon API event stream payload |
| epoch | UInt32 | The epoch number in the beacon API event stream payload |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| epoch_transition | Bool | If the event is an epoch transition |
| execution_optimistic | Bool | If the attached beacon node is running in execution optimistic mode |
| previous_duty_dependent_root | FixedString(66) | The previous duty dependent root in the beacon API event stream payload |
| current_duty_dependent_root | FixedString(66) | The current duty dependent root in the beacon API event stream payload |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |

### beacon_api_eth_v1_events_voluntary_exit
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Contains beacon API eventstream "voluntary exit" data from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | When the sentry received the event from a beacon node |
| epoch | UInt32 | The epoch number in the beacon API event stream payload |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| validator_index | UInt32 | The index of the validator making the voluntary exit |
| signature | String | The signature of the voluntary exit in the beacon API event stream payload |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |

### beacon_api_eth_v1_validator_attestation_data
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Contains beacon API /eth/v1/validator/attestation_data data from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | When the sentry received the event from a beacon node |
| slot | UInt32 | Slot number in the beacon API validator attestation data payload |
| slot_start_date_time | DateTime | The wall clock time when the slot started |
| committee_index | LowCardinality(String) | The committee index in the beacon API validator attestation data payload |
| beacon_block_root | FixedString(66) | The beacon block root hash in the beacon API validator attestation data payload |
| epoch | UInt32 | The epoch number in the beacon API validator attestation data payload |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| source_epoch | UInt32 | The source epoch number in the beacon API validator attestation data payload |
| source_epoch_start_date_time | DateTime | The wall clock time when the source epoch started |
| source_root | FixedString(66) | The source beacon block root hash in the beacon API validator attestation data payload |
| target_epoch | UInt32 | The target epoch number in the beacon API validator attestation data payload |
| target_epoch_start_date_time | DateTime | The wall clock time when the target epoch started |
| target_root | FixedString(66) | The target beacon block root hash in the beacon API validator attestation data payload |
| request_date_time | DateTime | When the request was sent to the beacon node |
| request_duration | UInt32 | The request duration in milliseconds |
| request_slot_start_diff | UInt32 | The difference between the request_date_time and the slot_start_date_time |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |

### beacon_api_eth_v2_beacon_block
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Contains beacon API /eth/v2/beacon/blocks/{block_id} data from each sentry client attached to a beacon node.
Contains beacon API /eth/v2/beacon/blocks/{block_id} data from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | When the sentry fetched the beacon block from a beacon node |
| slot | UInt32 | The slot number from beacon block payload |
| slot_start_date_time | DateTime | The wall clock time when the reorg slot started |
| epoch | UInt32 | The epoch number from beacon block payload |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| block_root | FixedString(66) | The root hash of the beacon block |
| block_version | LowCardinality(String) | The version of the beacon block |
| block_total_bytes | Nullable(UInt32) | The total bytes of the beacon block payload |
| block_total_bytes_compressed | Nullable(UInt32) | The total bytes of the beacon block payload when compressed using snappy |
| parent_root | FixedString(66) | The root hash of the parent beacon block |
| state_root | FixedString(66) | The root hash of the beacon state at this block |
| proposer_index | UInt32 | The index of the validator that proposed the beacon block |
| eth1_data_block_hash | FixedString(66) | The block hash of the associated execution block |
| eth1_data_deposit_root | FixedString(66) | The root of the deposit tree in the associated execution block |
| execution_payload_block_hash | FixedString(66) | The block hash of the execution payload |
| execution_payload_block_number | UInt32 | The block number of the execution payload |
| execution_payload_fee_recipient | String | The recipient of the fee for this execution payload |
| execution_payload_state_root | FixedString(66) | The state root of the execution payload |
| execution_payload_parent_hash | FixedString(66) | The parent hash of the execution payload |
| execution_payload_transactions_count | Nullable(UInt32) | The transaction count of the execution payload |
| execution_payload_transactions_total_bytes | Nullable(UInt32) | The transaction total bytes of the execution payload |
| execution_payload_transactions_total_bytes_compressed | Nullable(UInt32) | The transaction total bytes of the execution payload when compressed using snappy |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_execution_fork_id_hash | LowCardinality(String) |  |
| meta_execution_fork_id_next | LowCardinality(String) |  |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |
| event_date_time | DateTime64(3) | When the sentry fetched the beacon block from a beacon node |
| slot | UInt32 | The slot number from beacon block payload |
| slot_start_date_time | DateTime | The wall clock time when the reorg slot started |
| epoch | UInt32 | The epoch number from beacon block payload |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| block_root | FixedString(66) | The root hash of the beacon block |
| parent_root | FixedString(66) | The root hash of the parent beacon block |
| state_root | FixedString(66) | The root hash of the beacon state at this block |
| proposer_index | UInt32 | The index of the validator that proposed the beacon block |
| eth1_data_block_hash | FixedString(66) | The block hash of the associated execution block |
| eth1_data_deposit_root | FixedString(66) | The root of the deposit tree in the associated execution block |
| execution_payload_block_hash | FixedString(66) | The block hash of the execution payload |
| execution_payload_block_number | UInt32 | The block number of the execution payload |
| execution_payload_fee_recipient | String | The recipient of the fee for this execution payload |
| execution_payload_state_root | FixedString(66) | The state root of the execution payload |
| execution_payload_parent_hash | FixedString(66) | The parent hash of the execution payload |
| execution_payload_transactions_count | Nullable(UInt32) | The transaction count of the execution payload |
| execution_payload_transactions_total_bytes | Nullable(UInt32) | The transaction total bytes of the execution payload |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| meta_consensus_version_major | LowCardinality(String) | Ethereum consensus client major version that generated the event |
| meta_consensus_version_minor | LowCardinality(String) | Ethereum consensus client minor version that generated the event |
| meta_consensus_version_patch | LowCardinality(String) | Ethereum consensus client patch version that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_labels | Map(String, String) | Labels associated with the event |

### beacon_api_slot
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Aggregated beacon API slot data. Each row represents a slot from each sentry client attached to a beacon node.

| Column | Type | Description |
|--------|------|-------------|
| slot | UInt32 | Slot number |
| slot_start_date_time | DateTime | The wall clock time when the slot started |
| epoch | UInt32 | Epoch number |
| epoch_start_date_time | DateTime | The wall clock time when the epoch started |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_consensus_implementation | LowCardinality(String) | Ethereum consensus client implementation that generated the event |
| meta_consensus_version | LowCardinality(String) | Ethereum consensus client version that generated the event |
| blocks | AggregateFunction(sum, UInt16) | The number of beacon blocks seen in the slot |
| attestations | AggregateFunction(sum, UInt32) | The number of attestations seen in the slot |

### mempool_transaction
{{< badge >}} mainnet {{< /badge >}} {{< badge >}} holesky {{< /badge >}} {{< badge >}} sepolia {{< /badge >}} 

> Each row represents a transaction that was seen in the mempool by a sentry client. Sentries can report the same transaction multiple times if it has been long enough since the last report.

| Column | Type | Description |
|--------|------|-------------|
| event_date_time | DateTime64(3) | The time when the sentry saw the transaction in the mempool |
| hash | FixedString(66) | The hash of the transaction |
| from | FixedString(42) | The address of the account that sent the transaction |
| to | Nullable(FixedString(42)) | The address of the account that is the transaction recipient |
| nonce | UInt64 | The nonce of the sender account at the time of the transaction |
| gas_price | UInt128 | The gas price of the transaction in wei |
| gas | UInt64 | The maximum gas provided for the transaction execution |
| gas_tip_cap | Nullable(UInt128) | The priority fee (tip) the user has set for the transaction |
| gas_fee_cap | Nullable(UInt128) | The max fee the user has set for the transaction |
| value | UInt128 | The value transferred with the transaction in wei |
| type | Nullable(UInt8) | The type of the transaction |
| size | UInt32 | The size of the transaction data in bytes |
| call_data_size | UInt32 | The size of the call data of the transaction in bytes |
| blob_gas | Nullable(UInt64) | The maximum gas provided for the blob transaction execution |
| blob_gas_fee_cap | Nullable(UInt128) | The max fee the user has set for the transaction |
| blob_hashes | Array(String) | The hashes of the blob commitments for blob transactions |
| blob_sidecars_size | Nullable(UInt32) | The total size of the sidecars for blob transactions in bytes |
| blob_sidecars_empty_size | Nullable(UInt32) | The total empty size of the sidecars for blob transactions in bytes |
| meta_client_name | LowCardinality(String) | Name of the client that generated the event |
| meta_client_id | String | Unique Session ID of the client that generated the event. This changes every time the client is restarted. |
| meta_client_version | LowCardinality(String) | Version of the client that generated the event |
| meta_client_implementation | LowCardinality(String) | Implementation of the client that generated the event |
| meta_client_os | LowCardinality(String) | Operating system of the client that generated the event |
| meta_client_ip | Nullable(IPv6) | IP address of the client that generated the event |
| meta_client_geo_city | LowCardinality(String) | City of the client that generated the event |
| meta_client_geo_country | LowCardinality(String) | Country of the client that generated the event |
| meta_client_geo_country_code | LowCardinality(String) | Country code of the client that generated the event |
| meta_client_geo_continent_code | LowCardinality(String) | Continent code of the client that generated the event |
| meta_client_geo_longitude | Nullable(Float64) | Longitude of the client that generated the event |
| meta_client_geo_latitude | Nullable(Float64) | Latitude of the client that generated the event |
| meta_client_geo_autonomous_system_number | Nullable(UInt32) | Autonomous system number of the client that generated the event |
| meta_client_geo_autonomous_system_organization | Nullable(String) | Autonomous system organization of the client that generated the event |
| meta_network_id | Int32 | Ethereum network ID |
| meta_network_name | LowCardinality(String) | Ethereum network name |
| meta_execution_fork_id_hash | LowCardinality(String) | The hash of the fork ID of the current Ethereum network |
| meta_execution_fork_id_next | LowCardinality(String) | The fork ID of the next planned Ethereum network upgrade |
| meta_labels | Map(String, String) | Labels associated with the event |

## Credits

John Smith
