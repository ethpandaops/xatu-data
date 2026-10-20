CREATE TABLE mainnet.fct_block_graffiti_client_by_entity_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The wall clock time at the start of the hour' CODEC(DoubleDelta, ZSTD(1)),
    `entity` LowCardinality(String) COMMENT 'Staking entity of the proposer from dim_node, empty when the validator has none' CODEC(ZSTD(1)),
    `consensus_client` LowCardinality(String) COMMENT 'Consensus client named by the block graffiti, or unknown' CODEC(ZSTD(1)),
    `execution_client` LowCardinality(String) COMMENT 'Execution client named by the block graffiti, or unknown' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of canonical blocks in the hour from this entity with this consensus and execution client pair' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_block_graffiti_client_by_entity_hourly_local', cityHash64(hour_start_date_time, entity, consensus_client, execution_client))
COMMENT 'Hourly canonical block counts per proposer entity and consensus and execution client pair named by block graffiti'
