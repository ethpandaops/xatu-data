CREATE TABLE default.canonical_beacon_block_withdrawal_local
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The root hash of the beacon block' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The version of the beacon block',
    `withdrawal_index` UInt32 COMMENT 'The index of the withdrawal' CODEC(ZSTD(1)),
    `withdrawal_validator_index` UInt32 COMMENT 'The validator index from the withdrawal data' CODEC(ZSTD(1)),
    `withdrawal_address` FixedString(42) COMMENT 'The address of the account that is the withdrawal recipient' CODEC(ZSTD(1)),
    `withdrawal_amount` UInt128 COMMENT 'The amount of the withdrawal from the withdrawal data' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/canonical_beacon_block_withdrawal_local', '{replica}', updated_date_time)
PARTITION BY (meta_network_name, toYYYYMM(slot_start_date_time))
ORDER BY (meta_network_name, slot_start_date_time, block_root, withdrawal_index, withdrawal_validator_index)
SETTINGS index_granularity = 8192
COMMENT 'Contains a withdrawal from a beacon block.'
