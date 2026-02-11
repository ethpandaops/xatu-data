CREATE TABLE holesky.fct_head_vote_correctness_rate_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Number of slots in this hour' CODEC(ZSTD(1)),
    `avg_head_vote_rate` Float32 COMMENT 'Average head vote correctness rate (%)' CODEC(ZSTD(1)),
    `min_head_vote_rate` Float32 COMMENT 'Minimum head vote correctness rate (%)' CODEC(ZSTD(1)),
    `max_head_vote_rate` Float32 COMMENT 'Maximum head vote correctness rate (%)' CODEC(ZSTD(1)),
    `p05_head_vote_rate` Float32 COMMENT '5th percentile head vote correctness rate' CODEC(ZSTD(1)),
    `p50_head_vote_rate` Float32 COMMENT '50th percentile (median) head vote correctness rate' CODEC(ZSTD(1)),
    `p95_head_vote_rate` Float32 COMMENT '95th percentile head vote correctness rate' CODEC(ZSTD(1)),
    `stddev_head_vote_rate` Float32 COMMENT 'Standard deviation of head vote correctness rate' CODEC(ZSTD(1)),
    `upper_band_head_vote_rate` Float32 COMMENT 'Upper Bollinger band (avg + 2*stddev)' CODEC(ZSTD(1)),
    `lower_band_head_vote_rate` Float32 COMMENT 'Lower Bollinger band (avg - 2*stddev)' CODEC(ZSTD(1)),
    `moving_avg_head_vote_rate` Float32 COMMENT 'Moving average head vote correctness rate (6-hour window)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_head_vote_correctness_rate_hourly_local', cityHash64(hour_start_date_time))
COMMENT 'Hourly aggregated head vote correctness rate statistics'
