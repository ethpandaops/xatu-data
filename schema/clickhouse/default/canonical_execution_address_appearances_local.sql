CREATE TABLE default.canonical_execution_address_appearances_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash that caused the address appearance' CODEC(ZSTD(1)),
    `internal_index` UInt32 COMMENT 'The internal index of the address appearance within the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The address of the address appearance' CODEC(ZSTD(1)),
    `relationship` LowCardinality(String) COMMENT 'The relationship of the address to the transaction',
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/default/tables/canonical_execution_address_appearances_local/{shard}', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 5000000)
ORDER BY (block_number, meta_network_name, transaction_hash, internal_index)
SETTINGS index_granularity = 8192
COMMENT 'Contains canonical execution address appearance data.'
