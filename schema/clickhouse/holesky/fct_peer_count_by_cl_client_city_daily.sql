CREATE TABLE holesky.fct_peer_count_by_cl_client_city_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `country_code` LowCardinality(String) COMMENT 'Country code of the address, unknown when not geolocated' CODEC(ZSTD(1)),
    `city` LowCardinality(String) COMMENT 'City of the address, unknown when not geolocated to a city, other for residential city and client cells with under 3 peers' CODEC(ZSTD(1)),
    `network_type` LowCardinality(String) COMMENT 'hosting for cloud and hosting providers (known ASNs and organisation names), other for the rest (mostly residential and business ISPs), unknown when not geolocated' CODEC(ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client from the peer agent: lighthouse, lodestar, nimbus, prysm, teku, grandine, caplin (erigon), silver or ethlambda, unknown when the agent was never seen, other for every other agent' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Consensus peers our libp2p sentries or our discovery crawler saw in the day' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_peer_count_by_cl_client_city_daily_local', cityHash64(day_start_date, country_code, city, network_type, client))
COMMENT 'Daily consensus peers by country, city, network type and client, residential and hosting, from our libp2p sentries and our discovery crawler. Not crossed with autonomous system or version. Residential (network type other or unknown) city and client cells under 3 peers roll into city other within the country. Crawlers, probes, light clients and our own sentries are excluded.'
