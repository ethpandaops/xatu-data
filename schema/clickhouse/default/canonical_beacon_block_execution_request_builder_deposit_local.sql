CREATE TABLE default.canonical_beacon_block_execution_request_builder_deposit_local
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
    `position_in_block` UInt32 COMMENT 'The index of the builder deposit within the block builder deposit requests' CODEC(DoubleDelta, ZSTD(1)),
    `pubkey` String COMMENT 'The public key of the builder from the builder deposit request' CODEC(ZSTD(1)),
    `withdrawal_credentials` FixedString(66) COMMENT 'The withdrawal credentials from the builder deposit request' CODEC(ZSTD(1)),
    `amount` UInt128 COMMENT 'The builder deposit amount in gwei' CODEC(ZSTD(1)),
    `signature` String COMMENT 'The builder deposit signature' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/canonical_beacon_block_execution_request_builder_deposit_local', '{replica}', updated_date_time)
PARTITION BY (meta_network_name, toYYYYMM(slot_start_date_time))
ORDER BY (meta_network_name, slot_start_date_time, block_root, position_in_block)
SETTINGS index_granularity = 8192
COMMENT 'Contains an EIP-8282 execution request builder deposit from a beacon block.'
