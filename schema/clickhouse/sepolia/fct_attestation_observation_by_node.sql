CREATE TABLE sepolia.fct_attestation_observation_by_node
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `attestation_count` UInt32 COMMENT 'Number of attestations observed by this node in this slot' CODEC(DoubleDelta, ZSTD(1)),
    `avg_seen_slot_start_diff` UInt32 COMMENT 'Average time from slot start to see attestations (milliseconds, rounded)' CODEC(DoubleDelta, ZSTD(1)),
    `median_seen_slot_start_diff` UInt32 COMMENT 'Median time from slot start to see attestations (milliseconds, rounded)' CODEC(DoubleDelta, ZSTD(1)),
    `min_seen_slot_start_diff` UInt32 COMMENT 'Minimum time from slot start to see an attestation (milliseconds)' CODEC(DoubleDelta, ZSTD(1)),
    `max_seen_slot_start_diff` UInt32 COMMENT 'Maximum time from slot start to see an attestation (milliseconds)' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'Representative beacon block root (from most common attestation target)' CODEC(ZSTD(1)),
    `username` LowCardinality(String) COMMENT 'Username of the node' CODEC(ZSTD(1)),
    `node_id` String COMMENT 'ID of the node' CODEC(ZSTD(1)),
    `classification` LowCardinality(String) COMMENT 'Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the client',
    `meta_client_version` LowCardinality(String) COMMENT 'Version of the client',
    `meta_client_implementation` LowCardinality(String) COMMENT 'Implementation of the client',
    `meta_client_geo_city` LowCardinality(String) COMMENT 'City of the client' CODEC(ZSTD(1)),
    `meta_client_geo_country` LowCardinality(String) COMMENT 'Country of the client' CODEC(ZSTD(1)),
    `meta_client_geo_country_code` LowCardinality(String) COMMENT 'Country code of the client' CODEC(ZSTD(1)),
    `meta_client_geo_continent_code` LowCardinality(String) COMMENT 'Continent code of the client' CODEC(ZSTD(1)),
    `meta_client_geo_longitude` Nullable(Float64) COMMENT 'Longitude of the client' CODEC(ZSTD(1)),
    `meta_client_geo_latitude` Nullable(Float64) COMMENT 'Latitude of the client' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_number` Nullable(UInt32) COMMENT 'Autonomous system number of the client' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_organization` Nullable(String) COMMENT 'Autonomous system organization of the client' CODEC(ZSTD(1)),
    `meta_consensus_version` LowCardinality(String) COMMENT 'Ethereum consensus client version',
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'Ethereum consensus client implementation'
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_attestation_observation_by_node_local', cityHash64(slot_start_date_time, meta_client_name))
COMMENT 'Attestation observations by contributor nodes, aggregated per slot per node for performance'
