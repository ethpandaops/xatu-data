CREATE TABLE default.libp2p_synthetic_heartbeat_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime64(3) COMMENT 'Timestamp of the heartbeat event' CODEC(DoubleDelta, ZSTD(1)),
    `remote_peer_id_unique_key` Int64 COMMENT 'Unique key of the remote peer',
    `remote_maddrs` String COMMENT 'Multiaddress of the remote peer' CODEC(ZSTD(1)),
    `latency_ms` Nullable(Int64) COMMENT 'EWMA latency in milliseconds (0 if unavailable)' CODEC(ZSTD(1)),
    `direction` LowCardinality(String) COMMENT 'Connection direction (Unknown/Inbound/Outbound)',
    `protocols` Array(String) COMMENT 'List of supported protocols' CODEC(ZSTD(1)),
    `connection_age_ms` Nullable(Int64) COMMENT 'Connection age in milliseconds' CODEC(ZSTD(1)),
    `remote_agent_implementation` LowCardinality(String) COMMENT 'Implementation of the remote peer',
    `remote_agent_version` LowCardinality(String) COMMENT 'Version of the remote peer',
    `remote_agent_version_major` LowCardinality(String) COMMENT 'Major version of the remote peer',
    `remote_agent_version_minor` LowCardinality(String) COMMENT 'Minor version of the remote peer',
    `remote_agent_version_patch` LowCardinality(String) COMMENT 'Patch version of the remote peer',
    `remote_agent_platform` LowCardinality(String) COMMENT 'Platform of the remote peer',
    `remote_ip` Nullable(IPv6) COMMENT 'IP address of the remote peer' CODEC(ZSTD(1)),
    `remote_port` Nullable(UInt16) COMMENT 'Port of the remote peer' CODEC(ZSTD(1)),
    `remote_geo_city` LowCardinality(String) COMMENT 'City of the remote peer' CODEC(ZSTD(1)),
    `remote_geo_country` LowCardinality(String) COMMENT 'Country of the remote peer' CODEC(ZSTD(1)),
    `remote_geo_country_code` LowCardinality(String) COMMENT 'Country code of the remote peer' CODEC(ZSTD(1)),
    `remote_geo_continent_code` LowCardinality(String) COMMENT 'Continent code of the remote peer' CODEC(ZSTD(1)),
    `remote_geo_longitude` Nullable(Float64) COMMENT 'Longitude of the remote peer' CODEC(ZSTD(1)),
    `remote_geo_latitude` Nullable(Float64) COMMENT 'Latitude of the remote peer' CODEC(ZSTD(1)),
    `remote_geo_autonomous_system_number` Nullable(UInt32) COMMENT 'ASN of the remote peer' CODEC(ZSTD(1)),
    `remote_geo_autonomous_system_organization` Nullable(String) COMMENT 'AS organization of the remote peer' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the client that generated the event',
    `meta_client_id` String COMMENT 'Unique Session ID of the client' CODEC(ZSTD(1)),
    `meta_client_version` LowCardinality(String) COMMENT 'Version of the client',
    `meta_client_implementation` LowCardinality(String) COMMENT 'Implementation of the client',
    `meta_client_os` LowCardinality(String) COMMENT 'Operating system of the client',
    `meta_client_ip` Nullable(IPv6) COMMENT 'IP address of the client' CODEC(ZSTD(1)),
    `meta_client_geo_city` LowCardinality(String) COMMENT 'City of the client' CODEC(ZSTD(1)),
    `meta_client_geo_country` LowCardinality(String) COMMENT 'Country of the client' CODEC(ZSTD(1)),
    `meta_client_geo_country_code` LowCardinality(String) COMMENT 'Country code of the client' CODEC(ZSTD(1)),
    `meta_client_geo_continent_code` LowCardinality(String) COMMENT 'Continent code of the client' CODEC(ZSTD(1)),
    `meta_client_geo_longitude` Nullable(Float64) COMMENT 'Longitude of the client' CODEC(ZSTD(1)),
    `meta_client_geo_latitude` Nullable(Float64) COMMENT 'Latitude of the client' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_number` Nullable(UInt32) COMMENT 'ASN of the client' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_organization` Nullable(String) COMMENT 'AS organization of the client' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/libp2p_synthetic_heartbeat_local', '{replica}', updated_date_time)
PARTITION BY toYYYYMM(event_date_time)
ORDER BY (event_date_time, meta_network_name, meta_client_name, remote_peer_id_unique_key, updated_date_time)
SETTINGS index_granularity = 8192
COMMENT 'Contains heartbeat events from libp2p peers'
