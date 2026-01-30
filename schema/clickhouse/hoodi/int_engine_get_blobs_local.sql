CREATE TABLE hoodi.int_engine_get_blobs_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime64(3) COMMENT 'When the sentry received the event' CODEC(DoubleDelta, ZSTD(1)),
    `requested_date_time` DateTime64(3) COMMENT 'When the engine_getBlobs call was initiated' CODEC(DoubleDelta, ZSTD(1)),
    `duration_ms` UInt32 COMMENT 'How long the engine_getBlobs call took in milliseconds' CODEC(ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number of the beacon block containing the blobs' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number derived from the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'Root of the beacon block (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `block_parent_root` FixedString(66) COMMENT 'Root of the parent beacon block (hex encoded with 0x prefix)' CODEC(ZSTD(1)),
    `proposer_index` UInt32 COMMENT 'Validator index of the block proposer' CODEC(ZSTD(1)),
    `requested_count` UInt32 COMMENT 'Number of blobs requested (length of versioned_hashes array)' CODEC(ZSTD(1)),
    `versioned_hashes` Array(FixedString(66)) COMMENT 'Versioned hashes of the requested blobs' CODEC(ZSTD(1)),
    `returned_count` UInt32 COMMENT 'Number of blobs actually returned' CODEC(ZSTD(1)),
    `returned_blob_indexes` Array(UInt8) COMMENT 'Indexes of the returned blobs' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'Engine API response status (SUCCESS, PARTIAL, EMPTY, UNSUPPORTED, ERROR)' CODEC(ZSTD(1)),
    `error_message` Nullable(String) COMMENT 'Error message when the call fails' CODEC(ZSTD(1)),
    `method_version` LowCardinality(String) COMMENT 'Version of the engine_getBlobs method' CODEC(ZSTD(1)),
    `source` LowCardinality(String) COMMENT 'Source of the engine event' CODEC(ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)' CODEC(ZSTD(1)),
    `meta_execution_version` LowCardinality(String) COMMENT 'Full execution client version string from web3_clientVersion RPC' CODEC(ZSTD(1)),
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation name (e.g., Geth, Nethermind, Besu, Reth)' CODEC(ZSTD(1)),
    `meta_client_name` LowCardinality(String) COMMENT 'Name of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_implementation` LowCardinality(String) COMMENT 'Implementation of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_version` LowCardinality(String) COMMENT 'Version of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_city` LowCardinality(String) COMMENT 'City of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_country` LowCardinality(String) COMMENT 'Country of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_country_code` LowCardinality(String) COMMENT 'Country code of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_continent_code` LowCardinality(String) COMMENT 'Continent code of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_latitude` Nullable(Float64) COMMENT 'Latitude of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_longitude` Nullable(Float64) COMMENT 'Longitude of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_number` Nullable(UInt32) COMMENT 'Autonomous system number of the client that generated the event' CODEC(ZSTD(1)),
    `meta_client_geo_autonomous_system_organization` Nullable(String) COMMENT 'Autonomous system organization of the client that generated the event' CODEC(ZSTD(1)),
    PROJECTION p_by_slot
    (
        SELECT *
        ORDER BY
            slot,
            block_root
    ),
    PROJECTION p_by_duration_ms
    (
        SELECT *
        ORDER BY
            duration_ms,
            slot_start_date_time
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_engine_get_blobs_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, block_root, meta_client_name, event_date_time)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Individual engine_getBlobs observations enriched with slot context from beacon blob sidecar data'
