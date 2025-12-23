CREATE TABLE sepolia.fct_storage_slot_state_with_expiry_by_address_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `expiry_policy` LowCardinality(String) COMMENT 'Expiry policy identifier: 1m, 6m, 12m, 18m, 24m' CODEC(ZSTD(1)),
    `active_slots` Int64 COMMENT 'Cumulative count of active storage slots at end of day (with expiry applied)' CODEC(ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Cumulative sum of effective bytes at end of day (with expiry applied)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_storage_slot_state_with_expiry_by_address_daily_local', '{replica}', updated_date_time)
PARTITION BY (expiry_policy, toYYYYMM(day_start_date))
ORDER BY (address, expiry_policy, day_start_date)
SETTINGS index_granularity = 8192
COMMENT 'Storage slot state metrics per address with expiry policies aggregated by day'
