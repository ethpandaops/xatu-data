CREATE TABLE default.canonical_beacon_block_proposer_slashing
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The root hash of the beacon block' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The version of the beacon block',
    `signed_header_1_message_slot` UInt32 COMMENT 'The slot number from the first signed header in the slashing payload' CODEC(DoubleDelta, ZSTD(1)),
    `signed_header_1_message_proposer_index` UInt32 COMMENT 'The proposer index from the first signed header in the slashing payload' CODEC(DoubleDelta, ZSTD(1)),
    `signed_header_1_message_body_root` FixedString(66) COMMENT 'The body root from the first signed header in the slashing payload' CODEC(ZSTD(1)),
    `signed_header_1_message_parent_root` FixedString(66) COMMENT 'The parent root from the first signed header in the slashing payload' CODEC(ZSTD(1)),
    `signed_header_1_message_state_root` FixedString(66) COMMENT 'The state root from the first signed header in the slashing payload' CODEC(ZSTD(1)),
    `signed_header_1_signature` String COMMENT 'The signature for the first signed header in the slashing payload' CODEC(ZSTD(1)),
    `signed_header_2_message_slot` UInt32 COMMENT 'The slot number from the second signed header in the slashing payload' CODEC(DoubleDelta, ZSTD(1)),
    `signed_header_2_message_proposer_index` UInt32 COMMENT 'The proposer index from the second signed header in the slashing payload' CODEC(DoubleDelta, ZSTD(1)),
    `signed_header_2_message_body_root` FixedString(66) COMMENT 'The body root from the second signed header in the slashing payload' CODEC(ZSTD(1)),
    `signed_header_2_message_parent_root` FixedString(66) COMMENT 'The parent root from the second signed header in the slashing payload' CODEC(ZSTD(1)),
    `signed_header_2_message_state_root` FixedString(66) COMMENT 'The state root from the second signed header in the slashing payload' CODEC(ZSTD(1)),
    `signed_header_2_signature` String COMMENT 'The signature for the second signed header in the slashing payload' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_beacon_block_proposer_slashing_local', cityHash64(slot_start_date_time, meta_network_name, block_root, signed_header_1_message_slot, signed_header_2_message_slot, signed_header_1_message_proposer_index, signed_header_2_message_proposer_index, signed_header_1_message_body_root, signed_header_2_message_body_root))
COMMENT 'Contains proposer slashing from a beacon block.'
