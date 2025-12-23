CREATE TABLE sepolia.fct_contract_storage_state_with_expiry_by_address_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `expiry_policy` LowCardinality(String) COMMENT 'Expiry policy identifier: 1m, 6m, 12m, 18m, 24m' CODEC(ZSTD(1)),
    `active_slots` Int64 COMMENT 'Active storage slots in this contract at end of day (0 if expired)' CODEC(ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Effective bytes at end of day (0 if expired)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_contract_storage_state_with_expiry_by_address_daily_local', cityHash64(address, expiry_policy, day_start_date))
COMMENT 'Contract-level expiry state metrics per address aggregated by day'
