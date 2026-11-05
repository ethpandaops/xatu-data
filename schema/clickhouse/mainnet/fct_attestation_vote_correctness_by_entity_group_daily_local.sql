CREATE TABLE mainnet.fct_attestation_vote_correctness_by_entity_group_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `entity_group` LowCardinality(String) COMMENT 'Group of staking entities run under one protocol: lido is every entity whose name contains lido (lido itself, the curated *_lido operators, the csm_operator*_lido Community Staking operators and the lidox* Simple DVT clusters)' CODEC(ZSTD(1)),
    `entity_count` UInt32 COMMENT 'Entities of the group with attestation duties in the day' CODEC(ZSTD(1)),
    `total_duties` UInt64 COMMENT 'Attestation duties' CODEC(ZSTD(1)),
    `attested_count` UInt64 COMMENT 'Attestations included on the finalized chain' CODEC(ZSTD(1)),
    `missed_count` UInt64 COMMENT 'Attestations missed: duties with no attestation included on the finalized chain' CODEC(ZSTD(1)),
    `head_correct_count` UInt64 COMMENT 'Head votes that were correct' CODEC(ZSTD(1)),
    `target_correct_count` UInt64 COMMENT 'Target votes that were correct' CODEC(ZSTD(1)),
    `source_correct_count` UInt64 COMMENT 'Source votes that were correct, from attestations seen on gossip' CODEC(ZSTD(1)),
    `avg_inclusion_distance` Nullable(Float64) COMMENT 'Mean inclusion distance in slots per included attestation, NULL when there were none' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_attestation_vote_correctness_by_entity_group_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, entity_group)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily attestation liveness, vote correctness and inclusion per entity group on the finalized chain: the sum of the member entities in fct_attestation_vote_correctness_by_entity_daily. Only entities in a group have rows'
