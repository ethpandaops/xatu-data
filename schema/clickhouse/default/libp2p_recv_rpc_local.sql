CREATE TABLE default.libp2p_recv_rpc_local
(
    `unique_key` Int64,
    `updated_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime64(3) CODEC(DoubleDelta, ZSTD(1)),
    `peer_id_unique_key` Int64,
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
    `meta_network_name` LowCardinality(String)
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/libp2p_recv_rpc_local', '{replica}', updated_date_time)
PARTITION BY toYYYYMM(event_date_time)
ORDER BY (event_date_time, unique_key, meta_network_name, meta_client_name)
SETTINGS index_granularity = 8192
