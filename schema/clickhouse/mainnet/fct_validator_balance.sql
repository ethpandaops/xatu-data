CREATE TABLE mainnet.fct_validator_balance
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The start time of the epoch' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The index of the validator' CODEC(ZSTD(1)),
    `balance` UInt64 COMMENT 'Validator balance at this epoch in Gwei' CODEC(T64, ZSTD(1)),
    `effective_balance` UInt64 COMMENT 'Effective balance at this epoch in Gwei' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Validator status at this epoch',
    `slashed` Bool COMMENT 'Whether the validator was slashed (as of this epoch)'
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_validator_balance_local', cityHash64(validator_index, epoch_start_date_time))
COMMENT 'Per-epoch validator balance and status'
