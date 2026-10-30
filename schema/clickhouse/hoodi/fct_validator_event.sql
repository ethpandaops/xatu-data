CREATE TABLE hoodi.fct_validator_event
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `version` UInt64 COMMENT 'ReplacingMergeTree version: rows with a known amount win over rows without one, then the newest row wins' CODEC(ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot of the block that included the operation' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'Wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch of the block that included the operation' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'Wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'Root of the block that included the operation' CODEC(ZSTD(1)),
    `validator_index` UInt32 COMMENT 'Index of the validator the event belongs to' CODEC(ZSTD(1)),
    `event_type` LowCardinality(String) COMMENT 'One of deposit, top_up, withdrawal_partial, withdrawal_full, bls_to_execution_change, switch_to_compounding, consolidation_source, consolidation_target, withdrawal_request, exit_request, voluntary_exit, slashed',
    `event_position` UInt64 COMMENT 'Separates events of the same type for a validator in one block: withdrawal index for withdrawals, position in the block for execution requests, 2147483648 plus the order among the pubkey\\'s deposits in the block for bridge deposits, otherwise 0' CODEC(ZSTD(1)),
    `amount` Nullable(UInt64) COMMENT 'Amount in Gwei: deposit amount, withdrawal amount, partial withdrawal amount accepted into the queue, or balance moved by a consolidation once processed (NULL until then). NULL for other types' CODEC(ZSTD(1)),
    `counterparty_validator_index` Nullable(UInt32) COMMENT 'Other validator: consolidation target (for the source) or source (for the target), or the proposer that included a slashing' CODEC(ZSTD(1)),
    `address` Nullable(String) COMMENT 'Deposit withdrawal credentials, new execution address of a BLS change, withdrawal recipient address, or source address of an execution request' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_validator_event_local', cityHash64(validator_index))
COMMENT 'Validator lifecycle events: deposits, top-ups, credential changes, consolidations, withdrawals, exit and withdrawal requests, voluntary exits and slashings. Only operations that took effect on chain are included'
