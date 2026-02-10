CREATE TABLE mainnet.fct_attestation_vote_correctness_by_validator
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt64 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The start time of the slot' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `attested` Bool COMMENT 'Whether the validator attested in this slot',
    `head_correct` Nullable(Bool) COMMENT 'Whether the head vote was correct. NULL if not attested' CODEC(ZSTD(1)),
    `target_correct` Nullable(Bool) COMMENT 'Whether the target vote was correct. NULL if not attested' CODEC(ZSTD(1)),
    `source_correct` Nullable(Bool) COMMENT 'Whether the source vote was correct. NULL if not attested' CODEC(ZSTD(1)),
    `inclusion_distance` Nullable(UInt32) COMMENT 'Inclusion distance for the attestation. NULL if not attested' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_attestation_vote_correctness_by_validator_local', cityHash64(validator_index, slot_start_date_time))
COMMENT 'Per-slot attestation vote correctness by validator'
