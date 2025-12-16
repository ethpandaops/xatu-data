CREATE TABLE hoodi.fct_address_storage_slot_top_100_by_contract_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `rank` UInt32 COMMENT 'Rank by total storage slots (1=highest)' CODEC(DoubleDelta, ZSTD(1)),
    `contract_address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `total_storage_slots` UInt64 COMMENT 'Total number of storage slots for this contract' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_address_storage_slot_top_100_by_contract_local', '{replica}', updated_date_time)
PARTITION BY tuple()
ORDER BY rank
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Top 100 contracts by storage slots'
