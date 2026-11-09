CREATE TABLE hoodi.fct_peer_churn_by_cl_client_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client from the peer agent: lighthouse, lodestar, nimbus, prysm, teku, grandine, caplin (erigon), silver or ethlambda, unknown when the agent was never seen, other for every other agent. Departed peers count under their client the previous day' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Peers our sentries saw in the day. Equals continuing_peer_count + new_peer_count + returning_peer_count' CODEC(ZSTD(1)),
    `continuing_peer_count` UInt32 COMMENT 'Peers our sentries also saw the previous day' CODEC(ZSTD(1)),
    `new_peer_count` UInt32 COMMENT 'Peers our sentries had not seen in the previous 29 days' CODEC(ZSTD(1)),
    `returning_peer_count` UInt32 COMMENT 'Peers our sentries had not seen the previous day but had seen in the 28 days before it' CODEC(ZSTD(1)),
    `departed_peer_count` UInt32 COMMENT 'Peers our sentries saw the previous day but not in this day' CODEC(ZSTD(1)),
    `seen_2_7_days_peer_count` UInt32 COMMENT 'Peers in the day seen on 2 to 7 of the 30 days ending on it. With new_peer_count (seen on 1) and the two counts below, sums to peer_count' CODEC(ZSTD(1)),
    `seen_8_29_days_peer_count` UInt32 COMMENT 'Peers in the day seen on 8 to 29 of the 30 days ending on it' CODEC(ZSTD(1)),
    `seen_30_days_peer_count` UInt32 COMMENT 'Peers in the day seen on all 30 days ending on it' CODEC(ZSTD(1)),
    `history_days` UInt8 COMMENT 'How many of the previous 29 days hold sentry peers. Under 29, new_peer_count is overstated and the seen-days counts understated, as at the start of the data' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_peer_churn_by_cl_client_daily_local', cityHash64(day_start_date))
COMMENT 'Daily consensus peer churn by client, from the peers our libp2p sentries saw: peers kept from the previous day, new peers, returning peers and departed peers, and how many of the last 30 days each peer was seen on. A peer is its peer ID, so clients that rotate their ID on restart show as churn. Rows are written once the day is complete. Crawlers, probes, light clients and our own sentries are excluded.'
