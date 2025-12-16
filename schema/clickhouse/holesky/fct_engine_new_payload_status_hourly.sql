CREATE TABLE holesky.fct_engine_new_payload_status_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of slots in this hour aggregation' CODEC(ZSTD(1)),
    `observation_count` UInt64 COMMENT 'Total number of observations in this hour' CODEC(ZSTD(1)),
    `valid_count` UInt64 COMMENT 'Number of observations with VALID status' CODEC(ZSTD(1)),
    `invalid_count` UInt64 COMMENT 'Number of observations with INVALID status' CODEC(ZSTD(1)),
    `syncing_count` UInt64 COMMENT 'Number of observations with SYNCING status' CODEC(ZSTD(1)),
    `accepted_count` UInt64 COMMENT 'Number of observations with ACCEPTED status' CODEC(ZSTD(1)),
    `invalid_block_hash_count` UInt64 COMMENT 'Number of observations with INVALID_BLOCK_HASH status' CODEC(ZSTD(1)),
    `valid_pct` Float64 COMMENT 'Percentage of observations with VALID status' CODEC(ZSTD(1)),
    `avg_duration_ms` UInt64 COMMENT 'Average duration of engine_newPayload calls in milliseconds' CODEC(ZSTD(1)),
    `avg_p50_duration_ms` UInt64 COMMENT 'Average of median durations across slots in milliseconds' CODEC(ZSTD(1)),
    `avg_p95_duration_ms` UInt64 COMMENT 'Average of p95 durations across slots in milliseconds' CODEC(ZSTD(1)),
    `max_duration_ms` UInt64 COMMENT 'Maximum duration of engine_newPayload calls in milliseconds' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_engine_new_payload_status_hourly_local', cityHash64(hour_start_date_time, node_class))
COMMENT 'Hourly aggregated engine_newPayload status distribution and duration statistics'
