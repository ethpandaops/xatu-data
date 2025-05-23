CREATE TABLE default.canonical_execution_balance_diffs_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_index` UInt64 COMMENT 'The transaction index in the block' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash that caused the balance diff' CODEC(ZSTD(1)),
    `internal_index` UInt32 COMMENT 'The internal index of the balance diff within the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The address of the balance diff' CODEC(ZSTD(1)),
    `from_value` UInt256 COMMENT 'The from value of the balance diff' CODEC(ZSTD(1)),
    `to_value` UInt256 COMMENT 'The to value of the balance diff' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/default/tables/canonical_execution_balance_diffs_local/{shard}', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 5000000)
ORDER BY (block_number, meta_network_name, transaction_hash, internal_index)
SETTINGS index_granularity = 8192
COMMENT 'Contains canonical execution balance diff data.'
