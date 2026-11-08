CREATE TABLE mainnet.fct_peer_concentration_el_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Execution nodes' CODEC(ZSTD(1)),
    `located_peer_count` UInt32 COMMENT 'Peers with a known autonomous system, the population of hosting_peer_count' CODEC(ZSTD(1)),
    `hosting_peer_count` UInt32 COMMENT 'Peers on a cloud or hosting provider network' CODEC(ZSTD(1)),
    `ipv6_peer_count` UInt32 COMMENT 'Nodes whose record advertises an IPv6 address' CODEC(ZSTD(1)),
    `country_count` UInt32 COMMENT 'Countries with peers' CODEC(ZSTD(1)),
    `third_country_count` UInt32 COMMENT 'Fewest countries that hold a third of the peers with a known country' CODEC(ZSTD(1)),
    `half_country_count` UInt32 COMMENT 'Fewest countries that hold half of the peers with a known country' CODEC(ZSTD(1)),
    `autonomous_system_count` UInt32 COMMENT 'Autonomous systems with nodes, counting each residential system folded into autonomous system 0 (other) on its own' CODEC(ZSTD(1)),
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
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_concentration_el_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily concentration of execution nodes: countries and autonomous systems, the largest systems, the fewest countries and systems holding a third and half of the nodes, and nodes per continent. Shares are of nodes with a known country or system. Execution nodes our discovery crawler found in the day on the network genesis and its current fork, one count per node with its latest record.'
