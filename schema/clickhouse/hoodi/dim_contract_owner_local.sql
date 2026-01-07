CREATE TABLE hoodi.dim_contract_owner_local
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
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/dim_contract_owner_local', '{replica}', updated_date_time)
PARTITION BY tuple()
ORDER BY contract_address
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Contract owner information from Dune Analytics, growthepie, and eth-labels for top storage slot contracts'
