CREATE TABLE hoodi.int_attestation_first_seen_aggregate_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `attesting_validator_index` UInt32 COMMENT 'The index of the validator attesting' CODEC(ZSTD(1)),
    `committee_index` LowCardinality(String) COMMENT 'The committee index the validator is assigned to',
    `block_root` String COMMENT 'The head vote (beacon block root) from this aggregate' CODEC(ZSTD(1)),
    `source_epoch` UInt32 COMMENT 'Source checkpoint epoch from this aggregate' CODEC(DoubleDelta, ZSTD(1)),
    `source_root` String COMMENT 'Source checkpoint root from this aggregate' CODEC(ZSTD(1)),
    `target_epoch` UInt32 COMMENT 'Target checkpoint epoch from this aggregate' CODEC(DoubleDelta, ZSTD(1)),
    `target_root` String COMMENT 'Target checkpoint root from this aggregate' CODEC(ZSTD(1)),
    `seen_slot_start_diff` UInt32 COMMENT 'The earliest time (ms after slot start) the validator was seen attesting this specific vote inside an aggregate' CODEC(DoubleDelta, ZSTD(1)),
    `source` LowCardinality(String) COMMENT 'The first source this aggregate was observed from (beacon_api or libp2p)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_attestation_first_seen_aggregate_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, attesting_validator_index, block_root, source_epoch, source_root, target_epoch, target_root)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Each row is one (slot, validator, vote) pair seen inside an aggregate attestation. Two rows for the same (slot, validator) indicate slashable double attestation.'
