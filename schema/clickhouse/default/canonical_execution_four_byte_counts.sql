CREATE TABLE default.canonical_execution_four_byte_counts
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_index` UInt64 COMMENT 'The transaction index in the block' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `signature` String COMMENT 'The signature of the four byte count' CODEC(ZSTD(1)),
    `size` UInt64 COMMENT 'The size of the four byte count' CODEC(ZSTD(1)),
    `count` UInt64 COMMENT 'The count of the four byte count' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_execution_four_byte_counts_local', cityHash64(block_number, meta_network_name, transaction_hash))
COMMENT 'Contains canonical execution four byte count data.'
