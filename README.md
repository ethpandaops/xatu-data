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

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry received the event from a beacon node* |
| **slot** | {{< badge >}} UInt32 {{< /badge >}} | *Slot number in the beacon API committee payload* |
| **slot_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the slot started* |
| **committee_index** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *The committee index in the beacon API committee payload* |
| **validators** | {{< badge >}} Array(UInt32) {{< /badge >}} | *The validator indices in the beacon API committee payload* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number in the beacon API committee payload* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

### beacon_api_eth_v1_events_attestation

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "attestation" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry received the event from a beacon node* |
| **slot** | {{< badge >}} UInt32 {{< /badge >}} | *Slot number in the beacon API event stream payload* |
| **slot_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the slot started* |
| **propagation_slot_start_diff** | {{< badge >}} UInt32 {{< /badge >}} | *The difference between the event_date_time and the slot_start_date_time* |
| **committee_index** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *The committee index in the beacon API event stream payload* |
| **attesting_validator_index** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *The index of the validator attesting to the event* |
| **attesting_validator_committee_index** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *The committee index of the attesting validator* |
| **aggregation_bits** | {{< badge >}} String {{< /badge >}} | *The aggregation bits of the event in the beacon API event stream payload* |
| **beacon_block_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The beacon block root hash in the beacon API event stream payload* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **source_epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The source epoch number in the beacon API event stream payload* |
| **source_epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the source epoch started* |
| **source_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The source beacon block root hash in the beacon API event stream payload* |
| **target_epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The target epoch number in the beacon API event stream payload* |
| **target_epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the target epoch started* |
| **target_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The target beacon block root hash in the beacon API event stream payload* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

### beacon_api_eth_v1_events_blob_sidecar

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "blob_sidecar" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry received the event from a beacon node* |
| **slot** | {{< badge >}} UInt32 {{< /badge >}} | *Slot number in the beacon API event stream payload* |
| **slot_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the slot started* |
| **propagation_slot_start_diff** | {{< badge >}} UInt32 {{< /badge >}} | *The difference between the event_date_time and the slot_start_date_time* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **block_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The beacon block root hash in the beacon API event stream payload* |
| **blob_index** | {{< badge >}} UInt64 {{< /badge >}} | *The index of blob sidecar in the beacon API event stream payload* |
| **kzg_commitment** | {{< badge >}} FixedString(98) {{< /badge >}} | *The KZG commitment in the beacon API event stream payload* |
| **versioned_hash** | {{< badge >}} FixedString(66) {{< /badge >}} | *The versioned hash in the beacon API event stream payload* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

### beacon_api_eth_v1_events_block

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "block" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry received the event from a beacon node* |
| **slot** | {{< badge >}} UInt32 {{< /badge >}} | *Slot number in the beacon API event stream payload* |
| **slot_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the slot started* |
| **propagation_slot_start_diff** | {{< badge >}} UInt32 {{< /badge >}} | *The difference between the event_date_time and the slot_start_date_time* |
| **block** | {{< badge >}} FixedString(66) {{< /badge >}} | *The beacon block root hash in the beacon API event stream payload* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **execution_optimistic** | {{< badge >}} Bool {{< /badge >}} | *If the attached beacon node is running in execution optimistic mode* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

### beacon_api_eth_v1_events_chain_reorg

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "chain reorg" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry received the event from a beacon node* |
| **slot** | {{< badge >}} UInt32 {{< /badge >}} | *The slot number of the chain reorg event in the beacon API event stream payload* |
| **slot_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the reorg slot started* |
| **propagation_slot_start_diff** | {{< badge >}} UInt32 {{< /badge >}} | *Difference in slots between when the reorg occurred and when the sentry received the event* |
| **depth** | {{< badge >}} UInt16 {{< /badge >}} | *The depth of the chain reorg in the beacon API event stream payload* |
| **old_head_block** | {{< badge >}} FixedString(66) {{< /badge >}} | *The old head block root hash in the beacon API event stream payload* |
| **new_head_block** | {{< badge >}} FixedString(66) {{< /badge >}} | *The new head block root hash in the beacon API event stream payload* |
| **old_head_state** | {{< badge >}} FixedString(66) {{< /badge >}} | *The old head state root hash in the beacon API event stream payload* |
| **new_head_state** | {{< badge >}} FixedString(66) {{< /badge >}} | *The new head state root hash in the beacon API event stream payload* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **execution_optimistic** | {{< badge >}} Bool {{< /badge >}} | *Whether the execution of the epoch was optimistic* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

