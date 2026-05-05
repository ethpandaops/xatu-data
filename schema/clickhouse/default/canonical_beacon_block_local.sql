CREATE TABLE default.canonical_beacon_block_local
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The root hash of the beacon block' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The version of the beacon block',
    `block_total_bytes` Nullable(UInt32) COMMENT 'The total bytes of the beacon block payload' CODEC(ZSTD(1)),
    `block_total_bytes_compressed` Nullable(UInt32) COMMENT 'The total bytes of the beacon block payload when compressed using snappy' CODEC(ZSTD(1)),
    `parent_root` FixedString(66) COMMENT 'The root hash of the parent beacon block' CODEC(ZSTD(1)),
    `state_root` FixedString(66) COMMENT 'The root hash of the beacon state at this block' CODEC(ZSTD(1)),
    `proposer_index` UInt32 COMMENT 'The index of the validator that proposed the beacon block' CODEC(ZSTD(1)),
    `eth1_data_block_hash` FixedString(66) COMMENT 'The block hash of the associated execution block' CODEC(ZSTD(1)),
    `eth1_data_deposit_root` FixedString(66) COMMENT 'The root of the deposit tree in the associated execution block' CODEC(ZSTD(1)),
    `execution_payload_block_hash` Nullable(FixedString(66)) COMMENT 'The block hash of the execution payload' CODEC(ZSTD(1)),
    `execution_payload_block_number` Nullable(UInt32) COMMENT 'The block number of the execution payload' CODEC(DoubleDelta, ZSTD(1)),
    `execution_payload_fee_recipient` Nullable(String) COMMENT 'The recipient of the fee for this execution payload' CODEC(ZSTD(1)),
    `execution_payload_base_fee_per_gas` Nullable(UInt128) COMMENT 'Base fee per gas for execution payload' CODEC(ZSTD(1)),
    `execution_payload_blob_gas_used` Nullable(UInt64) COMMENT 'Gas used for blobs in execution payload' CODEC(ZSTD(1)),
    `execution_payload_excess_blob_gas` Nullable(UInt64) COMMENT 'Excess gas used for blobs in execution payload' CODEC(ZSTD(1)),
    `execution_payload_gas_limit` Nullable(UInt64) COMMENT 'Gas limit for execution payload' CODEC(DoubleDelta, ZSTD(1)),
    `execution_payload_gas_used` Nullable(UInt64) COMMENT 'Gas used for execution payload' CODEC(ZSTD(1)),
    `execution_payload_state_root` Nullable(FixedString(66)) COMMENT 'The state root of the execution payload' CODEC(ZSTD(1)),
    `execution_payload_parent_hash` Nullable(FixedString(66)) COMMENT 'The parent hash of the execution payload' CODEC(ZSTD(1)),
    `execution_payload_transactions_count` Nullable(UInt32) COMMENT 'The transaction count of the execution payload' CODEC(ZSTD(1)),
    `execution_payload_transactions_total_bytes` Nullable(UInt32) COMMENT 'The transaction total bytes of the execution payload' CODEC(ZSTD(1)),
    `execution_payload_transactions_total_bytes_compressed` Nullable(UInt32) COMMENT 'The transaction total bytes of the execution payload when compressed using snappy' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/canonical_beacon_block_local', '{replica}', updated_date_time)
PARTITION BY (meta_network_name, toYYYYMM(slot_start_date_time))
ORDER BY (meta_network_name, slot_start_date_time)
SETTINGS index_granularity = 8192
COMMENT 'Contains beacon block from a beacon node.'
