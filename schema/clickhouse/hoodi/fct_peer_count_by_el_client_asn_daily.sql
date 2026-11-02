CREATE TABLE hoodi.fct_peer_count_by_el_client_asn_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Execution client from the node devp2p name (nimbus reported as nimbusel)' CODEC(ZSTD(1)),
    `autonomous_system_number` UInt32 COMMENT 'Autonomous system number of the address, 0 for other and unknown' CODEC(ZSTD(1)),
    `autonomous_system_organization` LowCardinality(String) COMMENT 'Autonomous system organisation, other when the AS has under 3 peers, unknown when not geolocated' CODEC(ZSTD(1)),
    `network_type` LowCardinality(String) COMMENT 'hosting for cloud and hosting providers (known ASNs and organisation names), other for the rest (mostly residential and business ISPs), unknown when not geolocated' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Nodes' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_peer_count_by_el_client_asn_daily_local', cityHash64(day_start_date, client, network_type, autonomous_system_organization, autonomous_system_number))
COMMENT 'Daily execution node census by client and autonomous system. Execution nodes our discovery crawler found in the day, one count per node with its latest record, on the network genesis (the most common one that day, which excludes other chains). Autonomous systems under 3 nodes roll into an other bucket per network type.'
