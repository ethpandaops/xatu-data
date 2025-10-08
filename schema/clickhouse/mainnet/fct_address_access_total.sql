CREATE TABLE mainnet.fct_address_access_total
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `total_accounts` UInt64 COMMENT 'Total number of accounts accessed in last 365 days' CODEC(ZSTD(1)),
    `expired_accounts` UInt64 COMMENT 'Number of expired accounts (not accessed in last 365 days)' CODEC(ZSTD(1)),
    `total_contract_accounts` UInt64 COMMENT 'Total number of contract accounts accessed in last 365 days' CODEC(ZSTD(1)),
    `expired_contracts` UInt64 COMMENT 'Number of expired contracts (not accessed in last 365 days)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_address_access_total_local', rand())
COMMENT 'Address access totals and expiry statistics'
