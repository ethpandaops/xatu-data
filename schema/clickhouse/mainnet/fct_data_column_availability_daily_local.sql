CREATE TABLE mainnet.fct_data_column_availability_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `date` Date COMMENT 'Date of the aggregation' CODEC(DoubleDelta, ZSTD(1)),
    `column_index` UInt64 COMMENT 'Column index (0-127)' CODEC(ZSTD(1)),
    `hour_count` UInt32 COMMENT 'Number of hours in this day aggregation' CODEC(ZSTD(1)),
    `avg_availability_pct` Float64 COMMENT 'Availability percentage calculated from total counts (total_success_count / total_probe_count * 100, rounded to 2 decimal places)' CODEC(ZSTD(1)),
    `min_availability_pct` Float64 COMMENT 'Minimum availability percentage across hours (rounded to 2 decimal places)' CODEC(ZSTD(1)),
    `max_availability_pct` Float64 COMMENT 'Maximum availability percentage across hours (rounded to 2 decimal places)' CODEC(ZSTD(1)),
    `total_probe_count` UInt64 COMMENT 'Total probe count across all hours' CODEC(DoubleDelta, ZSTD(1)),
    `total_success_count` UInt64 COMMENT 'Total successful probes across all hours' CODEC(DoubleDelta, ZSTD(1)),
    `total_failure_count` UInt64 COMMENT 'Total failed probes across all hours (result = failure)' CODEC(DoubleDelta, ZSTD(1)),
    `total_missing_count` UInt64 COMMENT 'Total missing probes across all hours (result = missing)' CODEC(DoubleDelta, ZSTD(1)),
    `min_response_time_ms` UInt32 COMMENT 'Minimum response time in milliseconds for successful probes only (rounded to whole number)' CODEC(ZSTD(1)),
    `avg_p50_response_time_ms` UInt32 COMMENT 'Average of p50 response times across hours for successful probes only (rounded to whole number)' CODEC(ZSTD(1)),
    `avg_p95_response_time_ms` UInt32 COMMENT 'Average of p95 response times across hours for successful probes only (rounded to whole number)' CODEC(ZSTD(1)),
    `avg_p99_response_time_ms` UInt32 COMMENT 'Average of p99 response times across hours for successful probes only (rounded to whole number)' CODEC(ZSTD(1)),
    `max_response_time_ms` UInt32 COMMENT 'Maximum response time in milliseconds for successful probes only (rounded to whole number)' CODEC(ZSTD(1)),
    `max_blob_count` UInt16 COMMENT 'Maximum blob count observed in this day' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_data_column_availability_daily_local', '{replica}', updated_date_time)
PARTITION BY toYYYYMM(date)
ORDER BY (date, column_index)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Data column availability by day and column index'
