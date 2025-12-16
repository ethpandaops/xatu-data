CREATE TABLE mainnet.dim_block_blob_submitter
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'The transaction index' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The blob submitter address' CODEC(ZSTD(1)),
    `versioned_hashes` Array(String) COMMENT 'The versioned hashes of the blob submitter' CODEC(ZSTD(1)),
    `name` Nullable(String) COMMENT 'The name of the blob submitter' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'dim_block_blob_submitter_local', cityHash64(block_number, transaction_index))
COMMENT 'Blob transaction to submitter name mapping.'
