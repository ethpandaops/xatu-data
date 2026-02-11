CREATE TABLE sepolia.int_engine_new_payload_fastest_execution_by_node_class_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number of the beacon block containing the payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'Execution block hash (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `duration_ms` UInt64 COMMENT 'Duration of the fastest engine_newPayload call in milliseconds' CODEC(ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation name (e.g., Geth, Nethermind, Besu, Reth)' CODEC(ZSTD(1)),
    `meta_execution_version` LowCardinality(String) COMMENT 'Full execution client version string from web3_clientVersion RPC' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the client that generated the event' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_engine_new_payload_fastest_execution_by_node_class_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, slot, node_class)
SETTINGS index_granularity = 8192
COMMENT 'Fastest valid engine_newPayload observation per slot per node_class'
