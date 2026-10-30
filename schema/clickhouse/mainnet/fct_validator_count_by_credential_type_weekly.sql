CREATE TABLE mainnet.fct_validator_count_by_credential_type_weekly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `week_start_date` Date COMMENT 'The start of the week (Monday, UTC)' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch of the snapshot: the last epoch of the week, or the latest epoch for the current week' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'Wall clock time when the snapshot epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `credential_type` LowCardinality(String) COMMENT 'Withdrawal credential prefix at the snapshot: 0x00, 0x01 or 0x02',
    `validator_count` UInt32 COMMENT 'Validators in the beacon state with this credential type, in any status' CODEC(ZSTD(1)),
    `active_validator_count` UInt32 COMMENT 'Active validators (active_ongoing, active_exiting, active_slashed)' CODEC(ZSTD(1)),
    `active_effective_balance` UInt64 COMMENT 'Sum of active validators\\' effective balance in Gwei (active stake)' CODEC(ZSTD(1)),
    `active_balance` UInt64 COMMENT 'Sum of active validators\\' balance in Gwei' CODEC(ZSTD(1)),
    `pending_validator_count` UInt32 COMMENT 'Validators waiting for activation (pending_initialized, pending_queued)' CODEC(ZSTD(1)),
    `exiting_validator_count` UInt32 COMMENT 'Active validators with an exit started (active_exiting, active_slashed)' CODEC(ZSTD(1)),
    `exited_validator_count` UInt32 COMMENT 'Exited validators (exited_unslashed, exited_slashed, withdrawal_possible, withdrawal_done)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_validator_count_by_credential_type_weekly_local', cityHash64(week_start_date))
COMMENT 'Validators and stake by withdrawal credential type, one snapshot per week'
