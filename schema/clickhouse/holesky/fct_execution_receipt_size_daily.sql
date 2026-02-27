CREATE TABLE holesky.fct_execution_receipt_size_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The start date of the day',
    `block_count` UInt32 COMMENT 'Number of blocks in this day' CODEC(ZSTD(1)),
    `transaction_count` UInt64 COMMENT 'Number of transactions in this day' CODEC(ZSTD(1)),
    `total_receipt_bytes` UInt64 COMMENT 'Total receipt bytes across all blocks' CODEC(ZSTD(1)),
    `avg_receipt_bytes_per_block` Float64 COMMENT 'Average total receipt bytes per block' CODEC(ZSTD(1)),
    `min_receipt_bytes_per_block` UInt64 COMMENT 'Minimum total receipt bytes in a single block' CODEC(ZSTD(1)),
    `max_receipt_bytes_per_block` UInt64 COMMENT 'Maximum total receipt bytes in a single block' CODEC(ZSTD(1)),
    `p05_receipt_bytes_per_block` UInt64 COMMENT '5th percentile of total receipt bytes per block' CODEC(ZSTD(1)),
    `p50_receipt_bytes_per_block` UInt64 COMMENT '50th percentile of total receipt bytes per block' CODEC(ZSTD(1)),
    `p95_receipt_bytes_per_block` UInt64 COMMENT '95th percentile of total receipt bytes per block' CODEC(ZSTD(1)),
    `stddev_receipt_bytes_per_block` Float64 COMMENT 'Standard deviation of total receipt bytes per block' CODEC(ZSTD(1)),
    `upper_band_receipt_bytes_per_block` Float64 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_receipt_bytes_per_block` Float64 COMMENT 'Lower Bollinger band (avg - 2*stddev)' CODEC(ZSTD(1)),
    `moving_avg_receipt_bytes_per_block` Float64 COMMENT '7-day moving average of receipt bytes per block' CODEC(ZSTD(1)),
    `avg_receipt_bytes_per_transaction` Float64 COMMENT 'Average receipt bytes per transaction' CODEC(ZSTD(1)),
    `p50_receipt_bytes_per_transaction` UInt64 COMMENT '50th percentile of receipt bytes per transaction' CODEC(ZSTD(1)),
    `p95_receipt_bytes_per_transaction` UInt64 COMMENT '95th percentile of receipt bytes per transaction' CODEC(ZSTD(1)),
    `total_log_count` UInt64 COMMENT 'Total logs emitted across all transactions' CODEC(ZSTD(1)),
    `avg_log_count_per_transaction` Float64 COMMENT 'Average logs per transaction' CODEC(ZSTD(1)),
    `cumulative_receipt_bytes` UInt64 COMMENT 'Running total of receipt bytes since genesis' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_execution_receipt_size_daily_local', cityHash64(day_start_date))
COMMENT 'Daily aggregation of receipt size with standard statistics.'
