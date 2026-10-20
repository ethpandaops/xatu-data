CREATE TABLE sepolia.dim_client_release_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Client name as used by fct_block_graffiti, e.g. lighthouse or geth' CODEC(ZSTD(1)),
    `layer` LowCardinality(String) COMMENT 'Client layer: consensus or execution' CODEC(ZSTD(1)),
    `version` String COMMENT 'Release version taken from the tag, e.g. v8.2.3' CODEC(ZSTD(1)),
    `tag` String COMMENT 'Git tag of the release in the client repository' CODEC(ZSTD(1)),
    `commit_sha` String COMMENT 'Full commit hash the release tag points at, which graffiti commit prefixes resolve against' CODEC(ZSTD(1)),
    `release_date` Nullable(DateTime) COMMENT 'When the GitHub release was published, NULL when unknown' CODEC(ZSTD(1)),
    `prerelease` Bool COMMENT 'Whether the release is a pre-release (GitHub flag, or a pre-release suffix on the version)' CODEC(ZSTD(1)),
    `repository` LowCardinality(String) COMMENT 'GitHub repository the release tags come from, e.g. sigp/lighthouse' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/dim_client_release_local', '{replica}', updated_date_time)
ORDER BY (client, commit_sha, tag)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Consensus and execution client release tags and the commits they point at, for resolving graffiti commit prefixes to versions'
