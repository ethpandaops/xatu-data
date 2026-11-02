CREATE TABLE hoodi.fct_block_graffiti_client_version_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `layer` LowCardinality(String) COMMENT 'Client layer: consensus or execution' CODEC(ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Client named by the block graffiti, or unknown' CODEC(ZSTD(1)),
    `version` LowCardinality(String) COMMENT 'Release version the graffiti resolves to, else the version it states, empty when unresolved' CODEC(ZSTD(1)),
    `commit_prefix` LowCardinality(String) COMMENT 'Commit prefix from the graffiti, lowercase, empty when there is none' CODEC(ZSTD(1)),
    `release_status` LowCardinality(String) COMMENT 'How the version was resolved, see the table comment for values' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Number of canonical blocks with this client, version and release status' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_block_graffiti_client_version_daily_local', cityHash64(day_start_date, layer, client, version, commit_prefix, release_status))
COMMENT 'Daily canonical block counts per consensus and execution client release resolved from block graffiti. Each block counts once per layer. release_status: commit_match (the commit is a release tag commit agreeing with any version the graffiti states), commit_untagged (a default or release branch commit between tags, version is the release it builds on, else the stated version, empty for a development build with no recent tag), commit_mismatch (the commit resolves to another release than the stated version, which some clients leave stale, version is the commit release), commit_ambiguous (the prefix matches several commits), commit_unmatched (no release or branch commit, a custom or fork build), commit_short (a 2 character commit), commit_zero (an all-zero commit), version_match or version_unmatched (a version string with no commit, matched to a release tag or not), codes_min (client codes without commits), no_commit (no version information) or none (unknown client). Rows whose commit does not resolve keep the version the graffiti states. Rows with neither have an empty version'
