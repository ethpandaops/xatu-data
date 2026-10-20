CREATE TABLE default.canonical_execution_transaction_structlog_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `transaction_index` UInt64 COMMENT 'The transaction position in the block' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_gas` UInt64 COMMENT 'The transaction gas' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_failed` Bool COMMENT 'The transaction failed' CODEC(ZSTD(1)),
    `transaction_return_value` Nullable(String) COMMENT 'The transaction return value' CODEC(ZSTD(1)),
    `index` UInt32 COMMENT 'The index of this structlog in this transaction' CODEC(DoubleDelta, ZSTD(1)),
    `operation` LowCardinality(String) COMMENT 'The operation',
    `gas` UInt64 COMMENT 'The gas' CODEC(Delta(8), ZSTD(1)),
    `gas_cost` UInt64 COMMENT 'The gas cost' CODEC(DoubleDelta, ZSTD(1)),
    `gas_used` UInt64 DEFAULT 0 COMMENT 'Actual gas consumed (computed from consecutive gas values)' CODEC(ZSTD(1)),
    `gas_self` UInt64 DEFAULT 0 COMMENT 'Gas consumed by this opcode only, excludes child frame gas for CALL/CREATE opcodes. sum(gas_self) = total execution gas without double counting' CODEC(ZSTD(1)),
    `depth` UInt64 COMMENT 'The depth' CODEC(DoubleDelta, ZSTD(1)),
    `return_data` Nullable(String) COMMENT 'Return data buffer left by the CALL/CREATE-family opcode that just returned in this frame, set only on the first opcode after that call returns (NULL if empty). The buffer at any other opcode is the return_data of the latest such row in the same call_frame_id. Before execution-processor v0.3.0 (2026-10-20) the buffer was repeated on every opcode' CODEC(ZSTD(1)),
    `refund` Nullable(UInt64) COMMENT 'The refund' CODEC(ZSTD(1)),
    `error` Nullable(String) COMMENT 'The error' CODEC(ZSTD(1)),
    `call_to_address` Nullable(String) COMMENT 'Target address of a CALL, CALLCODE, DELEGATECALL or STATICCALL, or the address a CREATE or CREATE2 deployed (zero address if it failed). Before execution-processor v0.4.0 (2026-10-20) CREATE and CREATE2 rows from embedded (erigone) tracing had NULL' CODEC(ZSTD(1)),
    `call_frame_id` UInt32 DEFAULT 0 COMMENT 'Sequential identifier for the call frame within the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `call_frame_path` Array(UInt32) DEFAULT [0] COMMENT 'Path of frame IDs from root to current frame' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name',
    `synthetic` Bool COMMENT 'True for the row added after a CALL-family opcode whose target ran no code (an EOA or empty account, not a precompile). It has the CALL\\'s index, depth + 1, its own call_frame_id and an empty operation. Before execution-processor v0.4.0 (2026-10-20) these rows shared the CALL row\\'s key and one of the two was lost on merge' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/canonical_execution_transaction_structlog_local', '{replica}', updated_date_time)
PARTITION BY (meta_network_name, intDiv(block_number, 201600))
PRIMARY KEY (meta_network_name, block_number, transaction_hash, index)
ORDER BY (meta_network_name, block_number, transaction_hash, index, synthetic)
SETTINGS index_granularity = 8192
COMMENT 'Contains canonical execution transaction structlog data.'
