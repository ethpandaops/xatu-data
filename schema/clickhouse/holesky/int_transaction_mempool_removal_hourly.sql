CREATE TABLE holesky.int_transaction_mempool_removal_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The start of the hour bucket the removal detections fall in' CODEC(DoubleDelta, ZSTD(1)),
    `hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `reason` LowCardinality(String) COMMENT 'Why the transaction left the pool: replaced (a same-nonce transaction took its place), nonce_consumed (the sender nonce moved past it) or dropped (it left at least one sentry pool for any other reason, usually churn while it still circulates elsewhere)' CODEC(ZSTD(1)),
    `first_detected_date_time` DateTime64(3) COMMENT 'Earliest removal detection this hour across sentries' CODEC(DoubleDelta, ZSTD(1)),
    `last_detected_date_time` DateTime64(3) COMMENT 'Latest removal detection this hour across sentries' CODEC(DoubleDelta, ZSTD(1)),
    `first_seen_date_time` DateTime64(3) COMMENT 'Earliest txpool_content snapshot that held the transaction, across the detecting sentries' CODEC(DoubleDelta, ZSTD(1)),
    `last_seen_date_time` DateTime64(3) COMMENT 'Latest txpool_content snapshot that held the transaction, across the detecting sentries' CODEC(DoubleDelta, ZSTD(1)),
    `detection_count` UInt32 COMMENT 'Number of removal detections this hour, including repeat detections by the same sentry' CODEC(ZSTD(1)),
    `sentry_count` UInt32 COMMENT 'Distinct sentries that detected the removal this hour' CODEC(ZSTD(1)),
    `pending_sentry_count` UInt32 COMMENT 'Distinct sentries that detected the removal from their pending pool' CODEC(ZSTD(1)),
    `queued_sentry_count` UInt32 COMMENT 'Distinct sentries that detected the removal from their queued pool' CODEC(ZSTD(1)),
    `from` FixedString(42) COMMENT 'The address of the account that sent the transaction' CODEC(ZSTD(1)),
    `to` Nullable(FixedString(42)) COMMENT 'The address of the transaction recipient, null for contract creation' CODEC(ZSTD(1)),
    `nonce` UInt64 COMMENT 'The nonce of the transaction' CODEC(ZSTD(1)),
    `type` UInt8 COMMENT 'The type of the transaction' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'The maximum gas provided for the transaction execution' CODEC(ZSTD(1)),
    `gas_tip_cap` UInt128 COMMENT 'The priority fee (tip) cap of the transaction in wei' CODEC(ZSTD(1)),
    `gas_fee_cap` UInt128 COMMENT 'The max fee cap of the transaction in wei' CODEC(ZSTD(1)),
    `blob_gas_fee_cap` Nullable(UInt128) COMMENT 'The max blob fee cap of the transaction in wei, null for non-blob transactions' CODEC(ZSTD(1)),
    `replacement_hash` Nullable(FixedString(66)) COMMENT 'The hash of the transaction that replaced it, from the earliest replaced detection this hour' CODEC(ZSTD(1)),
    `replacement_gas_tip_cap` Nullable(UInt128) COMMENT 'The tip cap of the replacing transaction in wei' CODEC(ZSTD(1)),
    `replacement_gas_fee_cap` Nullable(UInt128) COMMENT 'The max fee cap of the replacing transaction in wei' CODEC(ZSTD(1)),
    `max_account_nonce` Nullable(UInt64) COMMENT 'Highest sender nonce at the latest block reported by a detecting sentry, null when only replaced detections exist' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_transaction_mempool_removal_hourly_local', cityHash64(hash))
COMMENT 'One row per transaction hash, removal reason and hour in which Xatu sentries saw it leave their txpool without being included. Repeat detections by one sentry collapse into one row. A dropped row means the hash left at least one sentry pool, which is usually churn rather than eviction'
