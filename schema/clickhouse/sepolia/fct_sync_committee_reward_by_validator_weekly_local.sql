CREATE TABLE sepolia.fct_sync_committee_reward_by_validator_weekly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `week_start_date` Date COMMENT 'The start of the week (Monday, UTC)' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Blocks of the week with a sync committee reward for the validator' CODEC(ZSTD(1)),
    `total` Int64 COMMENT 'Net sync committee reward in Gwei' CODEC(ZSTD(1)),
    `reward` Int64 COMMENT 'Sum of positive rewards in Gwei' CODEC(ZSTD(1)),
    `penalty` Int64 COMMENT 'Sum of negative rewards (missed votes) in Gwei' CODEC(ZSTD(1)),
    `penalized_slot_count` UInt32 COMMENT 'Blocks with a negative reward' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_sync_committee_reward_by_validator_weekly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfYear(week_start_date)
ORDER BY (validator_index, week_start_date)
SETTINGS index_granularity = 8192
COMMENT 'Sync committee rewards and penalties per validator per week'
