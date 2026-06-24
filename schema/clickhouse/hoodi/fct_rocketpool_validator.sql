CREATE TABLE hoodi.fct_rocketpool_validator
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The beacon chain validator index' CODEC(DoubleDelta, ZSTD(1)),
    `pubkey` String COMMENT 'The validator BLS public key, lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `node_operator` String COMMENT 'The Rocket Pool node operator address, lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `pool_type` LowCardinality(String) COMMENT 'The Rocket Pool staking mechanism backing this validator: minipool or megapool',
    `pool_address` String COMMENT 'The minipool contract address (minipool) or the validator withdrawal credential address (megapool), lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `created_date_time` DateTime COMMENT 'Wall clock time the backing minipool was created or the megapool deposit was made' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_rocketpool_validator_local', cityHash64(validator_index))
COMMENT 'Beacon chain validators operated via Rocket Pool (minipool and megapool), linked to their node operator'
