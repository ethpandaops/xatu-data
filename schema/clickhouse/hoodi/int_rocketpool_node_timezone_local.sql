CREATE TABLE hoodi.int_rocketpool_node_timezone_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `node_address` String COMMENT 'The Rocket Pool node operator address, lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `timezone` String COMMENT 'The self-reported timezone location string (e.g. Europe/London)' CODEC(ZSTD(1)),
    `set_block_number` UInt64 COMMENT 'Execution block number the timezone was set in' CODEC(DoubleDelta, ZSTD(1)),
    `set_date_time` DateTime COMMENT 'Wall clock time of the block the timezone was set in' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_rocketpool_node_timezone_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(set_date_time)
ORDER BY (node_address, set_block_number)
SETTINGS index_granularity = 8192
COMMENT 'Rocket Pool node timezone locations decoded from registerNode/setTimezoneLocation calldata'
