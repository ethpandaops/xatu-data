CREATE TABLE hoodi.fct_peer_concentration_cl_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Consensus peers our libp2p sentries or our discovery crawler saw in the day' CODEC(ZSTD(1)),
    `located_peer_count` UInt32 COMMENT 'Peers with a known autonomous system, the population of hosting_peer_count' CODEC(ZSTD(1)),
    `hosting_peer_count` UInt32 COMMENT 'Peers on a cloud or hosting provider network' CODEC(ZSTD(1)),
    `ipv6_peer_count` UInt32 COMMENT 'Peers that advertise a global IPv6 address, in an identify listen address or their ENR record' CODEC(ZSTD(1)),
    `country_count` UInt32 COMMENT 'Countries with peers' CODEC(ZSTD(1)),
    `third_country_count` UInt32 COMMENT 'Fewest countries that hold a third of the peers with a known country' CODEC(ZSTD(1)),
    `half_country_count` UInt32 COMMENT 'Fewest countries that hold half of the peers with a known country' CODEC(ZSTD(1)),
    `autonomous_system_count` UInt32 COMMENT 'Autonomous systems with peers, counting each residential system folded into autonomous system 0 (other) on its own' CODEC(ZSTD(1)),
    `top_1_asn_peer_count` UInt32 COMMENT 'Peers in the largest autonomous system' CODEC(ZSTD(1)),
    `top_5_asn_peer_count` UInt32 COMMENT 'Peers in the 5 largest autonomous systems' CODEC(ZSTD(1)),
    `top_10_asn_peer_count` UInt32 COMMENT 'Peers in the 10 largest autonomous systems' CODEC(ZSTD(1)),
    `third_asn_count` UInt32 COMMENT 'Fewest autonomous systems that hold a third of the peers with a known autonomous system' CODEC(ZSTD(1)),
    `half_asn_count` UInt32 COMMENT 'Fewest autonomous systems that hold half of the peers with a known autonomous system' CODEC(ZSTD(1)),
    `africa_peer_count` UInt32 COMMENT 'Peers in Africa (AF)' CODEC(ZSTD(1)),
    `antarctica_peer_count` UInt32 COMMENT 'Peers in Antarctica (AN)' CODEC(ZSTD(1)),
    `asia_peer_count` UInt32 COMMENT 'Peers in Asia (AS)' CODEC(ZSTD(1)),
    `europe_peer_count` UInt32 COMMENT 'Peers in Europe (EU)' CODEC(ZSTD(1)),
    `north_america_peer_count` UInt32 COMMENT 'Peers in North America (NA)' CODEC(ZSTD(1)),
    `oceania_peer_count` UInt32 COMMENT 'Peers in Oceania (OC)' CODEC(ZSTD(1)),
    `south_america_peer_count` UInt32 COMMENT 'Peers in South America (SA)' CODEC(ZSTD(1)),
    `unknown_continent_peer_count` UInt32 COMMENT 'Peers not geolocated to a continent' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_peer_concentration_cl_daily_local', cityHash64(day_start_date))
COMMENT 'Daily concentration of consensus peers our libp2p sentries or our discovery crawler saw: countries and autonomous systems, the largest systems, the fewest countries and systems holding a third and half of the peers, and peers per continent. Shares are of peers with a known country or system. Crawlers, probes, light clients and our own sentries are excluded.'
