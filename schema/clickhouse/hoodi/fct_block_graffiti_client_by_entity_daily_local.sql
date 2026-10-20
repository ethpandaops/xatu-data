CREATE TABLE hoodi.fct_block_graffiti_client_by_entity_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `entity` LowCardinality(String) COMMENT 'Staking entity of the proposer from dim_node, empty when the validator has none' CODEC(ZSTD(1)),
    `consensus_client` LowCardinality(String) COMMENT 'Consensus client named by the block graffiti, or unknown' CODEC(ZSTD(1)),
    `execution_client` LowCardinality(String) COMMENT 'Execution client named by the block graffiti, or unknown' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of canonical blocks in the day from this entity with this consensus and execution client pair' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_block_graffiti_client_by_entity_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, entity, consensus_client, execution_client)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily canonical block counts per proposer entity and consensus and execution client pair named by block graffiti'
