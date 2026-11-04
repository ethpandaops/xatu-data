CREATE TABLE hoodi.fct_execution_gas_limit_signalling_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `gas_limit_band_counts` Map(String, UInt32) COMMENT 'Map of gas limit band (1M increments) to validator count from rolling 7-day window' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_execution_gas_limit_signalling_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS index_granularity = 8192
COMMENT 'Daily gas limit signalling by validators, from their MEV relay validator registrations. For each UTC day, each validator counts once at the highest gas limit it registered in the 7 days ending that day, rounded up to a multiple of 1M gas. gas_limit_band_counts maps each band to its validator count. Validators that do not register with the relays xatu polls are not counted'
