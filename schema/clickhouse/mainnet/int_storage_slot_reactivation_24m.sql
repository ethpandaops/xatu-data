CREATE TABLE mainnet.int_storage_slot_reactivation_24m
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number where this slot was reactivated' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `touch_block` UInt32 COMMENT 'The original touch block that expired (for matching with expiry records)' CODEC(DoubleDelta, ZSTD(1)),
    `effective_bytes` UInt8 COMMENT 'Number of effective bytes being reactivated (0-32)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'int_storage_slot_reactivation_24m_local', cityHash64(block_number, address))
COMMENT 'Storage slot 24-month reactivations - slots touched after 24m expiry'
