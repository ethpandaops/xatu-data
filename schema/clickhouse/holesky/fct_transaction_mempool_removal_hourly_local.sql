CREATE TABLE holesky.fct_transaction_mempool_removal_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period, bucketed by removal detection time' CODEC(DoubleDelta, ZSTD(1)),
    `reason` LowCardinality(String) COMMENT 'Removal reason: replaced, nonce_consumed or dropped. dropped means the hash left at least one sentry pool and is usually seen again later' CODEC(ZSTD(1)),
    `hash_count` UInt64 COMMENT 'Distinct transaction hashes removed for this reason this hour' CODEC(ZSTD(1)),
    `pending_hash_count` UInt64 COMMENT 'Hashes removed from at least one sentry pending pool' CODEC(ZSTD(1)),
    `queued_hash_count` UInt64 COMMENT 'Hashes removed from at least one sentry queued pool' CODEC(ZSTD(1)),
    `hash_sentry_count` UInt64 COMMENT 'Distinct hash and sentry pairs, repeat detections by one sentry counted once' CODEC(ZSTD(1)),
    `detection_count` UInt64 COMMENT 'Raw removal detections including repeats' CODEC(ZSTD(1)),
    `blob_hash_count` UInt64 COMMENT 'Blob type 3 hashes removed for this reason' CODEC(ZSTD(1)),
    `with_replacement_count` UInt64 COMMENT 'Hashes with a known replacing transaction' CODEC(ZSTD(1)),
    `replacement_tip_cap_ratio_p50` Nullable(Float64) COMMENT 'Median replacing tip cap divided by the replaced tip cap, over replaced hashes with a non-zero tip cap' CODEC(ZSTD(1)),
    `replacement_fee_cap_ratio_p50` Nullable(Float64) COMMENT 'Median replacing max fee cap divided by the replaced max fee cap, over replaced hashes with a non-zero fee cap' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_transaction_mempool_removal_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY (hour_start_date_time, reason)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Hourly counts of transactions that left Xatu sentry txpools without being included, by removal reason. replaced and nonce_consumed are reliable, while dropped is churn-heavy'
