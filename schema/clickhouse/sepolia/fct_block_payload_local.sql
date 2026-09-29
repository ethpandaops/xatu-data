CREATE TABLE sepolia.fct_block_payload_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number of the block the payload belongs to' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The root of the beacon block the payload belongs to' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The beacon block version, e.g. gloas' CODEC(ZSTD(1)),
    `builder_index` UInt64 COMMENT 'Validator index of the builder, equal to the block proposer index for self-built payloads' CODEC(DoubleDelta, ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'The execution block hash of the payload' CODEC(ZSTD(1)),
    `parent_block_hash` FixedString(66) COMMENT 'The parent execution block hash' CODEC(ZSTD(1)),
    `value` UInt128 COMMENT 'The winning bid value in wei' CODEC(ZSTD(1)),
    `gas_limit` UInt64 COMMENT 'The gas limit committed to in the bid' CODEC(DoubleDelta, ZSTD(1)),
    `blob_kzg_commitment_count` UInt32 COMMENT 'Number of blob KZG commitments in the bid' CODEC(DoubleDelta, ZSTD(1)),
    `transactions_count` UInt32 COMMENT 'Number of transactions in the revealed payload' CODEC(DoubleDelta, ZSTD(1)),
    `transactions_total_bytes` UInt64 COMMENT 'Total bytes of transactions in the revealed payload' CODEC(DoubleDelta, ZSTD(1)),
    `transactions_total_gas_limit` UInt64 COMMENT 'Sum of per-transaction gas limits in the revealed payload' CODEC(DoubleDelta, ZSTD(1)),
    `blob_transactions_count` UInt32 COMMENT 'Number of type-3 blob transactions in the revealed payload' CODEC(DoubleDelta, ZSTD(1)),
    PROJECTION p_by_slot
    (
        SELECT *
        ORDER BY
            slot,
            block_root
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_block_payload_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, block_root)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Gloas (ePBS) per-block execution payload facts: the winning bid commitment joined with what the revealed envelope actually contained, replacing the pre-gloas execution columns that no longer exist on the beacon block'
