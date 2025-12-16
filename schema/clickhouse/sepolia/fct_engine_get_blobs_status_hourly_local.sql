CREATE TABLE sepolia.fct_engine_get_blobs_status_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of slots in this hour aggregation' CODEC(ZSTD(1)),
    `observation_count` UInt64 COMMENT 'Total number of observations in this hour' CODEC(ZSTD(1)),
    `success_count` UInt64 COMMENT 'Number of observations with SUCCESS status' CODEC(ZSTD(1)),
    `partial_count` UInt64 COMMENT 'Number of observations with PARTIAL status' CODEC(ZSTD(1)),
    `empty_count` UInt64 COMMENT 'Number of observations with EMPTY status' CODEC(ZSTD(1)),
    `unsupported_count` UInt64 COMMENT 'Number of observations with UNSUPPORTED status' CODEC(ZSTD(1)),
    `error_count` UInt64 COMMENT 'Number of observations with ERROR status' CODEC(ZSTD(1)),
    `success_pct` Float64 COMMENT 'Percentage of observations with SUCCESS status' CODEC(ZSTD(1)),
    `avg_duration_ms` UInt64 COMMENT 'Average duration of engine_getBlobs calls in milliseconds' CODEC(ZSTD(1)),
    `avg_p50_duration_ms` UInt64 COMMENT 'Average of median durations across slots in milliseconds' CODEC(ZSTD(1)),
    `avg_p95_duration_ms` UInt64 COMMENT 'Average of p95 durations across slots in milliseconds' CODEC(ZSTD(1)),
    `max_duration_ms` UInt64 COMMENT 'Maximum duration of engine_getBlobs calls in milliseconds' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_engine_get_blobs_status_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY (hour_start_date_time, node_class)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Hourly aggregated engine_getBlobs status distribution and duration statistics'
