CREATE TABLE hoodi.fct_peer_protocol_by_cl_client_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client from the peer agent (erigon reported as caplin), unknown when the agent was never seen, other for unparseable names' CODEC(ZSTD(1)),
    `protocol` LowCardinality(String) COMMENT 'libp2p protocol ID, e.g. /meshsub/1.3.0 or /eth2/beacon_chain/req/status/2/ssz_snappy' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Peers supporting the protocol' CODEC(ZSTD(1)),
    `client_peer_count` UInt32 COMMENT 'All peers of the client in the day' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_protocol_by_cl_client_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, client, protocol)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily libp2p protocol support by consensus client. Consensus peers our libp2p sentries saw in the day (heartbeats and identify exchanges), one count per peer with its latest agent and address. Crawlers, probes, light clients and our own sentries are excluded. Protocols fewer than 3 of the client peers support are excluded.'
