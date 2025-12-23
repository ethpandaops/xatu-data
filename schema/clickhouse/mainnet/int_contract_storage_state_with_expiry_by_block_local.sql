CREATE TABLE mainnet.int_contract_storage_state_with_expiry_by_block_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `expiry_policy` LowCardinality(String) COMMENT 'Expiry policy identifier: 1m, 6m, 12m, 18m, 24m' CODEC(ZSTD(1)),
    `active_slots` Int64 COMMENT 'Total active storage slots network-wide (with expiry applied)' CODEC(DoubleDelta, ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Total effective bytes network-wide (with expiry applied)' CODEC(DoubleDelta, ZSTD(1)),
    `active_contracts` Int64 COMMENT 'Count of contracts with active_slots > 0 (with expiry applied)' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_contract_storage_state_with_expiry_by_block_local', '{replica}', updated_date_time)
PARTITION BY expiry_policy
ORDER BY (expiry_policy, block_number)
SETTINGS index_granularity = 8192
COMMENT 'Contract-level expiry state per block network-wide - totals for slots, bytes, and active contracts'
