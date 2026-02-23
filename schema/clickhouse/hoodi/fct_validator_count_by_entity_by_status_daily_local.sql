CREATE TABLE hoodi.fct_validator_count_by_entity_by_status_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `entity` LowCardinality(String) COMMENT 'Entity name from dim_node mapping' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Validator status (active_ongoing, pending_queued, etc)' CODEC(ZSTD(1)),
    `validator_count` UInt32 COMMENT 'Number of validators with this status for this entity on this day' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_validator_count_by_entity_by_status_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, entity, status)
SETTINGS index_granularity = 8192
COMMENT 'Daily validator count by entity and status, derived from canonical_beacon_validators joined with dim_node'
