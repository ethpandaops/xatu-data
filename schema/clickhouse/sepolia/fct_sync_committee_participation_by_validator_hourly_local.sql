CREATE TABLE sepolia.fct_sync_committee_participation_by_validator_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The start of the hour for this aggregation' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'Index of the validator' CODEC(ZSTD(1)),
    `total_slots` UInt32 COMMENT 'Total sync committee slots for the validator in this hour' CODEC(ZSTD(1)),
    `participated_count` UInt32 COMMENT 'Number of slots where validator participated' CODEC(ZSTD(1)),
    `missed_count` UInt32 COMMENT 'Number of slots where validator missed' CODEC(ZSTD(1)),
    PROJECTION p_by_hour_start_date_time
    (
        SELECT *
        ORDER BY
            hour_start_date_time,
            validator_index
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_sync_committee_participation_by_validator_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY (validator_index, hour_start_date_time)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Hourly aggregation of per-validator sync committee participation'
