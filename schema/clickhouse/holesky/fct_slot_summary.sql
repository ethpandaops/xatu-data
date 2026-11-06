CREATE TABLE holesky.fct_slot_summary
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `status` LowCardinality(String) COMMENT 'canonical when the block is on the finalized chain, missed when no block was proposed, orphaned when the head saw a block the chain did not keep (before the head data starts an orphaned slot shows as missed)',
    `block_root` Nullable(String) COMMENT 'The beacon block root, NULL for a missed slot' CODEC(ZSTD(1)),
    `proposer_validator_index` UInt32 COMMENT 'The validator index of the proposer' CODEC(ZSTD(1)),
    `entity` Nullable(String) COMMENT 'The staking entity of the proposer, from its current dim_node mapping, NULL when unknown' CODEC(ZSTD(1)),
    `block_number` Nullable(UInt32) COMMENT 'The execution block number, NULL for a missed slot or a block without an execution payload' CODEC(DoubleDelta, ZSTD(1)),
    `gas_used` Nullable(UInt64) COMMENT 'Execution gas used by the block, NULL for a missed slot' CODEC(ZSTD(1)),
    `gas_limit` Nullable(UInt64) COMMENT 'Execution gas limit of the block, NULL for a missed slot' CODEC(ZSTD(1)),
    `transaction_count` Nullable(UInt32) COMMENT 'Number of transactions in the block, NULL for a missed slot' CODEC(ZSTD(1)),
    `blob_count` Nullable(UInt32) COMMENT 'Number of blobs in the block, NULL for a missed or orphaned slot' CODEC(ZSTD(1)),
    `consensus_client` Nullable(String) COMMENT 'Consensus client of the proposer, parsed from the block graffiti (unknown when the graffiti does not say), NULL for a missed or orphaned slot' CODEC(ZSTD(1)),
    `execution_client` Nullable(String) COMMENT 'Execution client of the proposer, parsed from the block graffiti (unknown when the graffiti does not say), NULL for a missed or orphaned slot' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_slot_summary_local', cityHash64(slot_start_date_time))
COMMENT 'One row per slot from fct_block_proposer: proposed, missed or orphaned, the proposer and entity, the block number, gas, transactions, blobs and the proposer clients from the graffiti. MEV relays, builder and value are in int_block_mev_canonical'
