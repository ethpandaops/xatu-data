CREATE TABLE mainnet.fct_block_payload_status_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'PTC verdict bucket: delivered or absent' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of blocks with this payload outcome in the day' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_block_payload_status_daily_local', cityHash64(day_start_date, status))
COMMENT 'Gloas (ePBS) daily payload delivery outcomes judged by the PTC, the daily twin of fct_block_payload_status_hourly. A block counts as delivered when a majority of observed PTC votes said the payload was present, absent otherwise'
