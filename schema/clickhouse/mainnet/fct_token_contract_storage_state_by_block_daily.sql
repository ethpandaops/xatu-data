CREATE TABLE mainnet.fct_token_contract_storage_state_by_block_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `token_standard` LowCardinality(String) COMMENT 'Token standard: erc20 or erc721' CODEC(ZSTD(1)),
    `active_slots` Int64 COMMENT 'Cumulative active storage slots owned by contracts of this standard at end of day' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_token_contract_storage_state_by_block_daily_local', cityHash64(day_start_date))
COMMENT 'Daily live storage slots owned by ERC20/ERC721 contracts, by token_standard'
