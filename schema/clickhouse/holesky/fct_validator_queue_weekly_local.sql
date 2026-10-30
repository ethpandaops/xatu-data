CREATE TABLE holesky.fct_validator_queue_weekly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `week_start_date` Date COMMENT 'The start of the week (Monday, UTC)' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch of the snapshot: the last epoch of the week, or the latest epoch for the current week' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'Wall clock time when the snapshot epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `pending_initialized_count` UInt32 COMMENT 'Validators with status pending_initialized (deposited, not yet eligible for activation)' CODEC(ZSTD(1)),
    `pending_initialized_balance` UInt64 COMMENT 'Balance of pending_initialized validators in Gwei' CODEC(ZSTD(1)),
    `activation_queue_count` UInt32 COMMENT 'Validators with status pending_queued (eligible, waiting for activation)' CODEC(ZSTD(1)),
    `activation_queue_effective_balance` UInt64 COMMENT 'Effective balance of pending_queued validators in Gwei' CODEC(ZSTD(1)),
    `exit_queue_count` UInt32 COMMENT 'Validators with an exit started but not yet exited (active_exiting, active_slashed)' CODEC(ZSTD(1)),
    `exit_queue_effective_balance` UInt64 COMMENT 'Effective balance of validators in the exit queue in Gwei' CODEC(ZSTD(1)),
    `pending_deposit_count` UInt32 COMMENT 'Entries in the pending deposit queue (Electra). 0 before Electra' CODEC(ZSTD(1)),
    `pending_deposit_amount` UInt64 COMMENT 'Amount in the pending deposit queue in Gwei' CODEC(ZSTD(1)),
    `pending_consolidation_count` UInt32 COMMENT 'Entries in the pending consolidation queue (Electra). 0 before Electra' CODEC(ZSTD(1)),
    `pending_consolidation_source_effective_balance` UInt64 COMMENT 'Effective balance of the queued consolidations\\' source validators in Gwei' CODEC(ZSTD(1)),
    `pending_partial_withdrawal_count` UInt32 COMMENT 'Entries in the pending partial withdrawal queue (Electra). 0 before Electra' CODEC(ZSTD(1)),
    `pending_partial_withdrawal_amount` UInt64 COMMENT 'Amount in the pending partial withdrawal queue in Gwei' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_validator_queue_weekly_local', '{replica}', epoch)
PARTITION BY toStartOfYear(week_start_date)
ORDER BY week_start_date
SETTINGS index_granularity = 8192
COMMENT 'Activation and exit queues and the Electra pending queues, one snapshot per week'
