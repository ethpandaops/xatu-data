CREATE TABLE hoodi.fct_attestation_reward_by_validator
(
    `epoch` UInt32 COMMENT 'The epoch number' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `head` Int64 COMMENT 'Head vote reward in Gwei' CODEC(ZSTD(1)),
    `target` Int64 COMMENT 'Target vote reward in Gwei (negative when penalised)' CODEC(ZSTD(1)),
    `source` Int64 COMMENT 'Source vote reward in Gwei (negative when penalised)' CODEC(ZSTD(1)),
    `inclusion_delay` Int64 DEFAULT 0 COMMENT 'Inclusion delay reward in Gwei (phase0 only, the attester\\'s share, 0 from Altair)',
    `inactivity` Int64 COMMENT 'Inactivity penalty in Gwei' CODEC(ZSTD(1)),
    `total` Int64 ALIAS (((head + target) + source) + inclusion_delay) + inactivity COMMENT 'head + target + source + inclusion_delay + inactivity in Gwei'
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_attestation_reward_by_validator_local', cityHash64(validator_index, epoch_start_date_time))
COMMENT 'Attestation reward of each validator in each epoch. Rows never change, so there is no version column'
