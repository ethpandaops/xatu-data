CREATE TABLE mainnet.int_storage_slot_reactivation_by_6m
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number where this slot was reactivated/cancelled (touched after 6+ months of inactivity)' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `effective_bytes` UInt8 COMMENT 'Number of effective bytes being reactivated (must match corresponding expiry record)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'int_storage_slot_reactivation_by_6m_local', cityHash64(block_number, address))
COMMENT 'Storage slot reactivations/cancellations - records slots that were touched after 6+ months of inactivity, undoing their expiry'
