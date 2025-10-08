CREATE TABLE hoodi.fct_block_proposer
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `proposer_validator_index` UInt32 COMMENT 'The validator index of the proposer for the slot' CODEC(ZSTD(1)),
    `proposer_pubkey` String COMMENT 'The public key of the validator proposer' CODEC(ZSTD(1)),
    `block_root` Nullable(String) COMMENT 'The beacon block root hash. Null if a block was never seen by a sentry, aka "missed"' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Can be "canonical", "orphaned" or "missed"'
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_block_proposer_local', cityHash64(slot_start_date_time))
COMMENT 'Block proposers for the finalized chain including orphaned blocks'
