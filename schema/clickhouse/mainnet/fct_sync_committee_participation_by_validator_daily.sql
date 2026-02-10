CREATE TABLE mainnet.fct_sync_committee_participation_by_validator_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The start of the day for this aggregation' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'Index of the validator' CODEC(ZSTD(1)),
    `total_slots` UInt32 COMMENT 'Total sync committee slots for the validator in this day' CODEC(ZSTD(1)),
    `participated_count` UInt32 COMMENT 'Number of slots where validator participated' CODEC(ZSTD(1)),
    `missed_count` UInt32 COMMENT 'Number of slots where validator missed' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_sync_committee_participation_by_validator_daily_local', cityHash64(validator_index, day_start_date))
COMMENT 'Daily aggregation of per-validator sync committee participation'
