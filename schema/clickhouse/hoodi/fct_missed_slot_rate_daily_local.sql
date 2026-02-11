CREATE TABLE hoodi.fct_missed_slot_rate_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Total number of slots in this day' CODEC(ZSTD(1)),
    `missed_count` UInt32 COMMENT 'Number of missed slots in this day' CODEC(ZSTD(1)),
    `missed_rate` Float32 COMMENT 'Missed slot rate (%)' CODEC(ZSTD(1)),
    `moving_avg_missed_rate` Float32 COMMENT 'Moving average missed rate (7-day window)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_missed_slot_rate_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS index_granularity = 8192
COMMENT 'Daily missed slot rate with moving averages'
