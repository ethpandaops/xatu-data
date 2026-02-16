CREATE TABLE default.beacon_api_eth_v1_events_voluntary_exit_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime64(3) COMMENT 'When the sentry received the event from a beacon node',
    `epoch` UInt32 COMMENT 'The epoch number in the beacon API event stream payload',
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started',
    `wallclock_slot` UInt32 COMMENT 'Slot number of the wall clock when the event was received' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_slot_start_date_time` DateTime COMMENT 'Start date and time of the wall clock slot when the event was received' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_epoch` UInt32 COMMENT 'Epoch number of the wall clock when the event was received' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_epoch_start_date_time` DateTime COMMENT 'Start date and time of the wall clock epoch when the event was received' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator making the voluntary exit',
    `signature` String COMMENT 'The signature of the voluntary exit in the beacon API event stream payload',
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the Sentry client that collected the event. The table contains data from multiple Sentry clients',
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
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tmp/tables/beacon_api_eth_v1_events_voluntary_exit_local/{shard}', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(wallclock_epoch_start_date_time)
ORDER BY (wallclock_epoch_start_date_time, meta_network_name, meta_client_name, validator_index)
SETTINGS index_granularity = 8192
COMMENT 'Xatu Sentry subscribes to a beacon node\\'s Beacon API event-stream and captures voluntary exit events. Each row represents a `voluntary_exit` event from the Beacon API `/eth/v1/events?topics=voluntary_exit`, when a validator initiates an exit. Partition: monthly by `wallclock_epoch_start_date_time`.'
