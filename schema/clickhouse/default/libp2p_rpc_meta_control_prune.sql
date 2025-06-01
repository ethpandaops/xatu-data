CREATE TABLE default.libp2p_rpc_meta_control_prune
(
    `unique_key` Int64 COMMENT 'Unique identifier for each "Prune" control record',
    `updated_date_time` DateTime COMMENT 'Timestamp when the "Prune" control record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime64(3) COMMENT 'Timestamp of the "Prune" control event' CODEC(DoubleDelta, ZSTD(1)),
    `control_index` Int32 COMMENT 'Position in the RPC meta control PRUNE array' CODEC(DoubleDelta, ZSTD(1)),
    `rpc_meta_unique_key` Int64 COMMENT 'Unique key associated with the "Prune" control metadata',
    `peer_id_index` Int32 CODEC(DoubleDelta, ZSTD(1)),
    `peer_id_unique_key` Int64 COMMENT 'Unique key associated with the identifier of the peer involved in the Prune control',
    `graft_peer_id_unique_key` Int64 COMMENT 'Unique key associated with the identifier of the graft peer involved in the Prune control',
    `topic_layer` LowCardinality(String) COMMENT 'Layer of the topic',
    `topic_fork_digest_value` LowCardinality(String) COMMENT 'Fork digest value of the topic',
    `topic_name` LowCardinality(String) COMMENT 'Name of the topic',
    `topic_encoding` LowCardinality(String) COMMENT 'Encoding of the topic',
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
ENGINE = Distributed('{cluster}', 'default', 'libp2p_rpc_meta_control_prune_local', unique_key)
COMMENT 'Contains the details of the "Prune" control messages from the peer.'
