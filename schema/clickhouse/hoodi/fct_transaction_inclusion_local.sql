CREATE TABLE hoodi.fct_transaction_inclusion_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number of the beacon block containing the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The beacon block root hash' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The beacon block version' CODEC(ZSTD(1)),
    `block_number` Nullable(UInt64) COMMENT 'The execution block number, null when the block is not yet present in fct_block' CODEC(ZSTD(1)),
    `position` UInt32 COMMENT 'The position of the transaction in the execution payload' CODEC(ZSTD(1)),
    `hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `from` FixedString(42) COMMENT 'The address of the account that sent the transaction' CODEC(ZSTD(1)),
    `to` Nullable(FixedString(42)) COMMENT 'The address of the transaction recipient, null for contract creation' CODEC(ZSTD(1)),
    `nonce` UInt64 COMMENT 'The nonce of the sender account at the time of the transaction' CODEC(ZSTD(1)),
    `type` UInt8 COMMENT 'The type of the transaction' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'The maximum gas provided for the transaction execution' CODEC(ZSTD(1)),
    `gas_price` UInt128 COMMENT 'The gas price of the transaction in wei' CODEC(ZSTD(1)),
    `gas_tip_cap` Nullable(UInt128) COMMENT 'The priority fee (tip) the user has set for the transaction in wei' CODEC(ZSTD(1)),
    `gas_fee_cap` Nullable(UInt128) COMMENT 'The max fee the user has set for the transaction in wei' CODEC(ZSTD(1)),
    `value` UInt128 COMMENT 'The value transferred with the transaction in wei' CODEC(ZSTD(1)),
    `size` UInt32 COMMENT 'The size of the transaction data in bytes' CODEC(ZSTD(1)),
    `call_data_size` UInt32 COMMENT 'The size of the call data of the transaction in bytes' CODEC(ZSTD(1)),
    `blob_gas` Nullable(UInt64) COMMENT 'The maximum gas provided for the blob transaction execution' CODEC(ZSTD(1)),
    `blob_gas_fee_cap` Nullable(UInt128) COMMENT 'The max blob fee the user has set for the transaction in wei' CODEC(ZSTD(1)),
    `blob_hashes` Array(String) COMMENT 'The hashes of the blob commitments for blob transactions' CODEC(ZSTD(1)),
    `is_cancel_shape` Bool COMMENT 'Whether the transaction is a self-transfer of zero value, the common wallet cancellation pattern' CODEC(ZSTD(1)),
    PROJECTION p_by_hash
    (
        SELECT *
        ORDER BY hash
    ),
    PROJECTION p_by_nonce_group
    (
        SELECT *
        ORDER BY
            from,
            nonce,
            slot_start_date_time
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_transaction_inclusion_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, block_root, position)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'One row per transaction included in a canonical beacon block execution payload. Carries no mempool or relay context so it can cover the full post-Merge history'
