CREATE TABLE hoodi.fct_block_proposer_reward_by_validator_weekly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `week_start_date` Date COMMENT 'The start of the week (Monday, UTC)' CODEC(DoubleDelta, ZSTD(1)),
    `proposer_index` UInt32 COMMENT 'The validator index of the proposer' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Canonical blocks proposed' CODEC(ZSTD(1)),
    `total` UInt64 COMMENT 'Total consensus layer proposer reward in Gwei' CODEC(ZSTD(1)),
    `attestations` UInt64 COMMENT 'Reward for included attestations in Gwei' CODEC(ZSTD(1)),
    `sync_aggregate` UInt64 COMMENT 'Reward for included sync aggregates in Gwei' CODEC(ZSTD(1)),
    `proposer_slashings` UInt64 COMMENT 'Reward for included proposer slashings in Gwei' CODEC(ZSTD(1)),
    `attester_slashings` UInt64 COMMENT 'Reward for included attester slashings in Gwei' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_block_proposer_reward_by_validator_weekly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfYear(week_start_date)
ORDER BY (proposer_index, week_start_date)
SETTINGS index_granularity = 8192
COMMENT 'Consensus layer proposer rewards per proposer per week'
