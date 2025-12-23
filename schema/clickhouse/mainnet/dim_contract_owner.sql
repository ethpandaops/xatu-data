CREATE TABLE mainnet.dim_contract_owner
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `contract_address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `owner_key` Nullable(String) COMMENT 'Owner key identifier' CODEC(ZSTD(1)),
    `account_owner` Nullable(String) COMMENT 'Account owner of the contract' CODEC(ZSTD(1)),
    `contract_name` Nullable(String) COMMENT 'Name of the contract' CODEC(ZSTD(1)),
    `factory_contract` Nullable(String) COMMENT 'Factory contract or deployer address' CODEC(ZSTD(1)),
    `usage_category` Nullable(String) COMMENT 'Usage category (e.g., stablecoin, dex, trading)' CODEC(ZSTD(1)),
    `source` String COMMENT 'Source of the label data (dune or growthepie)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'dim_contract_owner_local', cityHash64(contract_address))
COMMENT 'Contract owner information from Dune Analytics and growthepie for top storage slot contracts'
