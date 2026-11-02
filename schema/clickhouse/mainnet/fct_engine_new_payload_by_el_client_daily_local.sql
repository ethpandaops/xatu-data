CREATE TABLE mainnet.fct_engine_new_payload_by_el_client_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period, by slot' CODEC(DoubleDelta, ZSTD(1)),
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation (e.g., Geth, Nethermind, Besu, Reth)',
    `meta_execution_version` LowCardinality(String) COMMENT 'Execution client version string',
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of unique slots in this day' CODEC(ZSTD(1)),
    `observation_count` UInt32 COMMENT 'Total number of observations for this client in this day' CODEC(ZSTD(1)),
    `unique_node_count` UInt32 COMMENT 'Number of unique nodes reporting for this client in this day' CODEC(ZSTD(1)),
    `valid_count` UInt64 COMMENT 'Number of observations with VALID status' CODEC(ZSTD(1)),
    `invalid_count` UInt64 COMMENT 'Number of observations with INVALID status' CODEC(ZSTD(1)),
    `syncing_count` UInt64 COMMENT 'Number of observations with SYNCING status' CODEC(ZSTD(1)),
    `accepted_count` UInt64 COMMENT 'Number of observations with ACCEPTED status' CODEC(ZSTD(1)),
    `avg_duration_ms` UInt64 COMMENT 'Average duration of VALID engine_newPayload calls in milliseconds' CODEC(ZSTD(1)),
    `p50_duration_ms` UInt64 COMMENT '50th percentile (median) duration of VALID calls over the day in milliseconds' CODEC(ZSTD(1)),
    `p95_duration_ms` UInt64 COMMENT '95th percentile duration of VALID calls over the day in milliseconds' CODEC(ZSTD(1)),
    `min_duration_ms` UInt64 COMMENT 'Minimum duration of VALID calls in milliseconds' CODEC(ZSTD(1)),
    `max_duration_ms` UInt64 COMMENT 'Maximum duration of VALID calls in milliseconds' CODEC(ZSTD(1)),
    `avg_gas_used` UInt64 COMMENT 'Average gas used per block (VALID status only)' CODEC(ZSTD(1)),
    `avg_gas_limit` UInt64 COMMENT 'Average gas limit per block (VALID status only)' CODEC(ZSTD(1)),
    `avg_tx_count` Float32 COMMENT 'Average transaction count per block (VALID status only)' CODEC(ZSTD(1)),
    `avg_blob_count` Float32 COMMENT 'Average blob count per block (VALID status only)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_engine_new_payload_by_el_client_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, meta_execution_implementation, meta_execution_version, node_class)
SETTINGS index_granularity = 8192
COMMENT 'Daily aggregated engine_newPayload statistics by execution client with true percentiles'
