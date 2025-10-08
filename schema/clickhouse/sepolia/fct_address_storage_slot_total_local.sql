CREATE TABLE sepolia.fct_address_storage_slot_total_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `total_storage_slots` UInt64 COMMENT 'Total number of storage slots accessed in last 365 days' CODEC(ZSTD(1)),
    `expired_storage_slots` UInt64 COMMENT 'Number of expired storage slots (not accessed in last 365 days)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_address_storage_slot_total_local', '{replica}', updated_date_time)
PARTITION BY tuple()
ORDER BY updated_date_time
SETTINGS index_granularity = 8192
COMMENT 'Storage slot totals and expiry statistics'
