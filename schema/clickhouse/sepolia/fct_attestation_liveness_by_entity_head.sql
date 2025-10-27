CREATE TABLE sepolia.fct_attestation_liveness_by_entity_head
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `entity` String COMMENT 'The entity (staking provider) associated with the validators, unknown if not mapped' CODEC(ZSTD(1)),
    `status` String COMMENT 'Attestation status: attested or missed' CODEC(ZSTD(1)),
    `attestation_count` UInt32 COMMENT 'Number of attestations for this entity/status combination' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_attestation_liveness_by_entity_head_local', cityHash64(slot))
COMMENT 'Attestation liveness aggregated by entity for the head chain. One or two rows per (slot, entity): one for attested, one for missed.'
