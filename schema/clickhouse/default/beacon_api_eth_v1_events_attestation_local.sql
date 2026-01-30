CREATE TABLE default.beacon_api_eth_v1_events_attestation_local
(
    `event_date_time` DateTime64(3) CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `propagation_slot_start_diff` UInt32 CODEC(ZSTD(1)),
    `committee_index` LowCardinality(String),
    `attesting_validator_index` Nullable(UInt32) CODEC(ZSTD(1)),
    `attesting_validator_committee_index` LowCardinality(String),
    `aggregation_bits` String CODEC(ZSTD(1)),
    `beacon_block_root` FixedString(66) CODEC(ZSTD(1)),
    `epoch` UInt32 CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `source_epoch` UInt32 CODEC(DoubleDelta, ZSTD(1)),
    `source_epoch_start_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `source_root` FixedString(66) CODEC(ZSTD(1)),
    `target_epoch` UInt32 CODEC(DoubleDelta, ZSTD(1)),
    `target_epoch_start_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `target_root` FixedString(66) CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String),
    `meta_client_id` String CODEC(ZSTD(1)),
    `meta_client_version` LowCardinality(String),
    `meta_client_implementation` LowCardinality(String),
    `meta_client_os` LowCardinality(String),
    `meta_client_ip` Nullable(IPv6) CODEC(ZSTD(1)),
    `meta_client_geo_city` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_client_geo_country` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_client_geo_country_code` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_client_geo_continent_code` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_client_geo_longitude` Nullable(Float64) CODEC(ZSTD(1)),
    `meta_client_geo_latitude` Nullable(Float64) CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_number` Nullable(UInt32) CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_organization` Nullable(String) CODEC(ZSTD(1)),
    `meta_network_id` Int32 CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String),
    `meta_consensus_version` LowCardinality(String),
    `meta_consensus_version_major` LowCardinality(String),
    `meta_consensus_version_minor` LowCardinality(String),
    `meta_consensus_version_patch` LowCardinality(String),
    `meta_consensus_implementation` LowCardinality(String),
    `meta_labels` Map(String, String) CODEC(ZSTD(1))
)
ENGINE = ReplicatedMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/beacon_api_eth_v1_events_attestation_local', '{replica}')
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, meta_network_name, meta_client_name)
SETTINGS index_granularity = 8192
COMMENT 'Contains beacon API eventstream "attestation" data from each sentry client attached to a beacon node.'
