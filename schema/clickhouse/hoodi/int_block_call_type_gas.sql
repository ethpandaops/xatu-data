CREATE TABLE hoodi.int_block_call_type_gas
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `call_type` LowCardinality(String) COMMENT 'The call opcode (CALL, DELEGATECALL, STATICCALL, CALLCODE, CREATE, CREATE2)',
    `call_count` UInt32 COMMENT 'Number of internal call frames of this type in the block' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'Gas used by those frames themselves, excluding their child frames' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'int_block_call_type_gas_local', cityHash64(block_number))
COMMENT 'Internal calls per call type in a block, every call frame except the transaction root frames'
