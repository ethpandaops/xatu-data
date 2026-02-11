CREATE TABLE holesky.fct_head_vote_correctness_rate_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of slots in this day' CODEC(ZSTD(1)),
    `avg_head_vote_rate` Float32 COMMENT 'Average head vote correctness rate (%)' CODEC(ZSTD(1)),
    `min_head_vote_rate` Float32 COMMENT 'Minimum head vote correctness rate (%)' CODEC(ZSTD(1)),
    `max_head_vote_rate` Float32 COMMENT 'Maximum head vote correctness rate (%)' CODEC(ZSTD(1)),
    `p05_head_vote_rate` Float32 COMMENT '5th percentile head vote correctness rate' CODEC(ZSTD(1)),
    `p50_head_vote_rate` Float32 COMMENT '50th percentile (median) head vote correctness rate' CODEC(ZSTD(1)),
    `p95_head_vote_rate` Float32 COMMENT '95th percentile head vote correctness rate' CODEC(ZSTD(1)),
    `stddev_head_vote_rate` Float32 COMMENT 'Standard deviation of head vote correctness rate' CODEC(ZSTD(1)),
    `upper_band_head_vote_rate` Float32 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_head_vote_rate` Float32 COMMENT 'Lower Bollinger band (avg - 2*stddev)' CODEC(ZSTD(1)),
    `moving_avg_head_vote_rate` Float32 COMMENT 'Moving average head vote correctness rate (7-day window)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_head_vote_correctness_rate_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS index_granularity = 8192
COMMENT 'Daily aggregated head vote correctness rate statistics'
