CREATE TABLE mainnet.fct_reorg_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `depth` UInt16 COMMENT 'Reorg depth (number of consecutive orphaned slots)' CODEC(ZSTD(1)),
    `reorg_count` UInt32 COMMENT 'Number of reorg events at this depth' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_reorg_daily_local', cityHash64(day_start_date))
COMMENT 'Daily reorg event counts by depth'
