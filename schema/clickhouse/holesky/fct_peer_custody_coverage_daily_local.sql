CREATE TABLE holesky.fct_peer_custody_coverage_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `custody_peer_count` UInt32 COMMENT 'Peers counted: those with a known custody group count and node ID' CODEC(ZSTD(1)),
    `supernode_peer_count` UInt32 COMMENT 'Of those, peers custodying all 128 groups (supernodes)' CODEC(ZSTD(1)),
    `min_column_custodian_peer_count` UInt32 COMMENT 'Custodians of the thinnest column' CODEC(ZSTD(1)),
    `min_column_index` UInt8 COMMENT 'The thinnest column, the lowest index on a tie' CODEC(ZSTD(1)),
    `median_column_custodian_peer_count` UInt32 COMMENT 'Median custodians per column (the lower of the middle two)' CODEC(ZSTD(1)),
    `max_column_custodian_peer_count` UInt32 COMMENT 'Custodians of the thickest column' CODEC(ZSTD(1)),
    `min_column_non_supernode_peer_count` UInt32 COMMENT 'Custodians of the thinnest column without supernodes' CODEC(ZSTD(1)),
    `min_column_without_largest_autonomous_system_peer_count` UInt32 COMMENT 'Fewest custodians any column keeps once its largest hosting autonomous system is taken away' CODEC(ZSTD(1)),
    `min_column_country_count` UInt16 COMMENT 'Fewest countries any column is custodied in' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_custody_coverage_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily spread of consensus peers over the 128 data columns they custody, one row a day: the thinnest, median and thickest column, and the thinnest once supernodes or its largest hosting autonomous system are taken away. Peers as in fct_peer_custody_by_column_daily.'
