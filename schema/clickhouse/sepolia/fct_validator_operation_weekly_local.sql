CREATE TABLE sepolia.fct_validator_operation_weekly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `week_start_date` Date COMMENT 'The start of the week (Monday, UTC)' CODEC(DoubleDelta, ZSTD(1)),
    `operation` LowCardinality(String) COMMENT 'One of deposit, top_up, withdrawal_partial, withdrawal_full, bls_to_execution_change, switch_to_compounding, consolidation, withdrawal_request, exit_request, voluntary_exit, slashing',
    `operation_count` UInt32 COMMENT 'Number of operations that took effect' CODEC(ZSTD(1)),
    `validator_count` UInt32 COMMENT 'Distinct validators in the week (pubkeys for deposits and top-ups)' CODEC(ZSTD(1)),
    `amount` Nullable(UInt64) COMMENT 'Gwei deposited, withdrawn, or accepted into the partial withdrawal queue. NULL for operations without an amount' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_validator_operation_weekly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfYear(week_start_date)
ORDER BY (week_start_date, operation)
SETTINGS index_granularity = 8192
COMMENT 'Weekly counts and amounts of validator operations that took effect'
