CREATE TABLE holesky.dim_token_contract
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `contract_address` String COMMENT 'The token contract address' CODEC(ZSTD(1)),
    `token_standard` LowCardinality(String) COMMENT 'Mutually-exclusive classification by the standard of the first Transfer event the contract emitted (first-come-first-serve): erc20 or erc721' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'dim_token_contract_local', cityHash64(contract_address))
COMMENT 'Contracts that have emitted ERC20/ERC721 Transfer events, classified into a single token_standard by their first transfer'
