CREATE TABLE sepolia.fct_transaction_inclusion_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period, bucketed by inclusion slot time' CODEC(DoubleDelta, ZSTD(1)),
    `included_count` UInt64 COMMENT 'Number of transactions included in canonical blocks this hour' CODEC(ZSTD(1)),
    `relay_delivered_count` UInt64 COMMENT 'Included transactions whose block matched a known relay payload-delivered record' CODEC(ZSTD(1)),
    `unknown_build_count` UInt64 COMMENT 'Included transactions whose block matched no known relay payload-delivered record. Not proof the block was locally built' CODEC(ZSTD(1)),
    `type0_count` UInt64 COMMENT 'Included legacy type 0 transactions' CODEC(ZSTD(1)),
    `type1_count` UInt64 COMMENT 'Included access list type 1 transactions' CODEC(ZSTD(1)),
    `type2_count` UInt64 COMMENT 'Included dynamic fee type 2 transactions' CODEC(ZSTD(1)),
    `type3_count` UInt64 COMMENT 'Included blob type 3 transactions' CODEC(ZSTD(1)),
    `type4_count` UInt64 COMMENT 'Included set code type 4 transactions' CODEC(ZSTD(1)),
    `type_other_count` UInt64 COMMENT 'Included transactions of any other type' CODEC(ZSTD(1)),
    `blob_count` UInt64 COMMENT 'Total blob commitments across included transactions this hour' CODEC(ZSTD(1)),
    `contract_creation_count` UInt64 COMMENT 'Included transactions with no recipient address' CODEC(ZSTD(1)),
    `cancel_shape_count` UInt64 COMMENT 'Included transactions that are self-transfers of zero value, the common wallet cancellation pattern' CODEC(ZSTD(1)),
    `unique_senders` UInt64 COMMENT 'Distinct sender addresses across included transactions this hour' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_transaction_inclusion_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY hour_start_date_time
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Hourly counts of transactions included in canonical blocks, split by build path and transaction type'
