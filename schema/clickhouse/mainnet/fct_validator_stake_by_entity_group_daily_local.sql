CREATE TABLE mainnet.fct_validator_stake_by_entity_group_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The day (UTC)' CODEC(DoubleDelta, ZSTD(1)),
    `entity_group` LowCardinality(String) COMMENT 'Group of staking entities run under one protocol: lido is every entity whose name contains lido (lido itself, the curated *_lido operators, the csm_operator*_lido Community Staking operators and the lidox* Simple DVT clusters)' CODEC(ZSTD(1)),
    `credential_type` LowCardinality(String) COMMENT 'Withdrawal credential prefix at the snapshot: 0x00, 0x01 or 0x02' CODEC(ZSTD(1)),
    `entity_count` UInt32 COMMENT 'Entities of the group with active validators of this credential type on the day' CODEC(ZSTD(1)),
    `active_validator_count` UInt32 COMMENT 'Active validators (active_ongoing, active_exiting, active_slashed)' CODEC(ZSTD(1)),
    `active_effective_balance` UInt64 COMMENT 'Sum of active validators\\' effective balance in Gwei (active stake)' CODEC(ZSTD(1)),
    `active_balance` UInt64 COMMENT 'Sum of active validators\\' balance in Gwei' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_validator_stake_by_entity_group_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfYear(day_start_date)
ORDER BY (day_start_date, entity_group, credential_type)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Active validators and stake per entity group and withdrawal credential type, one snapshot per day: the sum of the member entities in fct_validator_stake_by_entity_daily. Only entities in a group have rows'
