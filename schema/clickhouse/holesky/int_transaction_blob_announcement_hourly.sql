CREATE TABLE holesky.int_transaction_blob_announcement_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The start of the hour bucket the announcements fall in' CODEC(DoubleDelta, ZSTD(1)),
    `hash` FixedString(66) COMMENT 'The blob transaction hash' CODEC(ZSTD(1)),
    `first_announced_date_time` DateTime64(3) COMMENT 'Earliest announcement received this hour across mimicry clients' CODEC(DoubleDelta, ZSTD(1)),
    `last_announced_date_time` DateTime64(3) COMMENT 'Latest announcement received this hour across mimicry clients' CODEC(DoubleDelta, ZSTD(1)),
    `announcement_count` UInt32 COMMENT 'Peer announcements received this hour, roughly the number of announcing peers summed over mimicry clients' CODEC(ZSTD(1)),
    `unique_sentries` UInt32 COMMENT 'Distinct mimicry clients that received an announcement this hour' CODEC(ZSTD(1)),
    `size` UInt32 COMMENT 'Announced transaction size in bytes, including blobs' CODEC(ZSTD(1)),
    `peer_implementations` Array(String) COMMENT 'Distinct execution clients of the announcing peers, sorted' CODEC(ZSTD(1)),
    `first_peer_implementation` LowCardinality(String) COMMENT 'Execution client of the peer whose announcement arrived first' CODEC(ZSTD(1)),
    `first_peer_version` LowCardinality(String) COMMENT 'Client version of the peer whose announcement arrived first' CODEC(ZSTD(1)),
    `first_sentry_name` LowCardinality(String) COMMENT 'Mimicry client that received the first announcement' CODEC(ZSTD(1)),
    `first_sentry_geo_city` LowCardinality(String) COMMENT 'City of the mimicry client that received the first announcement' CODEC(ZSTD(1)),
    `first_sentry_geo_country_code` LowCardinality(String) COMMENT 'Country code of the mimicry client that received the first announcement' CODEC(ZSTD(1)),
    `first_sentry_geo_continent_code` LowCardinality(String) COMMENT 'Continent code of the mimicry client that received the first announcement' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_transaction_blob_announcement_hourly_local', cityHash64(hash))
COMMENT 'One row per blob transaction hash per hour in which mimicry clients received an announcement of it from an execution layer peer'
