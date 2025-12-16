CREATE TABLE mainnet.int_storage_slot_expiry_by_6m_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number where this slot expiry is recorded (6 months after it was set)' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `effective_bytes` UInt8 COMMENT 'Number of effective bytes that were set and are now being marked for expiry (0-32)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_storage_slot_expiry_by_6m_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 5000000)
ORDER BY (block_number, address, slot_key)
SETTINGS index_granularity = 8192
COMMENT 'Storage slot expiries - records slots that were set 6 months ago and are now candidates for clearing'
