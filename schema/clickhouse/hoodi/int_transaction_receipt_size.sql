CREATE TABLE hoodi.int_transaction_receipt_size
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number containing the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'The index of the transaction within the block' CODEC(DoubleDelta, ZSTD(1)),
    `receipt_bytes` UInt64 COMMENT 'Exact RLP-encoded receipt size in bytes (matches eth_getTransactionReceipt)' CODEC(ZSTD(1)),
    `log_count` UInt32 COMMENT 'Number of logs emitted by this transaction' CODEC(ZSTD(1)),
    `log_data_bytes` UInt64 COMMENT 'Total raw bytes of log data fields (before RLP encoding)' CODEC(ZSTD(1)),
    `log_topic_count` UInt32 COMMENT 'Total number of topics across all logs' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'The name of the network'
)
ENGINE = Distributed('{cluster}', 'hoodi', 'int_transaction_receipt_size_local', cityHash64(block_number, transaction_hash))
COMMENT 'Per-transaction exact RLP-encoded receipt size derived from logs and transaction data.'
