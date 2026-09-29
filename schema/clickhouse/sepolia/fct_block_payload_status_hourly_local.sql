CREATE TABLE sepolia.fct_block_payload_status_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The wall clock time at the start of the hour' CODEC(DoubleDelta, ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'PTC verdict bucket: delivered or absent' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of blocks with this payload outcome in the hour' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_block_payload_status_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY (hour_start_date_time, status)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Gloas (ePBS) hourly payload delivery outcomes judged by the PTC, for delivery-rate charts'
