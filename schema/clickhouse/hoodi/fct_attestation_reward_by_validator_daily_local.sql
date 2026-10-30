CREATE TABLE hoodi.fct_attestation_reward_by_validator_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The day (UTC)' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `epoch_count` UInt32 COMMENT 'Epochs of the day the validator was active (had an attestation reward)' CODEC(ZSTD(1)),
    `head` Int64 COMMENT 'Head vote reward in Gwei' CODEC(ZSTD(1)),
    `target` Int64 COMMENT 'Target vote reward in Gwei (negative when penalised)' CODEC(ZSTD(1)),
    `source` Int64 COMMENT 'Source vote reward in Gwei (negative when penalised)' CODEC(ZSTD(1)),
    `inclusion_delay` Int64 DEFAULT 0 COMMENT 'Inclusion delay reward in Gwei (phase0 only, 0 from Altair)' CODEC(ZSTD(1)),
    `inactivity` Int64 COMMENT 'Inactivity penalty in Gwei' CODEC(ZSTD(1)),
    `total` Int64 COMMENT 'head + target + source + inclusion_delay + inactivity in Gwei' CODEC(ZSTD(1)),
    `penalty` Int64 COMMENT 'Sum of the negative components in Gwei' CODEC(ZSTD(1)),
    `penalized_epoch_count` UInt32 COMMENT 'Epochs with any negative component' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_attestation_reward_by_validator_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfYear(day_start_date)
ORDER BY (validator_index, day_start_date)
SETTINGS index_granularity = 8192
COMMENT 'Attestation rewards and penalties per validator per day'
