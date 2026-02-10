CREATE TABLE sepolia.fct_validator_balance_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The start of the day for this aggregation' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `start_epoch` UInt32 COMMENT 'First epoch in this day for this validator' CODEC(DoubleDelta, ZSTD(1)),
    `end_epoch` UInt32 COMMENT 'Last epoch in this day for this validator' CODEC(DoubleDelta, ZSTD(1)),
    `start_balance` Nullable(UInt64) COMMENT 'Balance at start of day (first epoch) in Gwei' CODEC(T64, ZSTD(1)),
    `end_balance` Nullable(UInt64) COMMENT 'Balance at end of day (last epoch) in Gwei' CODEC(T64, ZSTD(1)),
    `min_balance` Nullable(UInt64) COMMENT 'Minimum balance during the day in Gwei' CODEC(T64, ZSTD(1)),
    `max_balance` Nullable(UInt64) COMMENT 'Maximum balance during the day in Gwei' CODEC(T64, ZSTD(1)),
    `effective_balance` Nullable(UInt64) COMMENT 'Effective balance at end of day in Gwei' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Validator status at end of day',
    `slashed` Bool COMMENT 'Whether the validator was slashed (as of end of day)'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_validator_balance_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (validator_index, day_start_date)
SETTINGS index_granularity = 8192
COMMENT 'Daily validator balance snapshots aggregated from per-epoch data'
