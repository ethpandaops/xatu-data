CREATE TABLE mainnet.fct_peer_hosting_by_el_client_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Execution client from the node devp2p name: geth, nethermind, besu, erigon, reth, ethrex, nimbusel, ethereumjs or trin-execution, other for every other name' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Execution nodes' CODEC(ZSTD(1)),
    `hosting_peer_count` UInt32 COMMENT 'Peers on a cloud or hosting provider network' CODEC(ZSTD(1)),
    `located_peer_count` UInt32 COMMENT 'Peers with a known autonomous system, the population of hosting_peer_count' CODEC(ZSTD(1)),
    `ipv6_peer_count` UInt32 COMMENT 'Nodes whose record advertises an IPv6 address' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_peer_hosting_by_el_client_daily_local', cityHash64(day_start_date, client))
COMMENT 'Daily execution nodes by client, without versions, with hosting and IPv6 counts. Execution nodes our discovery crawler found in the day on the network genesis and its current fork, one count per node with its latest record.'
