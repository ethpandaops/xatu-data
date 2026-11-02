CREATE TABLE mainnet.fct_engine_get_blobs_by_el_client_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period, by slot' CODEC(DoubleDelta, ZSTD(1)),
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation (e.g., Geth, Nethermind, Besu, Reth)',
    `meta_execution_version` LowCardinality(String) COMMENT 'Execution client version string',
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of unique slots in this day' CODEC(ZSTD(1)),
    `observation_count` UInt32 COMMENT 'Total number of observations for this client in this day' CODEC(ZSTD(1)),
    `unique_node_count` UInt32 COMMENT 'Number of unique nodes reporting for this client in this day' CODEC(ZSTD(1)),
    `success_count` UInt64 COMMENT 'Number of observations with SUCCESS status' CODEC(ZSTD(1)),
    `partial_count` UInt64 COMMENT 'Number of observations with PARTIAL status' CODEC(ZSTD(1)),
    `empty_count` UInt64 COMMENT 'Number of observations with EMPTY status' CODEC(ZSTD(1)),
    `unsupported_count` UInt64 COMMENT 'Number of observations with UNSUPPORTED status' CODEC(ZSTD(1)),
    `error_count` UInt64 COMMENT 'Number of observations with ERROR status' CODEC(ZSTD(1)),
    `avg_returned_count` Float64 COMMENT 'Average number of blobs returned (SUCCESS status only)' CODEC(ZSTD(1)),
    `avg_duration_ms` UInt64 COMMENT 'Average duration of SUCCESS engine_getBlobs calls in milliseconds' CODEC(ZSTD(1)),
    `p50_duration_ms` UInt64 COMMENT '50th percentile (median) duration of SUCCESS calls over the day in milliseconds' CODEC(ZSTD(1)),
    `p95_duration_ms` UInt64 COMMENT '95th percentile duration of SUCCESS calls over the day in milliseconds' CODEC(ZSTD(1)),
    `min_duration_ms` UInt64 COMMENT 'Minimum duration of SUCCESS calls in milliseconds' CODEC(ZSTD(1)),
    `max_duration_ms` UInt64 COMMENT 'Maximum duration of SUCCESS calls in milliseconds' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_engine_get_blobs_by_el_client_daily_local', cityHash64(day_start_date, meta_execution_implementation, meta_execution_version, node_class))
COMMENT 'Daily aggregated engine_getBlobs statistics by execution client with true percentiles'
