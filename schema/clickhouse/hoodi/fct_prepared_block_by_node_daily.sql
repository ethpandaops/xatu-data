CREATE TABLE hoodi.fct_prepared_block_by_node_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period, by slot' CODEC(DoubleDelta, ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the node that built the blocks' CODEC(ZSTD(1)),
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'Consensus client implementation of the node' CODEC(ZSTD(1)),
    `meta_consensus_version` LowCardinality(String) COMMENT 'Consensus client version of the node' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Locally built blocks (rows in fct_prepared_block) from the node with this consensus client version in the day' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_prepared_block_by_node_daily_local', cityHash64(day_start_date, meta_client_name))
COMMENT 'Daily locally built block counts per Xatu node and consensus client version, from fct_prepared_block'
