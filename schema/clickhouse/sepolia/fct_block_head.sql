CREATE TABLE sepolia.fct_block_head
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block payload',
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the reorg slot started',
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload',
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started',
    `block_root` FixedString(66) COMMENT 'The root hash of the beacon block',
    `block_version` LowCardinality(String) COMMENT 'The version of the beacon block',
    `block_total_bytes` Nullable(UInt32) COMMENT 'The total bytes of the beacon block payload',
    `block_total_bytes_compressed` Nullable(UInt32) COMMENT 'The total bytes of the beacon block payload when compressed using snappy',
    `parent_root` FixedString(66) COMMENT 'The root hash of the parent beacon block',
    `state_root` FixedString(66) COMMENT 'The root hash of the beacon state at this block',
    `proposer_index` UInt32 COMMENT 'The index of the validator that proposed the beacon block',
    `eth1_data_block_hash` FixedString(66) COMMENT 'The block hash of the associated execution block',
    `eth1_data_deposit_root` FixedString(66) COMMENT 'The root of the deposit tree in the associated execution block',
    `execution_payload_block_hash` FixedString(66) COMMENT 'The block hash of the execution payload',
    `execution_payload_block_number` UInt32 COMMENT 'The block number of the execution payload',
    `execution_payload_fee_recipient` String COMMENT 'The recipient of the fee for this execution payload',
    `execution_payload_base_fee_per_gas` Nullable(UInt128) COMMENT 'Base fee per gas for execution payload' CODEC(ZSTD(1)),
    `execution_payload_blob_gas_used` Nullable(UInt64) COMMENT 'Gas used for blobs in execution payload' CODEC(ZSTD(1)),
    `execution_payload_excess_blob_gas` Nullable(UInt64) COMMENT 'Excess gas used for blobs in execution payload' CODEC(ZSTD(1)),
    `execution_payload_gas_limit` Nullable(UInt64) COMMENT 'Gas limit for execution payload' CODEC(DoubleDelta, ZSTD(1)),
    `execution_payload_gas_used` Nullable(UInt64) COMMENT 'Gas used for execution payload' CODEC(ZSTD(1)),
    `execution_payload_state_root` FixedString(66) COMMENT 'The state root of the execution payload',
    `execution_payload_parent_hash` FixedString(66) COMMENT 'The parent hash of the execution payload',
    `execution_payload_transactions_count` Nullable(UInt32) COMMENT 'The transaction count of the execution payload',
    `execution_payload_transactions_total_bytes` Nullable(UInt32) COMMENT 'The transaction total bytes of the execution payload',
    `execution_payload_transactions_total_bytes_compressed` Nullable(UInt32) COMMENT 'The transaction total bytes of the execution payload when compressed using snappy'
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_block_head_local', cityHash64(slot_start_date_time, block_root))
COMMENT 'Block details for the unfinalized chain. Forks in the chain may cause multiple block roots for the same slot to be present'
