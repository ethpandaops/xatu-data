CREATE TABLE sepolia.fct_engine_new_payload_by_el_client_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number of the beacon block containing the payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'Root of the beacon block (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'Execution block hash (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation (e.g., Geth, Nethermind, Besu, Reth)',
    `meta_execution_version` LowCardinality(String) COMMENT 'Execution client version string',
    `status` LowCardinality(String) COMMENT 'Engine API response status (VALID, INVALID, SYNCING, ACCEPTED, INVALID_BLOCK_HASH, ERROR)' CODEC(ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `gas_used` UInt64 COMMENT 'Total gas used by all transactions in the block' CODEC(ZSTD(1)),
    `gas_limit` UInt64 COMMENT 'Gas limit of the block' CODEC(ZSTD(1)),
    `tx_count` UInt32 COMMENT 'Number of transactions in the block' CODEC(ZSTD(1)),
    `blob_count` UInt32 COMMENT 'Number of blobs in the block' CODEC(ZSTD(1)),
    `observation_count` UInt32 COMMENT 'Number of observations for this EL client/status' CODEC(ZSTD(1)),
    `unique_node_count` UInt32 COMMENT 'Number of unique nodes with this EL client/status' CODEC(ZSTD(1)),
    `avg_duration_ms` UInt64 COMMENT 'Average duration of engine_newPayload calls in milliseconds' CODEC(ZSTD(1)),
    `median_duration_ms` UInt64 COMMENT 'Median duration of engine_newPayload calls in milliseconds' CODEC(ZSTD(1)),
    `min_duration_ms` UInt64 COMMENT 'Minimum duration of engine_newPayload calls in milliseconds' CODEC(ZSTD(1)),
    `max_duration_ms` UInt64 COMMENT 'Maximum duration of engine_newPayload calls in milliseconds' CODEC(ZSTD(1)),
    `p95_duration_ms` UInt64 COMMENT '95th percentile duration of engine_newPayload calls in milliseconds' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_engine_new_payload_by_el_client_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, block_hash, meta_execution_implementation, meta_execution_version, status, node_class)
SETTINGS index_granularity = 8192
COMMENT 'engine_newPayload observations aggregated by execution client and status for EL comparison'
