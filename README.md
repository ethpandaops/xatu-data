# xatu-data

## Table of contents
- [How to use](#how-to-use)
- [Schema](#schema)
  - [beacon_api_eth_v1_events_head](#beacon_api_eth_v1_events_head)
  - [beacon_api_eth_v1_events_block](#beacon_api_eth_v1_events_block)
- [Credits](#credits)

## How to use

xyz



## Schema
### beacon_api_eth_v1_events_head

> This is table1

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

> This is table1

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

## Credits

John Smith
