CREATE TABLE hoodi.fct_peer_count_by_client_pair_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `consensus_client` LowCardinality(String) COMMENT 'Consensus client at the address' CODEC(ZSTD(1)),
    `execution_client` LowCardinality(String) COMMENT 'Execution client at the address' CODEC(ZSTD(1)),
    `ip_count` UInt32 COMMENT 'Addresses with exactly this consensus and execution client' CODEC(ZSTD(1)),
    `cl_ip_count` UInt32 COMMENT 'Addresses in the day with a consensus client' CODEC(ZSTD(1)),
    `el_ip_count` UInt32 COMMENT 'Addresses in the day with an execution client' CODEC(ZSTD(1)),
    `matched_ip_count` UInt32 COMMENT 'Addresses in the day with both, the match rate is matched_ip_count / cl_ip_count' CODEC(ZSTD(1)),
    `paired_ip_count` UInt32 COMMENT 'Matched addresses with exactly one client per layer, the sum of ip_count over the day' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_peer_count_by_client_pair_daily_local', cityHash64(day_start_date, consensus_client, execution_client))
COMMENT 'Daily consensus and execution client pairs from nodes sharing an IPv4 address: consensus peers from libp2p and ENRs, execution nodes from discovery on the network genesis and its current fork. Only addresses with exactly one consensus and one execution client form a pair. No address is stored.'