### beacon_api_eth_v1_events_contribution_and_proof

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "contribution and proof" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry received the event from a beacon node* |
| **aggregator_index** | {{< badge >}} UInt32 {{< /badge >}} | *The validator index of the aggregator in the beacon API event stream payload* |
| **contribution_slot** | {{< badge >}} UInt32 {{< /badge >}} | *The slot number of the contribution in the beacon API event stream payload* |
| **contribution_slot_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the contribution slot started* |
| **contribution_propagation_slot_start_diff** | {{< badge >}} UInt32 {{< /badge >}} | *Difference in slots between when the contribution occurred and when the sentry received the event* |
| **contribution_beacon_block_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The beacon block root hash in the beacon API event stream payload* |
| **contribution_subcommittee_index** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *The subcommittee index of the contribution in the beacon API event stream payload* |
| **contribution_aggregation_bits** | {{< badge >}} String {{< /badge >}} | *The aggregation bits of the contribution in the beacon API event stream payload* |
| **contribution_signature** | {{< badge >}} String {{< /badge >}} | *The signature of the contribution in the beacon API event stream payload* |
| **contribution_epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number of the contribution in the beacon API event stream payload* |
| **contribution_epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the contribution epoch started* |
| **selection_proof** | {{< badge >}} String {{< /badge >}} | *The selection proof in the beacon API event stream payload* |
| **signature** | {{< badge >}} String {{< /badge >}} | *The signature in the beacon API event stream payload* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

### beacon_api_eth_v1_events_finalized_checkpoint

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "finalized checkpoint" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry received the event from a beacon node* |
| **block** | {{< badge >}} FixedString(66) {{< /badge >}} | *The finalized block root hash in the beacon API event stream payload* |
| **state** | {{< badge >}} FixedString(66) {{< /badge >}} | *The finalized state root hash in the beacon API event stream payload* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **execution_optimistic** | {{< badge >}} Bool {{< /badge >}} | *Whether the execution of the epoch was optimistic* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

### beacon_api_eth_v1_events_head

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "head" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry received the event from a beacon node* |
| **slot** | {{< badge >}} UInt32 {{< /badge >}} | *Slot number in the beacon API event stream payload* |
| **slot_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the slot started* |
| **propagation_slot_start_diff** | {{< badge >}} UInt32 {{< /badge >}} | *The difference between the event_date_time and the slot_start_date_time* |
| **block** | {{< badge >}} FixedString(66) {{< /badge >}} | *The beacon block root hash in the beacon API event stream payload* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **epoch_transition** | {{< badge >}} Bool {{< /badge >}} | *If the event is an epoch transition* |
| **execution_optimistic** | {{< badge >}} Bool {{< /badge >}} | *If the attached beacon node is running in execution optimistic mode* |
| **previous_duty_dependent_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The previous duty dependent root in the beacon API event stream payload* |
| **current_duty_dependent_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The current duty dependent root in the beacon API event stream payload* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

### beacon_api_eth_v1_events_voluntary_exit

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API eventstream "voluntary exit" data from each sentry client attached to a beacon node. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry received the event from a beacon node* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number in the beacon API event stream payload* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **validator_index** | {{< badge >}} UInt32 {{< /badge >}} | *The index of the validator making the voluntary exit* |
| **signature** | {{< badge >}} String {{< /badge >}} | *The signature of the voluntary exit in the beacon API event stream payload* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

### beacon_api_eth_v1_validator_attestation_data

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API /eth/v1/validator/attestation_data data from each sentry client attached to a beacon node. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry received the event from a beacon node* |
| **slot** | {{< badge >}} UInt32 {{< /badge >}} | *Slot number in the beacon API validator attestation data payload* |
| **slot_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the slot started* |
| **committee_index** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *The committee index in the beacon API validator attestation data payload* |
| **beacon_block_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The beacon block root hash in the beacon API validator attestation data payload* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number in the beacon API validator attestation data payload* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **source_epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The source epoch number in the beacon API validator attestation data payload* |
| **source_epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the source epoch started* |
| **source_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The source beacon block root hash in the beacon API validator attestation data payload* |
| **target_epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The target epoch number in the beacon API validator attestation data payload* |
| **target_epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the target epoch started* |
| **target_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The target beacon block root hash in the beacon API validator attestation data payload* |
| **request_date_time** | {{< badge >}} DateTime {{< /badge >}} | *When the request was sent to the beacon node* |
| **request_duration** | {{< badge >}} UInt32 {{< /badge >}} | *The request duration in milliseconds* |
| **request_slot_start_diff** | {{< badge >}} UInt32 {{< /badge >}} | *The difference between the request_date_time and the slot_start_date_time* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

