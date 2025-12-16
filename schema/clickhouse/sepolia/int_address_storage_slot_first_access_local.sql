CREATE TABLE sepolia.int_address_storage_slot_first_access_local
(
    `address` String COMMENT 'The address of the account' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The slot key of the storage' CODEC(ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number of the first access' CODEC(ZSTD(1)),
    `value` String COMMENT 'The value of the storage' CODEC(ZSTD(1)),
    `version` UInt32 DEFAULT 4294967295 - block_number COMMENT 'Version for this address + slot key, for internal use in clickhouse to keep first access' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_address_storage_slot_first_access_local', '{replica}', version)
PARTITION BY cityHash64(address) % 16
ORDER BY (address, slot_key)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Table for storage first access data'
