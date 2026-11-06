CREATE TABLE hoodi.fct_engine_new_payload_throughput_histogram_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The UTC day' CODEC(DoubleDelta, ZSTD(1)),
    `node_scope` LowCardinality(String) COMMENT 'Which Xatu nodes the timings come from: reference for reference nodes (node_class eip7870-block-builder), all for every Xatu node',
    `client` LowCardinality(String) COMMENT 'Execution client, lowercased, with go-ethereum as geth',
    `bucket_index` Int16 COMMENT 'Throughput bucket k, covering 1.04^k to 1.04^(k+1) Mgas/s' CODEC(ZSTD(1)),
    `bucket_lower_mgas_per_second` Float32 COMMENT 'Lower bound of the bucket in Mgas/s, inclusive' CODEC(ZSTD(1)),
    `bucket_upper_mgas_per_second` Float32 COMMENT 'Upper bound of the bucket in Mgas/s, exclusive' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of blocks of at least 5 Mgas whose throughput falls in the bucket' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_engine_new_payload_throughput_histogram_daily_local', cityHash64(day_start_date, client))
COMMENT 'Per-block engine_newPayload throughput histogram (Mgas/s, buckets about 4% wide) of VALID payloads of at least 5 Mgas per UTC day, node scope and execution client'
