CREATE TABLE mainnet.fct_mev_bid_count_by_relay
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number within the block bid' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The start time for the slot that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The start time for the epoch that the bid is for' CODEC(DoubleDelta, ZSTD(1)),
    `relay_name` String COMMENT 'The relay that the bid was fetched from' CODEC(ZSTD(1)),
    `bid_total` UInt32 COMMENT 'The total number of bids for the relay' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_mev_bid_count_by_relay_local', cityHash64(slot_start_date_time, relay_name))
COMMENT 'Total number of MEV relay bids for a slot by relay'
