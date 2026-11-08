CREATE TABLE sepolia.fct_custody_probe_by_country_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `continent_code` LowCardinality(String) COMMENT 'Continent code of the address, unknown when not geolocated' CODEC(ZSTD(1)),
    `country_code` LowCardinality(String) COMMENT 'Country code of the address, unknown when not geolocated' CODEC(ZSTD(1)),
    `country` LowCardinality(String) COMMENT 'Country name, Unknown when not geolocated' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Peers probed in the day' CODEC(ZSTD(1)),
    `probe_count` UInt32 COMMENT 'Custody probes' CODEC(ZSTD(1)),
    `success_count` UInt32 COMMENT 'Probes the peer answered with the column' CODEC(ZSTD(1)),
    `missing_count` UInt32 COMMENT 'Probes the peer answered without the column' CODEC(ZSTD(1)),
    `failure_count` UInt32 COMMENT 'Probes that errored or timed out' CODEC(ZSTD(1)),
    `missing_peer_count` UInt32 COMMENT 'Peers with at least one missing probe' CODEC(ZSTD(1)),
    `response_time_p50_ms` Nullable(Float64) COMMENT 'Median response time of successful probes in ms, NULL without any' CODEC(ZSTD(1)),
    `response_time_p90_ms` Nullable(Float64) COMMENT '90th percentile response time of successful probes in ms, NULL without any' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_custody_probe_by_country_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, continent_code, country_code, country)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily data column custody probes by the probed peer country (its latest location in the day). Crawlers and probes are excluded.'
