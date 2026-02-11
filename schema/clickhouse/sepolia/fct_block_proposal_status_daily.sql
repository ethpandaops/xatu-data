CREATE TABLE sepolia.fct_block_proposal_status_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Block proposal status (canonical, orphaned, missed)' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of slots with this status' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_block_proposal_status_daily_local', cityHash64(day_start_date))
COMMENT 'Daily block proposal status counts by status type'
