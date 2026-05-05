CREATE TABLE default.canonical_beacon_validators
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `index` UInt32 COMMENT 'The index of the validator' CODEC(DoubleDelta, ZSTD(1)),
    `balance` Nullable(UInt64) COMMENT 'The balance of the validator' CODEC(T64, ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'The status of the validator',
    `effective_balance` Nullable(UInt64) COMMENT 'The effective balance of the validator' CODEC(ZSTD(1)),
    `slashed` Bool COMMENT 'Whether the validator is slashed',
    `activation_epoch` Nullable(UInt64) COMMENT 'The epoch when the validator was activated' CODEC(ZSTD(1)),
    `activation_eligibility_epoch` Nullable(UInt64) COMMENT 'The epoch when the validator was activated' CODEC(ZSTD(1)),
    `exit_epoch` Nullable(UInt64) COMMENT 'The epoch when the validator exited' CODEC(ZSTD(1)),
    `withdrawable_epoch` Nullable(UInt64) COMMENT 'The epoch when the validator can withdraw' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_beacon_validators_local', cityHash64(epoch_start_date_time, meta_network_name, index, status))
COMMENT 'Contains a validator state for an epoch.'
