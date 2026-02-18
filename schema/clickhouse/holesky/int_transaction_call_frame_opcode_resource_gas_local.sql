CREATE TABLE holesky.int_transaction_call_frame_opcode_resource_gas_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number containing the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'The index of the transaction within the block' CODEC(DoubleDelta, ZSTD(1)),
    `call_frame_id` UInt32 COMMENT 'Sequential frame ID within transaction (0 = root)' CODEC(DoubleDelta, ZSTD(1)),
    `opcode` LowCardinality(String) COMMENT 'The EVM opcode name (e.g., SLOAD, ADD, CALL)',
    `count` UInt64 COMMENT 'Number of times this opcode was executed in this frame' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'Total gas consumed by this opcode in this frame' CODEC(ZSTD(1)),
    `gas_compute` UInt64 COMMENT 'Gas attributed to pure computation' CODEC(ZSTD(1)),
    `gas_memory` UInt64 COMMENT 'Gas attributed to memory expansion' CODEC(ZSTD(1)),
    `gas_address_access` UInt64 COMMENT 'Gas attributed to cold address/storage access (EIP-2929)' CODEC(ZSTD(1)),
    `gas_state_growth` UInt64 COMMENT 'Gas attributed to state growth (new storage slots, contract creation)' CODEC(ZSTD(1)),
    `gas_history` UInt64 COMMENT 'Gas attributed to history/log data storage' CODEC(ZSTD(1)),
    `gas_bloom_topics` UInt64 COMMENT 'Gas attributed to bloom filter topic indexing' CODEC(ZSTD(1)),
    `gas_block_size` UInt64 COMMENT 'Gas attributed to block size (always 0 at opcode level)' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'The name of the network'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_transaction_call_frame_opcode_resource_gas_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 201600)
ORDER BY (block_number, transaction_hash, call_frame_id, opcode, meta_network_name)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Per-frame per-opcode resource gas decomposition into 7 categories.'
