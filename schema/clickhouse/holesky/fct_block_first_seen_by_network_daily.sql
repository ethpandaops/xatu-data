CREATE TABLE holesky.fct_block_first_seen_by_network_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period, by slot' CODEC(DoubleDelta, ZSTD(1)),
    `node_count` UInt32 COMMENT 'Xatu nodes with a row in fct_block_first_seen_by_node_daily for the day' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Slots in the day that at least one Xatu node saw a block in' CODEC(ZSTD(1)),
    `p10_median_seen_slot_start_diff` Float64 COMMENT '10th percentile across nodes of each node median block arrival (p50_seen_slot_start_diff in fct_block_first_seen_by_node_daily), in milliseconds from slot start. Every node weighs the same, linear interpolation between ranks' CODEC(ZSTD(1)),
    `p50_median_seen_slot_start_diff` Float64 COMMENT 'Median across nodes of each node median block arrival (p50_seen_slot_start_diff in fct_block_first_seen_by_node_daily), in milliseconds from slot start. Every node weighs the same, linear interpolation between ranks' CODEC(ZSTD(1)),
    `p90_median_seen_slot_start_diff` Float64 COMMENT '90th percentile across nodes of each node median block arrival (p50_seen_slot_start_diff in fct_block_first_seen_by_node_daily), in milliseconds from slot start. Every node weighs the same, linear interpolation between ranks' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_block_first_seen_by_network_daily_local', cityHash64(day_start_date))
COMMENT 'Daily block arrival across every Xatu node: the spread of the per-node medians in fct_block_first_seen_by_node_daily, one row per day'
