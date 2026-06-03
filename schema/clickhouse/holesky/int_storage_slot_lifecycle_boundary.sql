CREATE TABLE holesky.int_storage_slot_lifecycle_boundary
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `lifecycle_number` UInt32 COMMENT 'Reincarnation counter for this slot (1 = first lifecycle, 2 = second, etc.)' CODEC(DoubleDelta, ZSTD(1)),
    `birth_block` UInt32 COMMENT 'Block where the slot transitioned from 0 to non-zero effective bytes' CODEC(DoubleDelta, ZSTD(1)),
    `death_block` Nullable(UInt32) COMMENT 'Block where the slot transitioned from non-zero to 0 effective bytes (NULL if still alive)' CODEC(ZSTD(1)),
    `effective_bytes_birth` UInt8 COMMENT 'Number of effective bytes at birth (the to_value of the 0->non-zero transition)' CODEC(ZSTD(1)),
    `effective_bytes_death` Nullable(UInt8) COMMENT 'Number of effective bytes before death (the from_value of the non-zero->0 transition, NULL if still alive)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_storage_slot_lifecycle_boundary_local', cityHash64(address, slot_key))
COMMENT 'Lifecycle boundaries per storage slot: birth (0→non-zero) and death (non-zero→0) blocks with effective bytes at each transition.'
