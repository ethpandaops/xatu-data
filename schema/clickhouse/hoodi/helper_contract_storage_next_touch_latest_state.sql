CREATE TABLE hoodi.helper_contract_storage_next_touch_latest_state
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number of the latest touch for this contract' CODEC(DoubleDelta, ZSTD(1)),
    `next_touch_block` Nullable(UInt32) COMMENT 'The next block where this contract was touched (NULL if no subsequent touch yet)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'helper_contract_storage_next_touch_latest_state_local', cityHash64(address))
COMMENT 'Latest state per contract for efficient lookups. Helper table for int_contract_storage_next_touch.'
