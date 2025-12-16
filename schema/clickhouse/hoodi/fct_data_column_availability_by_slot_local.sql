CREATE TABLE hoodi.fct_data_column_availability_by_slot_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number being probed' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_request_slot` UInt32 COMMENT 'The wallclock slot when the request was sent' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_request_slot_start_date_time` DateTime COMMENT 'The start time for the slot when the request was sent' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_request_epoch` UInt32 COMMENT 'The wallclock epoch when the request was sent' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_request_epoch_start_date_time` DateTime COMMENT 'The start time for the wallclock epoch when the request was sent' CODEC(DoubleDelta, ZSTD(1)),
    `column_index` UInt64 COMMENT 'Column index being probed (0-127)' CODEC(ZSTD(1)),
    `beacon_block_root` Nullable(FixedString(66)) COMMENT 'Beacon block root for this slot (from earliest observation, handles reorgs, NULL if unavailable)' CODEC(ZSTD(1)),
    `beacon_block_root_variants` UInt8 COMMENT 'Number of unique block roots observed (>1 indicates reorg/fork)' CODEC(ZSTD(1)),
    `blob_count` UInt16 COMMENT 'Number of blobs in the slot (max column_rows_count)' CODEC(ZSTD(1)),
    `success_count` UInt32 COMMENT 'Count of successful probes' CODEC(DoubleDelta, ZSTD(1)),
    `failure_count` UInt32 COMMENT 'Count of failed probes (result = failure)' CODEC(DoubleDelta, ZSTD(1)),
    `missing_count` UInt32 COMMENT 'Count of missing probes (result = missing)' CODEC(DoubleDelta, ZSTD(1)),
    `probe_count` UInt32 COMMENT 'Total count of probes' CODEC(DoubleDelta, ZSTD(1)),
    `availability_pct` Float64 COMMENT 'Availability percentage (success / total * 100) rounded to 2 decimal places' CODEC(ZSTD(1)),
    `min_response_time_ms` UInt32 COMMENT 'Minimum response time in milliseconds for successful probes only' CODEC(ZSTD(1)),
    `p50_response_time_ms` UInt32 COMMENT 'Median (p50) response time in milliseconds for successful probes only' CODEC(ZSTD(1)),
    `p95_response_time_ms` UInt32 COMMENT '95th percentile response time in milliseconds for successful probes only' CODEC(ZSTD(1)),
    `p99_response_time_ms` UInt32 COMMENT '99th percentile response time in milliseconds for successful probes only' CODEC(ZSTD(1)),
    `max_response_time_ms` UInt32 COMMENT 'Maximum response time in milliseconds for successful probes only' CODEC(ZSTD(1)),
    `unique_peer_count` UInt32 COMMENT 'Count of unique peers probed' CODEC(ZSTD(1)),
    `unique_client_count` UInt32 COMMENT 'Count of unique client names' CODEC(ZSTD(1)),
    `unique_implementation_count` UInt32 COMMENT 'Count of unique client implementations' CODEC(ZSTD(1)),
    `custody_probe_count` UInt32 COMMENT 'Count of observations from active RPC custody probes' CODEC(ZSTD(1)),
    `gossipsub_count` UInt32 COMMENT 'Count of observations from passive gossipsub propagation' CODEC(ZSTD(1)),
    PROJECTION p_by_slot_column
    (
        SELECT *
        ORDER BY
            slot,
            column_index
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_data_column_availability_by_slot_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, column_index)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Data column availability by slot and column index'
