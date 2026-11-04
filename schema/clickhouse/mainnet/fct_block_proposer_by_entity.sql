CREATE TABLE mainnet.fct_block_proposer_by_entity
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `entity` LowCardinality(String) COMMENT 'Staking entity of the scheduled proposer in dim_node, or unknown' CODEC(ZSTD(1)),
    `proposer_validator_index` UInt32 COMMENT 'The validator index of the scheduled proposer' CODEC(ZSTD(1)),
    `block_root` Nullable(String) COMMENT 'The beacon block root, NULL when the slot was missed' CODEC(ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'canonical, orphaned (a block was seen but is not on the finalized chain) or missed (no block was seen)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_block_proposer_by_entity_local', cityHash64(slot_start_date_time))
COMMENT 'Every slot of the finalized chain with the staking entity of its scheduled proposer and how the proposal ended: canonical, orphaned or missed. Validators map to their current entity in dim_node, and validators it does not name are unknown'
