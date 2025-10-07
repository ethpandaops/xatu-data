CREATE TABLE mainnet.fct_attestation_correctness_canonical
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` Nullable(String) COMMENT 'The beacon block root hash' CODEC(ZSTD(1)),
    `votes_max` UInt32 COMMENT 'The maximum number of scheduled votes for the block' CODEC(ZSTD(1)),
    `votes_head` Nullable(UInt32) COMMENT 'The number of votes for the block proposed in the current slot' CODEC(ZSTD(1)),
    `votes_other` Nullable(UInt32) COMMENT 'The number of votes for any blocks proposed in previous slots' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_attestation_correctness_canonical_local', cityHash64(slot_start_date_time))
COMMENT 'Attestation correctness of a block for the finalized chain'
