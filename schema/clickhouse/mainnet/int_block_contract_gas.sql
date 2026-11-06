CREATE TABLE mainnet.int_block_contract_gas
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `target_address` String COMMENT 'The contract address (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `call_types` Array(LowCardinality(String)) COMMENT 'The call types used to call the contract in the block, a transaction calling it directly counts as CALL' CODEC(ZSTD(1)),
    `first_transaction_hash` FixedString(66) COMMENT 'The first transaction in the block that called the contract' CODEC(ZSTD(1)),
    `call_count` UInt32 COMMENT 'Number of call frames that targeted the contract in the block' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'Gas used by those frames themselves, excluding their child frames' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'int_block_contract_gas_local', cityHash64(block_number))
COMMENT 'Gas each contract used in a block, summed over every call frame that targeted it, root frames included. Contracts that used no gas are left out'
