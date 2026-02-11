CREATE TABLE sepolia.fct_engine_new_payload_winrate_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation name (e.g., Reth, Nethermind, Besu)' CODEC(ZSTD(1)),
    `win_count` UInt32 COMMENT 'Number of slots where this client had the fastest engine_newPayload duration' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_engine_new_payload_winrate_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, node_class, meta_execution_implementation)
SETTINGS index_granularity = 8192
COMMENT 'Daily execution client winrate based on fastest engine_newPayload duration per slot'
