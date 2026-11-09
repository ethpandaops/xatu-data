CREATE TABLE sepolia.fct_peer_subnet_coverage_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `attnets_64_peer_count` UInt32 COMMENT 'Peers on all 64 attestation subnets' CODEC(ZSTD(1)),
    `min_attestation_subnet_peer_count` UInt32 COMMENT 'Peers on the thinnest attestation subnet' CODEC(ZSTD(1)),
    `min_attestation_subnet_id` UInt8 COMMENT 'The thinnest attestation subnet, the lowest index on a tie' CODEC(ZSTD(1)),
    `median_attestation_subnet_peer_count` UInt32 COMMENT 'Median peers per attestation subnet (the lower of the middle two)' CODEC(ZSTD(1)),
    `max_attestation_subnet_peer_count` UInt32 COMMENT 'Peers on the thickest attestation subnet' CODEC(ZSTD(1)),
    `min_attestation_subnet_partial_peer_count` UInt32 COMMENT 'Fewest peers any attestation subnet has without the peers on all 64' CODEC(ZSTD(1)),
    `min_sync_subnet_peer_count` UInt32 COMMENT 'Peers on the thinnest sync committee subnet' CODEC(ZSTD(1)),
    `max_sync_subnet_peer_count` UInt32 COMMENT 'Peers on the thickest sync committee subnet' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_peer_subnet_coverage_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY day_start_date
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily spread of consensus peers over the 64 attestation and 4 sync subnets they advertise, one row a day: the thinnest, median and thickest attestation subnet, the thinnest without peers on all 64, and the thinnest and thickest sync subnet. Peers as in fct_peer_subnet_daily.'
