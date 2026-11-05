CREATE TABLE sepolia.fct_execution_gas_used_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the UTC hour. The first row is the hour of block 1, never 1970-01-01 (the mainnet genesis block has timestamp 0)' CODEC(DoubleDelta, ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of canonical blocks of this network in this hour, genesis excluded' CODEC(ZSTD(1)),
    `total_gas_used` UInt64 COMMENT 'Total gas used in this hour' CODEC(ZSTD(1)),
    `cumulative_gas_used` UInt64 COMMENT 'Cumulative gas used since genesis' CODEC(ZSTD(1)),
    `avg_gas_used` UInt64 COMMENT 'Average gas used per block' CODEC(ZSTD(1)),
    `min_gas_used` UInt64 COMMENT 'Minimum gas used in a block' CODEC(ZSTD(1)),
    `max_gas_used` UInt64 COMMENT 'Maximum gas used in a block' CODEC(ZSTD(1)),
    `p05_gas_used` UInt64 COMMENT '5th percentile gas used' CODEC(ZSTD(1)),
    `p50_gas_used` UInt64 COMMENT '50th percentile (median) gas used' CODEC(ZSTD(1)),
    `p95_gas_used` UInt64 COMMENT '95th percentile gas used' CODEC(ZSTD(1)),
    `stddev_gas_used` UInt64 COMMENT 'Standard deviation of gas used' CODEC(ZSTD(1)),
    `upper_band_gas_used` UInt64 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_gas_used` Int64 COMMENT 'Lower Bollinger band (avg - 2*stddev), can be negative during high volatility' CODEC(ZSTD(1)),
    `moving_avg_gas_used` UInt64 COMMENT 'Moving average gas used (6-hour window)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_execution_gas_used_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY hour_start_date_time
SETTINGS index_granularity = 8192
COMMENT 'Gas used per canonical block of this network, aggregated by UTC hour, with percentiles, Bollinger bands and a 6-hour moving average. Starts at block 1, the genesis block is excluded'
