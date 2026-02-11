CREATE TABLE mainnet.fct_proposer_reward_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of MEV relay blocks in this day' CODEC(ZSTD(1)),
    `total_reward_eth` Float64 COMMENT 'Total proposer reward in ETH' CODEC(ZSTD(1)),
    `avg_reward_eth` Float64 COMMENT 'Average proposer reward in ETH' CODEC(ZSTD(1)),
    `min_reward_eth` Float64 COMMENT 'Minimum proposer reward in ETH' CODEC(ZSTD(1)),
    `max_reward_eth` Float64 COMMENT 'Maximum proposer reward in ETH' CODEC(ZSTD(1)),
    `p05_reward_eth` Float64 COMMENT '5th percentile proposer reward' CODEC(ZSTD(1)),
    `p50_reward_eth` Float64 COMMENT '50th percentile (median) proposer reward' CODEC(ZSTD(1)),
    `p95_reward_eth` Float64 COMMENT '95th percentile proposer reward' CODEC(ZSTD(1)),
    `stddev_reward_eth` Float64 COMMENT 'Standard deviation of proposer reward' CODEC(ZSTD(1)),
    `upper_band_reward_eth` Float64 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_reward_eth` Float64 COMMENT 'Lower Bollinger band (avg - 2*stddev)' CODEC(ZSTD(1)),
    `moving_avg_reward_eth` Float64 COMMENT 'Moving average proposer reward (7-day window)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_proposer_reward_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS index_granularity = 8192
COMMENT 'Daily aggregated MEV proposer reward statistics with percentiles, Bollinger bands, and moving averages'
