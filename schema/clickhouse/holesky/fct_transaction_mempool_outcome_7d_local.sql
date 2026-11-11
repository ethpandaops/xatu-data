CREATE TABLE holesky.fct_transaction_mempool_outcome_7d_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `first_seen_date_time` DateTime64(3) COMMENT 'Earliest sighting of the transaction within its observation episode, the anchor of the 7 day horizon' CODEC(DoubleDelta, ZSTD(1)),
    `hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `from` FixedString(42) COMMENT 'The address of the account that sent the transaction' CODEC(ZSTD(1)),
    `to` Nullable(FixedString(42)) COMMENT 'The address of the transaction recipient, null for contract creation' CODEC(ZSTD(1)),
    `nonce` UInt64 COMMENT 'The nonce of the sender account at the time of the transaction' CODEC(ZSTD(1)),
    `type` Nullable(UInt8) COMMENT 'The type of the transaction' CODEC(ZSTD(1)),
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
    `last_seen_date_time` DateTime64(3) COMMENT 'Latest sighting of the transaction within the 7 day horizon' CODEC(DoubleDelta, ZSTD(1)),
    `sighting_count` UInt32 COMMENT 'Number of sightings within the 7 day horizon across all sentries' CODEC(ZSTD(1)),
    `peak_hourly_unique_sentries` UInt32 COMMENT 'Peak number of distinct sentries sighting the transaction within any single hour of the horizon' CODEC(ZSTD(1)),
    `outcome` LowCardinality(String) COMMENT 'Outcome within 7 days of first sighting: included, nonce_consumed (a different transaction with the same from and nonce was included) or unincluded. The statement is fixed to the horizon and remains true even if the transaction is included later' CODEC(ZSTD(1)),
    `resolution_date_time` DateTime64(3) COMMENT 'When the outcome was determined: the inclusion slot start for included, the winner inclusion slot start for nonce_consumed, or first_seen_date_time plus 7 days for unincluded' CODEC(DoubleDelta, ZSTD(1)),
    `included_slot` Nullable(UInt32) COMMENT 'The slot of the beacon block that included the transaction, when outcome is included' CODEC(ZSTD(1)),
    `included_slot_start_date_time` Nullable(DateTime) COMMENT 'The wall clock time when the inclusion slot started, when outcome is included' CODEC(ZSTD(1)),
    `included_block_root` Nullable(FixedString(66)) COMMENT 'The beacon block root of the including block, when outcome is included' CODEC(ZSTD(1)),
    `included_position` Nullable(UInt32) COMMENT 'The position of the transaction in the execution payload, when outcome is included' CODEC(ZSTD(1)),
    `wait_ms` Nullable(Int64) COMMENT 'Milliseconds from first sighting to the inclusion slot start, when outcome is included. Negative when the transaction was first sighted after its inclusion slot started' CODEC(ZSTD(1)),
    `included_via_known_relay` Nullable(Bool) COMMENT 'Whether the including block matched a known relay payload-delivered record, when outcome is included. False is not proof the block was locally built' CODEC(ZSTD(1)),
    `winner_hash` Nullable(FixedString(66)) COMMENT 'The hash of the transaction that consumed the nonce, when outcome is nonce_consumed' CODEC(ZSTD(1)),
    `winner_slot_start_date_time` Nullable(DateTime) COMMENT 'The wall clock time when the winner inclusion slot started, when outcome is nonce_consumed' CODEC(ZSTD(1)),
    `observed_after_nonce_consumed` Bool COMMENT 'Whether the transaction was first sighted after its nonce had already been consumed by another transaction' CODEC(ZSTD(1)),
    `in_mempool_at_deadline` Bool COMMENT 'Whether a sighting occurred in the final hour before the 7 day deadline. Sensor evidence of continued circulation, only meaningful when outcome is unincluded' CODEC(ZSTD(1)),
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
            first_seen_date_time
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_transaction_mempool_outcome_7d_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(first_seen_date_time)
ORDER BY (first_seen_date_time, hash)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'One immutable row per transaction hash observed in the public mempool, stating its fixed-horizon outcome within 7 days of first sighting. An observation episode starts when a hash is sighted with no sightings in the preceding 7 days. A hash re-sighted after more than 7 days of silence starts a new episode and a new row'
