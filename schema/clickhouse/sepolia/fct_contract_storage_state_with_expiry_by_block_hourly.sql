CREATE TABLE sepolia.fct_contract_storage_state_with_expiry_by_block_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `expiry_policy` LowCardinality(String) COMMENT 'Expiry policy identifier: 1m, 6m, 12m, 18m, 24m' CODEC(ZSTD(1)),
    `active_slots` Int64 COMMENT 'Total active storage slots at end of hour (with expiry applied)' CODEC(ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Total effective bytes at end of hour (with expiry applied)' CODEC(ZSTD(1)),
    `active_contracts` Int64 COMMENT 'Count of contracts with active_slots > 0 at end of hour' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_contract_storage_state_with_expiry_by_block_hourly_local', cityHash64(expiry_policy, hour_start_date_time))
COMMENT 'Contract-level expiry state metrics aggregated by hour'
