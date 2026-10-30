CREATE TABLE hoodi.fct_sync_committee_reward_by_validator_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `reward` Int64 COMMENT 'Sync committee reward in Gwei (negative for a missed vote)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_sync_committee_reward_by_validator_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (validator_index, slot_start_date_time)
SETTINGS index_granularity = 8192
COMMENT 'Sync committee reward of each validator in each block'
