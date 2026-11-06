CREATE TABLE mainnet.int_block_opcode_resource_gas_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `opcode` LowCardinality(String) COMMENT 'The EVM opcode name (e.g., SLOAD, ADD, CALL)',
    `count` UInt64 COMMENT 'Number of times this opcode was executed in the block' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'Total gas consumed by this opcode in the block' CODEC(ZSTD(1)),
    `gas_compute` UInt64 COMMENT 'Gas attributed to pure computation' CODEC(ZSTD(1)),
    `gas_memory` UInt64 COMMENT 'Gas attributed to memory expansion' CODEC(ZSTD(1)),
    `gas_address_access` UInt64 COMMENT 'Gas attributed to cold address and storage access (EIP-2929)' CODEC(ZSTD(1)),
    `gas_state_growth` UInt64 COMMENT 'Gas attributed to state growth (new storage slots, contract creation)' CODEC(ZSTD(1)),
    `gas_history` UInt64 COMMENT 'Gas attributed to history and log data storage' CODEC(ZSTD(1)),
    `gas_bloom_topics` UInt64 COMMENT 'Gas attributed to bloom filter topic indexing' CODEC(ZSTD(1)),
    `gas_block_size` UInt64 COMMENT 'Gas attributed to block size (always 0 at opcode level)' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'The name of the network'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_block_opcode_resource_gas_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 201600)
ORDER BY (block_number, opcode, meta_network_name)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Per-opcode resource gas per block, summed over every transaction and call frame in the block'
