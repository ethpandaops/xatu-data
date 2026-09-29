CREATE TABLE sepolia.fct_block_payload_status_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The wall clock time at the start of the hour' CODEC(DoubleDelta, ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'PTC verdict bucket: delivered or absent' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of blocks with this payload outcome in the hour' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_block_payload_status_hourly_local', cityHash64(hour_start_date_time, status))
COMMENT 'Gloas (ePBS) hourly payload delivery outcomes judged by the PTC, for delivery-rate charts'
