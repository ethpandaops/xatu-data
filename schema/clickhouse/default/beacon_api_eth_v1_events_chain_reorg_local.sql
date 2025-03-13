CREATE TABLE default.beacon_api_eth_v1_events_chain_reorg_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime64(3) COMMENT 'When the sentry received the event from a beacon node',
    `slot` UInt32 COMMENT 'The slot number of the chain reorg event in the beacon API event stream payload',
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the reorg slot started',
    `propagation_slot_start_diff` UInt32 COMMENT 'Difference in slots between when the reorg occurred and when the sentry received the event',
    `depth` UInt16 COMMENT 'The depth of the chain reorg in the beacon API event stream payload',
    `old_head_block` FixedString(66) COMMENT 'The old head block root hash in the beacon API event stream payload',
    `new_head_block` FixedString(66) COMMENT 'The new head block root hash in the beacon API event stream payload',
    `old_head_state` FixedString(66) COMMENT 'The old head state root hash in the beacon API event stream payload',
    `new_head_state` FixedString(66) COMMENT 'The new head state root hash in the beacon API event stream payload',
    `epoch` UInt32 COMMENT 'The epoch number in the beacon API event stream payload',
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started',
    `execution_optimistic` Bool COMMENT 'Whether the execution of the epoch was optimistic',
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the client that generated the event',
    `meta_client_id` String COMMENT 'Unique Session ID of the client that generated the event. This changes every time the client is restarted.',
    `meta_client_version` LowCardinality(String) COMMENT 'Version of the client that generated the event',
    `meta_client_implementation` LowCardinality(String) COMMENT 'Implementation of the client that generated the event',
    `meta_client_os` LowCardinality(String) COMMENT 'Operating system of the client that generated the event',
    `meta_client_ip` Nullable(IPv6) COMMENT 'IP address of the client that generated the event',
    `meta_client_geo_city` LowCardinality(String) COMMENT 'City of the client that generated the event',
    `meta_client_geo_country` LowCardinality(String) COMMENT 'Country of the client that generated the event',
    `meta_client_geo_country_code` LowCardinality(String) COMMENT 'Country code of the client that generated the event',
    `meta_client_geo_continent_code` LowCardinality(String) COMMENT 'Continent code of the client that generated the event',
    `meta_client_geo_longitude` Nullable(Float64) COMMENT 'Longitude of the client that generated the event',
    `meta_client_geo_latitude` Nullable(Float64) COMMENT 'Latitude of the client that generated the event',
    `meta_client_geo_autonomous_system_number` Nullable(UInt32) COMMENT 'Autonomous system number of the client that generated the event',
    `meta_client_geo_autonomous_system_organization` Nullable(String) COMMENT 'Autonomous system organization of the client that generated the event',
    `meta_network_id` Int32 COMMENT 'Ethereum network ID',
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name',
    `meta_consensus_version` LowCardinality(String) COMMENT 'Ethereum consensus client version that generated the event',
    `meta_consensus_version_major` LowCardinality(String) COMMENT 'Ethereum consensus client major version that generated the event',
    `meta_consensus_version_minor` LowCardinality(String) COMMENT 'Ethereum consensus client minor version that generated the event',
    `meta_consensus_version_patch` LowCardinality(String) COMMENT 'Ethereum consensus client patch version that generated the event',
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'Ethereum consensus client implementation that generated the event',
    `meta_labels` Map(String, String) COMMENT 'Labels associated with the event'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/default/tables/beacon_api_eth_v1_events_chain_reorg_local/{shard}', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, meta_network_name, meta_client_name, old_head_block, new_head_block)
SETTINGS index_granularity = 8192
COMMENT 'Contains beacon API eventstream "chain reorg" data from each sentry client attached to a beacon node.'
