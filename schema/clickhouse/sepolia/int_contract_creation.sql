CREATE TABLE sepolia.int_contract_creation
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'Block where contract was created' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` String COMMENT 'Transaction hash' CODEC(ZSTD(1)),
    `transaction_index` UInt16 COMMENT 'Position in block' CODEC(DoubleDelta, ZSTD(1)),
    `internal_index` UInt32 COMMENT 'Position within transaction' CODEC(DoubleDelta, ZSTD(1)),
    `contract_address` String COMMENT 'Address of created contract' CODEC(ZSTD(1)),
    `deployer` String COMMENT 'Address that deployed the contract' CODEC(ZSTD(1)),
    `factory` String COMMENT 'Factory contract address if applicable' CODEC(ZSTD(1)),
    `init_code_hash` String COMMENT 'Hash of the initialization code' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'int_contract_creation_local', cityHash64(block_number, contract_address))
COMMENT 'Contract creation events with projection for efficient address lookups'
