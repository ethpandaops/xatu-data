CREATE TABLE hoodi.fct_attestation_first_seen_chunked_50ms
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The beacon block root hash that was attested, null means the attestation was missed' CODEC(ZSTD(1)),
    `chunk_slot_start_diff` UInt32 COMMENT 'The different between the chunk start time and slot_start_date_time. "1500" would mean this chunk contains attestations first seen between 1500ms 1550ms into the slot' CODEC(DoubleDelta, ZSTD(1)),
    `attestation_count` UInt32 COMMENT 'The number of attestations in this chunk' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_attestation_first_seen_chunked_50ms_local', cityHash64(slot_start_date_time, block_root))
COMMENT 'Attestations first seen on the unfinalized chain broken down by 50ms chunks. Only includes attestations that were seen within 12000ms of the slot start time. There can be multiple block roots + chunk_slot_start_diff for the same slot, it most likely means votes for prior slot blocks'
