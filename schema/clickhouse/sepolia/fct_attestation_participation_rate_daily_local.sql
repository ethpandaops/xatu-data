CREATE TABLE sepolia.fct_attestation_participation_rate_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of slots in this day' CODEC(ZSTD(1)),
    `avg_participation_rate` Float32 COMMENT 'Average participation rate (%)' CODEC(ZSTD(1)),
    `min_participation_rate` Float32 COMMENT 'Minimum participation rate (%)' CODEC(ZSTD(1)),
    `max_participation_rate` Float32 COMMENT 'Maximum participation rate (%)' CODEC(ZSTD(1)),
    `p05_participation_rate` Float32 COMMENT '5th percentile participation rate' CODEC(ZSTD(1)),
    `p50_participation_rate` Float32 COMMENT '50th percentile (median) participation rate' CODEC(ZSTD(1)),
    `p95_participation_rate` Float32 COMMENT '95th percentile participation rate' CODEC(ZSTD(1)),
    `stddev_participation_rate` Float32 COMMENT 'Standard deviation of participation rate' CODEC(ZSTD(1)),
    `upper_band_participation_rate` Float32 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_participation_rate` Float32 COMMENT 'Lower Bollinger band (avg - 2*stddev)' CODEC(ZSTD(1)),
    `moving_avg_participation_rate` Float32 COMMENT 'Moving average participation rate (7-day window)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_attestation_participation_rate_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS index_granularity = 8192
COMMENT 'Daily aggregated attestation participation rate statistics with percentiles, Bollinger bands, and moving averages'
