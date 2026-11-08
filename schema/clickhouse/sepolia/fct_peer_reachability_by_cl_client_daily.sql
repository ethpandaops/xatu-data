CREATE TABLE sepolia.fct_peer_reachability_by_cl_client_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client from the peer agent: lighthouse, lodestar, nimbus, prysm, teku, grandine, caplin (erigon), silver or ethlambda, unknown when the agent was never seen, other for every other agent' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Peers our sentries saw in the day' CODEC(ZSTD(1)),
    `dialled_peer_count` UInt32 COMMENT 'Peers our sentries dialled (outbound connections), so publicly reachable' CODEC(ZSTD(1)),
    `inbound_only_peer_count` UInt32 COMMENT 'Peers that only connected to our sentries and were never dialled' CODEC(ZSTD(1)),
    `quic_connected_peer_count` UInt32 COMMENT 'Peers connected to over QUIC' CODEC(ZSTD(1)),
    `quic_listen_peer_count` UInt32 COMMENT 'Peers advertising a QUIC listen address in identify' CODEC(ZSTD(1)),
    `enr_peer_count` UInt32 COMMENT 'Peers our discovery crawler also dialled from their ENR' CODEC(ZSTD(1)),
    `enr_ip_mismatch_peer_count` UInt32 COMMENT 'Of those, peers whose ENR advertises another address than the one our sentries connected to' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_peer_reachability_by_cl_client_daily_local', cityHash64(day_start_date, client))
COMMENT 'Daily consensus peer reachability by client: peers our libp2p sentries dialled or that only connected in, QUIC, and ENR address mismatches.'
