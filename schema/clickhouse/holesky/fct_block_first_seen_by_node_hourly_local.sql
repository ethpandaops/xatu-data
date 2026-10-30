CREATE TABLE holesky.fct_block_first_seen_by_node_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The wall clock time at the start of the hour, by slot' CODEC(DoubleDelta, ZSTD(1)),
    `node_id` String COMMENT 'ID of the node' CODEC(ZSTD(1)),
    `username` LowCardinality(String) COMMENT 'Username of the node' CODEC(ZSTD(1)),
    `classification` LowCardinality(String) COMMENT 'Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Latest client name of the node in the period' CODEC(ZSTD(1)),
    `meta_client_implementation` LowCardinality(String) COMMENT 'Latest collector implementation of the node in the period' CODEC(ZSTD(1)),
    `meta_client_version` LowCardinality(String) COMMENT 'Latest collector version of the node in the period' CODEC(ZSTD(1)),
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'Latest consensus client implementation of the node in the period' CODEC(ZSTD(1)),
    `meta_consensus_version` LowCardinality(String) COMMENT 'Latest consensus client version of the node in the period' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Slots the node saw a block in' CODEC(ZSTD(1)),
    `min_seen_slot_start_diff` UInt32 COMMENT 'Earliest block arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p10_seen_slot_start_diff` UInt32 COMMENT '10th percentile block arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p50_seen_slot_start_diff` UInt32 COMMENT 'Median block arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p90_seen_slot_start_diff` UInt32 COMMENT '90th percentile block arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p95_seen_slot_start_diff` UInt32 COMMENT '95th percentile block arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `max_seen_slot_start_diff` UInt32 COMMENT 'Latest block arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    PROJECTION p_by_node_id
    (
        SELECT *
        ORDER BY
            node_id,
            hour_start_date_time
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_block_first_seen_by_node_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY (hour_start_date_time, node_id)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Hourly block arrival per node'
