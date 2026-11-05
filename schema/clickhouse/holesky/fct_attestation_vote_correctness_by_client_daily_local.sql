CREATE TABLE holesky.fct_attestation_vote_correctness_by_client_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `layer` LowCardinality(String) COMMENT 'Client layer: consensus or execution' CODEC(ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Client of the validator most recent identifying graffiti in the 365 days before the end of the day, or unknown' CODEC(ZSTD(1)),
    `validator_count` UInt32 COMMENT 'Validators with attestation duties in the day mapped to this client' CODEC(ZSTD(1)),
    `total_duties` UInt64 COMMENT 'Attestation duties' CODEC(ZSTD(1)),
    `attested_count` UInt64 COMMENT 'Attestations included on chain' CODEC(ZSTD(1)),
    `missed_count` UInt64 COMMENT 'Attestations missed' CODEC(ZSTD(1)),
    `head_correct_count` UInt64 COMMENT 'Head votes that were correct' CODEC(ZSTD(1)),
    `target_correct_count` UInt64 COMMENT 'Target votes that were correct' CODEC(ZSTD(1)),
    `source_correct_count` UInt64 COMMENT 'Source votes that were correct, from attestations seen on gossip' CODEC(ZSTD(1)),
    `avg_inclusion_distance` Nullable(Float64) COMMENT 'Mean inclusion distance per included attestation, NULL when there were none' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_attestation_vote_correctness_by_client_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, layer, client)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily attestation vote correctness and inclusion per consensus and execution client. Validators map to the clients of their most recent identifying graffiti (a proposed block naming the client) in the 365 days before the end of the day. Only validators that proposed with identifying graffiti are covered, the rest are the unknown client.'
