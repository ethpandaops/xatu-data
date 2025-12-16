CREATE TABLE hoodi.fct_attestation_correctness_by_validator_head
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `attesting_validator_index` UInt32 COMMENT 'The index of the validator attesting' CODEC(ZSTD(1)),
    `block_root` Nullable(String) COMMENT 'The beacon block root hash that was attested, null means the attestation was missed' CODEC(ZSTD(1)),
    `slot_distance` Nullable(UInt32) COMMENT 'The distance from the slot to the attested block. If the attested block is the same as the slot, the distance is 0, if the attested block is the previous slot, the distance is 1, etc. If null, the attestation was missed, the block was orphaned and never seen by a sentry or the block was more than 64 slots ago' CODEC(DoubleDelta, ZSTD(1)),
    `propagation_distance` Nullable(UInt32) COMMENT 'The distance from the slot when the attestation was propagated. 0 means the attestation was propagated within the same slot as its duty was assigned, 1 means the attestation was propagated within the next slot, etc.' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_attestation_correctness_by_validator_head_local', cityHash64(slot_start_date_time, attesting_validator_index))
COMMENT 'Attestation correctness by validator for the finalized chain'
