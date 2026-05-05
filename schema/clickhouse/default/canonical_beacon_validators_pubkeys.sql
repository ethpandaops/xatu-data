CREATE TABLE default.canonical_beacon_validators_pubkeys
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `pubkey` String COMMENT 'The public key of the validator' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_beacon_validators_pubkeys_local', cityHash64(index, meta_network_name))
COMMENT 'Contains a validator pubkeys for an epoch.'
