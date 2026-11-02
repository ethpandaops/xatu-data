CREATE TABLE mainnet.fct_peer_count_by_el_client_country_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Execution client from the node devp2p name (nimbus reported as nimbusel)' CODEC(ZSTD(1)),
    `continent_code` LowCardinality(String) COMMENT 'Continent code of the address, other for buckets under 3 peers' CODEC(ZSTD(1)),
    `country_code` LowCardinality(String) COMMENT 'Country code of the address, other when the country has under 3 peers, unknown when not geolocated' CODEC(ZSTD(1)),
    `country` LowCardinality(String) COMMENT 'Country name, Other or Unknown' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Nodes' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_count_by_el_client_country_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, client, continent_code, country_code, country)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily execution node census by client and country. Execution nodes our discovery crawler found in the day, one count per node with its latest record, on the network genesis (the most common one that day, which excludes other chains). Countries under 3 nodes roll into their continent other bucket, and continents still under 3 into a global other bucket.'
