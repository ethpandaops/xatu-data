CREATE TABLE default.canonical_beacon_state_ptc_member
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot the payload timeliness committee serves' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number the slot belongs to' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `state_id` LowCardinality(String) COMMENT 'The state ID the committee was read from',
    `position` UInt32 COMMENT 'The index of the member within the committee, equal to its bit index in a payload attestation aggregation_bits' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The validator holding this position, which can repeat within a committee' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_beacon_state_ptc_member_local', cityHash64(slot_start_date_time, meta_network_name, slot, position))
COMMENT 'Contains the ordered payload timeliness committee of each Gloas slot, one row per committee position.'
