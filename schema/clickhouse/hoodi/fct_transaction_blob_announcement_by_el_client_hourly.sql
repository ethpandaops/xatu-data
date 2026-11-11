CREATE TABLE hoodi.fct_transaction_blob_announcement_by_el_client_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period, bucketed by announcement receive time' CODEC(DoubleDelta, ZSTD(1)),
    `peer_implementation` LowCardinality(String) COMMENT 'Execution client of the announcing peers' CODEC(ZSTD(1)),
    `announcement_count` UInt64 COMMENT 'Blob transaction announcements received from peers running this client' CODEC(ZSTD(1)),
    `hash_count` UInt64 COMMENT 'Distinct blob transaction hashes announced by peers running this client' CODEC(ZSTD(1)),
    `unique_sentries` UInt64 COMMENT 'Distinct mimicry clients that received announcements from this client' CODEC(ZSTD(1)),
    `first_announcer_hash_count` UInt64 COMMENT 'Blob transaction hashes whose earliest announcement this hour came from a peer running this client' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_transaction_blob_announcement_by_el_client_hourly_local', cityHash64(hour_start_date_time))
COMMENT 'Hourly blob transaction announcements received by mimicry clients, per announcing peer execution client'
