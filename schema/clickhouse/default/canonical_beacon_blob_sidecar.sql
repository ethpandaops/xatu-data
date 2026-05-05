CREATE TABLE default.canonical_beacon_blob_sidecar
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The root hash of the beacon block' CODEC(ZSTD(1)),
    `block_parent_root` FixedString(66) COMMENT 'The root hash of the parent beacon block' CODEC(ZSTD(1)),
    `versioned_hash` FixedString(66) COMMENT 'The versioned hash in the beacon API event stream payload' CODEC(ZSTD(1)),
    `kzg_commitment` FixedString(98) COMMENT 'The KZG commitment in the blob sidecar payload' CODEC(ZSTD(1)),
    `kzg_proof` FixedString(98) COMMENT 'The KZG proof in the blob sidecar payload' CODEC(ZSTD(1)),
    `proposer_index` UInt32 COMMENT 'The index of the validator that proposed the beacon block' CODEC(ZSTD(1)),
    `blob_index` UInt64 COMMENT 'The index of blob sidecar in the blob sidecar payload' CODEC(ZSTD(1)),
    `blob_size` UInt32 COMMENT 'The total bytes of the blob' CODEC(ZSTD(1)),
    `blob_empty_size` Nullable(UInt32) COMMENT 'The total empty size of the blob in bytes' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = Distributed('{cluster}', 'default', 'canonical_beacon_blob_sidecar_local', cityHash64(slot_start_date_time, meta_network_name, block_root, blob_index))
COMMENT 'Contains a blob sidecar from a beacon block.'
