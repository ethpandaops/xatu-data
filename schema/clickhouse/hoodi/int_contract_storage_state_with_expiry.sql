CREATE TABLE hoodi.int_contract_storage_state_with_expiry
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `expiry_policy` LowCardinality(String) COMMENT 'Expiry policy identifier: 1m, 6m, 12m, 18m, 24m' CODEC(ZSTD(1)),
    `net_slots_delta` Int32 COMMENT 'Net slot adjustment this block (negative=expiry, positive=reactivation)' CODEC(DoubleDelta, ZSTD(1)),
    `net_bytes_delta` Int64 COMMENT 'Net bytes adjustment this block (negative=expiry, positive=reactivation)' CODEC(DoubleDelta, ZSTD(1)),
    `cumulative_net_slots` Int64 COMMENT 'Cumulative net slot adjustment up to this block' CODEC(DoubleDelta, ZSTD(1)),
    `cumulative_net_bytes` Int64 COMMENT 'Cumulative net bytes adjustment up to this block' CODEC(DoubleDelta, ZSTD(1)),
    `active_slots` Int64 COMMENT 'Number of active storage slots in this contract (with expiry applied)' CODEC(DoubleDelta, ZSTD(1)),
    `effective_bytes` Int64 COMMENT 'Effective bytes for this contract (with expiry applied)' CODEC(DoubleDelta, ZSTD(1)),
    `prev_active_slots` Int64 COMMENT 'Previous block active_slots for this address (for transition detection)' CODEC(DoubleDelta, ZSTD(1)),
    `prev_effective_bytes` Int64 COMMENT 'Previous block effective_bytes for this address (for delta calculation)' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'int_contract_storage_state_with_expiry_local', cityHash64(block_number, address))
COMMENT 'Contract-level expiry state base table - tracks deltas and cumulative adjustments per address per policy'
