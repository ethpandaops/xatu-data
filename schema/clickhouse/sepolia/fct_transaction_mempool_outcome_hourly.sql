CREATE TABLE sepolia.fct_transaction_mempool_outcome_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period, bucketed by first sighting time. Rows are complete once the 7 day horizon for the hour has been processed and never change afterwards' CODEC(DoubleDelta, ZSTD(1)),
    `observed_count` UInt64 COMMENT 'Transactions first sighted in the public mempool this hour' CODEC(ZSTD(1)),
    `included_count` UInt64 COMMENT 'Observed transactions included within 7 days of first sighting' CODEC(ZSTD(1)),
    `nonce_consumed_count` UInt64 COMMENT 'Observed transactions whose nonce was consumed by a different transaction within 7 days' CODEC(ZSTD(1)),
    `unincluded_count` UInt64 COMMENT 'Observed transactions with no inclusion of their nonce within 7 days' CODEC(ZSTD(1)),
    `included_relay_delivered_count` UInt64 COMMENT 'Included observed transactions whose block matched a known relay payload-delivered record' CODEC(ZSTD(1)),
    `included_unknown_build_count` UInt64 COMMENT 'Included observed transactions whose block matched no known relay payload-delivered record. Not proof the block was locally built' CODEC(ZSTD(1)),
    `in_mempool_at_deadline_count` UInt64 COMMENT 'Unincluded transactions with a sighting in the final hour before the 7 day deadline' CODEC(ZSTD(1)),
    `cancel_shape_count` UInt64 COMMENT 'Observed transactions that are self-transfers of zero value, the common wallet cancellation pattern' CODEC(ZSTD(1)),
    `observed_after_nonce_consumed_count` UInt64 COMMENT 'Observed transactions first sighted after their nonce had already been consumed' CODEC(ZSTD(1)),
    `wait_ms_p50` Nullable(Float64) COMMENT 'Median milliseconds from first sighting to inclusion slot start, over included transactions with non-negative waits' CODEC(ZSTD(1)),
    `wait_ms_p90` Nullable(Float64) COMMENT 'p90 milliseconds from first sighting to inclusion slot start, over included transactions with non-negative waits' CODEC(ZSTD(1)),
    `wait_ms_p99` Nullable(Float64) COMMENT 'p99 milliseconds from first sighting to inclusion slot start, over included transactions with non-negative waits' CODEC(ZSTD(1)),
    `wait_sample_count` UInt64 COMMENT 'Number of included transactions contributing to the wait quantiles' CODEC(ZSTD(1)),
    `negative_wait_count` UInt64 COMMENT 'Included transactions first sighted after their inclusion slot started, excluded from the wait quantiles' CODEC(ZSTD(1)),
    `blob_observed_count` UInt64 COMMENT 'Observed blob type 3 transactions first sighted this hour' CODEC(ZSTD(1)),
    `blob_wait_ms_p50` Nullable(Float64) COMMENT 'Median wait milliseconds over included blob transactions with non-negative waits' CODEC(ZSTD(1)),
    `blob_wait_ms_p90` Nullable(Float64) COMMENT 'p90 wait milliseconds over included blob transactions with non-negative waits' CODEC(ZSTD(1)),
    `blob_wait_ms_p99` Nullable(Float64) COMMENT 'p99 wait milliseconds over included blob transactions with non-negative waits' CODEC(ZSTD(1)),
    `blob_wait_sample_count` UInt64 COMMENT 'Number of included blob transactions contributing to the blob wait quantiles' CODEC(ZSTD(1)),
    `nonce_group_count` UInt64 COMMENT 'Distinct from and nonce pairs across transactions first sighted this hour' CODEC(ZSTD(1)),
    `multi_attempt_nonce_group_count` UInt64 COMMENT 'Nonce groups with at least two observed attempts, anchored to this hour by their earliest attempt sighting' CODEC(ZSTD(1)),
    `replaced_attempt_count` UInt64 COMMENT 'Non-winning attempts across multi-attempt nonce groups anchored to this hour' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_transaction_mempool_outcome_hourly_local', cityHash64(hour_start_date_time))
COMMENT 'Hourly cohort outcomes for transactions first sighted in the public mempool, resolved at the fixed 7 day horizon'
