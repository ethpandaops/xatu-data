CREATE TABLE default.canonical_beacon_block_deposit_local
(
    `updated_date_time` DateTime COMMENT 'When this row was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number from beacon block payload' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` FixedString(66) COMMENT 'The root hash of the beacon block' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The version of the beacon block',
    `deposit_proof` Array(String) COMMENT 'The proof of the deposit data' CODEC(ZSTD(1)),
    `deposit_data_pubkey` String COMMENT 'The BLS public key of the validator from the deposit data' CODEC(ZSTD(1)),
    `deposit_data_withdrawal_credentials` FixedString(66) COMMENT 'The withdrawal credentials of the validator from the deposit data' CODEC(ZSTD(1)),
    `deposit_data_amount` UInt128 COMMENT 'The amount of the deposit from the deposit data' CODEC(ZSTD(1)),
    `deposit_data_signature` String COMMENT 'The signature of the deposit data' CODEC(ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/default/canonical_beacon_block_deposit_local', '{replica}', updated_date_time)
PARTITION BY (meta_network_name, toYYYYMM(slot_start_date_time))
ORDER BY (meta_network_name, slot_start_date_time, block_root, deposit_data_pubkey, deposit_proof)
SETTINGS index_granularity = 8192
COMMENT 'Contains a deposit from a beacon block.'
