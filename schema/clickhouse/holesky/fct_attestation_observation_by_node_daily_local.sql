CREATE TABLE holesky.fct_attestation_observation_by_node_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period, by slot' CODEC(DoubleDelta, ZSTD(1)),
    `node_id` String COMMENT 'ID of the node' CODEC(ZSTD(1)),
    `username` LowCardinality(String) COMMENT 'Username of the node' CODEC(ZSTD(1)),
    `classification` LowCardinality(String) COMMENT 'Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Latest client name of the node in the period' CODEC(ZSTD(1)),
    `meta_client_implementation` LowCardinality(String) COMMENT 'Latest collector implementation of the node in the period' CODEC(ZSTD(1)),
    `meta_client_version` LowCardinality(String) COMMENT 'Latest collector version of the node in the period' CODEC(ZSTD(1)),
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'Latest consensus client implementation of the node in the period' CODEC(ZSTD(1)),
    `meta_consensus_version` LowCardinality(String) COMMENT 'Latest consensus client version of the node in the period' CODEC(ZSTD(1)),
    `slot_count` UInt32 COMMENT 'Slots the node saw attestations in' CODEC(ZSTD(1)),
    `attestation_count` UInt64 COMMENT 'Attestations the node saw' CODEC(ZSTD(1)),
    `min_seen_slot_start_diff` UInt32 COMMENT 'Earliest attestation arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p10_median_seen_slot_start_diff` UInt32 COMMENT '10th percentile of the per-slot median attestation arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p50_median_seen_slot_start_diff` UInt32 COMMENT 'Median of the per-slot median attestation arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p90_median_seen_slot_start_diff` UInt32 COMMENT '90th percentile of the per-slot median attestation arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    `p95_median_seen_slot_start_diff` UInt32 COMMENT '95th percentile of the per-slot median attestation arrival, in milliseconds from slot start' CODEC(ZSTD(1)),
    PROJECTION p_by_node_id
    (
        SELECT *
        ORDER BY
            node_id,
            day_start_date
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_attestation_observation_by_node_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, node_id)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily attestation arrival per node'
