CREATE TABLE holesky.fct_peer_subnet_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `subnet_type` LowCardinality(String) COMMENT 'attestation (64 subnets) or sync (4 sync committee subnets)' CODEC(ZSTD(1)),
    `subnet_id` UInt8 COMMENT 'Subnet index, 0 to 63 for attestation and 0 to 3 for sync' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Peers that last advertised the subnet in the day' CODEC(ZSTD(1)),
    `all_subnets_peer_count` UInt32 COMMENT 'Of those, peers on every subnet of the type, the same on every row of the type' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_subnet_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, subnet_type, subnet_id)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily consensus peers by the attestation and sync subnets they last advertised in a metadata response to our libp2p sentries, 68 rows a day. Crawlers, probes, light clients and our own sentries are excluded.'
