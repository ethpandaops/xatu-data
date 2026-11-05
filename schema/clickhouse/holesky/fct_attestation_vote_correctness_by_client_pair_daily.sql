CREATE TABLE holesky.fct_attestation_vote_correctness_by_client_pair_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `consensus_client` LowCardinality(String) COMMENT 'Consensus client named by the graffiti, or unknown' CODEC(ZSTD(1)),
    `execution_client` LowCardinality(String) COMMENT 'Execution client named by the graffiti, or unknown' CODEC(ZSTD(1)),
    `validator_count` UInt32 COMMENT 'Validators with attestation duties in the day mapped to this client' CODEC(ZSTD(1)),
    `total_duties` UInt64 COMMENT 'Attestation duties' CODEC(ZSTD(1)),
    `attested_count` UInt64 COMMENT 'Attestations included on chain' CODEC(ZSTD(1)),
    `missed_count` UInt64 COMMENT 'Attestations missed' CODEC(ZSTD(1)),
    `head_correct_count` UInt64 COMMENT 'Head votes that were correct' CODEC(ZSTD(1)),
    `target_correct_count` UInt64 COMMENT 'Target votes that were correct' CODEC(ZSTD(1)),
    `source_correct_count` UInt64 COMMENT 'Source votes that were correct, from attestations seen on gossip' CODEC(ZSTD(1)),
    `avg_inclusion_distance` Nullable(Float64) COMMENT 'Mean inclusion distance per included attestation, NULL when there were none' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_attestation_vote_correctness_by_client_pair_daily_local', cityHash64(day_start_date, consensus_client, execution_client))
COMMENT 'Daily attestation vote correctness and inclusion per consensus and execution client pair. Validators map to the pair of their most recent graffiti naming either client in the 365 days before the end of the day, a side it does not name being unknown. Validators that never proposed with identifying graffiti are unknown/unknown.'
