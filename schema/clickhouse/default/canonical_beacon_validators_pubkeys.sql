CREATE TABLE default.canonical_beacon_validators_pubkeys
(
    `updated_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `version` UInt32 DEFAULT 4294967295 - toUnixTimestamp(epoch_start_date_time) CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `index` UInt32 CODEC(ZSTD(1)),
    `pubkey` String CODEC(ZSTD(1)),
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
ENGINE = Distributed('{cluster}', 'default', 'canonical_beacon_validators_pubkeys_local', cityHash64(index, meta_network_name))
COMMENT 'Contains a validator pubkeys for an epoch.'
