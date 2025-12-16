CREATE TABLE hoodi.int_execution_block_by_date_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_date_time` DateTime64(3) COMMENT 'The block timestamp' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_execution_block_by_date_local', '{replica}', updated_date_time)
PARTITION BY toYYYYMM(block_date_time)
ORDER BY (block_date_time, block_number)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Execution blocks ordered by timestamp for efficient date range lookups'
