CREATE TABLE holesky.fct_execution_gas_limit_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of blocks in this day' CODEC(ZSTD(1)),
    `total_gas_limit` UInt64 COMMENT 'Total gas limit in this day' CODEC(ZSTD(1)),
    `avg_gas_limit` UInt64 COMMENT 'Average gas limit per block' CODEC(ZSTD(1)),
    `min_gas_limit` UInt64 COMMENT 'Minimum gas limit in a block' CODEC(ZSTD(1)),
    `max_gas_limit` UInt64 COMMENT 'Maximum gas limit in a block' CODEC(ZSTD(1)),
    `p05_gas_limit` UInt64 COMMENT '5th percentile gas limit' CODEC(ZSTD(1)),
    `p50_gas_limit` UInt64 COMMENT '50th percentile (median) gas limit' CODEC(ZSTD(1)),
    `p95_gas_limit` UInt64 COMMENT '95th percentile gas limit' CODEC(ZSTD(1)),
    `stddev_gas_limit` UInt64 COMMENT 'Standard deviation of gas limit' CODEC(ZSTD(1)),
    `upper_band_gas_limit` UInt64 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_gas_limit` Int64 COMMENT 'Lower Bollinger band (avg - 2*stddev), can be negative during high volatility' CODEC(ZSTD(1)),
    `moving_avg_gas_limit` UInt64 COMMENT 'Moving average gas limit (7-day window)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_execution_gas_limit_daily_local', cityHash64(day_start_date))
COMMENT 'Daily aggregated execution layer gas limit statistics with percentiles, Bollinger bands, and moving averages'
