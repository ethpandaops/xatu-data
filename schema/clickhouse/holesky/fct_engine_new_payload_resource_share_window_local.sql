CREATE TABLE holesky.fct_engine_new_payload_resource_share_window_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `window_grain` LowCardinality(String) COMMENT 'hour for windows of hours, day for all history in complete UTC days ending yesterday',
    `window_length` UInt16 COMMENT 'Window length in hours (24, 168 or 744), 0 for all history' CODEC(ZSTD(1)),
    `window_start_date_time` DateTime COMMENT 'Start of the window, inclusive' CODEC(DoubleDelta, ZSTD(1)),
    `window_end_date_time` DateTime COMMENT 'End of the window, exclusive. Hour windows end at the last complete hour, or for resource share at the last hour its hourly table has counted' CODEC(DoubleDelta, ZSTD(1)),
    `node_scope` LowCardinality(String) COMMENT 'Which Xatu nodes the timings come from: reference for reference nodes (node_class eip7870-block-builder), all for every Xatu node',
    `client` LowCardinality(String) COMMENT 'Execution client, lowercased, with go-ethereum as geth',
    `resource` LowCardinality(String) COMMENT 'Gas resource: compute, memory, address_access, state_growth, history, bloom_topics or block_size',
    `share_bucket_pct` UInt8 COMMENT 'Share of the block resource gas this resource took, the lower bound of a 10 percentage point bucket (0 to 90)' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of blocks of at least 10 Mgas in the bucket' CODEC(ZSTD(1)),
    `gas_mgas_sum` Float64 COMMENT 'Sum of block gas used in Mgas' CODEC(ZSTD(1)),
    `p50_ms_sum` Float64 COMMENT 'Sum over blocks of the median engine_newPayload duration across Xatu nodes, in milliseconds. gas_mgas_sum over p50_ms_sum times 1000 is the throughput in Mgas/s' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_engine_new_payload_resource_share_window_local', '{replica}', updated_date_time)
ORDER BY (window_grain, window_length, node_scope, client, resource, share_bucket_pct)
SETTINGS index_granularity = 8192
COMMENT 'engine_newPayload throughput sums per gas resource and 10% resource share bucket summed over the last 24, 168 and 744 hours and all history, recomputed hourly from fct_engine_new_payload_resource_share_hourly and _daily'
