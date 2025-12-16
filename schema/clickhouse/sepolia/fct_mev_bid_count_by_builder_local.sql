CREATE TABLE sepolia.fct_mev_bid_count_by_builder_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number within the block bid' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The start time for the slot that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The start time for the epoch that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `builder_pubkey` String COMMENT 'The relay that the bid was fetched from' CODEC(ZSTD(1)),
    `bid_total` UInt32 COMMENT 'The total number of bids from the builder' CODEC(DoubleDelta, ZSTD(1)),
    PROJECTION p_by_slot
    (
        SELECT *
        ORDER BY
            slot,
            builder_pubkey
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_mev_bid_count_by_builder_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, builder_pubkey)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Total number of MEV builder bids for a slot'
