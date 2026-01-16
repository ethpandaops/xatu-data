CREATE TABLE holesky.fct_execution_transactions_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of blocks in this hour' CODEC(ZSTD(1)),
    `total_transactions` UInt64 COMMENT 'Total transactions in this hour' CODEC(ZSTD(1)),
    `cumulative_transactions` UInt64 COMMENT 'Cumulative transaction count since genesis' CODEC(ZSTD(1)),
    `avg_txn_per_block` Float32 COMMENT 'Average transactions per block' CODEC(ZSTD(1)),
    `min_txn_per_block` UInt32 COMMENT 'Minimum transactions in a block' CODEC(ZSTD(1)),
    `max_txn_per_block` UInt32 COMMENT 'Maximum transactions in a block' CODEC(ZSTD(1)),
    `p50_txn_per_block` UInt32 COMMENT '50th percentile (median) transactions per block' CODEC(ZSTD(1)),
    `p95_txn_per_block` UInt32 COMMENT '95th percentile transactions per block' CODEC(ZSTD(1)),
    `p05_txn_per_block` UInt32 COMMENT '5th percentile transactions per block' CODEC(ZSTD(1)),
    `stddev_txn_per_block` Float32 COMMENT 'Standard deviation of transactions per block' CODEC(ZSTD(1)),
    `upper_band_txn_per_block` Float32 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_txn_per_block` Float32 COMMENT 'Lower Bollinger band (avg - 2*stddev)' CODEC(ZSTD(1)),
    `moving_avg_txn_per_block` Float32 COMMENT 'Moving average transactions per block (6-hour window)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_execution_transactions_hourly_local', cityHash64(hour_start_date_time))
COMMENT 'Hourly aggregated execution layer transaction counts with cumulative totals and per-block statistics'
