CREATE TABLE holesky.fct_block_proposal_status_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Block proposal status (canonical, orphaned, missed)' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of slots with this status' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_block_proposal_status_hourly_local', cityHash64(hour_start_date_time))
COMMENT 'Hourly block proposal status counts by status type'
