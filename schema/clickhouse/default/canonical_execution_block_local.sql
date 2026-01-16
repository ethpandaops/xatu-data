CREATE TABLE default.canonical_execution_block_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_date_time` DateTime64(3) COMMENT 'The block timestamp' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'The block hash' CODEC(ZSTD(1)),
    `author` Nullable(String) COMMENT 'The block author' CODEC(ZSTD(1)),
    `gas_used` Nullable(UInt64) COMMENT 'The block gas used' CODEC(DoubleDelta, ZSTD(1)),
    `gas_limit` UInt64 COMMENT 'The block gas limit' CODEC(DoubleDelta, ZSTD(1)),
    `extra_data` Nullable(String) COMMENT 'The block extra data in hex' CODEC(ZSTD(1)),
    `extra_data_string` Nullable(String) COMMENT 'The block extra data in UTF-8 string' CODEC(ZSTD(1)),
    `base_fee_per_gas` Nullable(UInt64) COMMENT 'The block base fee per gas' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/default/tables/canonical_execution_block_local/{shard}', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 5000000)
ORDER BY (block_number, meta_network_name)
SETTINGS index_granularity = 8192
COMMENT 'Contains canonical execution block data.'
