CREATE TABLE mainnet.dim_validator_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch of the state this row was taken from' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'Wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `pubkey` String COMMENT 'The public key of the validator' CODEC(ZSTD(1)),
    `withdrawal_credentials` String COMMENT 'Current withdrawal credentials' CODEC(ZSTD(1)),
    `credential_type` LowCardinality(String) COMMENT 'Withdrawal credential prefix: 0x00 (BLS), 0x01 (execution address) or 0x02 (compounding)',
    `withdrawal_address` Nullable(String) COMMENT 'Execution address from 0x01 or 0x02 credentials. NULL for 0x00' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Beacon chain validator status (e.g. pending_queued, active_ongoing, withdrawal_done)',
    `balance` Nullable(UInt64) COMMENT 'Balance in Gwei' CODEC(ZSTD(1)),
    `effective_balance` Nullable(UInt64) COMMENT 'Effective balance in Gwei' CODEC(ZSTD(1)),
    `slashed` Bool COMMENT 'Whether the validator has been slashed',
    `activation_eligibility_epoch` Nullable(UInt64) COMMENT 'Epoch the validator became eligible for activation. NULL if not yet set' CODEC(ZSTD(1)),
    `activation_epoch` Nullable(UInt64) COMMENT 'Epoch the validator activates or activated. NULL if not yet set' CODEC(ZSTD(1)),
    `exit_epoch` Nullable(UInt64) COMMENT 'Epoch the validator exits or exited. NULL if no exit has been initiated' CODEC(ZSTD(1)),
    `withdrawable_epoch` Nullable(UInt64) COMMENT 'Epoch the validator becomes or became withdrawable. NULL if no exit has been initiated' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/dim_validator_local', '{replica}', epoch)
PARTITION BY tuple()
ORDER BY validator_index
SETTINGS index_granularity = 8192
COMMENT 'Current identity and state of every validator, refreshed from the latest epoch'
