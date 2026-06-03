CREATE TABLE holesky.int_storage_slot_lifecycle
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `lifecycle_number` UInt32 COMMENT 'Reincarnation counter for this slot (1 = first lifecycle, 2 = second, etc.)' CODEC(DoubleDelta, ZSTD(1)),
    `birth_block` UInt32 COMMENT 'Block where the slot transitioned from 0 to non-zero effective bytes' CODEC(DoubleDelta, ZSTD(1)),
    `death_block` Nullable(UInt32) COMMENT 'Block where the slot transitioned from non-zero to 0 effective bytes (NULL if still alive)' CODEC(ZSTD(1)),
    `lifespan_blocks` Nullable(UInt32) COMMENT 'Number of blocks between birth and death (NULL if still alive)' CODEC(ZSTD(1)),
    `touch_count` UInt32 COMMENT 'Total number of times this slot was touched during this lifecycle' CODEC(DoubleDelta, ZSTD(1)),
    `effective_bytes_birth` UInt8 COMMENT 'Number of effective bytes at birth (the to_value of the 0->non-zero transition)' CODEC(ZSTD(1)),
    `effective_bytes_peak` UInt8 COMMENT 'Maximum effective bytes observed during this lifecycle' CODEC(ZSTD(1)),
    `effective_bytes_death` Nullable(UInt8) COMMENT 'Number of effective bytes before death (the from_value of the non-zero->0 transition, NULL if still alive)' CODEC(ZSTD(1)),
    `last_touch_block` UInt32 COMMENT 'Most recent block where this slot was touched in this lifecycle' CODEC(DoubleDelta, ZSTD(1)),
    `interval_count` UInt32 COMMENT 'Number of touch-to-touch intervals observed (touch_count - 1 when > 1)' CODEC(DoubleDelta, ZSTD(1)),
    `interval_sum` UInt64 COMMENT 'Sum of all touch-to-touch intervals in blocks (for computing mean)' CODEC(DoubleDelta, ZSTD(1)),
    `interval_max` UInt32 COMMENT 'Maximum touch-to-touch interval in blocks' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_storage_slot_lifecycle_local', cityHash64(address, slot_key))
COMMENT 'Per-slot lifecycle metrics: birth/death blocks, touch counts, and touch-to-touch interval statistics. A lifecycle starts when a slot transitions from zero to non-zero (birth) and ends at the reverse (death). A slot can have multiple lifecycles.'
