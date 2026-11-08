CREATE TABLE hoodi.fct_peer_sync_status_by_cl_client_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client from the peer agent: lighthouse, lodestar, nimbus, prysm, teku, grandine, caplin (erigon), silver or ethlambda, unknown when the agent was never seen, other for every other agent' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Peers our sentries saw in the day' CODEC(ZSTD(1)),
    `status_peer_count` UInt32 COMMENT 'Peers that exchanged status with our sentries, the population of the head, finalized and fork digest buckets' CODEC(ZSTD(1)),
    `head_lag_0_1_peer_count` UInt32 COMMENT 'Peers whose head trailed our sentries by at most 1 slot (median over the day)' CODEC(ZSTD(1)),
    `head_lag_2_32_peer_count` UInt32 COMMENT 'Peers whose head trailed our sentries by 2 to 32 slots' CODEC(ZSTD(1)),
    `head_lag_over_32_peer_count` UInt32 COMMENT 'Peers whose head trailed our sentries by more than 32 slots (syncing or stuck)' CODEC(ZSTD(1)),
    `finalized_lag_over_1_peer_count` UInt32 COMMENT 'Peers whose finalized checkpoint trailed our sentries by more than 1 epoch (median over the day)' CODEC(ZSTD(1)),
    `other_fork_digest_peer_count` UInt32 COMMENT 'Peers whose latest status carried another fork digest than the most common one among all peers that day' CODEC(ZSTD(1)),
    `history_known_peer_count` UInt32 COMMENT 'Peers that sent an earliest available slot (status v2), the population of the history buckets' CODEC(ZSTD(1)),
    `history_full_peer_count` UInt32 COMMENT 'Peers serving blocks from genesis (earliest available slot 0)' CODEC(ZSTD(1)),
    `history_over_min_peer_count` UInt32 COMMENT 'Peers serving more than a day beyond the spec minimum of 33024 epochs of blocks, short of genesis' CODEC(ZSTD(1)),
    `history_min_peer_count` UInt32 COMMENT 'Peers serving the spec minimum of 33024 epochs of blocks, give or take a day' CODEC(ZSTD(1)),
    `history_under_min_peer_count` UInt32 COMMENT 'Peers serving more than a day less than the spec minimum of 33024 epochs of blocks' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_sync_status_by_cl_client_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, client)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily consensus peer sync status by client, from status exchanges with our libp2p sentries: head and finalized lag against the sentry, fork digest, and block history served (earliest available slot).'
