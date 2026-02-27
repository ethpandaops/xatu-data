CREATE TABLE mainnet.int_block_receipt_size_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `receipt_bytes` UInt64 COMMENT 'Total RLP-encoded receipt bytes across all transactions in the block' CODEC(ZSTD(1)),
    `transaction_count` UInt32 COMMENT 'Number of transactions in the block' CODEC(ZSTD(1)),
    `log_count` UInt32 COMMENT 'Total logs emitted across all transactions in the block' CODEC(ZSTD(1)),
    `log_data_bytes` UInt64 COMMENT 'Total raw bytes of log data fields across all transactions' CODEC(ZSTD(1)),
    `log_topic_count` UInt32 COMMENT 'Total number of topics across all logs in the block' CODEC(ZSTD(1)),
    `avg_receipt_bytes_per_transaction` Float64 COMMENT 'Average receipt bytes per transaction in this block' CODEC(ZSTD(1)),
    `max_receipt_bytes_per_transaction` UInt64 COMMENT 'Largest single transaction receipt in this block' CODEC(ZSTD(1)),
    `p50_receipt_bytes_per_transaction` UInt64 COMMENT '50th percentile of receipt bytes per transaction' CODEC(ZSTD(1)),
    `p95_receipt_bytes_per_transaction` UInt64 COMMENT '95th percentile of receipt bytes per transaction' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'The name of the network'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_block_receipt_size_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 201600)
ORDER BY (block_number, meta_network_name)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Per-block receipt size totals. Derived from int_transaction_receipt_size.'
