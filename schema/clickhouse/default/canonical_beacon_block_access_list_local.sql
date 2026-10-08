CREATE TABLE default.canonical_beacon_block_access_list_local
(
    `updated_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) CODEC(ZSTD(1)),
    `block_number` UInt64 CODEC(DoubleDelta, ZSTD(1)),
    `block_hash` FixedString(66) CODEC(ZSTD(1)),
    `address` FixedString(42) CODEC(ZSTD(1)),
    `change_type` LowCardinality(String) CODEC(ZSTD(1)),
    `block_access_index` UInt32 CODEC(DoubleDelta, ZSTD(1)),
    `storage_key` Nullable(FixedString(66)) CODEC(ZSTD(1)),
    `new_value` Nullable(String) CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_client_id` String CODEC(ZSTD(1)),
    `meta_client_version` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_client_implementation` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_client_os` LowCardinality(String) CODEC(ZSTD(1)),
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
    `meta_network_name` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_consensus_version` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_consensus_version_major` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_consensus_version_minor` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_consensus_version_patch` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_consensus_implementation` LowCardinality(String) CODEC(ZSTD(1)),
    `meta_labels` Map(String, String) CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, meta_network_name, block_hash, address, change_type, storage_key, block_access_index)
SETTINGS allow_nullable_key = 1, index_granularity = 8192
