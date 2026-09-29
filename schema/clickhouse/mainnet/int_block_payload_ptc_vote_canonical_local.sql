CREATE TABLE mainnet.int_block_payload_ptc_vote_canonical_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The attested slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the attested slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the attested slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The beacon block root being attested by the PTC' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The beacon block version of the containing block, empty when no votes were included' CODEC(ZSTD(1)),
    `included_in_slot` UInt32 COMMENT 'Slot of the canonical block that included the payload attestations, 0 when no votes were included' CODEC(DoubleDelta, ZSTD(1)),
    `included_in_block_root` String COMMENT 'Root of the canonical block that included the payload attestations, empty when no votes were included' CODEC(ZSTD(1)),
    `ptc_validators` UInt32 COMMENT 'Total PTC validators covered by the included payload attestation aggregates' CODEC(DoubleDelta, ZSTD(1)),
    `payload_present_votes` UInt32 COMMENT 'PTC validators attesting the payload was present' CODEC(DoubleDelta, ZSTD(1)),
    `blob_data_available_votes` UInt32 COMMENT 'PTC validators attesting blob data was available' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_block_payload_ptc_vote_canonical_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, block_root)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Gloas (ePBS) Payload Timeliness Committee votes per attested block, from aggregates included in canonical beacon blocks'
