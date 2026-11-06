CREATE TABLE mainnet.fct_engine_new_payload_throughput_histogram_window
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `window_grain` LowCardinality(String) COMMENT 'hour for windows of hours, day for all history in complete UTC days ending yesterday',
    `window_length` UInt16 COMMENT 'Window length in hours (24, 168 or 744), 0 for all history' CODEC(ZSTD(1)),
    `window_start_date_time` DateTime COMMENT 'Start of the window, inclusive' CODEC(DoubleDelta, ZSTD(1)),
    `window_end_date_time` DateTime COMMENT 'End of the window, exclusive. Hour windows end at the last complete hour, or for resource share at the last hour its hourly table has counted' CODEC(DoubleDelta, ZSTD(1)),
    `node_scope` LowCardinality(String) COMMENT 'Which Xatu nodes the timings come from: reference for reference nodes (node_class eip7870-block-builder), all for every Xatu node',
    `client` LowCardinality(String) COMMENT 'Execution client, lowercased, with go-ethereum as geth',
    `bucket_index` Int32 COMMENT 'Throughput bucket k, covering 1.04^k to 1.04^(k+1) Mgas/s' CODEC(ZSTD(1)),
    `bucket_lower_mgas_per_second` Float32 COMMENT 'Lower bound of the bucket in Mgas/s, inclusive' CODEC(ZSTD(1)),
    `bucket_upper_mgas_per_second` Float32 COMMENT 'Upper bound of the bucket in Mgas/s, exclusive' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of blocks of at least 5 Mgas whose throughput falls in the bucket' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_engine_new_payload_throughput_histogram_window_local', cityHash64(window_grain, window_length, client))
COMMENT 'engine_newPayload per-block throughput histogram buckets summed over the last 24, 168 and 744 hours and all history, recomputed hourly from fct_engine_new_payload_throughput_histogram_hourly and _daily'
