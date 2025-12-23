CREATE TABLE hoodi.fct_storage_slot_top_100_by_bytes_with_expiry
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `expiry_policy` LowCardinality(String) COMMENT 'Expiry policy identifier: 1m, 6m, 12m, 18m, 24m' CODEC(ZSTD(1)),
    `rank` UInt32 COMMENT 'Rank by effective bytes within expiry policy (1=highest)' CODEC(DoubleDelta, ZSTD(1)),
    `contract_address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Effective bytes of storage for this contract (with expiry applied)' CODEC(ZSTD(1)),
    `active_slots` Int64 COMMENT 'Number of active storage slots for this contract (with expiry applied)' CODEC(ZSTD(1)),
    `owner_key` Nullable(String) COMMENT 'Owner key identifier' CODEC(ZSTD(1)),
    `account_owner` Nullable(String) COMMENT 'Account owner of the contract' CODEC(ZSTD(1)),
    `contract_name` Nullable(String) COMMENT 'Name of the contract' CODEC(ZSTD(1)),
    `factory_contract` Nullable(String) COMMENT 'Factory contract or deployer address' CODEC(ZSTD(1)),
    `usage_category` Nullable(String) COMMENT 'Usage category (e.g., stablecoin, dex, trading)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_storage_slot_top_100_by_bytes_with_expiry_local', cityHash64(expiry_policy, rank))
COMMENT 'Top 100 contracts by effective storage bytes per expiry policy'
