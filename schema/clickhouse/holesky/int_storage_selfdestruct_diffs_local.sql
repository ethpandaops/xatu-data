CREATE TABLE holesky.int_storage_selfdestruct_diffs_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'Block where SELFDESTRUCT occurred' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'Transaction index within the block' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'Transaction hash of the SELFDESTRUCT' CODEC(ZSTD(1)),
    `internal_index` UInt32 COMMENT 'Internal index of the SELFDESTRUCT trace' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'Contract address that was selfdestructed' CODEC(ZSTD(1)),
    `slot` String COMMENT 'Storage slot key being cleared' CODEC(ZSTD(1)),
    `from_value` String COMMENT 'Value before clearing (last known value)' CODEC(ZSTD(1)),
    `to_value` String COMMENT 'Value after clearing (always 0x00...00)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_storage_selfdestruct_diffs_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 1000000)
ORDER BY (block_number, transaction_hash, internal_index, slot)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Synthetic storage diffs for selfdestructs that clear all storage slots'
