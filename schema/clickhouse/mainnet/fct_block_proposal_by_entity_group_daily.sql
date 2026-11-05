CREATE TABLE mainnet.fct_block_proposal_by_entity_group_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `entity_group` LowCardinality(String) COMMENT 'Group of staking entities run under one protocol: lido is every entity whose name contains lido (lido itself, the curated *_lido operators, the csm_operator*_lido Community Staking operators and the lidox* Simple DVT clusters)' CODEC(ZSTD(1)),
    `entity_count` UInt32 COMMENT 'Entities of the group with a proposal in the day' CODEC(ZSTD(1)),
    `block_count` UInt32 COMMENT 'Canonical blocks proposed' CODEC(ZSTD(1)),
    `mev_block_count` UInt32 COMMENT 'Canonical blocks delivered by an MEV relay, the rest were built locally' CODEC(ZSTD(1)),
    `avg_mev_value_eth` Nullable(Float64) COMMENT 'Mean relay-reported value of the MEV blocks in ETH, NULL when there were none' CODEC(ZSTD(1)),
    `orphaned_block_count` UInt32 COMMENT 'Blocks proposed that did not make the finalized chain' CODEC(ZSTD(1)),
    `missed_slot_count` UInt32 COMMENT 'Slots the group was scheduled to propose where no block was seen' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_block_proposal_by_entity_group_daily_local', cityHash64(day_start_date, entity_group))
COMMENT 'Daily block proposals per entity group on the finalized chain: the sum of the member entities in fct_block_proposal_by_entity_daily. Proposals due are block_count + orphaned_block_count + missed_slot_count. Only entities in a group have rows'
