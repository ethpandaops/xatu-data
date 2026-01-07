CREATE TABLE mainnet.dim_contract_owner
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `contract_address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `owner_key` Nullable(String) COMMENT 'Owner key identifier' CODEC(ZSTD(1)),
    `account_owner` Nullable(String) COMMENT 'Account owner of the contract' CODEC(ZSTD(1)),
    `contract_name` Nullable(String) COMMENT 'Name of the contract' CODEC(ZSTD(1)),
    `factory_contract` Nullable(String) COMMENT 'Factory contract or deployer address' CODEC(ZSTD(1)),
    `labels` Array(String) COMMENT 'Labels/categories (e.g., stablecoin, dex, circle)' CODEC(ZSTD(1)),
    `sources` Array(String) COMMENT 'Sources of the label data (e.g., growthepie, dune, eth-labels)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'dim_contract_owner_local', cityHash64(contract_address))
COMMENT 'Contract owner information from Dune Analytics, growthepie, and eth-labels for top storage slot contracts'
