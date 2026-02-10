CREATE TABLE hoodi.dim_validator_pubkey_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `pubkey` String COMMENT 'The public key of the validator' CODEC(ZSTD(1)),
    PROJECTION p_by_validator_index
    (
        SELECT *
        ORDER BY validator_index
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/dim_validator_pubkey_local', '{replica}', updated_date_time)
ORDER BY (pubkey, validator_index)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Validator index to pubkey mapping — one row per validator with the latest pubkey'
