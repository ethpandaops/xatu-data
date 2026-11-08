CREATE TABLE sepolia.fct_peer_count_by_el_asn_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `autonomous_system_number` UInt32 COMMENT 'Autonomous system number of the address, 0 for unknown and for residential autonomous systems under 3 peers (other)' CODEC(ZSTD(1)),
    `autonomous_system_organization` LowCardinality(String) COMMENT 'Autonomous system organisation, unknown when not geolocated, other for residential autonomous systems under 3 peers' CODEC(ZSTD(1)),
    `network_type` LowCardinality(String) COMMENT 'hosting for cloud and hosting providers (known ASNs and organisation names), other for the rest (mostly residential and business ISPs), unknown when not geolocated' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Execution nodes' CODEC(ZSTD(1)),
    `autonomous_system_count` UInt32 COMMENT 'Autonomous systems in the row: 1, the number of residential systems folded into autonomous system 0 (other), each with 1 or 2 peers, or 0 for unknown' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_peer_count_by_el_asn_daily_local', cityHash64(day_start_date, autonomous_system_number, autonomous_system_organization, network_type))
COMMENT 'Daily execution nodes by autonomous system, all clients together. Residential autonomous systems under 3 nodes roll into autonomous system 0 (other), which keeps how many systems it holds. Execution nodes our discovery crawler found in the day on the network genesis and its current fork, one count per node with its latest record.'
