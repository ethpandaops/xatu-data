CREATE TABLE holesky.fct_peer_count_by_cl_client_country_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client from the peer agent (erigon reported as caplin), unknown when the agent was never seen, other for unparseable names' CODEC(ZSTD(1)),
    `continent_code` LowCardinality(String) COMMENT 'Continent code of the address, other for buckets under 3 peers' CODEC(ZSTD(1)),
    `country_code` LowCardinality(String) COMMENT 'Country code of the address, other when the country has under 3 peers, unknown when not geolocated' CODEC(ZSTD(1)),
    `country` LowCardinality(String) COMMENT 'Country name, Other or Unknown' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Peers' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_peer_count_by_cl_client_country_daily_local', cityHash64(day_start_date, client, continent_code, country_code, country))
COMMENT 'Daily consensus peer census by client and country. Consensus peers our libp2p sentries saw in the day (heartbeats and identify exchanges), one count per peer with its latest agent and address. Crawlers, probes, light clients and our own sentries are excluded. Countries under 3 peers roll into their continent other bucket, and continents still under 3 into a global other bucket.'
