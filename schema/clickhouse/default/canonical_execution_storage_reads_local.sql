CREATE TABLE default.canonical_execution_storage_reads_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'The transaction index' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash associated with the storage read' CODEC(ZSTD(1)),
    `internal_index` UInt32 COMMENT 'The internal index of the storage read within the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `contract_address` String COMMENT 'The contract address associated with the storage read' CODEC(ZSTD(1)),
    `slot` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `value` String COMMENT 'The value read from the storage slot' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/default/tables/canonical_execution_storage_reads_local/{shard}', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 5000000)
ORDER BY (block_number, meta_network_name, transaction_hash, internal_index)
SETTINGS index_granularity = 8192
COMMENT 'Contains canonical execution storage reads data.'
