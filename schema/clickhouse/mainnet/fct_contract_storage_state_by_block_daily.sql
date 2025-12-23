CREATE TABLE mainnet.fct_contract_storage_state_by_block_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `active_slots` Int64 COMMENT 'Cumulative count of active storage slots at end of day' CODEC(ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Cumulative sum of effective bytes at end of day' CODEC(ZSTD(1)),
    `active_contracts` Int64 COMMENT 'Cumulative count of contracts with at least one active slot at end of day' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_contract_storage_state_by_block_daily_local', cityHash64(day_start_date))
COMMENT 'Contract storage state metrics aggregated by day'
