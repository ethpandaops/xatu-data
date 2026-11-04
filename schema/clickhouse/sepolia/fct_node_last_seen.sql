CREATE TABLE sepolia.fct_node_last_seen
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `last_seen_date_time` DateTime COMMENT 'Start of the latest slot the Xatu node reported a block in' CODEC(DoubleDelta, ZSTD(1)),
    `username` LowCardinality(String) COMMENT 'Username of the Xatu node' CODEC(ZSTD(1)),
    `node_id` String COMMENT 'ID of the Xatu node' CODEC(ZSTD(1)),
    `classification` LowCardinality(String) COMMENT 'Classification of the Xatu node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the Xatu node' CODEC(ZSTD(1)),
    `meta_client_version` LowCardinality(String) COMMENT 'Version of the collector at the latest observation' CODEC(ZSTD(1)),
    `meta_client_implementation` LowCardinality(String) COMMENT 'Implementation of the collector at the latest observation' CODEC(ZSTD(1)),
    `meta_client_geo_city` LowCardinality(String) COMMENT 'City of the Xatu node at the latest observation' CODEC(ZSTD(1)),
    `meta_client_geo_country` LowCardinality(String) COMMENT 'Country of the Xatu node at the latest observation' CODEC(ZSTD(1)),
    `meta_client_geo_country_code` LowCardinality(String) COMMENT 'Country code of the Xatu node at the latest observation' CODEC(ZSTD(1)),
    `meta_client_geo_continent_code` LowCardinality(String) COMMENT 'Continent code of the Xatu node at the latest observation' CODEC(ZSTD(1)),
    `meta_client_geo_longitude` Nullable(Float64) COMMENT 'Longitude of the Xatu node at the latest observation' CODEC(ZSTD(1)),
    `meta_client_geo_latitude` Nullable(Float64) COMMENT 'Latitude of the Xatu node at the latest observation' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_number` Nullable(UInt32) COMMENT 'Autonomous system number of the Xatu node at the latest observation' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_organization` Nullable(String) COMMENT 'Autonomous system organization of the Xatu node at the latest observation' CODEC(ZSTD(1)),
    `meta_consensus_version` LowCardinality(String) COMMENT 'Consensus client version of the Xatu node at the latest observation' CODEC(ZSTD(1)),
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'Consensus client implementation of the Xatu node at the latest observation' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_node_last_seen_local', cityHash64(meta_client_name))
COMMENT 'Every Xatu node that has reported a block, with its latest identity, client and location, from fct_block_first_seen_by_node. The row with the latest last_seen_date_time wins, so a node reported in a range ending now has last_seen_date_time inside it'
