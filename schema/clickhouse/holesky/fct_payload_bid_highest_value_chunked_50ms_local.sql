CREATE TABLE holesky.fct_payload_bid_highest_value_chunked_50ms_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number the bid targets' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The start time for the slot that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The start time for the epoch that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `chunk_slot_start_diff` Int32 COMMENT 'The difference between the chunk start time and slot_start_date_time. Negative values indicate bids received before slot start' CODEC(DoubleDelta, ZSTD(1)),
    `earliest_bid_date_time` DateTime64(3) COMMENT 'The timestamp of the earliest observation of the leading bid in this chunk' CODEC(DoubleDelta, ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'The execution block hash committed to in the leading bid' CODEC(ZSTD(1)),
    `builder_index` UInt64 COMMENT 'Validator index of the builder leading this chunk' CODEC(DoubleDelta, ZSTD(1)),
    `value` UInt128 COMMENT 'The best bid value across all builders in this chunk, in wei' CODEC(ZSTD(1)),
    PROJECTION p_by_slot
    (
        SELECT *
        ORDER BY
            slot,
            chunk_slot_start_diff
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_payload_bid_highest_value_chunked_50ms_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, chunk_slot_start_diff)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Gloas (ePBS) auction frontier: the single best builder bid per slot per 50ms chunk across all builders. Bounded by the chunk grid regardless of builder count. Only includes bids within -12000ms to +12000ms of slot start time'
