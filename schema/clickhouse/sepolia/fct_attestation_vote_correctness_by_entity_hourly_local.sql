CREATE TABLE sepolia.fct_attestation_vote_correctness_by_entity_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `entity` LowCardinality(String) COMMENT 'Staking entity of the validators in dim_node, or unknown' CODEC(ZSTD(1)),
    `validator_count` UInt32 COMMENT 'Validators of the entity with attestation duties in the hour' CODEC(ZSTD(1)),
    `total_duties` UInt64 COMMENT 'Attestation duties' CODEC(ZSTD(1)),
    `attested_count` UInt64 COMMENT 'Attestations included on the finalized chain' CODEC(ZSTD(1)),
    `missed_count` UInt64 COMMENT 'Attestations missed: duties with no attestation included on the finalized chain' CODEC(ZSTD(1)),
    `head_correct_count` UInt64 COMMENT 'Head votes that were correct' CODEC(ZSTD(1)),
    `target_correct_count` UInt64 COMMENT 'Target votes that were correct' CODEC(ZSTD(1)),
    `source_correct_count` UInt64 COMMENT 'Source votes that were correct, from attestations seen on gossip' CODEC(ZSTD(1)),
    `avg_inclusion_distance` Nullable(Float64) COMMENT 'Mean inclusion distance in slots per included attestation, NULL when there were none' CODEC(ZSTD(1)),
    PROJECTION p_by_entity
    (
        SELECT *
        ORDER BY
            entity,
            hour_start_date_time
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_attestation_vote_correctness_by_entity_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY (hour_start_date_time, entity)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Hourly attestation liveness, vote correctness and inclusion per staking entity on the finalized chain. Duties are total_duties = attested_count + missed_count. Validators map to their current entity in dim_node, and validators it does not name are unknown, so the rows of an hour sum to the whole network'
