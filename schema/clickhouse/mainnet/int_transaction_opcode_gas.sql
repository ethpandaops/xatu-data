CREATE TABLE mainnet.int_transaction_opcode_gas
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number containing the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'The index of the transaction within the block' CODEC(DoubleDelta, ZSTD(1)),
    `opcode` LowCardinality(String) COMMENT 'The EVM opcode name (e.g., SLOAD, ADD, CALL)',
    `count` UInt64 COMMENT 'Number of times this opcode was executed in the transaction' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'Gas consumed by this opcode. sum(gas) = transaction executed gas' CODEC(ZSTD(1)),
    `gas_cumulative` UInt64 COMMENT 'For CALL opcodes: includes all descendant frame gas. For others: same as gas' CODEC(ZSTD(1)),
    `error_count` UInt64 COMMENT 'Number of times this opcode resulted in an error' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'The name of the network'
)
ENGINE = Distributed('{cluster}', 'mainnet', 'int_transaction_opcode_gas_local', cityHash64(block_number, transaction_hash))
COMMENT 'Aggregated opcode-level gas usage per transaction. Source: canonical_execution_transaction_structlog'
