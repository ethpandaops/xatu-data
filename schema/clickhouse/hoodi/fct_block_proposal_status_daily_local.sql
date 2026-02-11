CREATE TABLE hoodi.fct_block_proposal_status_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Block proposal status (canonical, orphaned, missed)' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of slots with this status' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_block_proposal_status_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, status)
SETTINGS index_granularity = 8192
COMMENT 'Daily block proposal status counts by status type'
