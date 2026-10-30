CREATE TABLE mainnet.fct_engine_new_payload_by_node_daily_local
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
    `slot_count` UInt32 COMMENT 'Slots with an engine_newPayload call' CODEC(ZSTD(1)),
    `call_count` UInt32 COMMENT 'engine_newPayload calls' CODEC(ZSTD(1)),
    `valid_count` UInt32 COMMENT 'Calls that returned VALID' CODEC(ZSTD(1)),
    `invalid_count` UInt32 COMMENT 'Calls that returned INVALID' CODEC(ZSTD(1)),
    `syncing_count` UInt32 COMMENT 'Calls that returned SYNCING' CODEC(ZSTD(1)),
    `accepted_count` UInt32 COMMENT 'Calls that returned ACCEPTED' CODEC(ZSTD(1)),
    `p50_duration_ms` UInt32 COMMENT 'Median duration of VALID calls, in milliseconds' CODEC(ZSTD(1)),
    `p90_duration_ms` UInt32 COMMENT '90th percentile duration of VALID calls, in milliseconds' CODEC(ZSTD(1)),
    `p95_duration_ms` UInt32 COMMENT '95th percentile duration of VALID calls, in milliseconds' CODEC(ZSTD(1)),
    `max_duration_ms` UInt32 COMMENT 'Longest VALID call, in milliseconds' CODEC(ZSTD(1)),
    PROJECTION p_by_node_id
    (
        SELECT *
        ORDER BY
            node_id,
            day_start_date
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_engine_new_payload_by_node_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, node_id)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily engine_newPayload duration per node'
