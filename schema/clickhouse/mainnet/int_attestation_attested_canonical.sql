CREATE TABLE mainnet.int_attestation_attested_canonical
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
    `inclusion_distance` UInt32 COMMENT 'The distance from the slot when the attestation was included' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'int_attestation_attested_canonical_local', cityHash64(slot_start_date_time, block_root, attesting_validator_index))
COMMENT 'Attested head of a block for the unfinalized chain.'
