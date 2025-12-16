CREATE TABLE default.canonical_execution_storage_diffs
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'The transaction index' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash associated with the storage diff' CODEC(ZSTD(1)),
    `internal_index` UInt32 COMMENT 'The internal index of the storage diff within the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The address associated with the storage diff' CODEC(ZSTD(1)),
    `slot` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `from_value` String COMMENT 'The original value before the storage diff' CODEC(ZSTD(1)),
    `to_value` String COMMENT 'The new value after the storage diff' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_execution_storage_diffs_local', cityHash64(block_number, meta_network_name, transaction_hash, internal_index))
COMMENT 'Contains canonical execution storage diffs data.'
