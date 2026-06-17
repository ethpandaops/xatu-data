CREATE TABLE sepolia.int_token_contract_storage_state_by_block
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `token_standard` LowCardinality(String) COMMENT 'Token standard: erc20 or erc721' CODEC(ZSTD(1)),
    `slots_delta` Int32 COMMENT 'Change in active slots owned by contracts of this standard at this block' CODEC(DoubleDelta, ZSTD(1)),
    `active_slots` Int64 COMMENT 'Cumulative active storage slots owned by contracts of this standard at this block' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'int_token_contract_storage_state_by_block_local', cityHash64(block_number))
COMMENT 'Cumulative live storage slots owned by ERC20/ERC721 contracts per block, split by token_standard'
