CREATE TABLE hoodi.fct_peer_count_by_el_country_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `continent_code` LowCardinality(String) COMMENT 'Continent code of the address, unknown when not geolocated' CODEC(ZSTD(1)),
    `country_code` LowCardinality(String) COMMENT 'Country code of the address, unknown when not geolocated' CODEC(ZSTD(1)),
    `country` LowCardinality(String) COMMENT 'Country name, Unknown when not geolocated' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Execution nodes' CODEC(ZSTD(1)),
    `hosting_peer_count` UInt32 COMMENT 'Peers on a cloud or hosting provider network' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_count_by_el_country_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, continent_code, country_code, country)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily execution nodes by country, all clients together. Execution nodes our discovery crawler found in the day on the network genesis and its current fork, one count per node with its latest record.'
