CREATE TABLE mainnet.fct_engine_new_payload_duration_chunked_50ms
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number of the beacon block containing the payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'Execution block hash (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `chunk_duration_ms` Int64 COMMENT 'Duration bucket in 50ms chunks (0, 50, 100, 150, ...)' CODEC(ZSTD(1)),
    `observation_count` UInt32 COMMENT 'Number of observations in this duration chunk' CODEC(ZSTD(1)),
    `valid_count` UInt32 COMMENT 'Number of VALID status observations in this chunk' CODEC(ZSTD(1)),
    `invalid_count` UInt32 COMMENT 'Number of INVALID or INVALID_BLOCK_HASH status observations in this chunk' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_engine_new_payload_duration_chunked_50ms_local', cityHash64(slot_start_date_time, block_hash, node_class, chunk_duration_ms))
COMMENT 'Fine-grained engine_newPayload duration distribution in 50ms chunks for latency histogram analysis'
