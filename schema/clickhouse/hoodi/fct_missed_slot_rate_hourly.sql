CREATE TABLE hoodi.fct_missed_slot_rate_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Total number of slots in this hour' CODEC(ZSTD(1)),
    `missed_count` UInt32 COMMENT 'Number of missed slots in this hour' CODEC(ZSTD(1)),
    `missed_rate` Float32 COMMENT 'Missed slot rate (%)' CODEC(ZSTD(1)),
    `moving_avg_missed_rate` Float32 COMMENT 'Moving average missed rate (6-hour window)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_missed_slot_rate_hourly_local', cityHash64(hour_start_date_time))
COMMENT 'Hourly missed slot rate with moving averages'
