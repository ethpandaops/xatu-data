CREATE TABLE sepolia.int_data_column_gossip_by_slot_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `column_index` UInt64 COMMENT 'Data column index (0-127)' CODEC(ZSTD(1)),
    `beacon_block_root` String COMMENT 'Beacon block root of the earliest gossipsub sighting of the column' CODEC(ZSTD(1)),
    `beacon_block_root_variants` UInt8 COMMENT 'Number of block roots in the sightings (more than 1 means a fork)' CODEC(ZSTD(1)),
    `blob_count` UInt16 COMMENT 'Number of blobs in the slot, the most KZG commitments a sighting carried' CODEC(ZSTD(1)),
    `gossipsub_count` UInt32 COMMENT 'Number of gossipsub sightings of the column whose block root a beacon node accepted' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_data_column_gossip_by_slot_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, column_index)
SETTINGS index_granularity = 8192
COMMENT 'Gossipsub data column sidecar sightings per slot and column, from libp2p sentries, counting only sidecars whose block root a beacon node accepted'
