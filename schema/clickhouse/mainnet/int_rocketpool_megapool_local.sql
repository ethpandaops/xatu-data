CREATE TABLE mainnet.int_rocketpool_megapool_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `megapool_address` String COMMENT 'The Rocket Pool megapool contract address, lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `node_operator` String COMMENT 'The Rocket Pool node operator that owns the megapool, lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `created_block_number` UInt64 COMMENT 'Execution block number the megapool was deployed in' CODEC(DoubleDelta, ZSTD(1)),
    `created_date_time` DateTime COMMENT 'Wall clock time the megapool was deployed (decoded from the deposit event)' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'Execution transaction hash that deployed the megapool' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_rocketpool_megapool_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(created_date_time)
ORDER BY megapool_address
SETTINGS index_granularity = 8192
COMMENT 'Rocket Pool Saturn megapool contracts mapped to their node operator'
