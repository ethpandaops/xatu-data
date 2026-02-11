CREATE TABLE mainnet.fct_attestation_inclusion_delay_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of slots in this day' CODEC(ZSTD(1)),
    `avg_inclusion_delay` Float32 COMMENT 'Average inclusion delay (slots)' CODEC(ZSTD(1)),
    `min_inclusion_delay` Float32 COMMENT 'Minimum inclusion delay (slots)' CODEC(ZSTD(1)),
    `max_inclusion_delay` Float32 COMMENT 'Maximum inclusion delay (slots)' CODEC(ZSTD(1)),
    `p05_inclusion_delay` Float32 COMMENT '5th percentile inclusion delay' CODEC(ZSTD(1)),
    `p50_inclusion_delay` Float32 COMMENT '50th percentile (median) inclusion delay' CODEC(ZSTD(1)),
    `p95_inclusion_delay` Float32 COMMENT '95th percentile inclusion delay' CODEC(ZSTD(1)),
    `stddev_inclusion_delay` Float32 COMMENT 'Standard deviation of inclusion delay' CODEC(ZSTD(1)),
    `upper_band_inclusion_delay` Float32 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_inclusion_delay` Float32 COMMENT 'Lower Bollinger band (avg - 2*stddev)' CODEC(ZSTD(1)),
    `moving_avg_inclusion_delay` Float32 COMMENT 'Moving average inclusion delay (7-day window)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_attestation_inclusion_delay_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS index_granularity = 8192
COMMENT 'Daily aggregated attestation inclusion delay statistics with percentiles, Bollinger bands, and moving averages'
