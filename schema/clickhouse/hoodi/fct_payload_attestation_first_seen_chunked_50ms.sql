CREATE TABLE hoodi.fct_payload_attestation_first_seen_chunked_50ms
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The attested slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the attested slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the attested slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The beacon block root being attested by the PTC' CODEC(ZSTD(1)),
    `chunk_slot_start_diff` UInt32 COMMENT 'The difference between the chunk start time and slot_start_date_time. "9000" would mean this chunk contains payload attestations first seen between 9000ms and 9050ms into the slot' CODEC(DoubleDelta, ZSTD(1)),
    `attestation_count` UInt32 COMMENT 'The number of PTC validators first seen in this chunk' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_payload_attestation_first_seen_chunked_50ms_local', cityHash64(slot_start_date_time, block_root))
COMMENT 'Gloas (ePBS) PTC payload attestation arrivals broken down by 50ms chunks, deduplicated per validator at earliest observation across sentries. Only includes messages seen within 12000ms of the slot start time'
