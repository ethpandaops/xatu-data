CREATE TABLE mainnet.fct_block_proposal_by_entity_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `entity` LowCardinality(String) COMMENT 'Staking entity of the scheduled proposer in dim_node, or unknown' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Canonical blocks proposed' CODEC(ZSTD(1)),
    `mev_block_count` UInt32 COMMENT 'Canonical blocks delivered by an MEV relay, the rest were built locally' CODEC(ZSTD(1)),
    `avg_mev_value_eth` Nullable(Float64) COMMENT 'Mean relay-reported value of the MEV blocks in ETH, NULL when there were none' CODEC(ZSTD(1)),
    `orphaned_block_count` UInt32 COMMENT 'Blocks proposed that did not make the finalized chain' CODEC(ZSTD(1)),
    `missed_slot_count` UInt32 COMMENT 'Slots the entity was scheduled to propose where no block was seen' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_block_proposal_by_entity_daily_local', cityHash64(day_start_date, entity))
COMMENT 'Daily block proposals per staking entity on the finalized chain: canonical blocks, MEV share and value, orphaned blocks and missed slots. Proposals due are block_count + orphaned_block_count + missed_slot_count. Validators map to their current entity in dim_node, and validators it does not name are unknown, so the rows of a day sum to the whole network'
