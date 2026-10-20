CREATE TABLE hoodi.fct_data_column_completion_by_path_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The wall clock time at the start of the hour, by block slot' CODEC(DoubleDelta, ZSTD(1)),
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'Consensus client of the sentry nodes that completed the columns' CODEC(ZSTD(1)),
    `completed_via` LowCardinality(String) COMMENT 'How the columns were completed: FULL_GOSSIP, PARTIAL_GOSSIP, EL, RECONSTRUCTION or UNKNOWN' CODEC(ZSTD(1)),
    `node_count` UInt32 COMMENT 'Distinct sentry nodes with a completion on this path' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Distinct blocks with a column completed on this path' CODEC(ZSTD(1)),
    `completion_count` UInt32 COMMENT 'Column completions, one per node per column' CODEC(ZSTD(1)),
    `cells_total` UInt64 COMMENT 'Cells in the completed columns' CODEC(ZSTD(1)),
    `cells_from_gossip` UInt64 COMMENT 'Cells received over gossip' CODEC(ZSTD(1)),
    `cells_from_el` UInt64 COMMENT 'Cells built from blobs returned by the execution layer' CODEC(ZSTD(1)),
    `avg_contributing_peers` Float64 COMMENT 'Average number of distinct peers that contributed cells to a completion' CODEC(ZSTD(1)),
    `min_completion_slot_start_diff` UInt32 COMMENT 'Earliest completion, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p50_completion_slot_start_diff` UInt32 COMMENT 'Median completion time, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p90_completion_slot_start_diff` UInt32 COMMENT '90th percentile completion time, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p99_completion_slot_start_diff` UInt32 COMMENT '99th percentile completion time, in milliseconds from slot start' CODEC(ZSTD(1)),
    `max_completion_slot_start_diff` UInt32 COMMENT 'Latest completion, in milliseconds from slot start' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_data_column_completion_by_path_hourly_local', cityHash64(hour_start_date_time, meta_consensus_implementation, completed_via))
COMMENT 'Hourly data column completions on sentry nodes by consensus client and completion path, with cells by source and completion time percentiles'
