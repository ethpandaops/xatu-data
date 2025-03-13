CREATE TABLE default.canonical_execution_traces_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'The transaction index' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `internal_index` UInt32 COMMENT 'The internal index of the trace within the transaction' CODEC(DoubleDelta, ZSTD(1)),
    `action_from` String COMMENT 'The from address of the action' CODEC(ZSTD(1)),
    `action_to` Nullable(String) COMMENT 'The to address of the action' CODEC(ZSTD(1)),
    `action_value` String COMMENT 'The value of the action' CODEC(ZSTD(1)),
    `action_gas` UInt32 COMMENT 'The gas provided for the action' CODEC(DoubleDelta, ZSTD(1)),
    `action_input` Nullable(String) COMMENT 'The input data for the action' CODEC(ZSTD(1)),
    `action_call_type` LowCardinality(String) COMMENT 'The call type of the action' CODEC(ZSTD(1)),
    `action_init` Nullable(String) COMMENT 'The initialization code for the action' CODEC(ZSTD(1)),
    `action_reward_type` String COMMENT 'The reward type for the action' CODEC(ZSTD(1)),
    `action_type` LowCardinality(String) COMMENT 'The type of the action' CODEC(ZSTD(1)),
    `result_gas_used` UInt32 COMMENT 'The gas used in the result' CODEC(DoubleDelta, ZSTD(1)),
    `result_output` Nullable(String) COMMENT 'The output of the result' CODEC(ZSTD(1)),
    `result_code` Nullable(String) COMMENT 'The code returned in the result' CODEC(ZSTD(1)),
    `result_address` Nullable(String) COMMENT 'The address returned in the result' CODEC(ZSTD(1)),
    `trace_address` Nullable(String) COMMENT 'The trace address' CODEC(ZSTD(1)),
    `subtraces` UInt32 COMMENT 'The number of subtraces' CODEC(DoubleDelta, ZSTD(1)),
    `error` Nullable(String) COMMENT 'The error, if any, in the trace' CODEC(ZSTD(1)),
    `meta_network_id` Int32 COMMENT 'Ethereum network ID' CODEC(DoubleDelta, ZSTD(1)),
    `meta_network_name` LowCardinality(String) COMMENT 'Ethereum network name'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/default/tables/canonical_execution_traces_local/{shard}', '{replica}', updated_date_time)
PARTITION BY intDiv(block_number, 5000000)
ORDER BY (block_number, meta_network_name, transaction_hash, internal_index)
SETTINGS index_granularity = 8192
COMMENT 'Contains canonical execution traces data.'
