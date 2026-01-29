CREATE TABLE default.libp2p_send_rpc
(
    `unique_key` Int64,
    `updated_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime64(3) CODEC(DoubleDelta, ZSTD(1)),
    `peer_id_unique_key` Int64,
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the client that collected the data. The table contains data from multiple clients',
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
ENGINE = Distributed('{cluster}', 'default', 'libp2p_send_rpc_local', unique_key)
COMMENT 'Contains RPC messages sent to peers. Collected from deep instrumentation within forked consensus layer clients. Control messages are split into separate tables referencing this via rpc_meta_unique_key. Partition: monthly by `event_date_time`.'
