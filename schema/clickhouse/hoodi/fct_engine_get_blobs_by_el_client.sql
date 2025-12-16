CREATE TABLE hoodi.fct_engine_get_blobs_by_el_client
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number of the beacon block being reconstructed' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'Root of the beacon block (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation (e.g., Geth, Nethermind, Besu, Reth)',
    `meta_execution_version` LowCardinality(String) COMMENT 'Execution client version string',
    `status` LowCardinality(String) COMMENT 'Engine API response status (SUCCESS, PARTIAL, EMPTY, UNSUPPORTED, ERROR)' CODEC(ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `observation_count` UInt32 COMMENT 'Number of observations for this EL client/status' CODEC(ZSTD(1)),
    `unique_node_count` UInt32 COMMENT 'Number of unique nodes with this EL client/status' CODEC(ZSTD(1)),
    `max_requested_count` UInt32 COMMENT 'Maximum number of versioned hashes requested' CODEC(ZSTD(1)),
    `avg_returned_count` Float64 COMMENT 'Average number of non-null blobs returned' CODEC(ZSTD(1)),
    `avg_duration_ms` UInt64 COMMENT 'Average duration of engine_getBlobs calls in milliseconds' CODEC(ZSTD(1)),
    `median_duration_ms` UInt64 COMMENT 'Median duration of engine_getBlobs calls in milliseconds' CODEC(ZSTD(1)),
    `min_duration_ms` UInt64 COMMENT 'Minimum duration of engine_getBlobs calls in milliseconds' CODEC(ZSTD(1)),
    `max_duration_ms` UInt64 COMMENT 'Maximum duration of engine_getBlobs calls in milliseconds' CODEC(ZSTD(1)),
    `p95_duration_ms` UInt64 COMMENT '95th percentile duration of engine_getBlobs calls in milliseconds' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_engine_get_blobs_by_el_client_local', cityHash64(slot_start_date_time, block_root, meta_execution_implementation, meta_execution_version, status, node_class))
COMMENT 'engine_getBlobs observations aggregated by execution client and status for EL comparison'
