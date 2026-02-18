CREATE TABLE sepolia.int_block_resource_gas_local
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
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_block_resource_gas_local', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 201600)
ORDER BY (block_number, meta_network_name)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Per-block resource gas totals. Derived from int_transaction_resource_gas.'
