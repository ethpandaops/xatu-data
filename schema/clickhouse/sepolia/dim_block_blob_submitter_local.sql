CREATE TABLE sepolia.dim_block_blob_submitter_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'The transaction index' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The blob submitter address' CODEC(ZSTD(1)),
    `versioned_hashes` Array(String) COMMENT 'The versioned hashes of the blob submitter' CODEC(ZSTD(1)),
    `name` Nullable(String) COMMENT 'The name of the blob submitter' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/dim_block_blob_submitter_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 500000)
ORDER BY (block_number, transaction_index)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Blob transaction to submitter name mapping.'
