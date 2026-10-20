CREATE TABLE hoodi.fct_block_partial_data_column_header_first_seen
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The beacon block root hash' CODEC(ZSTD(1)),
    `proposer_index` UInt32 COMMENT 'The validator index of the block proposer, from the header' CODEC(ZSTD(1)),
    `blob_count` UInt32 COMMENT 'Number of KZG commitments in the header' CODEC(ZSTD(1)),
    `seen_slot_start_diff` UInt32 COMMENT 'Time from slot start until any sentry node first received a partial data column header for the block, in milliseconds' CODEC(ZSTD(1)),
    `p50_node_seen_slot_start_diff` UInt32 COMMENT 'Median across nodes of the time each node first received a header for the block, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p90_node_seen_slot_start_diff` UInt32 COMMENT '90th percentile across nodes of the time each node first received a header for the block, in milliseconds from slot start' CODEC(ZSTD(1)),
    `max_node_seen_slot_start_diff` UInt32 COMMENT 'Latest time a node first received a header for the block, in milliseconds from slot start' CODEC(ZSTD(1)),
    `node_count` UInt32 COMMENT 'Number of sentry nodes that received a partial data column header for the block' CODEC(ZSTD(1)),
    `first_seen_meta_client_name` LowCardinality(String) COMMENT 'Name of the sentry node that received a header first' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_block_partial_data_column_header_first_seen_local', cityHash64(slot_start_date_time, block_root))
COMMENT 'When sentry nodes first received the gossipsub partial data column header for a Fulu block, the eager push that lets peers verify cells before the full column arrives'
