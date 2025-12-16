CREATE TABLE default.canonical_execution_erc721_transfers
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_index` UInt64 COMMENT 'The transaction index in the block' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `internal_index` UInt32 COMMENT 'The internal index of the transfer within the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `log_index` UInt64 COMMENT 'The log index in the block' CODEC(DoubleDelta, ZSTD(1)),
    `erc20` String COMMENT 'The erc20 address' CODEC(ZSTD(1)),
    `from_address` String COMMENT 'The from address' CODEC(ZSTD(1)),
    `to_address` String COMMENT 'The to address' CODEC(ZSTD(1)),
    `token` UInt256 COMMENT 'The token id' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_execution_erc721_transfers_local', cityHash64(block_number, meta_network_name, transaction_hash, internal_index))
COMMENT 'Contains canonical execution erc721 transfer data.'
