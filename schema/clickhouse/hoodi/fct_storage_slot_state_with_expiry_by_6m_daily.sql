CREATE TABLE hoodi.fct_storage_slot_state_with_expiry_by_6m_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `active_slots` Int64 COMMENT 'Cumulative count of active storage slots at end of day (with 6m expiry policy)' CODEC(ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Cumulative sum of effective bytes at end of day (with 6m expiry policy)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_storage_slot_state_with_expiry_by_6m_daily_local', cityHash64(day_start_date))
COMMENT 'Storage slot state metrics with 6-month expiry policy aggregated by day'
