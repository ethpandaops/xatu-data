CREATE TABLE mainnet.fct_node_count_by_cl_client_version_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The UTC day' CODEC(DoubleDelta, ZSTD(1)),
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'The consensus client the Xatu nodes ran',
    `meta_consensus_version` LowCardinality(String) COMMENT 'The consensus client version the Xatu nodes reported, as the client reports it',
    `node_count` UInt32 COMMENT 'The number of distinct Xatu nodes whose last reported version that day was this one' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_node_count_by_cl_client_version_daily_local', cityHash64(day_start_date, meta_consensus_implementation))
COMMENT 'Xatu nodes per day, consensus client and consensus client version, from the heads each node saw'
