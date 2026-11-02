CREATE TABLE sepolia.fct_peer_count_by_cl_client_asn_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client from the peer agent (erigon reported as caplin), unknown when the agent was never seen, other for unparseable names' CODEC(ZSTD(1)),
    `autonomous_system_number` UInt32 COMMENT 'Autonomous system number of the address, 0 for other and unknown' CODEC(ZSTD(1)),
    `autonomous_system_organization` LowCardinality(String) COMMENT 'Autonomous system organisation, other when the AS has under 3 peers, unknown when not geolocated' CODEC(ZSTD(1)),
    `network_type` LowCardinality(String) COMMENT 'hosting for cloud and hosting providers (known ASNs and organisation names), other for the rest (mostly residential and business ISPs), unknown when not geolocated' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Peers' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_peer_count_by_cl_client_asn_daily_local', cityHash64(day_start_date, client, network_type, autonomous_system_organization, autonomous_system_number))
COMMENT 'Daily consensus peer census by client and autonomous system. Consensus peers our libp2p sentries saw in the day (heartbeats and identify exchanges), one count per peer with its latest agent and address. Crawlers, probes, light clients and our own sentries are excluded. Autonomous systems under 3 peers roll into an other bucket per network type.'
