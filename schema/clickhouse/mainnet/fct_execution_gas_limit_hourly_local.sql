CREATE TABLE mainnet.fct_execution_gas_limit_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the UTC hour. The first row is the hour of block 1, never 1970-01-01 (the mainnet genesis block has timestamp 0)' CODEC(DoubleDelta, ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of canonical blocks of this network in this hour, genesis excluded' CODEC(ZSTD(1)),
    `total_gas_limit` UInt64 COMMENT 'Total gas limit in this hour' CODEC(ZSTD(1)),
    `avg_gas_limit` UInt64 COMMENT 'Average gas limit per block' CODEC(ZSTD(1)),
    `min_gas_limit` UInt64 COMMENT 'Minimum gas limit in a block' CODEC(ZSTD(1)),
    `max_gas_limit` UInt64 COMMENT 'Maximum gas limit in a block' CODEC(ZSTD(1)),
    `p05_gas_limit` UInt64 COMMENT '5th percentile gas limit' CODEC(ZSTD(1)),
    `p50_gas_limit` UInt64 COMMENT '50th percentile (median) gas limit' CODEC(ZSTD(1)),
    `p95_gas_limit` UInt64 COMMENT '95th percentile gas limit' CODEC(ZSTD(1)),
    `stddev_gas_limit` UInt64 COMMENT 'Standard deviation of gas limit' CODEC(ZSTD(1)),
    `upper_band_gas_limit` UInt64 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_gas_limit` Int64 COMMENT 'Lower Bollinger band (avg - 2*stddev), can be negative during high volatility' CODEC(ZSTD(1)),
    `moving_avg_gas_limit` UInt64 COMMENT 'Moving average gas limit (6-hour window)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_execution_gas_limit_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY hour_start_date_time
SETTINGS index_granularity = 8192
COMMENT 'Gas limit per canonical block of this network, aggregated by UTC hour, with percentiles, Bollinger bands and a 6-hour moving average. Starts at block 1, the genesis block is excluded'
