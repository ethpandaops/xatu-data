CREATE TABLE default.canonical_execution_logs
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'The transaction index' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash associated with the log' CODEC(ZSTD(1)),
    `internal_index` UInt32 COMMENT 'The internal index of the log within the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `log_index` UInt32 COMMENT 'The log index within the block' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The address associated with the log' CODEC(ZSTD(1)),
    `topic0` String COMMENT 'The first topic of the log' CODEC(ZSTD(1)),
    `topic1` Nullable(String) COMMENT 'The second topic of the log' CODEC(ZSTD(1)),
    `topic2` Nullable(String) COMMENT 'The third topic of the log' CODEC(ZSTD(1)),
    `topic3` Nullable(String) COMMENT 'The fourth topic of the log' CODEC(ZSTD(1)),
    `data` Nullable(String) COMMENT 'The data associated with the log' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_execution_logs_local', cityHash64(block_number, meta_network_name, transaction_hash, internal_index))
COMMENT 'Contains canonical execution logs data.'
