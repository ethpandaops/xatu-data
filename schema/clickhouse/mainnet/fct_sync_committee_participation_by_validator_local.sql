CREATE TABLE mainnet.fct_sync_committee_participation_by_validator_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt64 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The start time of the slot' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'Index of the validator' CODEC(ZSTD(1)),
    `participated` Bool COMMENT 'Whether the validator participated in sync committee for this slot'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_sync_committee_participation_by_validator_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (validator_index, slot_start_date_time)
SETTINGS index_granularity = 8192
COMMENT 'Per-slot sync committee participation by validator'
