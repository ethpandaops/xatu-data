CREATE TABLE default.beacon_api_eth_v1_events_contribution_and_proof_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime64(3) COMMENT 'When the sentry received the event from a beacon node',
    `aggregator_index` UInt32 COMMENT 'The validator index of the aggregator in the beacon API event stream payload',
    `contribution_slot` UInt32 COMMENT 'The slot number of the contribution in the beacon API event stream payload',
    `contribution_slot_start_date_time` DateTime COMMENT 'The wall clock time when the contribution slot started',
    `contribution_propagation_slot_start_diff` UInt32 COMMENT 'Difference in slots between when the contribution occurred and when the sentry received the event',
    `contribution_beacon_block_root` FixedString(66) COMMENT 'The beacon block root hash in the beacon API event stream payload',
    `contribution_subcommittee_index` LowCardinality(String) COMMENT 'The subcommittee index of the contribution in the beacon API event stream payload',
    `contribution_aggregation_bits` String COMMENT 'The aggregation bits of the contribution in the beacon API event stream payload',
    `contribution_signature` String COMMENT 'The signature of the contribution in the beacon API event stream payload',
    `contribution_epoch` UInt32 COMMENT 'The epoch number of the contribution in the beacon API event stream payload',
    `contribution_epoch_start_date_time` DateTime COMMENT 'The wall clock time when the contribution epoch started',
    `selection_proof` String COMMENT 'The selection proof in the beacon API event stream payload',
    `signature` String COMMENT 'The signature in the beacon API event stream payload',
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
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/default/tables/beacon_api_eth_v1_events_contribution_and_proof_local/{shard}', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(contribution_slot_start_date_time)
ORDER BY (contribution_slot_start_date_time, meta_network_name, meta_client_name, contribution_beacon_block_root, contribution_subcommittee_index, signature)
SETTINGS index_granularity = 8192
COMMENT 'Contains beacon API eventstream "contribution and proof" data from each sentry client attached to a beacon node.'
