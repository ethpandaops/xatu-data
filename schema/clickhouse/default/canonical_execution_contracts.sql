CREATE TABLE default.canonical_execution_contracts
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash that created the contract' CODEC(ZSTD(1)),
    `internal_index` UInt32 COMMENT 'The internal index of the contract creation within the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `create_index` UInt32 COMMENT 'The create index' CODEC(DoubleDelta, ZSTD(1)),
    `contract_address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `deployer` String COMMENT 'The address of the contract deployer' CODEC(ZSTD(1)),
    `factory` String COMMENT 'The address of the factory that deployed the contract' CODEC(ZSTD(1)),
    `init_code` String COMMENT 'The initialization code of the contract' CODEC(ZSTD(1)),
    `code` Nullable(String) COMMENT 'The code of the contract' CODEC(ZSTD(1)),
    `init_code_hash` String COMMENT 'The hash of the initialization code' CODEC(ZSTD(1)),
    `n_init_code_bytes` UInt32 COMMENT 'Number of bytes in the initialization code' CODEC(DoubleDelta, ZSTD(1)),
    `n_code_bytes` UInt32 COMMENT 'Number of bytes in the contract code' CODEC(DoubleDelta, ZSTD(1)),
    `code_hash` String COMMENT 'The hash of the contract code' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_execution_contracts_local', cityHash64(block_number, meta_network_name, transaction_hash, internal_index))
COMMENT 'Contains canonical execution contract data.'
