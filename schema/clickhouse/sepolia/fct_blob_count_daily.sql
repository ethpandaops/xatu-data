CREATE TABLE sepolia.fct_blob_count_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of slots with blobs in this day' CODEC(ZSTD(1)),
    `total_blobs` UInt64 COMMENT 'Total blobs in this day' CODEC(ZSTD(1)),
    `avg_blob_count` Float32 COMMENT 'Average blob count per slot' CODEC(ZSTD(1)),
    `min_blob_count` UInt32 COMMENT 'Minimum blob count in a slot' CODEC(ZSTD(1)),
    `max_blob_count` UInt32 COMMENT 'Maximum blob count in a slot' CODEC(ZSTD(1)),
    `p05_blob_count` Float32 COMMENT '5th percentile blob count' CODEC(ZSTD(1)),
    `p50_blob_count` Float32 COMMENT '50th percentile (median) blob count' CODEC(ZSTD(1)),
    `p95_blob_count` Float32 COMMENT '95th percentile blob count' CODEC(ZSTD(1)),
    `stddev_blob_count` Float32 COMMENT 'Standard deviation of blob count' CODEC(ZSTD(1)),
    `upper_band_blob_count` Float32 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_blob_count` Float32 COMMENT 'Lower Bollinger band (avg - 2*stddev)' CODEC(ZSTD(1)),
    `moving_avg_blob_count` Float32 COMMENT 'Moving average blob count (7-day window)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_blob_count_daily_local', cityHash64(day_start_date))
COMMENT 'Daily aggregated consensus layer blob count statistics with percentiles, Bollinger bands, and moving averages'
