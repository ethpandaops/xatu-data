CREATE TABLE sepolia.int_attestation_attested_head_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `source_epoch` UInt32 COMMENT 'The source epoch number in the attestation group',
    `source_epoch_start_date_time` DateTime COMMENT 'The wall clock time when the source epoch started',
    `source_root` FixedString(66) COMMENT 'The source beacon block root hash in the attestation group',
    `target_epoch` UInt32 COMMENT 'The target epoch number in the attestation group',
    `target_epoch_start_date_time` DateTime COMMENT 'The wall clock time when the target epoch started',
    `target_root` FixedString(66) COMMENT 'The target beacon block root hash in the attestation group',
    `block_root` String COMMENT 'The beacon block root hash' CODEC(ZSTD(1)),
    `attesting_validator_index` UInt32 COMMENT 'The index of the validator attesting' CODEC(ZSTD(1)),
    `propagation_distance` UInt32 COMMENT 'The distance from the slot when the attestation was propagated. 0 means the attestation was propagated within the same slot as its duty was assigned, 1 means the attestation was propagated within the next slot, etc.' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_attestation_attested_head_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, block_root, attesting_validator_index)
SETTINGS index_granularity = 8192
COMMENT 'Attested head of a block for the unfinalized chain.'
