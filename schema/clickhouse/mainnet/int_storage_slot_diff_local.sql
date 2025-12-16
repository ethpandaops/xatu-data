CREATE TABLE mainnet.int_storage_slot_diff_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The storage slot key' CODEC(ZSTD(1)),
    `effective_bytes_from` UInt8 COMMENT 'Number of effective bytes in the first from_value of the block (0-32)' CODEC(ZSTD(1)),
    `effective_bytes_to` UInt8 COMMENT 'Number of effective bytes in the last to_value of the block (0-32)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_storage_slot_diff_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 5000000)
ORDER BY (block_number, address, slot_key)
SETTINGS index_granularity = 8192
COMMENT 'Storage slot diffs aggregated per block - stores effective bytes from first and last value per address/slot'
