CREATE TABLE mainnet.fct_reorg_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `depth` UInt16 COMMENT 'Reorg depth (number of consecutive orphaned slots)' CODEC(ZSTD(1)),
    `reorg_count` UInt32 COMMENT 'Number of reorg events at this depth' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_reorg_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, depth)
SETTINGS index_granularity = 8192
COMMENT 'Daily reorg event counts by depth'
