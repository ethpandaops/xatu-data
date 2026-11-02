CREATE TABLE mainnet.fct_block_proposal_by_client_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `layer` LowCardinality(String) COMMENT 'Client layer: consensus or execution' CODEC(ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Proposer client from the block graffiti, or for orphaned blocks and missed slots from the proposer most recent identifying graffiti, else unknown' CODEC(ZSTD(1)),
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
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_block_proposal_by_client_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, layer, client)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily block proposals per consensus and execution client: blocks, MEV share and value, gas, blobs, first-seen propagation, orphaned blocks and missed slots. Canonical blocks use their own graffiti. Orphaned and missed proposals use the proposer most recent identifying graffiti from the previous 365 days.'
