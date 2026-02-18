CREATE TABLE sepolia.int_transaction_resource_gas
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number containing the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'The index of the transaction within the block' CODEC(DoubleDelta, ZSTD(1)),
    `gas_compute` UInt64 COMMENT 'Total compute gas (EVM execution + intrinsic compute)' CODEC(ZSTD(1)),
    `gas_memory` UInt64 COMMENT 'Total memory expansion gas' CODEC(ZSTD(1)),
    `gas_address_access` UInt64 COMMENT 'Total cold address/storage access gas' CODEC(ZSTD(1)),
    `gas_state_growth` UInt64 COMMENT 'Total state growth gas' CODEC(ZSTD(1)),
    `gas_history` UInt64 COMMENT 'Total history/log data gas' CODEC(ZSTD(1)),
    `gas_bloom_topics` UInt64 COMMENT 'Total bloom filter topic gas' CODEC(ZSTD(1)),
    `gas_block_size` UInt64 COMMENT 'Total block size gas (from intrinsic calldata)' CODEC(ZSTD(1)),
    `gas_refund` UInt64 COMMENT 'Gas refund from SSTORE operations' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'The name of the network'
)
ENGINE = Distributed('{cluster}', 'sepolia', 'int_transaction_resource_gas_local', cityHash64(block_number, transaction_hash))
COMMENT 'Per-transaction resource gas totals including intrinsic gas decomposition.'
