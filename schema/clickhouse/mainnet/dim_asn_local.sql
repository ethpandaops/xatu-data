CREATE TABLE mainnet.dim_asn_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `autonomous_system_number` UInt32 COMMENT 'Autonomous system number of the address, 0 when unknown' CODEC(ZSTD(1)),
    `autonomous_system_organization` LowCardinality(String) COMMENT 'Autonomous system organisation on the last day it had peers' CODEC(ZSTD(1)),
    `provider` LowCardinality(String) COMMENT 'Network operator: one name for providers that span several autonomous systems or organisation names (Amazon, Google, Microsoft, Alibaba, Oracle, OVHcloud, Hetzner, Contabo, Akamai, Tencent), else the organisation without its legal suffix, empty when unknown' CODEC(ZSTD(1)),
    `network_type` LowCardinality(String) COMMENT 'hosting for cloud and hosting providers (known ASNs and organisation names), other for the rest (mostly residential and business ISPs)' CODEC(ZSTD(1)),
    `last_seen_date` Date COMMENT 'Last day our consensus peers were on the autonomous system' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/dim_asn_local', '{replica}', last_seen_date)
ORDER BY autonomous_system_number
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Autonomous systems our consensus peers were on, residential and hosting, with organisation, provider and network type as of the last day they had peers.'
