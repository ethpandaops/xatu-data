CREATE TABLE hoodi.fct_storage_slot_top_100_by_slots_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `rank` UInt32 COMMENT 'Rank by active slots (1=highest)' CODEC(DoubleDelta, ZSTD(1)),
    `contract_address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `active_slots` Int64 COMMENT 'Number of active storage slots for this contract' CODEC(ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Effective bytes of storage for this contract' CODEC(ZSTD(1)),
    `owner_key` Nullable(String) COMMENT 'Owner key identifier' CODEC(ZSTD(1)),
    `account_owner` Nullable(String) COMMENT 'Account owner of the contract' CODEC(ZSTD(1)),
    `contract_name` Nullable(String) COMMENT 'Name of the contract' CODEC(ZSTD(1)),
    `factory_contract` Nullable(String) COMMENT 'Factory contract or deployer address' CODEC(ZSTD(1)),
    `usage_category` Nullable(String) COMMENT 'Usage category (e.g., stablecoin, dex, trading)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_storage_slot_top_100_by_slots_local', '{replica}', updated_date_time)
PARTITION BY tuple()
ORDER BY rank
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Top 100 contracts by active storage slot count'