### beacon_api_eth_v2_beacon_block

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Contains beacon API /eth/v2/beacon/blocks/{block_id} data from each sentry client attached to a beacon node.
Contains beacon API /eth/v2/beacon/blocks/{block_id} data from each sentry client attached to a beacon node. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry fetched the beacon block from a beacon node* |
| **slot** | {{< badge >}} UInt32 {{< /badge >}} | *The slot number from beacon block payload* |
| **slot_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the reorg slot started* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **block_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The root hash of the beacon block* |
| **block_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *The version of the beacon block* |
| **block_total_bytes** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *The total bytes of the beacon block payload when compressed using snappy* |
| **parent_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The root hash of the parent beacon block* |
| **state_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The root hash of the beacon state at this block* |
| **proposer_index** | {{< badge >}} UInt32 {{< /badge >}} | *The index of the validator that proposed the beacon block* |
| **eth1_data_block_hash** | {{< badge >}} FixedString(66) {{< /badge >}} | *The block hash of the associated execution block* |
| **eth1_data_deposit_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The root of the deposit tree in the associated execution block* |
| **execution_payload_block_hash** | {{< badge >}} FixedString(66) {{< /badge >}} | *The block hash of the execution payload* |
| **execution_payload_block_number** | {{< badge >}} UInt32 {{< /badge >}} | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | {{< badge >}} String {{< /badge >}} | *The recipient of the fee for this execution payload* |
| **execution_payload_state_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The state root of the execution payload* |
| **execution_payload_parent_hash** | {{< badge >}} FixedString(66) {{< /badge >}} | *The parent hash of the execution payload* |
| **execution_payload_transactions_count** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *The transaction total bytes of the execution payload* |
| **execution_payload_transactions_total_bytes_compressed** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *The transaction total bytes of the execution payload when compressed using snappy* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_execution_fork_id_hash** | {{< badge >}} LowCardinality(String) {{< /badge >}} | ** |
| **meta_execution_fork_id_next** | {{< badge >}} LowCardinality(String) {{< /badge >}} | ** |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *When the sentry fetched the beacon block from a beacon node* |
| **slot** | {{< badge >}} UInt32 {{< /badge >}} | *The slot number from beacon block payload* |
| **slot_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the reorg slot started* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **block_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The root hash of the beacon block* |
| **parent_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The root hash of the parent beacon block* |
| **state_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The root hash of the beacon state at this block* |
| **proposer_index** | {{< badge >}} UInt32 {{< /badge >}} | *The index of the validator that proposed the beacon block* |
| **eth1_data_block_hash** | {{< badge >}} FixedString(66) {{< /badge >}} | *The block hash of the associated execution block* |
| **eth1_data_deposit_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The root of the deposit tree in the associated execution block* |
| **execution_payload_block_hash** | {{< badge >}} FixedString(66) {{< /badge >}} | *The block hash of the execution payload* |
| **execution_payload_block_number** | {{< badge >}} UInt32 {{< /badge >}} | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | {{< badge >}} String {{< /badge >}} | *The recipient of the fee for this execution payload* |
| **execution_payload_state_root** | {{< badge >}} FixedString(66) {{< /badge >}} | *The state root of the execution payload* |
| **execution_payload_parent_hash** | {{< badge >}} FixedString(66) {{< /badge >}} | *The parent hash of the execution payload* |
| **execution_payload_transactions_count** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *The transaction total bytes of the execution payload* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **meta_consensus_version_major** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client major version that generated the event* |
| **meta_consensus_version_minor** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client minor version that generated the event* |
| **meta_consensus_version_patch** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client patch version that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

### beacon_api_slot

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Aggregated beacon API slot data. Each row represents a slot from each sentry client attached to a beacon node. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **slot** | {{< badge >}} UInt32 {{< /badge >}} | *Slot number* |
| **slot_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the slot started* |
| **epoch** | {{< badge >}} UInt32 {{< /badge >}} | *Epoch number* |
| **epoch_start_date_time** | {{< badge >}} DateTime {{< /badge >}} | *The wall clock time when the epoch started* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_consensus_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client implementation that generated the event* |
| **meta_consensus_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum consensus client version that generated the event* |
| **blocks** | {{< badge >}} AggregateFunction(sum, UInt16) {{< /badge >}} | *The number of beacon blocks seen in the slot* |
| **attestations** | {{< badge >}} AggregateFunction(sum, UInt32) {{< /badge >}} | *The number of attestations seen in the slot* |

