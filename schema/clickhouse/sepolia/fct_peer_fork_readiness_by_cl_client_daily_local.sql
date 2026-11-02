CREATE TABLE sepolia.fct_peer_fork_readiness_by_cl_client_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client from the ENR client name (erigon reported as caplin)' CODEC(ZSTD(1)),
    `version` LowCardinality(String) COMMENT 'Release version from dim_client_release when the commit or version resolved (for commit_untagged the release the commit builds on), else the version the agent reports, empty when it reports none' CODEC(ZSTD(1)),
    `release_status` LowCardinality(String) COMMENT 'How the version was resolved: commit_match (a release tag commit agreeing with any stated version), commit_untagged (a default or release branch commit, version is the release it builds on, else the stated version), commit_mismatch (the commit resolves to another release than the stated version, version is the commit release), commit_ambiguous, commit_unmatched (a custom or fork build, the stated version is kept), commit_zero, version_match, version_unmatched or none. Rows whose commit does not resolve keep the version the agent states' CODEC(ZSTD(1)),
    `fork_digest` LowCardinality(String) COMMENT 'Current fork digest in the ENR' CODEC(ZSTD(1)),
    `next_fork_digest` LowCardinality(String) COMMENT 'Next fork digest in the ENR, empty when none' CODEC(ZSTD(1)),
    `node_count` UInt32 COMMENT 'Nodes' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_fork_readiness_by_cl_client_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, client, version, release_status, fork_digest, next_fork_digest)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily consensus nodes from discovery (ENRs) by client, release, fork digest and next fork digest. A next fork digest of 0x00000000 or equal to the current digest means no next fork and is stored as empty. How the version was resolved: commit_match (a release tag commit agreeing with any stated version), commit_untagged (a default or release branch commit, version is the release it builds on, else the stated version), commit_mismatch (the commit resolves to another release than the stated version, version is the commit release), commit_ambiguous, commit_unmatched (a custom or fork build, the stated version is kept), commit_zero, version_match, version_unmatched or none. Rows whose commit does not resolve keep the version the agent states'
