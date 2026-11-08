CREATE TABLE mainnet.fct_peer_count_by_source_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Consensus peers our libp2p sentries or our discovery crawler saw in the day' CODEC(ZSTD(1)),
    `sentry_peer_count` UInt32 COMMENT 'Peers our libp2p sentries were connected to' CODEC(ZSTD(1)),
    `enr_peer_count` UInt32 COMMENT 'Peers our discovery crawler dialled from their ENR' CODEC(ZSTD(1)),
    `sentry_and_enr_peer_count` UInt32 COMMENT 'Peers both sources saw' CODEC(ZSTD(1)),
    `dialled_peer_count` UInt32 COMMENT 'Peers our sentries dialled (outbound connections), so publicly reachable' CODEC(ZSTD(1)),
    `inbound_only_peer_count` UInt32 COMMENT 'Peers that only connected to our sentries and were never dialled' CODEC(ZSTD(1)),
    `quic_peer_count` UInt32 COMMENT 'Peers connected to over QUIC or advertising a QUIC listen address' CODEC(ZSTD(1)),
    `ipv6_peer_count` UInt32 COMMENT 'Peers that advertise a global IPv6 address, in an identify listen address or their ENR record' CODEC(ZSTD(1)),
    `hosting_peer_count` UInt32 COMMENT 'Peers on a cloud or hosting provider network' CODEC(ZSTD(1)),
    `located_peer_count` UInt32 COMMENT 'Peers with a known autonomous system, the population of hosting_peer_count' CODEC(ZSTD(1)),
    `custody_known_peer_count` UInt32 COMMENT 'Peers whose custody group count is known from a metadata response or their ENR' CODEC(ZSTD(1)),
    `custody_4_peer_count` UInt32 COMMENT 'Peers custodying 4 or fewer groups (the minimum)' CODEC(ZSTD(1)),
    `custody_5_8_peer_count` UInt32 COMMENT 'Peers custodying 5 to 8 groups' CODEC(ZSTD(1)),
    `custody_9_127_peer_count` UInt32 COMMENT 'Peers custodying 9 to 127 groups' CODEC(ZSTD(1)),
    `custody_128_peer_count` UInt32 COMMENT 'Peers custodying all 128 groups (supernodes)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_peer_count_by_source_daily_local', cityHash64(day_start_date))
COMMENT 'Daily consensus peer totals by source: peers our libp2p sentries and our discovery crawler saw, and how many both saw, with reachability, hosting and custody counts. Crawlers, probes, light clients and our own sentries are excluded.'
