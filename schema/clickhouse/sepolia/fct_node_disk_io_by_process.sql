CREATE TABLE sepolia.fct_node_disk_io_by_process
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `window_start` DateTime64(3) COMMENT 'Start of the sub-slot aggregation window' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_slot` UInt32 COMMENT 'The wallclock slot number' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_slot_start_date_time` DateTime64(3) COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the observoor client that collected the data',
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name',
    `pid` UInt32 COMMENT 'Process ID of the monitored client' CODEC(ZSTD(1)),
    `client_type` LowCardinality(String) COMMENT 'Client type: CL or EL',
    `rw` LowCardinality(String) COMMENT 'I/O direction: read or write',
    `io_bytes` Float32 COMMENT 'Total bytes transferred across all devices in this window' CODEC(ZSTD(1)),
    `io_ops` UInt32 COMMENT 'Total I/O operations across all devices in this window' CODEC(ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for filtering (e.g. eip7870)'
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_node_disk_io_by_process_local', cityHash64(wallclock_slot_start_date_time, meta_client_name))
COMMENT 'Node disk I/O per sub-slot window aggregated across devices with node classification'
