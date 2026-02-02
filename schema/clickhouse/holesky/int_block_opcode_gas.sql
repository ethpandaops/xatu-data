CREATE TABLE holesky.int_block_opcode_gas
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `opcode` LowCardinality(String) COMMENT 'The EVM opcode name (e.g., SLOAD, ADD, CALL)',
    `count` UInt64 COMMENT 'Total execution count of this opcode across all transactions in the block' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'Total gas consumed by this opcode across all transactions in the block' CODEC(ZSTD(1)),
    `error_count` UInt64 COMMENT 'Number of times this opcode resulted in an error across all transactions' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'The name of the network'
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_block_opcode_gas_local', cityHash64(block_number))
COMMENT 'Aggregated opcode-level gas usage per block. Derived from int_transaction_opcode_gas.'
