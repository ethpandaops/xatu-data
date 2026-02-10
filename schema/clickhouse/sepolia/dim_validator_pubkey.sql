CREATE TABLE sepolia.dim_validator_pubkey
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `pubkey` String COMMENT 'The public key of the validator' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'dim_validator_pubkey_local', cityHash64(pubkey, validator_index))
COMMENT 'Validator index to pubkey mapping — one row per validator with the latest pubkey'
