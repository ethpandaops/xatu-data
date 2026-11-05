CREATE TABLE holesky.int_block_blob_count_canonical
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The beacon block root hash' CODEC(ZSTD(1)),
    `blob_count` UInt32 COMMENT 'The number of blobs in the block, from its execution payload blob gas before Gloas, its execution payload bid blob KZG commitments from Gloas, or its blob sidecars when neither is available' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_block_blob_count_canonical_local', cityHash64(slot_start_date_time, block_root))
COMMENT 'Blob count of every canonical block that carries blobs, from its execution payload blob gas (blob gas used over 131072) before Gloas, from the blob KZG commitments in its execution payload bid from Gloas, and from its blob sidecars only when neither is available'
