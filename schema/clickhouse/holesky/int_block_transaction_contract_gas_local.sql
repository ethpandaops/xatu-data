CREATE TABLE holesky.int_block_transaction_contract_gas_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `target_address` String COMMENT 'The contract address (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'Position of the transaction within the block' CODEC(DoubleDelta, ZSTD(1)),
    `call_count` UInt32 COMMENT 'Number of call frames in the transaction that targeted the contract' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'Gas used by those frames themselves, excluding their child frames' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_block_transaction_contract_gas_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 201600)
ORDER BY (block_number, transaction_hash, target_address)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Gas each contract used within each transaction of a block, the flows from transactions to contracts. Contracts that used no gas in the transaction are left out'
