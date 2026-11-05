CREATE TABLE mainnet.fct_block_first_seen_by_network_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The wall clock time at the start of the hour, by slot' CODEC(DoubleDelta, ZSTD(1)),
    `node_count` UInt32 COMMENT 'Xatu nodes with a row in fct_block_first_seen_by_node_hourly for the hour' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Slots in the hour that at least one Xatu node saw a block in' CODEC(ZSTD(1)),
    `p10_median_seen_slot_start_diff` Float64 COMMENT '10th percentile across nodes of each node median block arrival (p50_seen_slot_start_diff in fct_block_first_seen_by_node_hourly), in milliseconds from slot start. Every node weighs the same, linear interpolation between ranks' CODEC(ZSTD(1)),
    `p50_median_seen_slot_start_diff` Float64 COMMENT 'Median across nodes of each node median block arrival (p50_seen_slot_start_diff in fct_block_first_seen_by_node_hourly), in milliseconds from slot start. Every node weighs the same, linear interpolation between ranks' CODEC(ZSTD(1)),
    `p90_median_seen_slot_start_diff` Float64 COMMENT '90th percentile across nodes of each node median block arrival (p50_seen_slot_start_diff in fct_block_first_seen_by_node_hourly), in milliseconds from slot start. Every node weighs the same, linear interpolation between ranks' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_block_first_seen_by_network_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfYear(hour_start_date_time)
ORDER BY hour_start_date_time
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Hourly block arrival across every Xatu node: the spread of the per-node medians in fct_block_first_seen_by_node_hourly, one row per hour'
