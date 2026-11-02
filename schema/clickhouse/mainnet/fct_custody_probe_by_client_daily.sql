CREATE TABLE mainnet.fct_custody_probe_by_client_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client from the peer agent (erigon reported as caplin), unknown when the agent was never seen, other for unparseable names' CODEC(ZSTD(1)),
    `version` LowCardinality(String) COMMENT 'Release version from dim_client_release when the commit or version resolved (for commit_untagged the release the commit builds on), else the version the agent reports, empty when it reports none' CODEC(ZSTD(1)),
    `release_status` LowCardinality(String) COMMENT 'How the version was resolved: commit_match (a release tag commit agreeing with any stated version), commit_untagged (a default or release branch commit, version is the release it builds on, else the stated version), commit_mismatch (the commit resolves to another release than the stated version, version is the commit release), commit_ambiguous, commit_unmatched (a custom or fork build, the stated version is kept), commit_zero, version_match, version_unmatched or none. Rows whose commit does not resolve keep the version the agent states' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Probed peers' CODEC(ZSTD(1)),
    `probe_count` UInt32 COMMENT 'Probes' CODEC(ZSTD(1)),
    `success_count` UInt32 COMMENT 'Probes returning the columns' CODEC(ZSTD(1)),
    `missing_count` UInt32 COMMENT 'Probes where the peer did not return a column it should custody' CODEC(ZSTD(1)),
    `failure_count` UInt32 COMMENT 'Probes that failed' CODEC(ZSTD(1)),
    `missing_peer_count` UInt32 COMMENT 'Peers with at least one missing probe' CODEC(ZSTD(1)),
    `response_time_p50_ms` Nullable(Float64) COMMENT 'Median response time of successful probes in ms' CODEC(ZSTD(1)),
    `response_time_p90_ms` Nullable(Float64) COMMENT '90th percentile response time of successful probes in ms' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_custody_probe_by_client_daily_local', cityHash64(day_start_date, client, version, release_status))
COMMENT 'Daily data column custody probe outcomes by the probed peer client and release (its latest agent in the day), from int_custody_probe. How the version was resolved: commit_match (a release tag commit agreeing with any stated version), commit_untagged (a default or release branch commit, version is the release it builds on, else the stated version), commit_mismatch (the commit resolves to another release than the stated version, version is the commit release), commit_ambiguous, commit_unmatched (a custom or fork build, the stated version is kept), commit_zero, version_match, version_unmatched or none. Rows whose commit does not resolve keep the version the agent states'
