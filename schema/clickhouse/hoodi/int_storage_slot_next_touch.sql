CREATE TABLE hoodi.int_storage_slot_next_touch
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number where this slot was touched' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `next_touch_block` Nullable(UInt32) COMMENT 'The next block number where this slot was touched (NULL if no subsequent touch)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'int_storage_slot_next_touch_local', cityHash64(block_number, address))
COMMENT 'Storage slot touches with precomputed next touch block - ordered by block_number for efficient range queries'
