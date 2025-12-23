CREATE TABLE hoodi.fct_contract_storage_state_with_expiry_by_address_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `expiry_policy` LowCardinality(String) COMMENT 'Expiry policy identifier: 1m, 6m, 12m, 18m, 24m' CODEC(ZSTD(1)),
    `active_slots` Int64 COMMENT 'Active storage slots in this contract at end of hour (0 if expired)' CODEC(ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Effective bytes at end of hour (0 if expired)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_contract_storage_state_with_expiry_by_address_hourly_local', '{replica}', updated_date_time)
PARTITION BY (expiry_policy, toStartOfMonth(hour_start_date_time))
ORDER BY (address, expiry_policy, hour_start_date_time)
SETTINGS index_granularity = 8192
COMMENT 'Contract-level expiry state metrics per address aggregated by hour'
