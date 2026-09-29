CREATE TABLE hoodi.fct_block_payload_ptc_vote_head
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The attested slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the attested slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the attested slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The beacon block root being attested by the PTC' CODEC(ZSTD(1)),
    `ptc_validators_seen` UInt32 COMMENT 'Distinct PTC validators whose payload attestation was seen on the live event stream' CODEC(DoubleDelta, ZSTD(1)),
    `payload_present_votes` UInt32 COMMENT 'Distinct PTC validators attesting the payload was present' CODEC(DoubleDelta, ZSTD(1)),
    `blob_data_available_votes` UInt32 COMMENT 'Distinct PTC validators attesting blob data was available' CODEC(DoubleDelta, ZSTD(1)),
    `first_seen_slot_start_diff` UInt32 COMMENT 'Time from slot start that the first payload attestation was seen in ms' CODEC(DoubleDelta, ZSTD(1)),
    `last_seen_slot_start_diff` UInt32 COMMENT 'Time from slot start that the last payload attestation was seen in ms' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_block_payload_ptc_vote_head_local', cityHash64(slot_start_date_time, block_root))
COMMENT 'Gloas (ePBS) Payload Timeliness Committee votes per attested block, observed on the live beacon API event stream. Available at head without waiting for finalization.'
