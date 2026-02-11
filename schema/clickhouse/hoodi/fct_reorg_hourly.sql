CREATE TABLE hoodi.fct_reorg_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `depth` UInt16 COMMENT 'Reorg depth (number of consecutive orphaned slots)' CODEC(ZSTD(1)),
    `reorg_count` UInt32 COMMENT 'Number of reorg events at this depth' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_reorg_hourly_local', cityHash64(hour_start_date_time))
COMMENT 'Hourly reorg event counts by depth'
