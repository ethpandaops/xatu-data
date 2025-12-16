CREATE TABLE sepolia.dim_node_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `name` Nullable(String) COMMENT 'The name of the node' CODEC(ZSTD(1)),
    `groups` Array(String) COMMENT 'Groups the node belongs to' CODEC(ZSTD(1)),
    `tags` Array(String) COMMENT 'Tags associated with the node' CODEC(ZSTD(1)),
    `attributes` Map(String, String) COMMENT 'Additional attributes of the node' CODEC(ZSTD(1)),
    `source` String COMMENT 'The source entity of the node' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/dim_node_local', '{replica}', updated_date_time)
ORDER BY validator_index
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Node information for validators'
