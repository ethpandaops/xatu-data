CREATE TABLE holesky.int_contract_storage_expiry_24m
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number where this contract expiry is recorded' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `touch_block` UInt32 COMMENT 'The original touch block that led to this expiry (propagates through waterfall chain)' CODEC(DoubleDelta, ZSTD(1)),
    `active_slots` UInt64 COMMENT 'Count of slots in the contract at expiry time' CODEC(ZSTD(1)),
    `effective_bytes` UInt64 COMMENT 'Sum of effective bytes across all slots in the contract at expiry time' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_contract_storage_expiry_24m_local', cityHash64(block_number, address))
COMMENT 'Contract-level 24-month expiries - waterfalls from 18m tier'
