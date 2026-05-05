CREATE TABLE default.canonical_beacon_block_bls_to_execution_change
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The root hash of the beacon block' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The version of the beacon block',
    `exchanging_message_validator_index` UInt32 COMMENT 'The validator index from the exchanging message' CODEC(ZSTD(1)),
    `exchanging_message_from_bls_pubkey` String COMMENT 'The BLS public key from the exchanging message' CODEC(ZSTD(1)),
    `exchanging_message_to_execution_address` FixedString(42) COMMENT 'The execution address from the exchanging message' CODEC(ZSTD(1)),
    `exchanging_signature` String COMMENT 'The signature for the exchanging message' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_beacon_block_bls_to_execution_change_local', cityHash64(slot_start_date_time, meta_network_name, block_root, exchanging_message_validator_index, exchanging_message_from_bls_pubkey, exchanging_message_to_execution_address))
COMMENT 'Contains bls to execution change from a beacon block.'
