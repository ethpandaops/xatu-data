CREATE TABLE holesky.fct_validator_balance_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The start of the hour for this aggregation' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `start_epoch` UInt32 COMMENT 'First epoch in this hour for this validator' CODEC(DoubleDelta, ZSTD(1)),
    `end_epoch` UInt32 COMMENT 'Last epoch in this hour for this validator' CODEC(DoubleDelta, ZSTD(1)),
    `start_balance` Nullable(UInt64) COMMENT 'Balance at start of hour (first epoch) in Gwei' CODEC(T64, ZSTD(1)),
    `end_balance` Nullable(UInt64) COMMENT 'Balance at end of hour (last epoch) in Gwei' CODEC(T64, ZSTD(1)),
    `min_balance` Nullable(UInt64) COMMENT 'Minimum balance during the hour in Gwei' CODEC(T64, ZSTD(1)),
    `max_balance` Nullable(UInt64) COMMENT 'Maximum balance during the hour in Gwei' CODEC(T64, ZSTD(1)),
    `effective_balance` Nullable(UInt64) COMMENT 'Effective balance at end of hour in Gwei' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Validator status at end of hour',
    `slashed` Bool COMMENT 'Whether the validator was slashed (as of end of hour)',
    PROJECTION p_by_hour_start_date_time
    (
        SELECT *
        ORDER BY
            hour_start_date_time,
            validator_index
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_validator_balance_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY (validator_index, hour_start_date_time)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Hourly validator balance snapshots aggregated from per-epoch data'
