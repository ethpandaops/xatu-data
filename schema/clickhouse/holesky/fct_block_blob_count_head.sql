CREATE TABLE holesky.fct_block_blob_count_head
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The beacon block root hash' CODEC(ZSTD(1)),
    `blob_count` UInt32 COMMENT 'The number of blobs in the block' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_block_blob_count_head_local', cityHash64(slot_start_date_time, block_root))
COMMENT 'Blob count of a block for the unfinalized chain. Forks in the chain may cause multiple block roots for the same slot to be present'
