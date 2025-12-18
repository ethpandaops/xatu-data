CREATE TABLE hoodi.int_storage_slot_expiry_1m
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number where this slot expiry is recorded' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `touch_block` UInt32 COMMENT 'The original touch block that led to this expiry (propagates through waterfall chain)' CODEC(DoubleDelta, ZSTD(1)),
    `effective_bytes` UInt8 COMMENT 'Number of effective bytes that were set (0-32)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'int_storage_slot_expiry_1m_local', cityHash64(block_number, address))
COMMENT 'Storage slot 1-month expiries - base tier of waterfall chain'
