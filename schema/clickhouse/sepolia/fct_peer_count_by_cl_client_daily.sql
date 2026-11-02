CREATE TABLE sepolia.fct_peer_count_by_cl_client_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client from the peer agent (erigon reported as caplin), unknown when the agent was never seen, other for unparseable names' CODEC(ZSTD(1)),
    `version` LowCardinality(String) COMMENT 'Release version from dim_client_release when the commit or version resolved (for commit_untagged the release the commit builds on), else the version the agent reports, empty when it reports none' CODEC(ZSTD(1)),
    `release_status` LowCardinality(String) COMMENT 'How the version was resolved: commit_match (a release tag commit agreeing with any stated version), commit_untagged (a default or release branch commit, version is the release it builds on, else the stated version), commit_mismatch (the commit resolves to another release than the stated version, version is the commit release), commit_ambiguous, commit_unmatched (a custom or fork build, the stated version is kept), commit_zero, version_match, version_unmatched or none. Rows whose commit does not resolve keep the version the agent states' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Peers' CODEC(ZSTD(1)),
    `dialled_peer_count` UInt32 COMMENT 'Peers our sentries dialled (outbound connections), so publicly reachable' CODEC(ZSTD(1)),
    `quic_connected_peer_count` UInt32 COMMENT 'Peers connected to over QUIC' CODEC(ZSTD(1)),
    `quic_listen_peer_count` UInt32 COMMENT 'Peers advertising a QUIC listen address in identify' CODEC(ZSTD(1)),
    `custody_known_peer_count` UInt32 COMMENT 'Peers whose custody group count is known from a metadata response' CODEC(ZSTD(1)),
    `custody_4_peer_count` UInt32 COMMENT 'Peers custodying 4 or fewer groups (the minimum)' CODEC(ZSTD(1)),
    `custody_5_8_peer_count` UInt32 COMMENT 'Peers custodying 5 to 8 groups' CODEC(ZSTD(1)),
    `custody_9_127_peer_count` UInt32 COMMENT 'Peers custodying 9 to 127 groups' CODEC(ZSTD(1)),
    `custody_128_peer_count` UInt32 COMMENT 'Peers custodying all 128 groups (supernodes)' CODEC(ZSTD(1)),
    `latency_p50_ms` Nullable(Float64) COMMENT 'Median over peers of each peer median heartbeat latency in ms, NULL without heartbeats' CODEC(ZSTD(1)),
    `latency_p90_ms` Nullable(Float64) COMMENT '90th percentile over peers of each peer median heartbeat latency in ms' CODEC(ZSTD(1)),
    `connection_age_p50_ms` Nullable(Float64) COMMENT 'Median over peers of each peer longest connection age in ms' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_peer_count_by_cl_client_daily_local', cityHash64(day_start_date, client, version, release_status))
COMMENT 'Daily consensus peer census by client and release. Consensus peers our libp2p sentries saw in the day (heartbeats and identify exchanges), one count per peer with its latest agent and address. Crawlers, probes, light clients and our own sentries are excluded. Custody group counts come from metadata responses to our outbound requests. How the version was resolved: commit_match (a release tag commit agreeing with any stated version), commit_untagged (a default or release branch commit, version is the release it builds on, else the stated version), commit_mismatch (the commit resolves to another release than the stated version, version is the commit release), commit_ambiguous, commit_unmatched (a custom or fork build, the stated version is kept), commit_zero, version_match, version_unmatched or none. Rows whose commit does not resolve keep the version the agent states'
