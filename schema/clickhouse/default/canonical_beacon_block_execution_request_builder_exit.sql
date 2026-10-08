CREATE TABLE default.canonical_beacon_block_execution_request_builder_exit
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The root hash of the beacon block' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The version of the beacon block',
    `block_number` UInt64 COMMENT 'The execution block number from the execution payload' CODEC(DoubleDelta, ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'The execution block hash from the execution payload' CODEC(ZSTD(1)),
    `position_in_block` UInt32 COMMENT 'The index of the builder exit within the block builder exit requests' CODEC(DoubleDelta, ZSTD(1)),
    `source_address` FixedString(42) COMMENT 'The source address that initiated the builder exit request' CODEC(ZSTD(1)),
    `pubkey` String COMMENT 'The public key of the builder the exit targets' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_beacon_block_execution_request_builder_exit_local', cityHash64(slot_start_date_time, meta_network_name, block_root, position_in_block))
COMMENT 'Contains an EIP-8282 execution request builder exit from a beacon block.'
