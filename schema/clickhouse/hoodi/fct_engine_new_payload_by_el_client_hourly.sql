CREATE TABLE hoodi.fct_engine_new_payload_by_el_client_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation (e.g., Geth, Nethermind, Besu, Reth)',
    `meta_execution_version` LowCardinality(String) COMMENT 'Execution client version string',
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of unique slots in this hour' CODEC(ZSTD(1)),
    `observation_count` UInt32 COMMENT 'Total number of observations for this client in this hour' CODEC(ZSTD(1)),
    `unique_node_count` UInt32 COMMENT 'Number of unique nodes reporting for this client' CODEC(ZSTD(1)),
    `valid_count` UInt64 COMMENT 'Number of observations with VALID status' CODEC(ZSTD(1)),
    `invalid_count` UInt64 COMMENT 'Number of observations with INVALID status' CODEC(ZSTD(1)),
    `syncing_count` UInt64 COMMENT 'Number of observations with SYNCING status' CODEC(ZSTD(1)),
    `accepted_count` UInt64 COMMENT 'Number of observations with ACCEPTED status' CODEC(ZSTD(1)),
    `avg_duration_ms` UInt64 COMMENT 'Average duration of engine_newPayload calls in milliseconds' CODEC(ZSTD(1)),
    `p50_duration_ms` UInt64 COMMENT '50th percentile (median) duration in milliseconds' CODEC(ZSTD(1)),
    `p95_duration_ms` UInt64 COMMENT '95th percentile duration in milliseconds' CODEC(ZSTD(1)),
    `min_duration_ms` UInt64 COMMENT 'Minimum duration in milliseconds' CODEC(ZSTD(1)),
    `max_duration_ms` UInt64 COMMENT 'Maximum duration in milliseconds' CODEC(ZSTD(1)),
    `avg_gas_used` UInt64 COMMENT 'Average gas used per block (VALID status only)' CODEC(ZSTD(1)),
    `avg_gas_limit` UInt64 COMMENT 'Average gas limit per block (VALID status only)' CODEC(ZSTD(1)),
    `avg_tx_count` Float32 COMMENT 'Average transaction count per block (VALID status only)' CODEC(ZSTD(1)),
    `avg_blob_count` Float32 COMMENT 'Average blob count per block (VALID status only)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_engine_new_payload_by_el_client_hourly_local', cityHash64(hour_start_date_time, meta_execution_implementation, meta_execution_version, node_class))
COMMENT 'Hourly aggregated engine_newPayload statistics by execution client with true percentiles'
