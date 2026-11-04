CREATE TABLE hoodi.fct_epoch_summary_canonical_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `slot_count` UInt8 COMMENT 'Slots of the epoch with a proposer duty or block, 32 once the epoch is complete' CODEC(ZSTD(1)),
    `canonical_block_count` UInt8 COMMENT 'Slots with a block on the finalized chain' CODEC(ZSTD(1)),
    `missed_slot_count` UInt8 COMMENT 'Slots without a block on the finalized chain, whether the proposer missed or the block was orphaned' CODEC(ZSTD(1)),
    `votes_max` UInt32 COMMENT 'Attestations scheduled across the epoch slots' CODEC(ZSTD(1)),
    `votes_head` UInt32 COMMENT 'Attestations included on chain that voted for the block of their own slot' CODEC(ZSTD(1)),
    `votes_other` UInt32 COMMENT 'Attestations included on chain that voted for another block' CODEC(ZSTD(1)),
    `participation_rate` Nullable(Float64) COMMENT 'Share of scheduled attestations included on chain, (votes_head + votes_other) / votes_max from 0 to 1, NULL when none were scheduled' CODEC(ZSTD(1)),
    `participation_bps` UInt16 COMMENT 'participation_rate in basis points from 0 to 10000, rounded down, 0 when none were scheduled. Integer so the API can filter on it' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_epoch_summary_canonical_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(epoch_start_date_time)
ORDER BY epoch_start_date_time
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'One row per epoch of the finalized chain with its proposer duties, canonical blocks, slots without a canonical block and attestation participation, from int_block_proposer_canonical and fct_attestation_correctness_canonical'
