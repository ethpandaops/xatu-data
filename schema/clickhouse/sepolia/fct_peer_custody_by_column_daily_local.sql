CREATE TABLE sepolia.fct_peer_custody_by_column_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `column_index` UInt8 COMMENT 'Data column index, 0 to 127' CODEC(ZSTD(1)),
    `custodian_peer_count` UInt32 COMMENT 'Peers that custody the column, from their custody group count and node ID' CODEC(ZSTD(1)),
    `supernode_peer_count` UInt32 COMMENT 'Of those, peers custodying all 128 groups (supernodes), the same for every column' CODEC(ZSTD(1)),
    `hosting_peer_count` UInt32 COMMENT 'Of those, peers on a cloud or hosting provider network' CODEC(ZSTD(1)),
    `country_count` UInt16 COMMENT 'Countries the custodians are in' CODEC(ZSTD(1)),
    `largest_country_peer_count` UInt32 COMMENT 'Custodians in the country with the most of them' CODEC(ZSTD(1)),
    `hosting_autonomous_system_count` UInt16 COMMENT 'Hosting autonomous systems the custodians are on. Residential peers have no autonomous system here' CODEC(ZSTD(1)),
    `largest_autonomous_system_peer_count` UInt32 COMMENT 'Custodians on the hosting autonomous system with the most of them' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_custody_by_column_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, column_index)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily consensus peers by the data columns they custody, 128 rows a day: a peer with custody group count n custodies the first n groups its node ID assigns. Peers our libp2p sentries or discovery crawler saw with a known custody group count and peer ID (all peers from April 2026). Crawlers, probes, light clients and our own sentries are excluded.'
