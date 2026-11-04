CREATE TABLE holesky.fct_block_payload_status_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'PTC verdict bucket: delivered or absent' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of blocks with this payload outcome in the day' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_block_payload_status_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, status)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Gloas (ePBS) daily payload delivery outcomes judged by the PTC, the daily twin of fct_block_payload_status_hourly. A block counts as delivered when a majority of observed PTC votes said the payload was present, absent otherwise'
