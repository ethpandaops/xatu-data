CREATE TABLE sepolia.int_peer_subnet_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `peer_id_unique_key` Int64 COMMENT 'Hash of the peer ID and network, the key shared by the libp2p tables' CODEC(ZSTD(1)),
    `attnets` UInt64 COMMENT 'Attestation subnets the peer last advertised in the day: bit i is subnet i' CODEC(ZSTD(1)),
    `syncnets` UInt8 COMMENT 'Sync committee subnets the peer last advertised in the day: bit i is subnet i' CODEC(ZSTD(1)),
    `response_count` UInt32 COMMENT 'Metadata responses the peer sent our sentries in the day. 0 means the peer was dropped from the day on a recount' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_peer_subnet_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, peer_id_unique_key)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'One row per consensus peer per day with the attestation and sync subnets it last advertised in a metadata response to our libp2p sentries. Crawlers, probes, light clients and our own sentries are excluded.'
