CREATE TABLE sepolia.fct_head_first_seen_by_node_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period, by slot' CODEC(DoubleDelta, ZSTD(1)),
    `node_id` String COMMENT 'ID of the node' CODEC(ZSTD(1)),
    `username` LowCardinality(String) COMMENT 'Username of the node' CODEC(ZSTD(1)),
    `classification` LowCardinality(String) COMMENT 'Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Latest client name of the node in the period' CODEC(ZSTD(1)),
    `meta_client_implementation` LowCardinality(String) COMMENT 'Latest collector implementation of the node in the period' CODEC(ZSTD(1)),
    `meta_client_version` LowCardinality(String) COMMENT 'Latest collector version of the node in the period' CODEC(ZSTD(1)),
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'Latest consensus client implementation of the node in the period' CODEC(ZSTD(1)),
    `meta_consensus_version` LowCardinality(String) COMMENT 'Latest consensus client version of the node in the period' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Slots the node saw a head event in' CODEC(ZSTD(1)),
    `min_seen_slot_start_diff` UInt32 COMMENT 'Earliest head event arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p10_seen_slot_start_diff` UInt32 COMMENT '10th percentile head event arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p50_seen_slot_start_diff` UInt32 COMMENT 'Median head event arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p90_seen_slot_start_diff` UInt32 COMMENT '90th percentile head event arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p95_seen_slot_start_diff` UInt32 COMMENT '95th percentile head event arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `max_seen_slot_start_diff` UInt32 COMMENT 'Latest head event arrival, in milliseconds from slot start' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_head_first_seen_by_node_daily_local', cityHash64(day_start_date, node_id))
COMMENT 'Daily head event arrival per node'
