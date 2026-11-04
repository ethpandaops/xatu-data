CREATE TABLE mainnet.fct_block_graffiti_client_version_pair_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `consensus_client` LowCardinality(String) COMMENT 'Consensus client named by the block graffiti, or unknown' CODEC(ZSTD(1)),
    `consensus_version` LowCardinality(String) COMMENT 'Consensus client release version the graffiti resolves to, or the version it states when unresolved, empty when there is none' CODEC(ZSTD(1)),
    `consensus_release_status` LowCardinality(String) COMMENT 'How the consensus client version was resolved, see the table comment for values' CODEC(ZSTD(1)),
    `execution_client` LowCardinality(String) COMMENT 'Execution client named by the block graffiti, or unknown' CODEC(ZSTD(1)),
    `execution_version` LowCardinality(String) COMMENT 'Execution client release version the graffiti resolves to, or the version it states when unresolved, empty when there is none' CODEC(ZSTD(1)),
    `execution_release_status` LowCardinality(String) COMMENT 'How the execution client version was resolved, see the table comment for values' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of canonical blocks with this consensus and execution client release pair' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_block_graffiti_client_version_pair_daily_local', cityHash64(day_start_date, consensus_client, execution_client, consensus_version, execution_version, consensus_release_status, execution_release_status))
COMMENT 'Daily canonical block counts per consensus and execution client release pair resolved from block graffiti, each block counted once, with builds of one version from different commits together. release_status: commit_match (the graffiti commit is a release tag commit), commit_untagged (a default or release branch commit between tags, version is the release it builds on), commit_ambiguous (the prefix matches several commits), commit_unmatched (no release or branch commit, a custom or fork build), commit_short (a 2 character commit), commit_zero (an all-zero commit), version_match or version_unmatched (a version string with no commit, matched to a release tag or not), codes_min (client codes without commits), no_commit (no version information) or none (unknown client). An unresolved side keeps the version its graffiti states, or is empty when it states none'
