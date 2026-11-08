CREATE TABLE sepolia.fct_peer_count_by_el_client_country_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Execution client from the node devp2p name (nimbus reported as nimbusel)' CODEC(ZSTD(1)),
    `continent_code` LowCardinality(String) COMMENT 'Continent code of the address, other for buckets under 3 peers' CODEC(ZSTD(1)),
    `country_code` LowCardinality(String) COMMENT 'Country code of the address, other when the country has under 3 peers, unknown when not geolocated' CODEC(ZSTD(1)),
    `country` LowCardinality(String) COMMENT 'Country name, Other or Unknown' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Nodes' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_peer_count_by_el_client_country_daily_local', cityHash64(day_start_date, client, continent_code, country_code, country))
COMMENT 'Daily execution node census by client and country. Execution nodes our discovery crawler found in the day, one count per node with its latest record, on the network genesis and its current fork (a fork ID hash at least 10% of the nodes of the day share whose next fork has not passed, which excludes other chains and stale forks). Countries under 3 nodes roll into their continent other bucket, and continents still under 3 into a global other bucket.'
