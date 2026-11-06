CREATE TABLE hoodi.fct_engine_new_payload_gas_bucket_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour' CODEC(DoubleDelta, ZSTD(1)),
    `node_scope` LowCardinality(String) COMMENT 'Which Xatu nodes the timings come from: reference for reference nodes (node_class eip7870-block-builder), all for every Xatu node',
    `client` LowCardinality(String) COMMENT 'Execution client, lowercased, with go-ethereum as geth',
    `gas_bucket_mgas` UInt16 COMMENT 'Block size bucket, the lower bound in Mgas of a 5 Mgas wide bucket' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of blocks' CODEC(ZSTD(1)),
    `gas_mgas_sum` Float64 COMMENT 'Sum of block gas used in Mgas' CODEC(ZSTD(1)),
    `gas_mgas_sq_sum` Float64 COMMENT 'Sum of squared block gas used in Mgas' CODEC(ZSTD(1)),
    `avg_ms_sum` Float64 COMMENT 'Sum over blocks of the mean engine_newPayload duration across Xatu nodes, in milliseconds' CODEC(ZSTD(1)),
    `p50_ms_sum` Float64 COMMENT 'Sum over blocks of the median engine_newPayload duration across Xatu nodes, in milliseconds' CODEC(ZSTD(1)),
    `p50_ms_sq_sum` Float64 COMMENT 'Sum over blocks of the squared median duration' CODEC(ZSTD(1)),
    `gas_p50_product_sum` Float64 COMMENT 'Sum over blocks of Mgas times the median duration' CODEC(ZSTD(1)),
    `p95_ms_sum` Float64 COMMENT 'Sum over blocks of the 95th percentile engine_newPayload duration across Xatu nodes, in milliseconds' CODEC(ZSTD(1)),
    `p95_ms_sq_sum` Float64 COMMENT 'Sum over blocks of the squared 95th percentile duration' CODEC(ZSTD(1)),
    `gas_p95_product_sum` Float64 COMMENT 'Sum over blocks of Mgas times the 95th percentile duration' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_engine_new_payload_gas_bucket_hourly_local', cityHash64(hour_start_date_time, client))
COMMENT 'engine_newPayload timings of VALID payloads per hour, node scope, execution client and 5 Mgas block size bucket, as counts and sums from which a least-squares cost model and throughput can be computed exactly over any range'
