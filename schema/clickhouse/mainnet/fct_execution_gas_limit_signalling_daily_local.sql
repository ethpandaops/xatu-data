CREATE TABLE mainnet.fct_execution_gas_limit_signalling_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `gas_limit_band_counts` Map(String, UInt32) COMMENT 'Map of gas limit band (1M increments) to validator count from rolling 7-day window' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_execution_gas_limit_signalling_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS index_granularity = 8192
COMMENT 'Daily snapshots of validator gas limit signalling using rolling 7-day window'
