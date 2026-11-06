CREATE TABLE mainnet.fct_engine_new_payload_duration_percentile_window_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `window_grain` LowCardinality(String) COMMENT 'hour for windows ending at the last complete hour, day for windows of complete UTC days ending yesterday',
    `window_length` UInt16 COMMENT 'Window length in hours (1, 6, 24, 168 or 744) or days (7, 14, 30, 60, 90, 180 or 365), 0 for all history' CODEC(ZSTD(1)),
    `window_start_date_time` DateTime COMMENT 'Start of the window, inclusive' CODEC(DoubleDelta, ZSTD(1)),
    `window_end_date_time` DateTime COMMENT 'End of the window, exclusive' CODEC(DoubleDelta, ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification: eip7870-block-builder for reference nodes, empty for other Xatu nodes, all for every Xatu node together',
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation name (e.g., Geth, Nethermind, Besu, Reth)',
    `meta_execution_build_line` LowCardinality(String) COMMENT 'Build line: the version without its trailing commit hash (e.g., 1.17.11-unstable), empty for all versions of the client together',
    `meta_execution_version` LowCardinality(String) COMMENT 'Full execution client version string from web3_clientVersion RPC, empty for all builds of the build line together',
    `status` LowCardinality(String) COMMENT 'Engine API response status (VALID, INVALID, SYNCING, ACCEPTED, INVALID_BLOCK_HASH, ERROR)',
    `observation_count` UInt64 COMMENT 'Number of engine_newPayload calls in the window, 0 for a key that left the window' CODEC(ZSTD(1)),
    `p50_duration_ms` Float32 COMMENT 'Median engine_newPayload duration in milliseconds over the window, interpolated inside its log-scaled bucket (about 4% wide)' CODEC(ZSTD(1)),
    `p95_duration_ms` Float32 COMMENT '95th percentile engine_newPayload duration in milliseconds over the window, interpolated inside its log-scaled bucket (about 4% wide)' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_engine_new_payload_duration_percentile_window_local', '{replica}', updated_date_time)
ORDER BY (window_grain, window_length, node_class, meta_execution_implementation, meta_execution_build_line, meta_execution_version, status)
SETTINGS index_granularity = 8192
COMMENT 'engine_newPayload duration P50 and P95 per window (1 hour to all history, aligned like Lab ranges), node class (or all Xatu nodes), execution client, build line and version (empty for all), and status, recomputed hourly'
