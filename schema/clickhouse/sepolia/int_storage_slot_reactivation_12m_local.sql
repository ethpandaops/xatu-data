CREATE TABLE sepolia.int_storage_slot_reactivation_12m_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number where this slot was reactivated' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `touch_block` UInt32 COMMENT 'The original touch block that expired (for matching with expiry records)' CODEC(DoubleDelta, ZSTD(1)),
    `effective_bytes` UInt8 COMMENT 'Number of effective bytes being reactivated (0-32)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_storage_slot_reactivation_12m_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 5000000)
ORDER BY (block_number, address, slot_key, touch_block)
SETTINGS index_granularity = 8192
COMMENT 'Storage slot 12-month reactivations - slots touched after 12m expiry'
