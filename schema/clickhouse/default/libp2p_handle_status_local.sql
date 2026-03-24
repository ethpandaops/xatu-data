CREATE TABLE default.libp2p_handle_status_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime64(3) COMMENT 'Timestamp of the event' CODEC(DoubleDelta, ZSTD(1)),
    `peer_id_unique_key` Int64 COMMENT 'Unique key associated with the identifier of the peer',
    `error` Nullable(String) COMMENT 'Error message if the status handling failed' CODEC(ZSTD(1)),
    `protocol` LowCardinality(String) COMMENT 'The protocol of the status handling event',
    `direction` LowCardinality(Nullable(String)) COMMENT 'Direction of the RPC request (inbound or outbound)' CODEC(ZSTD(1)),
    `request_finalized_epoch` Nullable(UInt32) COMMENT 'Requested finalized epoch' CODEC(DoubleDelta, ZSTD(1)),
    `request_finalized_root` Nullable(String) COMMENT 'Requested finalized root',
    `request_fork_digest` LowCardinality(String) COMMENT 'Requested fork digest',
    `request_head_root` Nullable(FixedString(66)) COMMENT 'Requested head root' CODEC(ZSTD(1)),
    `request_head_slot` Nullable(UInt32) COMMENT 'Requested head slot' CODEC(ZSTD(1)),
    `request_earliest_available_slot` Nullable(UInt32) COMMENT 'Requested earliest available slot' CODEC(ZSTD(1)),
    `response_finalized_epoch` Nullable(UInt32) COMMENT 'Response finalized epoch' CODEC(DoubleDelta, ZSTD(1)),
    `response_finalized_root` Nullable(FixedString(66)) COMMENT 'Response finalized root' CODEC(ZSTD(1)),
    `response_fork_digest` LowCardinality(String) COMMENT 'Response fork digest',
    `response_head_root` Nullable(FixedString(66)) COMMENT 'Response head root' CODEC(ZSTD(1)),
    `response_head_slot` Nullable(UInt32) COMMENT 'Response head slot' CODEC(DoubleDelta, ZSTD(1)),
    `response_earliest_available_slot` Nullable(UInt32) COMMENT 'Response earliest available slot' CODEC(ZSTD(1)),
    `latency_milliseconds` Decimal(10, 3) COMMENT 'How long it took to handle the status request in milliseconds' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the client that collected the data. The table contains data from multiple clients',
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
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/default/tables/libp2p_handle_status_local/{shard}', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(event_date_time)
ORDER BY (event_date_time, meta_network_name, meta_client_name, peer_id_unique_key, latency_milliseconds)
SETTINGS index_granularity = 8192
COMMENT 'Contains status protocol handling events (req/resp). Collected from deep instrumentation within forked consensus layer clients. Each row represents a status exchange with a peer including their head and finalized info. Partition: monthly by `event_date_time`.'
