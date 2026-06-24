CREATE TABLE hoodi.fct_block_blob_head
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The beacon block root hash containing the blob' CODEC(ZSTD(1)),
    `blob_index` UInt32 COMMENT 'The index of the blob within the block' CODEC(DoubleDelta, ZSTD(1)),
    `versioned_hash` String COMMENT 'The versioned hash derived from the KZG commitment, used as the blob archive key' CODEC(ZSTD(1)),
    `kzg_commitment` String COMMENT 'The KZG commitment of the blob' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_block_blob_head_local', cityHash64(slot_start_date_time, block_root, blob_index))
COMMENT 'One row per (slot, block root, blob index) carrying the blob versioned hash and KZG commitment, sourced from the head beacon blob sidecar event stream. Available at head without waiting for finalization.'
