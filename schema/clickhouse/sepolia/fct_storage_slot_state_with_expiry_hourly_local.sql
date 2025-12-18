CREATE TABLE sepolia.fct_storage_slot_state_with_expiry_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `expiry_policy` LowCardinality(String) COMMENT 'Expiry policy identifier: 1m, 6m, 12m, 18m, 24m' CODEC(ZSTD(1)),
    `active_slots` Int64 COMMENT 'Cumulative count of active storage slots at end of hour (with expiry applied)' CODEC(ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Cumulative sum of effective bytes at end of hour (with expiry applied)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_storage_slot_state_with_expiry_hourly_local', '{replica}', updated_date_time)
PARTITION BY (expiry_policy, toStartOfMonth(hour_start_date_time))
ORDER BY (expiry_policy, hour_start_date_time)
SETTINGS index_granularity = 8192
COMMENT 'Storage slot state metrics with expiry policies aggregated by hour'
