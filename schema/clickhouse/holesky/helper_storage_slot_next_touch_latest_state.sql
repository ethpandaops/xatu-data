CREATE TABLE holesky.helper_storage_slot_next_touch_latest_state
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number of the latest touch for this slot' CODEC(DoubleDelta, ZSTD(1)),
    `next_touch_block` Nullable(UInt32) COMMENT 'The next block where this slot was touched (NULL if no subsequent touch yet)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'helper_storage_slot_next_touch_latest_state_local', cityHash64(address, slot_key))
COMMENT 'Latest state per storage slot for efficient lookups. Helper table for int_storage_slot_next_touch.'
