CREATE TABLE holesky.int_contract_storage_next_touch_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number where this contract was touched' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `next_touch_block` Nullable(UInt32) COMMENT 'The next block number where this contract was touched (NULL if no subsequent touch)' CODEC(ZSTD(1)),
    PROJECTION proj_by_next_touch_block
    (
        SELECT *
        ORDER BY
            next_touch_block,
            block_number,
            address
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_contract_storage_next_touch_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 5000000)
ORDER BY (block_number, address)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Contract-level touches with precomputed next touch block - a touch is any slot read or write on the contract'
