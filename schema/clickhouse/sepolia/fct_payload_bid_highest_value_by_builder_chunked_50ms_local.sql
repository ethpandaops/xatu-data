CREATE TABLE sepolia.fct_payload_bid_highest_value_by_builder_chunked_50ms_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number the bid targets' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The start time for the slot that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The start time for the epoch that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `chunk_slot_start_diff` Int32 COMMENT 'The difference between the chunk start time and slot_start_date_time. "1500" would mean the earliest observation of this bid was between 1500ms and 1550ms into the slot. Negative values indicate bids received before slot start' CODEC(DoubleDelta, ZSTD(1)),
    `earliest_bid_date_time` DateTime64(3) COMMENT 'The timestamp of the earliest observation of the highest-value bid in this chunk' CODEC(DoubleDelta, ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'The execution block hash committed to in the bid' CODEC(ZSTD(1)),
    `builder_index` UInt64 COMMENT 'Validator index of the builder that produced the bid' CODEC(DoubleDelta, ZSTD(1)),
    `value` UInt128 COMMENT 'The bid value in wei' CODEC(ZSTD(1)),
    `execution_payment` UInt128 COMMENT 'The execution payment in wei' CODEC(ZSTD(1)),
    `fee_recipient` FixedString(42) COMMENT 'The fee recipient address of the bid' CODEC(ZSTD(1)),
    PROJECTION p_by_slot
    (
        SELECT *
        ORDER BY
            slot,
            chunk_slot_start_diff,
            builder_index
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_payload_bid_highest_value_by_builder_chunked_50ms_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, chunk_slot_start_diff, builder_index)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Highest value gloas (ePBS) builder bid per slot broken down by 50ms chunks, sourced from builder bids observed on the beacon API event stream across sentries. Only includes bids within -12000ms to +12000ms of slot start time'
