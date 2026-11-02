CREATE TABLE holesky.int_block_graffiti_release
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number of the block' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The root of the canonical beacon block' CODEC(ZSTD(1)),
    `proposer_index` UInt32 COMMENT 'The validator index of the block proposer' CODEC(ZSTD(1)),
    `entity` LowCardinality(String) COMMENT 'Staking entity of the proposer from dim_node, empty when the validator has none' CODEC(ZSTD(1)),
    `graffiti_format` LowCardinality(String) COMMENT 'Graffiti format from fct_block_graffiti that identified the clients' CODEC(ZSTD(1)),
    `consensus_client` LowCardinality(String) COMMENT 'Consensus client named by the graffiti, e.g. lighthouse, or unknown' CODEC(ZSTD(1)),
    `consensus_client_version` LowCardinality(String) COMMENT 'Consensus client release version from dim_client_release (or the release a branch commit builds on), else the version the graffiti states, empty when unresolved' CODEC(ZSTD(1)),
    `consensus_client_commit` LowCardinality(String) COMMENT 'Consensus client commit prefix from the graffiti, lowercase, empty when there is none' CODEC(ZSTD(1)),
    `consensus_client_release_status` LowCardinality(String) COMMENT 'How the consensus client version was resolved, see the table comment for values' CODEC(ZSTD(1)),
    `execution_client` LowCardinality(String) COMMENT 'Execution client named by the graffiti, e.g. geth, or unknown' CODEC(ZSTD(1)),
    `execution_client_version` LowCardinality(String) COMMENT 'Execution client release version from dim_client_release (or the release a branch commit builds on), empty when unresolved' CODEC(ZSTD(1)),
    `execution_client_commit` LowCardinality(String) COMMENT 'Execution client commit prefix from the graffiti, lowercase, empty when there is none' CODEC(ZSTD(1)),
    `execution_client_release_status` LowCardinality(String) COMMENT 'How the execution client version was resolved, see the table comment for values' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_block_graffiti_release_local', cityHash64(slot_start_date_time, block_root))
COMMENT 'Canonical blocks with the client releases their graffiti resolves to, resolved like the Lab slot page. release_status: commit_match (the commit is a release tag commit agreeing with any version the graffiti states), commit_untagged (a default or release branch commit between tags, version is the release it builds on, else the stated version, empty for a development build with no recent tag), commit_mismatch (the commit resolves to another release than the stated version, which some clients leave stale, version is the commit release), commit_ambiguous (the prefix matches several commits), commit_unmatched (no release or branch commit, a custom or fork build), commit_short (a 2 character commit), commit_zero (an all-zero commit), version_match or version_unmatched (a version string with no commit, matched to a release tag or not), codes_min (client codes without commits), no_commit (no version information) or none (unknown client). Rows whose commit does not resolve keep the version the graffiti states. Rows with neither have an empty version'
