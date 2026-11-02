CREATE TABLE hoodi.fct_block_proposal_by_client_pair_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `consensus_client` LowCardinality(String) COMMENT 'Consensus client named by the graffiti, or unknown' CODEC(ZSTD(1)),
    `execution_client` LowCardinality(String) COMMENT 'Execution client named by the graffiti, or unknown' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Canonical blocks proposed' CODEC(ZSTD(1)),
    `mev_block_count` UInt32 COMMENT 'Canonical blocks delivered by an MEV relay, the rest were built locally' CODEC(ZSTD(1)),
    `avg_mev_value_eth` Nullable(Float64) COMMENT 'Mean relay-reported value of the MEV blocks in ETH, NULL when there were none' CODEC(ZSTD(1)),
    `avg_gas_used` Nullable(Float64) COMMENT 'Mean execution gas used per canonical block' CODEC(ZSTD(1)),
    `avg_blob_count` Nullable(Float64) COMMENT 'Mean blobs per canonical block' CODEC(ZSTD(1)),
    `blob_count` UInt32 COMMENT 'Blobs in the canonical blocks' CODEC(ZSTD(1)),
    `block_first_seen_p50_ms` Nullable(Float64) COMMENT 'Median over blocks of the median time sentry nodes first saw the block, in ms from slot start' CODEC(ZSTD(1)),
    `block_first_seen_p90_ms` Nullable(Float64) COMMENT '90th percentile over blocks of the median time sentry nodes first saw the block, in ms from slot start' CODEC(ZSTD(1)),
    `orphaned_block_count` UInt32 COMMENT 'Orphaned blocks, attributed through the proposer most recent identifying graffiti' CODEC(ZSTD(1)),
    `missed_slot_count` UInt32 COMMENT 'Missed slots, attributed through the scheduled proposer most recent identifying graffiti' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_block_proposal_by_client_pair_daily_local', cityHash64(day_start_date, consensus_client, execution_client))
COMMENT 'Daily block proposals per consensus and execution client pair: blocks, MEV share and value, gas, blobs, first-seen propagation, orphaned blocks and missed slots. Canonical blocks use their own graffiti. Orphaned and missed proposals use the pair of the proposer most recent graffiti naming either client from the previous 365 days. A side the graffiti does not name is unknown.'
