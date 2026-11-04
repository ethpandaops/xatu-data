CREATE TABLE hoodi.int_block_blob_count_canonical_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The beacon block root hash' CODEC(ZSTD(1)),
    `blob_count` UInt32 COMMENT 'The number of blobs in the block, from its execution payload blob gas, or its blob sidecars from Gloas onwards' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_block_blob_count_canonical_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, block_root)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Blob count of every canonical block that carries blobs, from its execution payload blob gas (blob gas used over 131072), or from its blob sidecars when the beacon block has no execution payload (Gloas onwards)'
