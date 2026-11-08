CREATE TABLE mainnet.fct_custody_probe_by_asn_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `autonomous_system_number` UInt32 COMMENT 'Autonomous system number of the address, 0 when unknown and for residential autonomous systems with under 3 probed peers in the day (other)' CODEC(ZSTD(1)),
    `autonomous_system_organization` LowCardinality(String) COMMENT 'Autonomous system organisation, unknown when not geolocated, other for residential autonomous systems with under 3 probed peers in the day' CODEC(ZSTD(1)),
    `network_type` LowCardinality(String) COMMENT 'hosting for cloud and hosting providers (known ASNs and organisation names), other for the rest (mostly residential and business ISPs), unknown when not geolocated' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Peers probed in the day' CODEC(ZSTD(1)),
    `probe_count` UInt32 COMMENT 'Custody probes' CODEC(ZSTD(1)),
    `success_count` UInt32 COMMENT 'Probes the peer answered with the column' CODEC(ZSTD(1)),
    `missing_count` UInt32 COMMENT 'Probes the peer answered without the column' CODEC(ZSTD(1)),
    `failure_count` UInt32 COMMENT 'Probes that errored or timed out' CODEC(ZSTD(1)),
    `missing_peer_count` UInt32 COMMENT 'Peers with at least one missing probe' CODEC(ZSTD(1)),
    `response_time_p50_ms` Nullable(Float64) COMMENT 'Median response time of successful probes in ms, NULL without any' CODEC(ZSTD(1)),
    `response_time_p90_ms` Nullable(Float64) COMMENT '90th percentile response time of successful probes in ms, NULL without any' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_custody_probe_by_asn_daily_local', cityHash64(day_start_date, autonomous_system_number, autonomous_system_organization, network_type))
COMMENT 'Daily data column custody probes by the probed peer autonomous system (its latest location in the day), residential and hosting. Residential autonomous systems with under 3 probed peers in the day roll into autonomous system 0 (other). Crawlers and probes are excluded.'
