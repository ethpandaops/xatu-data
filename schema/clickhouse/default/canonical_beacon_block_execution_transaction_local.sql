CREATE TABLE default.canonical_beacon_block_execution_transaction_local
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The root hash of the beacon block' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The version of the beacon block',
    `position` UInt32 COMMENT 'The position of the transaction in the beacon block' CODEC(DoubleDelta, ZSTD(1)),
    `hash` FixedString(66) COMMENT 'The hash of the transaction' CODEC(ZSTD(1)),
    `from` FixedString(42) COMMENT 'The address of the account that sent the transaction' CODEC(ZSTD(1)),
    `to` Nullable(FixedString(42)) COMMENT 'The address of the account that is the transaction recipient' CODEC(ZSTD(1)),
    `nonce` UInt64 COMMENT 'The nonce of the sender account at the time of the transaction' CODEC(ZSTD(1)),
    `gas_price` UInt128 COMMENT 'The gas price of the transaction in wei' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'The maximum gas provided for the transaction execution' CODEC(ZSTD(1)),
    `gas_tip_cap` Nullable(UInt128) COMMENT 'The priority fee (tip) the user has set for the transaction' CODEC(ZSTD(1)),
    `gas_fee_cap` Nullable(UInt128) COMMENT 'The max fee the user has set for the transaction' CODEC(ZSTD(1)),
    `value` UInt128 COMMENT 'The value transferred with the transaction in wei' CODEC(ZSTD(1)),
    `type` UInt8 COMMENT 'The type of the transaction' CODEC(ZSTD(1)),
    `size` UInt32 COMMENT 'The size of the transaction data in bytes' CODEC(ZSTD(1)),
    `call_data_size` UInt32 COMMENT 'The size of the call data of the transaction in bytes' CODEC(ZSTD(1)),
    `blob_gas` Nullable(UInt64) COMMENT 'The maximum gas provided for the blob transaction execution' CODEC(ZSTD(1)),
    `blob_gas_fee_cap` Nullable(UInt128) COMMENT 'The max fee the user has set for the transaction' CODEC(ZSTD(1)),
    `blob_hashes` Array(String) COMMENT 'The hashes of the blob commitments for blob transactions' CODEC(ZSTD(1)),
    `blob_sidecars_size` Nullable(UInt32) COMMENT 'The total size of the sidecars for blob transactions in bytes' CODEC(ZSTD(1)),
    `blob_sidecars_empty_size` Nullable(UInt32) COMMENT 'The total empty size of the sidecars for blob transactions in bytes' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name',
    `authorization_chain_ids` Array(UInt256) COMMENT 'The chain ID of each EIP-7702 authorization in a set code transaction' CODEC(ZSTD(1)),
    `authorization_addresses` Array(FixedString(42)) COMMENT 'The address each EIP-7702 authorization delegates its authority\\'s code to' CODEC(ZSTD(1)),
    `authorization_nonces` Array(UInt64) COMMENT 'The authority nonce of each EIP-7702 authorization' CODEC(ZSTD(1)),
    `authorization_authorities` Array(String) COMMENT 'The account that signed each EIP-7702 authorization, recovered from its signature. Empty when the signature does not recover' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/canonical_beacon_block_execution_transaction_local', '{replica}', updated_date_time)
PARTITION BY (meta_network_name, toYYYYMM(slot_start_date_time))
ORDER BY (meta_network_name, slot_start_date_time, block_root, position, hash, nonce)
SETTINGS index_granularity = 8192
COMMENT 'Contains execution transaction from a beacon block.'
