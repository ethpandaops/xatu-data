CREATE TABLE hoodi.fct_validator_effective_balance_by_credential_type_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The day (UTC)' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch of the snapshot: the last epoch of the day, or the latest epoch for today' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'Wall clock time when the snapshot epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `credential_type` LowCardinality(String) COMMENT 'Withdrawal credential prefix at the snapshot: 0x00, 0x01 or 0x02',
    `effective_balance_eth` UInt32 COMMENT 'Effective balance in whole ETH (effective balance moves in 1 ETH steps)' CODEC(ZSTD(1)),
    `validator_count` UInt32 COMMENT 'Active validators with this credential type and effective balance' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_validator_effective_balance_by_credential_type_daily_local', '{replica}', epoch)
PARTITION BY toStartOfYear(day_start_date)
ORDER BY (day_start_date, credential_type, effective_balance_eth)
SETTINGS index_granularity = 8192
COMMENT 'Histogram of active validators\\' effective balance by withdrawal credential type, one snapshot per day'
