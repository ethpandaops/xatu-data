CREATE TABLE holesky.int_block_transaction_summary
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'Position of the transaction within the block' CODEC(DoubleDelta, ZSTD(1)),
    `receipt_gas_used` Nullable(UInt64) COMMENT 'Gas used from the transaction receipt, the total gas the transaction used' CODEC(ZSTD(1)),
    `intrinsic_gas` Nullable(UInt64) COMMENT 'Intrinsic transaction cost (21000 plus calldata). Null for failed transactions' CODEC(ZSTD(1)),
    `gas_refund` UInt64 COMMENT 'Gas refunded to the transaction, 0 for failed transactions' CODEC(ZSTD(1)),
    `evm_gas` UInt64 COMMENT 'EVM execution gas of the whole call tree (the root frame cumulative gas)' CODEC(ZSTD(1)),
    `call_frame_count` UInt32 COMMENT 'Number of call frames in the transaction, including the root frame' CODEC(ZSTD(1)),
    `max_depth` UInt32 COMMENT 'Deepest call depth in the transaction (0 = root only)' CODEC(ZSTD(1)),
    `has_errors` Bool COMMENT 'Whether the root frame had an opcode that resulted in an error' CODEC(ZSTD(1)),
    `root_call_type` LowCardinality(String) COMMENT 'How the transaction started: CALL, CREATE, or the root frame call type' CODEC(ZSTD(1)),
    `target_address` Nullable(String) COMMENT 'The address the transaction called (hex encoded with 0x prefix), null for contract creation' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_block_transaction_summary_local', cityHash64(block_number))
COMMENT 'One row per transaction in a block with its call tree summarised: receipt and intrinsic gas from the root frame, and the frame count, deepest call and target from the whole tree'
