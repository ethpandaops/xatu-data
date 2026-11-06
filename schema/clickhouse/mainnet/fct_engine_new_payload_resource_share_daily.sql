CREATE TABLE mainnet.fct_engine_new_payload_resource_share_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'The UTC day' CODEC(DoubleDelta, ZSTD(1)),
    `node_scope` LowCardinality(String) COMMENT 'Which Xatu nodes the timings come from: reference for reference nodes (node_class eip7870-block-builder), all for every Xatu node',
    `client` LowCardinality(String) COMMENT 'Execution client, lowercased, with go-ethereum as geth',
    `resource` LowCardinality(String) COMMENT 'Gas resource: compute, memory, address_access, state_growth, history, bloom_topics or block_size',
    `share_bucket_pct` UInt8 COMMENT 'Share of the block resource gas this resource took, the lower bound of a 10 percentage point bucket (0 to 90)' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of blocks of at least 10 Mgas in the bucket' CODEC(ZSTD(1)),
    `gas_mgas_sum` Float64 COMMENT 'Sum of block gas used in Mgas' CODEC(ZSTD(1)),
    `p50_ms_sum` Float64 COMMENT 'Sum over blocks of the median engine_newPayload duration across Xatu nodes, in milliseconds. gas_mgas_sum over p50_ms_sum times 1000 is the throughput in Mgas/s' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_engine_new_payload_resource_share_daily_local', cityHash64(day_start_date, client))
COMMENT 'engine_newPayload throughput of VALID payloads of at least 10 Mgas per UTC day, node scope, execution client, gas resource and fixed 10% bucket of the share of block resource gas that resource took'
