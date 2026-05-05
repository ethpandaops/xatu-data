CREATE TABLE default.canonical_beacon_committee_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number in the beacon API committee payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `committee_index` LowCardinality(String) COMMENT 'The committee index in the beacon API committee payload',
    `validators` Array(UInt32) COMMENT 'The validator indices in the beacon API committee payload' CODEC(ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number in the beacon API committee payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/canonical_beacon_committee_local', '{replica}', updated_date_time)
PARTITION BY (meta_network_name, toYYYYMM(slot_start_date_time))
ORDER BY (meta_network_name, slot_start_date_time, committee_index)
SETTINGS index_granularity = 8192
COMMENT 'Contains canonical beacon API /eth/v1/beacon/committees data.'
