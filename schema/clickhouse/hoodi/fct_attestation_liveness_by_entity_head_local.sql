CREATE TABLE hoodi.fct_attestation_liveness_by_entity_head_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `entity` String COMMENT 'The entity (staking provider) associated with the validators, unknown if not mapped' CODEC(ZSTD(1)),
    `status` String COMMENT 'Attestation status: attested or missed' CODEC(ZSTD(1)),
    `attestation_count` UInt32 COMMENT 'Number of attestations for this entity/status combination' CODEC(ZSTD(1)),
    PROJECTION p_by_slot
    (
        SELECT *
        ORDER BY slot
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_attestation_liveness_by_entity_head_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, entity, status)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Attestation liveness aggregated by entity for the head chain. One or two rows per (slot, entity): one for attested, one for missed.'
