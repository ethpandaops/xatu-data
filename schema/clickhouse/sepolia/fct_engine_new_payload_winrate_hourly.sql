CREATE TABLE sepolia.fct_engine_new_payload_winrate_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation name (e.g., Reth, Nethermind, Besu)' CODEC(ZSTD(1)),
    `win_count` UInt32 COMMENT 'Number of slots where this client had the fastest engine_newPayload duration' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_engine_new_payload_winrate_hourly_local', cityHash64(hour_start_date_time, node_class))
COMMENT 'Hourly execution client winrate based on fastest engine_newPayload duration per slot'
