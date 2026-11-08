CREATE TABLE holesky.fct_peer_count_by_asn_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `autonomous_system_number` UInt32 COMMENT 'Autonomous system number of the address, 0 for unknown and for residential autonomous systems with under 3 peers in the day' CODEC(ZSTD(1)),
    `autonomous_system_organization` LowCardinality(String) COMMENT 'Autonomous system organisation, unknown when not geolocated, other for residential autonomous systems with under 3 peers in the day' CODEC(ZSTD(1)),
    `network_type` LowCardinality(String) COMMENT 'hosting for cloud and hosting providers (known ASNs and organisation names), other for the rest (mostly residential and business ISPs), unknown when not geolocated' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Consensus peers our libp2p sentries or our discovery crawler saw in the day' CODEC(ZSTD(1)),
    `sentry_peer_count` UInt32 COMMENT 'Peers our libp2p sentries were connected to' CODEC(ZSTD(1)),
    `enr_peer_count` UInt32 COMMENT 'Peers our discovery crawler dialled from their ENR' CODEC(ZSTD(1)),
    `dialled_peer_count` UInt32 COMMENT 'Peers our sentries dialled (outbound connections), so publicly reachable' CODEC(ZSTD(1)),
    `inbound_only_peer_count` UInt32 COMMENT 'Peers that only connected to our sentries and were never dialled' CODEC(ZSTD(1)),
    `quic_peer_count` UInt32 COMMENT 'Peers connected to over QUIC or advertising a QUIC listen address' CODEC(ZSTD(1)),
    `custody_known_peer_count` UInt32 COMMENT 'Peers whose custody group count is known from a metadata response or their ENR' CODEC(ZSTD(1)),
    `custody_4_peer_count` UInt32 COMMENT 'Peers custodying 4 or fewer groups (the minimum)' CODEC(ZSTD(1)),
    `custody_5_8_peer_count` UInt32 COMMENT 'Peers custodying 5 to 8 groups' CODEC(ZSTD(1)),
    `custody_9_127_peer_count` UInt32 COMMENT 'Peers custodying 9 to 127 groups' CODEC(ZSTD(1)),
    `custody_128_peer_count` UInt32 COMMENT 'Peers custodying all 128 groups (supernodes)' CODEC(ZSTD(1)),
    `autonomous_system_count` UInt32 COMMENT 'Autonomous systems in the row: 1, the number of residential systems folded into autonomous system 0 (other), each with 1 or 2 peers, or 0 for unknown' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_peer_count_by_asn_daily_local', cityHash64(day_start_date, autonomous_system_number, autonomous_system_organization, network_type))
COMMENT 'Daily consensus peers by autonomous system, residential and hosting, from our libp2p sentries and our discovery crawler, with reachability and custody counts. Residential autonomous systems under 3 peers in the day roll into autonomous system 0 (other), which keeps how many systems it holds. Crawlers, probes, light clients and our own sentries are excluded.'
