CREATE TABLE sepolia.fct_opcode_ops_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of blocks in this day' CODEC(ZSTD(1)),
    `total_opcode_count` UInt64 COMMENT 'Total opcode executions in this day' CODEC(ZSTD(1)),
    `total_gas` UInt64 COMMENT 'Total gas consumed by opcodes in this day' CODEC(ZSTD(1)),
    `total_seconds` UInt32 COMMENT 'Total actual seconds covered by blocks (sum of block time gaps)' CODEC(ZSTD(1)),
    `avg_ops` Float32 COMMENT 'Average opcodes per second using actual block time gaps' CODEC(ZSTD(1)),
    `min_ops` Float32 COMMENT 'Minimum per-block ops/sec' CODEC(ZSTD(1)),
    `max_ops` Float32 COMMENT 'Maximum per-block ops/sec' CODEC(ZSTD(1)),
    `p05_ops` Float32 COMMENT '5th percentile ops/sec' CODEC(ZSTD(1)),
    `p50_ops` Float32 COMMENT '50th percentile (median) ops/sec' CODEC(ZSTD(1)),
    `p95_ops` Float32 COMMENT '95th percentile ops/sec' CODEC(ZSTD(1)),
    `stddev_ops` Float32 COMMENT 'Standard deviation of ops/sec' CODEC(ZSTD(1)),
    `upper_band_ops` Float32 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_ops` Float32 COMMENT 'Lower Bollinger band (avg - 2*stddev)' CODEC(ZSTD(1)),
    `moving_avg_ops` Float32 COMMENT 'Moving average ops/sec (7-day window)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_opcode_ops_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS index_granularity = 8192
COMMENT 'Daily aggregated opcode execution rate statistics with percentiles, Bollinger bands, and moving averages'
