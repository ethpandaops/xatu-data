CREATE TABLE mainnet.fct_peer_attnet_count_by_cl_client_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client from the peer agent: lighthouse, lodestar, nimbus, prysm, teku, grandine, caplin (erigon), silver or ethlambda, unknown when the agent was never seen, other for every other agent' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Peers that answered our sentries metadata requests in the day' CODEC(ZSTD(1)),
    `attnets_0_peer_count` UInt32 COMMENT 'Peers on no attestation subnet' CODEC(ZSTD(1)),
    `attnets_1_2_peer_count` UInt32 COMMENT 'Peers on 1 or 2 attestation subnets (2 is the long-lived default)' CODEC(ZSTD(1)),
    `attnets_3_63_peer_count` UInt32 COMMENT 'Peers on 3 to 63 attestation subnets' CODEC(ZSTD(1)),
    `attnets_64_peer_count` UInt32 COMMENT 'Peers on all 64 attestation subnets' CODEC(ZSTD(1)),
    `syncnets_any_peer_count` UInt32 COMMENT 'Peers on at least one sync committee subnet' CODEC(ZSTD(1)),
    `syncnets_4_peer_count` UInt32 COMMENT 'Peers on all 4 sync committee subnets' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_attnet_count_by_cl_client_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, client)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily consensus peers by client and by how many attestation and sync subnets they last advertised in a metadata response to our libp2p sentries. Crawlers, probes, light clients and our own sentries are excluded.'
