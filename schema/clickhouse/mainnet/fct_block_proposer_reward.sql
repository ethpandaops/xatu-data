CREATE TABLE mainnet.fct_block_proposer_reward
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The canonical block root' CODEC(ZSTD(1)),
    `proposer_index` UInt32 COMMENT 'The validator index of the proposer' CODEC(ZSTD(1)),
    `total` UInt64 COMMENT 'Total consensus layer proposer reward in Gwei' CODEC(ZSTD(1)),
    `attestations` UInt64 COMMENT 'Reward for included attestations in Gwei' CODEC(ZSTD(1)),
    `sync_aggregate` UInt64 COMMENT 'Reward for the included sync aggregate in Gwei' CODEC(ZSTD(1)),
    `proposer_slashings` UInt64 COMMENT 'Reward for included proposer slashings in Gwei' CODEC(ZSTD(1)),
    `attester_slashings` UInt64 COMMENT 'Reward for included attester slashings in Gwei' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_block_proposer_reward_local', cityHash64(proposer_index, slot_start_date_time))
COMMENT 'Consensus layer reward of each canonical block\\'s proposer'
