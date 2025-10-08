CREATE TABLE sepolia.fct_block_mev
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number within the block proposer payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The start time for the slot that the proposer payload is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot that the proposer payload is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The start time for the epoch that the proposer payload is for' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The root hash of the beacon block' CODEC(ZSTD(1)),
    `earliest_bid_date_time` Nullable(DateTime64(3)) COMMENT 'The earliest timestamp of the accepted bid in milliseconds' CODEC(ZSTD(1)),
    `relay_names` Array(String) COMMENT 'The relay names that delivered the proposer payload' CODEC(ZSTD(1)),
    `parent_hash` FixedString(66) COMMENT 'The parent hash of the proposer payload' CODEC(ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number of the proposer payload' CODEC(DoubleDelta, ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'The block hash of the proposer payload' CODEC(ZSTD(1)),
    `builder_pubkey` String COMMENT 'The builder pubkey of the proposer payload' CODEC(ZSTD(1)),
    `proposer_pubkey` String COMMENT 'The proposer pubkey of the proposer payload' CODEC(ZSTD(1)),
    `proposer_fee_recipient` FixedString(42) COMMENT 'The proposer fee recipient of the proposer payload' CODEC(ZSTD(1)),
    `gas_limit` UInt64 COMMENT 'The gas limit of the proposer payload' CODEC(DoubleDelta, ZSTD(1)),
    `gas_used` UInt64 COMMENT 'The gas used of the proposer payload' CODEC(DoubleDelta, ZSTD(1)),
    `value` Nullable(UInt128) COMMENT 'The transaction value in wei' CODEC(ZSTD(1)),
    `transaction_count` UInt32 COMMENT 'The number of transactions in the proposer payload' CODEC(DoubleDelta, ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Can be "canonical" or "orphaned"'
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_block_mev_local', cityHash64(slot_start_date_time, block_root))
COMMENT 'MEV relay proposer payload delivered for a block on the finalized chain including orphaned blocks'
