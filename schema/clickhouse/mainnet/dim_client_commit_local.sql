CREATE TABLE mainnet.dim_client_commit_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Client name as used by fct_block_graffiti, e.g. prysm or geth' CODEC(ZSTD(1)),
    `layer` LowCardinality(String) COMMENT 'Client layer: consensus or execution' CODEC(ZSTD(1)),
    `repository` LowCardinality(String) COMMENT 'GitHub repository of the commit' CODEC(ZSTD(1)),
    `commit_sha` String COMMENT 'Full commit hash' CODEC(ZSTD(1)),
    `commit_date` DateTime COMMENT 'Committer date of the commit' CODEC(ZSTD(1)),
    `base_tag` String COMMENT 'Release tag the commit builds on: the tag reachable in the fewest parent steps, as git describe picks it, empty before the first tag or when that tag was committed over 120 days before the commit (a branch without recent tags, e.g. erigon main)' CODEC(ZSTD(1)),
    `base_version` LowCardinality(String) COMMENT 'Version of base_tag, as in dim_client_release' CODEC(ZSTD(1)),
    `commits_since_base` UInt32 COMMENT 'Parent steps along the shortest path from the commit to base_tag, 0 for a tagged commit' CODEC(ZSTD(1)),
    `is_tagged` Bool COMMENT 'Whether a release tag of the client points at this commit' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/dim_client_commit_local', '{replica}', updated_date_time)
PARTITION BY tuple()
ORDER BY (client, commit_sha)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Commits on each client default and release branches since 2020, with the release each builds on, so graffiti commits from builds between tags resolve to a version'
