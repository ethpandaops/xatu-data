CREATE TABLE holesky.fct_engine_new_payload_duration_histogram_by_version_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The UTC day' CODEC(DoubleDelta, ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification (eip7870-block-builder for reference nodes, empty for other Xatu nodes)',
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation name (e.g., Geth, Nethermind, Besu, Reth)',
    `meta_execution_version` LowCardinality(String) COMMENT 'Full execution client version string from web3_clientVersion RPC',
    `status` LowCardinality(String) COMMENT 'Engine API response status (VALID, INVALID, SYNCING, ACCEPTED, INVALID_BLOCK_HASH, ERROR)',
    `bucket_index` UInt16 COMMENT 'Duration bucket: 0 to 24 are 1ms wide, from 25 each bucket is about 4% wider than the last' CODEC(ZSTD(1)),
    `bucket_lower_ms` UInt32 COMMENT 'Lower bound of the bucket in milliseconds, inclusive' CODEC(ZSTD(1)),
    `bucket_upper_ms` UInt32 COMMENT 'Upper bound of the bucket in milliseconds, exclusive' CODEC(ZSTD(1)),
    `observation_count` UInt32 COMMENT 'Number of engine_newPayload calls whose duration falls in the bucket' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_engine_new_payload_duration_histogram_by_version_daily_local', cityHash64(day_start_date, meta_execution_implementation))
COMMENT 'engine_newPayload duration histogram with log-scaled buckets, 1ms wide below 25ms and about 4% wide above, per UTC day, node class, execution client, execution client version and status, from int_engine_new_payload. Summed over any range it gives the range percentiles within one bucket'
