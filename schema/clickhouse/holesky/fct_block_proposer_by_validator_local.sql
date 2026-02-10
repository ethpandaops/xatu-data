CREATE TABLE holesky.fct_block_proposer_by_validator_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The validator index of the proposer' CODEC(ZSTD(1)),
    `pubkey` String COMMENT 'The public key of the proposer' CODEC(ZSTD(1)),
    `block_root` Nullable(String) COMMENT 'The beacon block root hash. NULL if missed' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Can be "canonical", "orphaned" or "missed"'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_block_proposer_by_validator_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (validator_index, slot_start_date_time)
SETTINGS index_granularity = 8192
COMMENT 'Block proposers re-indexed by validator for efficient validator lookups'
