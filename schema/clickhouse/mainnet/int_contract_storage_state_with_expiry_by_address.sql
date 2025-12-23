CREATE TABLE mainnet.int_contract_storage_state_with_expiry_by_address
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `expiry_policy` LowCardinality(String) COMMENT 'Expiry policy identifier: 1m, 6m, 12m, 18m, 24m' CODEC(ZSTD(1)),
    `active_slots` Int64 COMMENT 'Number of active storage slots in this contract (0 if expired)' CODEC(DoubleDelta, ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Effective bytes for this contract (0 if expired)' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'int_contract_storage_state_with_expiry_by_address_local', cityHash64(address, block_number))
COMMENT 'Contract-level expiry state ordered by address - tracks active_slots and effective_bytes per contract'
