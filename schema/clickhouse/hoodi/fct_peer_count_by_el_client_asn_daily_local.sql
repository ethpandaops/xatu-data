CREATE TABLE hoodi.fct_peer_count_by_el_client_asn_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Execution client from the node devp2p name (nimbus reported as nimbusel)' CODEC(ZSTD(1)),
    `autonomous_system_number` UInt32 COMMENT 'Autonomous system number of the address, 0 for other and unknown' CODEC(ZSTD(1)),
    `autonomous_system_organization` LowCardinality(String) COMMENT 'Autonomous system organisation, other when the AS has under 3 peers, unknown when not geolocated' CODEC(ZSTD(1)),
    `network_type` LowCardinality(String) COMMENT 'hosting for cloud and hosting providers (known ASNs and organisation names), other for the rest (mostly residential and business ISPs), unknown when not geolocated' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Nodes' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_count_by_el_client_asn_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, client, network_type, autonomous_system_organization, autonomous_system_number)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily execution node census by client and autonomous system. Execution nodes our discovery crawler found in the day, one count per node with its latest record, on the network genesis and its current fork (a fork ID hash at least 10% of the nodes of the day share whose next fork has not passed, which excludes other chains and stale forks). Autonomous systems under 3 nodes roll into an other bucket per network type.'
