CREATE TABLE mainnet.fct_validator_performance_by_entity_rolling
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `period` LowCardinality(String) COMMENT 'Rolling period: 24h (the last 24 complete hours), 7d, 30d, 90d or 1y (the last complete UTC days), or all (every day with data)' CODEC(ZSTD(1)),
    `entity` LowCardinality(String) COMMENT 'Staking entity of the validators in dim_node, or unknown' CODEC(ZSTD(1)),
    `period_start_date_time` DateTime COMMENT 'Start of the period, or of the data when it starts later' CODEC(ZSTD(1)),
    `period_end_date_time` DateTime COMMENT 'End of the period, exclusive' CODEC(ZSTD(1)),
    `total_duties` UInt64 COMMENT 'Attestation duties' CODEC(ZSTD(1)),
    `attested_count` UInt64 COMMENT 'Attestations included on the finalized chain' CODEC(ZSTD(1)),
    `missed_count` UInt64 COMMENT 'Attestations missed: duties with no attestation included on the finalized chain' CODEC(ZSTD(1)),
    `head_correct_count` UInt64 COMMENT 'Head votes that were correct' CODEC(ZSTD(1)),
    `target_correct_count` UInt64 COMMENT 'Target votes that were correct' CODEC(ZSTD(1)),
    `source_correct_count` UInt64 COMMENT 'Source votes that were correct, from attestations seen on gossip' CODEC(ZSTD(1)),
    `avg_inclusion_distance` Nullable(Float64) COMMENT 'Mean inclusion distance in slots per included attestation, NULL when there were none' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Canonical blocks proposed' CODEC(ZSTD(1)),
    `mev_block_count` UInt32 COMMENT 'Canonical blocks delivered by an MEV relay, the rest were built locally' CODEC(ZSTD(1)),
    `avg_mev_value_eth` Nullable(Float64) COMMENT 'Mean relay-reported value of the MEV blocks in ETH, NULL when there were none' CODEC(ZSTD(1)),
    `orphaned_block_count` UInt32 COMMENT 'Blocks proposed that did not make the finalized chain' CODEC(ZSTD(1)),
    `missed_slot_count` UInt32 COMMENT 'Slots the entity was scheduled to propose where no block was seen' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_validator_performance_by_entity_rolling_local', cityHash64(period, entity))
COMMENT 'Attestation and block proposal performance per staking entity over rolling periods, refreshed every 30 minutes: one row per period and entity with duties or proposals in it. 24h sums fct_attestation_vote_correctness_by_entity_hourly and fct_block_proposer_by_entity over the last 24 complete hours. The day periods sum fct_attestation_vote_correctness_by_entity_daily and fct_block_proposal_by_entity_daily over the last complete UTC days. The rows of a period sum to the whole network'
