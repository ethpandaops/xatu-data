CREATE TABLE sepolia.int_contract_storage_next_touch
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number where this contract was touched' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `next_touch_block` Nullable(UInt32) COMMENT 'The next block number where this contract was touched (NULL if no subsequent touch)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'int_contract_storage_next_touch_local', cityHash64(block_number, address))
COMMENT 'Contract-level touches with precomputed next touch block - a touch is any slot read or write on the contract'
