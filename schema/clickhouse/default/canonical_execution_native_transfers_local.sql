CREATE TABLE default.canonical_execution_native_transfers_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_index` UInt64 COMMENT 'The transaction index in the block' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `internal_index` UInt32 COMMENT 'The internal index of the transfer within the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `transfer_index` UInt64 COMMENT 'The transfer index' CODEC(DoubleDelta, ZSTD(1)),
    `from_address` String COMMENT 'The from address' CODEC(ZSTD(1)),
    `to_address` String COMMENT 'The to address' CODEC(ZSTD(1)),
    `value` UInt256 COMMENT 'The value of the approval' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/default/tables/canonical_execution_native_transfers_local/{shard}', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 5000000)
ORDER BY (block_number, meta_network_name, transaction_hash, internal_index)
SETTINGS index_granularity = 8192
COMMENT 'Contains canonical execution native transfer data.'
