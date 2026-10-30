CREATE TABLE sepolia.fct_validator_balance_weekly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `week_start_date` Date COMMENT 'The start of the week (Monday, UTC) for this aggregation' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `start_epoch` UInt32 COMMENT 'First epoch in this week for this validator' CODEC(DoubleDelta, ZSTD(1)),
    `end_epoch` UInt32 COMMENT 'Last epoch in this week for this validator' CODEC(DoubleDelta, ZSTD(1)),
    `start_balance` Nullable(UInt64) COMMENT 'Balance at start of week (first epoch) in Gwei' CODEC(T64, ZSTD(1)),
    `end_balance` Nullable(UInt64) COMMENT 'Balance at end of week (last epoch) in Gwei' CODEC(T64, ZSTD(1)),
    `min_balance` Nullable(UInt64) COMMENT 'Minimum balance during the week in Gwei' CODEC(T64, ZSTD(1)),
    `max_balance` Nullable(UInt64) COMMENT 'Maximum balance during the week in Gwei' CODEC(T64, ZSTD(1)),
    `effective_balance` Nullable(UInt64) COMMENT 'Effective balance at end of week in Gwei' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Validator status at end of week',
    `slashed` Bool COMMENT 'Whether the validator was slashed (as of end of week)'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_validator_balance_weekly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfYear(week_start_date)
ORDER BY (validator_index, week_start_date)
SETTINGS index_granularity = 8192
COMMENT 'Weekly validator balance snapshots aggregated from daily data'
