CREATE TABLE sepolia.fct_storage_slot_state
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `slots_delta` Int32 COMMENT 'Change in active slots for this block (positive=activated, negative=deactivated)' CODEC(DoubleDelta, ZSTD(1)),
    `bytes_delta` Int64 COMMENT 'Change in effective bytes for this block' CODEC(DoubleDelta, ZSTD(1)),
    `active_slots` Int64 COMMENT 'Cumulative count of active storage slots at this block' CODEC(DoubleDelta, ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Cumulative sum of effective bytes across all active slots at this block' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_storage_slot_state_local', cityHash64(block_number))
COMMENT 'Cumulative storage slot state per block - tracks active slots and effective bytes with per-block deltas'
