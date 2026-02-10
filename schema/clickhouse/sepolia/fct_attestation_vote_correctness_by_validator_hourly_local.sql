CREATE TABLE sepolia.fct_attestation_vote_correctness_by_validator_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The start of the hour for this aggregation' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `total_duties` UInt32 COMMENT 'Total attestation duties for the validator in this hour' CODEC(ZSTD(1)),
    `attested_count` UInt32 COMMENT 'Number of attestations made' CODEC(ZSTD(1)),
    `missed_count` UInt32 COMMENT 'Number of attestations missed' CODEC(ZSTD(1)),
    `head_correct_count` UInt32 COMMENT 'Number of head votes that were correct' CODEC(ZSTD(1)),
    `target_correct_count` UInt32 COMMENT 'Number of target votes that were correct' CODEC(ZSTD(1)),
    `source_correct_count` UInt32 COMMENT 'Number of source votes that were correct' CODEC(ZSTD(1)),
    `avg_inclusion_distance` Nullable(Float32) COMMENT 'Average inclusion distance for attested slots. NULL if no attestations' CODEC(ZSTD(1)),
    PROJECTION p_by_hour_start_date_time
    (
        SELECT *
        ORDER BY
            hour_start_date_time,
            validator_index
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_attestation_vote_correctness_by_validator_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY (validator_index, hour_start_date_time)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Hourly aggregation of per-validator attestation vote correctness'
