CREATE TABLE mainnet.int_contract_storage_expiry_1m_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number where this contract expiry is recorded' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `touch_block` UInt32 COMMENT 'The original touch block that led to this expiry (propagates through waterfall chain)' CODEC(DoubleDelta, ZSTD(1)),
    `active_slots` UInt64 COMMENT 'Count of slots in the contract at expiry time' CODEC(ZSTD(1)),
    `effective_bytes` UInt64 COMMENT 'Sum of effective bytes across all slots in the contract at expiry time' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_contract_storage_expiry_1m_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 5000000)
ORDER BY (block_number, address, touch_block)
SETTINGS index_granularity = 8192
COMMENT 'Contract-level 1-month expiries - base tier of waterfall chain'
