CREATE TABLE holesky.fct_execution_tps_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of blocks in this day' CODEC(ZSTD(1)),
    `total_transactions` UInt64 COMMENT 'Total transactions in this day' CODEC(ZSTD(1)),
    `total_seconds` UInt32 COMMENT 'Total actual seconds covered by blocks (sum of block time gaps)' CODEC(ZSTD(1)),
    `avg_tps` Float32 COMMENT 'Average TPS using actual block time gaps' CODEC(ZSTD(1)),
    `min_tps` Float32 COMMENT 'Minimum per-block TPS' CODEC(ZSTD(1)),
    `max_tps` Float32 COMMENT 'Maximum per-block TPS' CODEC(ZSTD(1)),
    `p05_tps` Float32 COMMENT '5th percentile TPS' CODEC(ZSTD(1)),
    `p50_tps` Float32 COMMENT '50th percentile (median) TPS' CODEC(ZSTD(1)),
    `p95_tps` Float32 COMMENT '95th percentile TPS' CODEC(ZSTD(1)),
    `stddev_tps` Float32 COMMENT 'Standard deviation of TPS' CODEC(ZSTD(1)),
    `upper_band_tps` Float32 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_tps` Float32 COMMENT 'Lower Bollinger band (avg - 2*stddev), can be negative during high volatility' CODEC(ZSTD(1)),
    `moving_avg_tps` Float32 COMMENT 'Moving average TPS (7-day window)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_execution_tps_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS index_granularity = 8192
COMMENT 'Daily aggregated execution layer TPS statistics with percentiles, Bollinger bands, and moving averages'
