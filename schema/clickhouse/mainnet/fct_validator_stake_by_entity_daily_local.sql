CREATE TABLE mainnet.fct_validator_stake_by_entity_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The day (UTC)' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch of the snapshot: the last epoch of the day, or the latest epoch for today' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'Wall clock time when the snapshot epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `entity` String COMMENT 'Entity label from dim_node as it is today, or unknown' CODEC(ZSTD(1)),
    `credential_type` LowCardinality(String) COMMENT 'Withdrawal credential prefix at the snapshot: 0x00, 0x01 or 0x02',
    `active_validator_count` UInt32 COMMENT 'Active validators (active_ongoing, active_exiting, active_slashed)' CODEC(ZSTD(1)),
    `active_effective_balance` UInt64 COMMENT 'Sum of active validators\\' effective balance in Gwei (active stake)' CODEC(ZSTD(1)),
    `active_balance` UInt64 COMMENT 'Sum of active validators\\' balance in Gwei' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_validator_stake_by_entity_daily_local', '{replica}', epoch)
PARTITION BY toStartOfYear(day_start_date)
ORDER BY (day_start_date, entity, credential_type)
SETTINGS index_granularity = 8192
COMMENT 'Active validators and stake by entity and withdrawal credential type, one snapshot per day'
