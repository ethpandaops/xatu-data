CREATE TABLE sepolia.fct_address_storage_slot_expired_top_100_by_contract_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `rank` UInt32 COMMENT 'Rank by expired storage slots (1=highest)' CODEC(DoubleDelta, ZSTD(1)),
    `contract_address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `expired_slots` UInt64 COMMENT 'Number of expired storage slots for this contract' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_address_storage_slot_expired_top_100_by_contract_local', '{replica}', updated_date_time)
PARTITION BY tuple()
ORDER BY rank
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Top 100 contracts by expired storage slots (not accessed in last 365 days)'