### mempool_transaction

{{< keywordList >}}
{{< keyword >}} mainnet {{< /keyword >}}{{< keyword >}} holesky {{< /keyword >}}{{< keyword >}} sepolia {{< /keyword >}}
{{< /keywordList >}}

{{< lead >}} Each row represents a transaction that was seen in the mempool by a sentry client. Sentries can report the same transaction multiple times if it has been long enough since the last report. {{< /lead >}}

| Column | Type | Description |
|--------|------|-------------|
| **event_date_time** | {{< badge >}} DateTime64(3) {{< /badge >}} | *The time when the sentry saw the transaction in the mempool* |
| **hash** | {{< badge >}} FixedString(66) {{< /badge >}} | *The hash of the transaction* |
| **from** | {{< badge >}} FixedString(42) {{< /badge >}} | *The address of the account that sent the transaction* |
| **to** | {{< badge >}} Nullable(FixedString(42)) {{< /badge >}} | *The address of the account that is the transaction recipient* |
| **nonce** | {{< badge >}} UInt64 {{< /badge >}} | *The nonce of the sender account at the time of the transaction* |
| **gas_price** | {{< badge >}} UInt128 {{< /badge >}} | *The gas price of the transaction in wei* |
| **gas** | {{< badge >}} UInt64 {{< /badge >}} | *The maximum gas provided for the transaction execution* |
| **gas_tip_cap** | {{< badge >}} Nullable(UInt128) {{< /badge >}} | *The priority fee (tip) the user has set for the transaction* |
| **gas_fee_cap** | {{< badge >}} Nullable(UInt128) {{< /badge >}} | *The max fee the user has set for the transaction* |
| **value** | {{< badge >}} UInt128 {{< /badge >}} | *The value transferred with the transaction in wei* |
| **type** | {{< badge >}} Nullable(UInt8) {{< /badge >}} | *The type of the transaction* |
| **size** | {{< badge >}} UInt32 {{< /badge >}} | *The size of the transaction data in bytes* |
| **call_data_size** | {{< badge >}} UInt32 {{< /badge >}} | *The size of the call data of the transaction in bytes* |
| **blob_gas** | {{< badge >}} Nullable(UInt64) {{< /badge >}} | *The maximum gas provided for the blob transaction execution* |
| **blob_gas_fee_cap** | {{< badge >}} Nullable(UInt128) {{< /badge >}} | *The max fee the user has set for the transaction* |
| **blob_hashes** | {{< badge >}} Array(String) {{< /badge >}} | *The hashes of the blob commitments for blob transactions* |
| **blob_sidecars_size** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *The total size of the sidecars for blob transactions in bytes* |
| **blob_sidecars_empty_size** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *The total empty size of the sidecars for blob transactions in bytes* |
| **meta_client_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Name of the client that generated the event* |
| **meta_client_id** | {{< badge >}} String {{< /badge >}} | *Unique Session ID of the client that generated the event. This changes every time the client is restarted.* |
| **meta_client_version** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Version of the client that generated the event* |
| **meta_client_implementation** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Implementation of the client that generated the event* |
| **meta_client_os** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Operating system of the client that generated the event* |
| **meta_client_ip** | {{< badge >}} Nullable(IPv6) {{< /badge >}} | *IP address of the client that generated the event* |
| **meta_client_geo_city** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *City of the client that generated the event* |
| **meta_client_geo_country** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Continent code of the client that generated the event* |
| **meta_client_geo_longitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Longitude of the client that generated the event* |
| **meta_client_geo_latitude** | {{< badge >}} Nullable(Float64) {{< /badge >}} | *Latitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | {{< badge >}} Nullable(UInt32) {{< /badge >}} | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | {{< badge >}} Nullable(String) {{< /badge >}} | *Autonomous system organization of the client that generated the event* |
| **meta_network_id** | {{< badge >}} Int32 {{< /badge >}} | *Ethereum network ID* |
| **meta_network_name** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *Ethereum network name* |
| **meta_execution_fork_id_hash** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *The hash of the fork ID of the current Ethereum network* |
| **meta_execution_fork_id_next** | {{< badge >}} LowCardinality(String) {{< /badge >}} | *The fork ID of the next planned Ethereum network upgrade* |
| **meta_labels** | {{< badge >}} Map(String, String) {{< /badge >}} | *Labels associated with the event* |

## Credits

John Smith
