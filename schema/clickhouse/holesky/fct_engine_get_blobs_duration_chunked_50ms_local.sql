CREATE TABLE holesky.fct_engine_get_blobs_duration_chunked_50ms_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number of the beacon block being reconstructed' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'Root of the beacon block (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `chunk_duration_ms` Int64 COMMENT 'Duration bucket in 50ms chunks (0, 50, 100, 150, ...)' CODEC(ZSTD(1)),
    `observation_count` UInt32 COMMENT 'Number of observations in this duration chunk' CODEC(ZSTD(1)),
    `success_count` UInt32 COMMENT 'Number of SUCCESS status observations in this chunk' CODEC(ZSTD(1)),
    `partial_count` UInt32 COMMENT 'Number of PARTIAL status observations in this chunk' CODEC(ZSTD(1)),
    `empty_count` UInt32 COMMENT 'Number of EMPTY status observations in this chunk' CODEC(ZSTD(1)),
    `error_count` UInt32 COMMENT 'Number of ERROR or UNSUPPORTED status observations in this chunk' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_engine_get_blobs_duration_chunked_50ms_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, block_root, node_class, chunk_duration_ms)
SETTINGS index_granularity = 8192
COMMENT 'Fine-grained engine_getBlobs duration distribution in 50ms chunks for latency histogram analysis'
