CREATE TABLE default.canonical_beacon_block_attester_slashing
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The root hash of the beacon block' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The version of the beacon block',
    `attestation_1_attesting_indices` Array(UInt32) COMMENT 'The attesting indices from the first attestation in the slashing payload' CODEC(ZSTD(1)),
    `attestation_1_signature` String COMMENT 'The signature from the first attestation in the slashing payload' CODEC(ZSTD(1)),
    `attestation_1_data_beacon_block_root` FixedString(66) COMMENT 'The beacon block root from the first attestation in the slashing payload' CODEC(ZSTD(1)),
    `attestation_1_data_slot` UInt32 COMMENT 'The slot number from the first attestation in the slashing payload' CODEC(DoubleDelta, ZSTD(1)),
    `attestation_1_data_index` UInt32 COMMENT 'The attestor index from the first attestation in the slashing payload' CODEC(ZSTD(1)),
    `attestation_1_data_source_epoch` UInt32 COMMENT 'The source epoch number from the first attestation in the slashing payload' CODEC(DoubleDelta, ZSTD(1)),
    `attestation_1_data_source_root` FixedString(66) COMMENT 'The source root from the first attestation in the slashing payload' CODEC(ZSTD(1)),
    `attestation_1_data_target_epoch` UInt32 COMMENT 'The target epoch number from the first attestation in the slashing payload' CODEC(DoubleDelta, ZSTD(1)),
    `attestation_1_data_target_root` FixedString(66) COMMENT 'The target root from the first attestation in the slashing payload' CODEC(ZSTD(1)),
    `attestation_2_attesting_indices` Array(UInt32) COMMENT 'The attesting indices from the second attestation in the slashing payload' CODEC(ZSTD(1)),
    `attestation_2_signature` String COMMENT 'The signature from the second attestation in the slashing payload' CODEC(ZSTD(1)),
    `attestation_2_data_beacon_block_root` FixedString(66) COMMENT 'The beacon block root from the second attestation in the slashing payload' CODEC(ZSTD(1)),
    `attestation_2_data_slot` UInt32 COMMENT 'The slot number from the second attestation in the slashing payload' CODEC(DoubleDelta, ZSTD(1)),
    `attestation_2_data_index` UInt32 COMMENT 'The attestor index from the second attestation in the slashing payload' CODEC(ZSTD(1)),
    `attestation_2_data_source_epoch` UInt32 COMMENT 'The source epoch number from the second attestation in the slashing payload' CODEC(DoubleDelta, ZSTD(1)),
    `attestation_2_data_source_root` FixedString(66) COMMENT 'The source root from the second attestation in the slashing payload' CODEC(ZSTD(1)),
    `attestation_2_data_target_epoch` UInt32 COMMENT 'The target epoch number from the second attestation in the slashing payload' CODEC(DoubleDelta, ZSTD(1)),
    `attestation_2_data_target_root` FixedString(66) COMMENT 'The target root from the second attestation in the slashing payload' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_beacon_block_attester_slashing_local', cityHash64(slot_start_date_time, meta_network_name, block_root, attestation_1_attesting_indices, attestation_2_attesting_indices, attestation_1_data_slot, attestation_2_data_slot, attestation_1_data_beacon_block_root, attestation_2_data_beacon_block_root))
COMMENT 'Contains attester slashing from a beacon block.'
