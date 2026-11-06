CREATE TABLE hoodi.dim_xatu_node_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `meta_client_name` String COMMENT 'Name of the Xatu node as reported, e.g. pub-asn-city/<user>/hashed-<id>. Join key for the by_node tables' CODEC(ZSTD(1)),
    `stable_node_id` String COMMENT 'The Xatu node this name belongs to: the meta_client_name of the first ID in its chain. Hashed IDs change when the beacon node\\'s p2p key changes (every restart on nimbus without --netkey-file). IDs with the same username and consensus client chain when one starts in or after the hour the previous one was last seen. IDs active at the same time stay separate. Named IDs map to themselves' CODEC(ZSTD(1)),
    `username` String COMMENT 'Contributor username of the Xatu node' CODEC(ZSTD(1)),
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'Consensus client of the Xatu node at its latest observation' CODEC(ZSTD(1)),
    `first_seen_date_time` DateTime COMMENT 'Start of the first hour this name reported a block' CODEC(DoubleDelta, ZSTD(1)),
    `last_seen_date_time` DateTime COMMENT 'Start of the latest hour this name reported a block' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/dim_xatu_node_local', '{replica}', updated_date_time)
ORDER BY meta_client_name
SETTINGS index_granularity = 8192
COMMENT 'Maps every Xatu node name to a stable node: hashed names that rotate on beacon node restarts are chained into one node. Count uniqExact(stable_node_id) to count Xatu nodes'
