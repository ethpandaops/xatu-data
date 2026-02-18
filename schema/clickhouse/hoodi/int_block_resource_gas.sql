CREATE TABLE hoodi.int_block_resource_gas
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `gas_compute` UInt64 COMMENT 'Total compute gas across all transactions' CODEC(ZSTD(1)),
    `gas_memory` UInt64 COMMENT 'Total memory expansion gas across all transactions' CODEC(ZSTD(1)),
    `gas_address_access` UInt64 COMMENT 'Total cold address/storage access gas across all transactions' CODEC(ZSTD(1)),
    `gas_state_growth` UInt64 COMMENT 'Total state growth gas across all transactions' CODEC(ZSTD(1)),
    `gas_history` UInt64 COMMENT 'Total history/log data gas across all transactions' CODEC(ZSTD(1)),
    `gas_bloom_topics` UInt64 COMMENT 'Total bloom filter topic gas across all transactions' CODEC(ZSTD(1)),
    `gas_block_size` UInt64 COMMENT 'Total block size gas across all transactions' CODEC(ZSTD(1)),
    `gas_refund` UInt64 COMMENT 'Total gas refund across all transactions' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'The name of the network'
)
ENGINE = Distributed('{cluster}', 'hoodi', 'int_block_resource_gas_local', cityHash64(block_number))
COMMENT 'Per-block resource gas totals. Derived from int_transaction_resource_gas.'
