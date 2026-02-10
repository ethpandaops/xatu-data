CREATE TABLE holesky.fct_attestation_vote_correctness_by_validator_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The start of the day for this aggregation' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `total_duties` UInt32 COMMENT 'Total attestation duties for the validator in this day' CODEC(ZSTD(1)),
    `attested_count` UInt32 COMMENT 'Number of attestations made' CODEC(ZSTD(1)),
    `missed_count` UInt32 COMMENT 'Number of attestations missed' CODEC(ZSTD(1)),
    `head_correct_count` UInt32 COMMENT 'Number of head votes that were correct' CODEC(ZSTD(1)),
    `target_correct_count` UInt32 COMMENT 'Number of target votes that were correct' CODEC(ZSTD(1)),
    `source_correct_count` UInt32 COMMENT 'Number of source votes that were correct' CODEC(ZSTD(1)),
    `avg_inclusion_distance` Nullable(Float32) COMMENT 'Average inclusion distance for attested slots. NULL if no attestations' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_attestation_vote_correctness_by_validator_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (validator_index, day_start_date)
SETTINGS index_granularity = 8192
COMMENT 'Daily aggregation of per-validator attestation vote correctness'
