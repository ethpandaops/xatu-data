CREATE TABLE sepolia.fct_peer_count_by_el_client_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Execution client from the node devp2p name (nimbus reported as nimbusel)' CODEC(ZSTD(1)),
    `version` LowCardinality(String) COMMENT 'Release version from dim_client_release when the commit or version resolved (for commit_untagged the release the commit builds on), else the version the agent reports, empty when it reports none' CODEC(ZSTD(1)),
    `release_status` LowCardinality(String) COMMENT 'How the version was resolved: commit_match (a release tag commit agreeing with any stated version), commit_untagged (a default or release branch commit, version is the release it builds on, else the stated version), commit_mismatch (the commit resolves to another release than the stated version, version is the commit release), commit_ambiguous, commit_unmatched (a custom or fork build, the stated version is kept), commit_zero, version_match, version_unmatched or none. Rows whose commit does not resolve keep the version the agent states' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Nodes' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_count_by_el_client_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, client, version, release_status)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily execution node census by client and release. Execution nodes our discovery crawler found in the day, one count per node with its latest record, on the network genesis and its current fork (a fork ID hash at least 10% of the nodes of the day share whose next fork has not passed, which excludes other chains and stale forks). How the version was resolved: commit_match (a release tag commit agreeing with any stated version), commit_untagged (a default or release branch commit, version is the release it builds on, else the stated version), commit_mismatch (the commit resolves to another release than the stated version, version is the commit release), commit_ambiguous, commit_unmatched (a custom or fork build, the stated version is kept), commit_zero, version_match, version_unmatched or none. Rows whose commit does not resolve keep the version the agent states'
