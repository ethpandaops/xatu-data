CREATE TABLE default.canonical_beacon_block_voluntary_exit
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The root hash of the beacon block' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The version of the beacon block',
    `voluntary_exit_message_epoch` UInt32 COMMENT 'The epoch number from the exit message' CODEC(DoubleDelta, ZSTD(1)),
    `voluntary_exit_message_validator_index` UInt32 COMMENT 'The validator index from the exit message' CODEC(ZSTD(1)),
    `voluntary_exit_signature` String COMMENT 'The signature of the exit message' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_beacon_block_voluntary_exit_local', cityHash64(slot_start_date_time, meta_network_name, block_root, voluntary_exit_message_epoch, voluntary_exit_message_validator_index))
COMMENT 'Contains a voluntary exit from a beacon block.'
