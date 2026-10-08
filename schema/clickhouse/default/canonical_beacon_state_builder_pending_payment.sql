CREATE TABLE default.canonical_beacon_state_builder_pending_payment
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number the builder pending payments snapshot is for' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `state_id` LowCardinality(String) COMMENT 'The state ID the payments were read from',
    `payment_index` UInt32 COMMENT 'The index into builder_pending_payments, below SLOTS_PER_EPOCH for the previous epoch and above for the current epoch' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot the payment belongs to' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `weight` UInt64 COMMENT 'The attestation weight accumulated for the payment in gwei' CODEC(ZSTD(1)),
    `fee_recipient` FixedString(42) COMMENT 'The fee recipient of the payment withdrawal' CODEC(ZSTD(1)),
    `amount` UInt64 COMMENT 'The payment amount in gwei' CODEC(ZSTD(1)),
    `builder_index` UInt64 COMMENT 'The index of the paying builder' CODEC(ZSTD(1)),
    `proposer_index` UInt32 COMMENT 'The validator index of the slot proposer' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_beacon_state_builder_pending_payment_local', cityHash64(epoch_start_date_time, meta_network_name, epoch, payment_index))
COMMENT 'Contains the non-empty Gloas builder pending payments of a canonical beacon state epoch.'
