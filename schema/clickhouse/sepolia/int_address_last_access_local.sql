CREATE TABLE sepolia.int_address_last_access_local
(
    `address` String COMMENT 'The address of the account' CODEC(ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number of the last access' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_address_last_access_local', '{replica}', block_number)
PARTITION BY cityHash64(address) % 16
ORDER BY address
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Table for accounts last access data'
