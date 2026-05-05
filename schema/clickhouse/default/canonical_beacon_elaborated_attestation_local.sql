CREATE TABLE default.canonical_beacon_elaborated_attestation_local
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_slot` UInt32 COMMENT 'The slot number of the block containing the attestation' CODEC(DoubleDelta, ZSTD(1)),
    `block_slot_start_date_time` DateTime COMMENT 'The wall clock time when the block slot started' CODEC(DoubleDelta, ZSTD(1)),
    `block_epoch` UInt32 COMMENT 'The epoch number of the block containing the attestation' CODEC(DoubleDelta, ZSTD(1)),
    `block_epoch_start_date_time` DateTime COMMENT 'The wall clock time when the block epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `position_in_block` UInt32 COMMENT 'The position of the attestation in the block' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The root of the block containing the attestation' CODEC(ZSTD(1)),
    `validators` Array(UInt32) COMMENT 'Array of validator indices participating in the attestation' CODEC(ZSTD(1)),
    `committee_index` LowCardinality(String) COMMENT 'The index of the committee making the attestation',
    `beacon_block_root` FixedString(66) COMMENT 'The root of the beacon block being attested to' CODEC(ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number being attested to' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime CODEC(DoubleDelta, ZSTD(1)),
    `source_epoch` UInt32 COMMENT 'The source epoch referenced in the attestation' CODEC(DoubleDelta, ZSTD(1)),
    `source_epoch_start_date_time` DateTime COMMENT 'The wall clock time when the source epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `source_root` FixedString(66) COMMENT 'The root of the source checkpoint in the attestation' CODEC(ZSTD(1)),
    `target_epoch` UInt32 COMMENT 'The target epoch referenced in the attestation' CODEC(DoubleDelta, ZSTD(1)),
    `target_epoch_start_date_time` DateTime COMMENT 'The wall clock time when the target epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `target_root` FixedString(66) COMMENT 'The root of the target checkpoint in the attestation' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/canonical_beacon_elaborated_attestation_local', '{replica}', updated_date_time)
PARTITION BY (meta_network_name, toYYYYMM(slot_start_date_time))
ORDER BY (meta_network_name, slot_start_date_time, block_root, block_slot, position_in_block, beacon_block_root, slot, committee_index, source_root, target_root)
SETTINGS index_granularity = 8192
COMMENT 'Contains elaborated attestations from beacon blocks.'
