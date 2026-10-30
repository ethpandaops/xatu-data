CREATE TABLE holesky.fct_block_data_column_sidecar_first_seen_by_node_daily_local
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
    `slot_count` UInt32 COMMENT 'Slots the node saw data columns in' CODEC(ZSTD(1)),
    `column_count` UInt16 COMMENT 'Distinct column indexes the node saw, its custody set' CODEC(ZSTD(1)),
    `avg_columns_per_slot` Float64 COMMENT 'Average columns the node saw per slot' CODEC(ZSTD(1)),
    `p50_first_seen_slot_start_diff` UInt32 COMMENT 'Median arrival of the first column in a slot, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p10_last_seen_slot_start_diff` UInt32 COMMENT '10th percentile arrival of the last column in a slot, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p50_last_seen_slot_start_diff` UInt32 COMMENT 'Median arrival of the last column in a slot, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p90_last_seen_slot_start_diff` UInt32 COMMENT '90th percentile arrival of the last column in a slot, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p95_last_seen_slot_start_diff` UInt32 COMMENT '95th percentile arrival of the last column in a slot, in milliseconds from slot start' CODEC(ZSTD(1)),
    `max_last_seen_slot_start_diff` UInt32 COMMENT 'Latest arrival of the last column in a slot, in milliseconds from slot start' CODEC(ZSTD(1)),
    PROJECTION p_by_node_id
    (
        SELECT *
        ORDER BY
            node_id,
            day_start_date
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_block_data_column_sidecar_first_seen_by_node_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, node_id)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily data column arrival per node'
