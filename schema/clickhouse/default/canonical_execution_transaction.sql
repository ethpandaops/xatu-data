CREATE TABLE default.canonical_execution_transaction
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_index` UInt64 COMMENT 'The transaction index' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `nonce` UInt64 COMMENT 'The transaction nonce' CODEC(ZSTD(1)),
    `from_address` String COMMENT 'The transaction from address' CODEC(ZSTD(1)),
    `to_address` Nullable(String) COMMENT 'The transaction to address' CODEC(ZSTD(1)),
    `value` UInt256 COMMENT 'The transaction value in float64' CODEC(ZSTD(1)),
    `input` Nullable(String) COMMENT 'The transaction input in hex' CODEC(ZSTD(1)),
    `gas_limit` UInt64 COMMENT 'The transaction gas limit' CODEC(ZSTD(1)),
    `gas_used` UInt64 COMMENT 'The transaction gas used' CODEC(ZSTD(1)),
    `gas_price` UInt64 COMMENT 'The transaction gas price' CODEC(ZSTD(1)),
    `transaction_type` UInt32 COMMENT 'The transaction type' CODEC(ZSTD(1)),
    `max_priority_fee_per_gas` UInt64 COMMENT 'The transaction max priority fee per gas' CODEC(ZSTD(1)),
    `max_fee_per_gas` UInt64 COMMENT 'The transaction max fee per gas' CODEC(ZSTD(1)),
    `success` Bool COMMENT 'The transaction success' CODEC(ZSTD(1)),
    `n_input_bytes` UInt32 COMMENT 'The transaction input bytes' CODEC(ZSTD(1)),
    `n_input_zero_bytes` UInt32 COMMENT 'The transaction input zero bytes' CODEC(ZSTD(1)),
    `n_input_nonzero_bytes` UInt32 COMMENT 'The transaction input nonzero bytes' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_execution_transaction_local', cityHash64(block_number, meta_network_name, transaction_hash))
COMMENT 'Contains canonical execution transaction data.'
