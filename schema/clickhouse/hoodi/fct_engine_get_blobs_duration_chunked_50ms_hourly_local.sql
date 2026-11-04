CREATE TABLE hoodi.fct_engine_get_blobs_duration_chunked_50ms_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The wall clock time at the start of the hour, by slot' CODEC(DoubleDelta, ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation name (e.g., Geth, Nethermind, Besu, Reth)' CODEC(ZSTD(1)),
    `meta_execution_version` LowCardinality(String) COMMENT 'Full execution client version string from web3_clientVersion RPC' CODEC(ZSTD(1)),
    `chunk_duration_ms` Int64 COMMENT 'Duration bucket in 50ms chunks (0, 50, 100, 150, ...)' CODEC(ZSTD(1)),
    `observation_count` UInt32 COMMENT 'Number of engine_getBlobs observations in this duration chunk' CODEC(ZSTD(1)),
    `success_count` UInt32 COMMENT 'Number of SUCCESS status observations in this chunk' CODEC(ZSTD(1)),
    `partial_count` UInt32 COMMENT 'Number of PARTIAL status observations in this chunk' CODEC(ZSTD(1)),
    `empty_count` UInt32 COMMENT 'Number of EMPTY status observations in this chunk' CODEC(ZSTD(1)),
    `error_count` UInt32 COMMENT 'Number of ERROR or UNSUPPORTED status observations in this chunk' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_engine_get_blobs_duration_chunked_50ms_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY (hour_start_date_time, node_class, meta_execution_implementation, meta_execution_version, chunk_duration_ms)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Hourly engine_getBlobs duration distribution in 50ms chunks per node class and execution client version, from int_engine_get_blobs, for latency histograms and percentiles over long ranges'
