CREATE TABLE sepolia.fct_mev_bid_highest_value_by_builder_chunked_50ms_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number within the block bid' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The start time for the slot that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The start time for the epoch that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `chunk_slot_start_diff` Int32 COMMENT 'The difference between the chunk start time and slot_start_date_time. "1500" would mean the earliest bid for this block_hash was between 1500ms and 1550ms into the slot. Negative values indicate bids received before slot start' CODEC(DoubleDelta, ZSTD(1)),
    `earliest_bid_date_time` DateTime64(3) COMMENT 'The timestamp of the earliest bid for this block_hash from this builder' CODEC(DoubleDelta, ZSTD(1)),
    `relay_names` Array(String) COMMENT 'The relay that the bid was fetched from' CODEC(ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'The execution block hash of the bid' CODEC(ZSTD(1)),
    `builder_pubkey` String COMMENT 'The builder pubkey of the bid' CODEC(ZSTD(1)),
    `value` UInt128 COMMENT 'The transaction value in wei' CODEC(ZSTD(1)),
    PROJECTION p_by_slot
    (
        SELECT *
        ORDER BY
            slot,
            chunk_slot_start_diff,
            builder_pubkey
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_mev_bid_highest_value_by_builder_chunked_50ms_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, chunk_slot_start_diff, builder_pubkey)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Highest value bid from each builder per slot broken down by 50ms chunks. Each block_hash appears in the chunk determined by its earliest bid timestamp. Only includes bids within -12000ms to +12000ms of slot start time'
