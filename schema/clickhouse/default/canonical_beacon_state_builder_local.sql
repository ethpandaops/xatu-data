CREATE TABLE default.canonical_beacon_state_builder_local
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number the builder registry snapshot is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `state_id` LowCardinality(String) COMMENT 'The state ID the registry was read from',
    `builder_index` UInt64 COMMENT 'The index of the builder in the registry' CODEC(DoubleDelta, ZSTD(1)),
    `pubkey` FixedString(98) COMMENT 'The public key of the builder' CODEC(ZSTD(1)),
    `version` UInt8 COMMENT 'The builder version byte' CODEC(ZSTD(1)),
    `execution_address` FixedString(42) COMMENT 'The execution address of the builder' CODEC(ZSTD(1)),
    `balance` UInt64 COMMENT 'The builder balance in gwei' CODEC(ZSTD(1)),
    `deposit_epoch` UInt64 COMMENT 'The epoch in which the builder was added to the registry' CODEC(ZSTD(1)),
    `withdrawable_epoch` UInt64 COMMENT 'The epoch from which the builder can be withdrawn, FAR_FUTURE_EPOCH while no exit was initiated' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'The builder status (pending, active or exited) evaluated against the finalized checkpoint of the state',
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/canonical_beacon_state_builder_local', '{replica}', updated_date_time)
PARTITION BY (meta_network_name, toYYYYMM(epoch_start_date_time))
ORDER BY (meta_network_name, epoch_start_date_time, epoch, builder_index)
SETTINGS index_granularity = 8192
COMMENT 'Contains the Gloas builder registry snapshot for a canonical beacon state epoch.'
