CREATE TABLE default.beacon_synthetic_payload_status_resolved_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime64(3) COMMENT 'When the beacon node resolved the status (TYSM ResolvedAt)' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number whose payload status was resolved' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `propagation_slot_start_diff` UInt32 COMMENT 'Difference between event_date_time and slot_start_date_time in ms' CODEC(ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'Beacon block root for this slot' CODEC(ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'Execution block hash (when known)' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'New status: PENDING / FULL / EMPTY / INVALID',
    `previous_status` LowCardinality(String) COMMENT 'Previous status before this transition',
    `payload_timeliness_votes_positive` UInt64 COMMENT 'Count of PTC votes with payload_present=true' CODEC(ZSTD(1)),
    `payload_timeliness_votes_negative` Nullable(UInt64) COMMENT 'Count of PTC votes with payload_present=false (explicit negative). NULL when CL does not surface three-state PR #5180 breakdown' CODEC(ZSTD(1)),
    `payload_timeliness_votes_absent` Nullable(UInt64) COMMENT 'Count of PTC seats with no vote (Optional[bool]==None per PR #5180). NULL when CL does not surface the breakdown' CODEC(ZSTD(1)),
    `data_available_votes_positive` UInt64 COMMENT 'Count of PTC votes with blob_data_available=true' CODEC(ZSTD(1)),
    `data_available_votes_negative` Nullable(UInt64) COMMENT 'Count of PTC votes with blob_data_available=false (explicit negative). NULL when CL does not surface three-state PR #5180 breakdown' CODEC(ZSTD(1)),
    `data_available_votes_absent` Nullable(UInt64) COMMENT 'Count of PTC seats with no data-availability vote (Optional[bool]==None per PR #5180). NULL when CL does not surface the breakdown' CODEC(ZSTD(1)),
    `ptc_size` UInt64 COMMENT 'Total PTC committee size (typically 512)' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the client that generated the event',
    `meta_client_id` String COMMENT 'Unique Session ID of the client' CODEC(ZSTD(1)),
    `meta_client_version` LowCardinality(String) COMMENT 'Version of the client',
    `meta_client_implementation` LowCardinality(String) COMMENT 'Implementation of the client',
    `meta_client_os` LowCardinality(String) COMMENT 'Operating system of the client',
    `meta_client_ip` Nullable(IPv6) COMMENT 'IP address of the client' CODEC(ZSTD(1)),
    `meta_client_geo_city` LowCardinality(String) COMMENT 'City of the client' CODEC(ZSTD(1)),
    `meta_client_geo_country` LowCardinality(String) COMMENT 'Country of the client' CODEC(ZSTD(1)),
    `meta_client_geo_country_code` LowCardinality(String) COMMENT 'Country code of the client' CODEC(ZSTD(1)),
    `meta_client_geo_continent_code` LowCardinality(String) COMMENT 'Continent code of the client' CODEC(ZSTD(1)),
    `meta_client_geo_longitude` Nullable(Float64) COMMENT 'Longitude of the client' CODEC(ZSTD(1)),
    `meta_client_geo_latitude` Nullable(Float64) COMMENT 'Latitude of the client' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_number` Nullable(UInt32) COMMENT 'ASN of the client' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_organization` Nullable(String) COMMENT 'AS organization of the client' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name',
    `meta_consensus_version` LowCardinality(String) COMMENT 'Consensus client version',
    `meta_consensus_version_major` LowCardinality(String) COMMENT 'Consensus client major version',
    `meta_consensus_version_minor` LowCardinality(String) COMMENT 'Consensus client minor version',
    `meta_consensus_version_patch` LowCardinality(String) COMMENT 'Consensus client patch version',
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'Consensus client implementation',
    `meta_labels` Map(String, String) COMMENT 'Labels associated with the event' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/default/tables/beacon_synthetic_payload_status_resolved_local/{shard}', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, meta_network_name, meta_client_name, block_root, status)
SETTINGS index_granularity = 8192
COMMENT 'Fork-choice payload status transitions (EIP-7732 ePBS) synthesized from TYSM-instrumented beacon node internals. Multi-witness (per-node).'
