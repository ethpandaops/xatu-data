CREATE TABLE default.libp2p_handle_metadata_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime64(3) COMMENT 'Timestamp of the event' CODEC(DoubleDelta, ZSTD(1)),
    `peer_id_unique_key` Int64 COMMENT 'Unique key associated with the identifier of the peer involved in the RPC',
    `error` Nullable(String) COMMENT 'Error message if the metadata handling failed' CODEC(ZSTD(1)),
    `protocol` LowCardinality(String) COMMENT 'The protocol of the metadata handling event',
    `direction` LowCardinality(Nullable(String)) COMMENT 'Direction of the RPC request (inbound or outbound)' CODEC(ZSTD(1)),
    `attnets` String COMMENT 'Attestation subnets the peer is subscribed to' CODEC(ZSTD(1)),
    `seq_number` UInt64 COMMENT 'Sequence number of the metadata' CODEC(DoubleDelta, ZSTD(1)),
    `syncnets` String COMMENT 'Sync subnets the peer is subscribed to' CODEC(ZSTD(1)),
    `custody_group_count` Nullable(UInt8) COMMENT 'Number of custody groups (0-127)' CODEC(ZSTD(1)),
    `latency_milliseconds` Decimal(10, 3) COMMENT 'How long it took to handle the metadata request in milliseconds' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the client that generated the event',
    `meta_client_id` String COMMENT 'Unique Session ID of the client that generated the event. This changes every time the client is restarted.' CODEC(ZSTD(1)),
    `meta_client_version` LowCardinality(String) COMMENT 'Version of the client that generated the event',
    `meta_client_implementation` LowCardinality(String) COMMENT 'Implementation of the client that generated the event',
    `meta_client_os` LowCardinality(String) COMMENT 'Operating system of the client that generated the event',
    `meta_client_ip` Nullable(IPv6) COMMENT 'IP address of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_city` LowCardinality(String) COMMENT 'City of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_country` LowCardinality(String) COMMENT 'Country of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_country_code` LowCardinality(String) COMMENT 'Country code of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_continent_code` LowCardinality(String) COMMENT 'Continent code of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_longitude` Nullable(Float64) COMMENT 'Longitude of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_latitude` Nullable(Float64) COMMENT 'Latitude of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_number` Nullable(UInt32) COMMENT 'Autonomous system number of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_organization` Nullable(String) COMMENT 'Autonomous system organization of the client that generated the event' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/default/tables/libp2p_handle_metadata_local/{shard}', '{replica}', updated_date_time)
PARTITION BY toYYYYMM(event_date_time)
ORDER BY (event_date_time, meta_network_name, meta_client_name, peer_id_unique_key, attnets, seq_number, syncnets, latency_milliseconds)
SETTINGS index_granularity = 8192
COMMENT 'Contains the metadata handling events for libp2p peers.'
