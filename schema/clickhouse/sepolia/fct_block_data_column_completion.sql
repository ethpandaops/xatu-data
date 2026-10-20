CREATE TABLE sepolia.fct_block_data_column_completion
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The beacon block root hash' CODEC(ZSTD(1)),
    `blob_count` UInt32 COMMENT 'Number of blobs in the block, the number of cells in each column' CODEC(ZSTD(1)),
    `column_count` UInt32 COMMENT 'Distinct columns of the block that a sentry node completed' CODEC(ZSTD(1)),
    `node_count` UInt32 COMMENT 'Distinct sentry nodes that completed a column of the block' CODEC(ZSTD(1)),
    `completion_count` UInt32 COMMENT 'Column completions, one per node per column' CODEC(ZSTD(1)),
    `full_gossip_completion_count` UInt32 COMMENT 'Completions by a full data column gossip message' CODEC(ZSTD(1)),
    `partial_gossip_completion_count` UInt32 COMMENT 'Completions from cells received as gossipsub partial messages' CODEC(ZSTD(1)),
    `el_completion_count` UInt32 COMMENT 'Completions built from blobs returned by the execution layer' CODEC(ZSTD(1)),
    `reconstruction_completion_count` UInt32 COMMENT 'Completions recovered by reconstruction from other columns' CODEC(ZSTD(1)),
    `unknown_completion_count` UInt32 COMMENT 'Completions by a path the node did not report' CODEC(ZSTD(1)),
    `cells_total` UInt64 COMMENT 'Cells in the completed columns, summed over completions' CODEC(ZSTD(1)),
    `cells_from_gossip` UInt64 COMMENT 'Cells received over gossip, summed over completions' CODEC(ZSTD(1)),
    `cells_from_el` UInt64 COMMENT 'Cells built from blobs returned by the execution layer, summed over completions' CODEC(ZSTD(1)),
    `min_completion_slot_start_diff` UInt32 COMMENT 'Earliest completion of any column by any node, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p50_completion_slot_start_diff` UInt32 COMMENT 'Median completion time across completions, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p90_completion_slot_start_diff` UInt32 COMMENT '90th percentile completion time across completions, in milliseconds from slot start' CODEC(ZSTD(1)),
    `max_completion_slot_start_diff` UInt32 COMMENT 'Latest completion of any column by any node, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p50_node_last_completion_slot_start_diff` UInt32 COMMENT 'Median across nodes of the time each node completed its last column of the block, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p90_node_last_completion_slot_start_diff` UInt32 COMMENT '90th percentile across nodes of the time each node completed its last column of the block, in milliseconds from slot start' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_block_data_column_completion_local', cityHash64(slot_start_date_time, block_root))
COMMENT 'How sentry nodes completed the data columns of each block: completions by path, cells from gossip and the execution layer, and completion times'
