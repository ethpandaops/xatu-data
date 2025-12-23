CREATE TABLE holesky.int_contract_storage_reactivation_18m
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number where this contract was reactivated' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `touch_block` UInt32 COMMENT 'The original touch block that expired (for matching with expiry records)' CODEC(DoubleDelta, ZSTD(1)),
    `active_slots` UInt64 COMMENT 'Count of slots being reactivated' CODEC(ZSTD(1)),
    `effective_bytes` UInt64 COMMENT 'Sum of effective bytes being reactivated' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_contract_storage_reactivation_18m_local', cityHash64(block_number, address))
COMMENT 'Contract-level 18-month reactivations - contracts touched after 18m expiry'
