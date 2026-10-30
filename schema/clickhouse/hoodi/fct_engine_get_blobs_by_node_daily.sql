CREATE TABLE hoodi.fct_engine_get_blobs_by_node_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period, by slot' CODEC(DoubleDelta, ZSTD(1)),
    `node_id` String COMMENT 'ID of the node' CODEC(ZSTD(1)),
    `username` LowCardinality(String) COMMENT 'Username of the node' CODEC(ZSTD(1)),
    `classification` LowCardinality(String) COMMENT 'Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Latest client name of the node in the period' CODEC(ZSTD(1)),
    `meta_client_implementation` LowCardinality(String) COMMENT 'Latest collector implementation of the node in the period' CODEC(ZSTD(1)),
    `meta_client_version` LowCardinality(String) COMMENT 'Latest collector version of the node in the period' CODEC(ZSTD(1)),
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Latest execution client implementation of the node in the period' CODEC(ZSTD(1)),
    `meta_execution_version` LowCardinality(String) COMMENT 'Latest execution client version of the node in the period' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Slots with an engine_getBlobs call' CODEC(ZSTD(1)),
    `call_count` UInt32 COMMENT 'engine_getBlobs calls' CODEC(ZSTD(1)),
    `requested_count` UInt64 COMMENT 'Blobs requested across every call' CODEC(ZSTD(1)),
    `returned_count` UInt64 COMMENT 'Blobs returned across every call' CODEC(ZSTD(1)),
    `p50_duration_ms` UInt32 COMMENT 'Median call duration, in milliseconds' CODEC(ZSTD(1)),
    `p90_duration_ms` UInt32 COMMENT '90th percentile call duration, in milliseconds' CODEC(ZSTD(1)),
    `p95_duration_ms` UInt32 COMMENT '95th percentile call duration, in milliseconds' CODEC(ZSTD(1)),
    `max_duration_ms` UInt32 COMMENT 'Longest call, in milliseconds' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_engine_get_blobs_by_node_daily_local', cityHash64(day_start_date, node_id))
COMMENT 'Daily engine_getBlobs duration per node'
