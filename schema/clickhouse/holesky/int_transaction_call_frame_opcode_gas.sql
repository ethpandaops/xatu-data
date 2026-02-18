CREATE TABLE holesky.int_transaction_call_frame_opcode_gas
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number containing the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'The index of the transaction within the block' CODEC(DoubleDelta, ZSTD(1)),
    `call_frame_id` UInt32 COMMENT 'Sequential frame ID within transaction (0 = root)' CODEC(DoubleDelta, ZSTD(1)),
    `opcode` LowCardinality(String) COMMENT 'The EVM opcode name (e.g., SLOAD, ADD, CALL)',
    `count` UInt64 COMMENT 'Number of times this opcode was executed in this frame' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'Gas consumed by this opcode in this frame. sum(gas) = frame gas' CODEC(ZSTD(1)),
    `gas_cumulative` UInt64 COMMENT 'For CALL opcodes: includes all descendant frame gas. For others: same as gas' CODEC(ZSTD(1)),
    `error_count` UInt64 COMMENT 'Number of times this opcode resulted in an error in this frame' CODEC(ZSTD(1)),
    `memory_words_sum_before` UInt64 DEFAULT 0 COMMENT 'SUM(ceil(memory_bytes/32)) before each opcode executes.',
    `memory_words_sum_after` UInt64 DEFAULT 0 COMMENT 'SUM(ceil(memory_bytes/32)) after each opcode executes.',
    `memory_words_sq_sum_before` UInt64 DEFAULT 0 COMMENT 'SUM(words_before²).',
    `memory_words_sq_sum_after` UInt64 DEFAULT 0 COMMENT 'SUM(words_after²).',
    `memory_expansion_gas` UInt64 DEFAULT 0 COMMENT 'SUM(memory_expansion_gas). Exact per-opcode memory expansion cost.',
    `cold_access_count` UInt64 DEFAULT 0 COMMENT 'Number of cold storage/account accesses (EIP-2929).',
    `meta_network_name` LowCardinality(String) COMMENT 'The name of the network'
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_transaction_call_frame_opcode_gas_local', cityHash64(block_number, transaction_hash))
COMMENT 'Aggregated opcode-level gas usage per call frame. Enables per-frame opcode analysis.'
