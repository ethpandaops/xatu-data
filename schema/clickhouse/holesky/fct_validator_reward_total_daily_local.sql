CREATE TABLE holesky.fct_validator_reward_total_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The day (UTC)' CODEC(DoubleDelta, ZSTD(1)),
    `attesting_validator_count` UInt32 COMMENT 'Validators with an attestation reward on the day' CODEC(ZSTD(1)),
    `attestation_head` Int64 COMMENT 'Head vote rewards in Gwei' CODEC(ZSTD(1)),
    `attestation_target` Int64 COMMENT 'Target vote rewards in Gwei' CODEC(ZSTD(1)),
    `attestation_source` Int64 COMMENT 'Source vote rewards in Gwei' CODEC(ZSTD(1)),
    `attestation_inclusion_delay` Int64 DEFAULT 0 COMMENT 'Inclusion delay rewards in Gwei (phase0 only, 0 from Altair)' CODEC(ZSTD(1)),
    `attestation_inactivity` Int64 COMMENT 'Inactivity penalties in Gwei' CODEC(ZSTD(1)),
    `attestation_total` Int64 COMMENT 'Net attestation rewards in Gwei' CODEC(ZSTD(1)),
    `attestation_penalty` Int64 COMMENT 'Negative attestation components in Gwei' CODEC(ZSTD(1)),
    `sync_committee_reward` Int64 COMMENT 'Positive sync committee rewards in Gwei' CODEC(ZSTD(1)),
    `sync_committee_penalty` Int64 COMMENT 'Sync committee penalties in Gwei' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Canonical blocks on the day' CODEC(ZSTD(1)),
    `proposer_total` UInt64 COMMENT 'Consensus layer proposer rewards in Gwei' CODEC(ZSTD(1)),
    `proposer_attestations` UInt64 COMMENT 'Proposer rewards for attestations in Gwei' CODEC(ZSTD(1)),
    `proposer_sync_aggregate` UInt64 COMMENT 'Proposer rewards for sync aggregates in Gwei' CODEC(ZSTD(1)),
    `proposer_slashings` UInt64 COMMENT 'Proposer rewards for slashings in Gwei' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_validator_reward_total_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfYear(day_start_date)
ORDER BY day_start_date
SETTINGS index_granularity = 8192
COMMENT 'Network-wide consensus layer rewards and penalties per day'
