CREATE TABLE hoodi.fct_opcode_gas_by_opcode_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour period' CODEC(DoubleDelta, ZSTD(1)),
    `opcode` LowCardinality(String) COMMENT 'The EVM opcode name (e.g., SLOAD, ADD, CALL)',
    `block_count` UInt32 COMMENT 'Number of blocks containing this opcode in this hour' CODEC(ZSTD(1)),
    `total_count` UInt64 COMMENT 'Total execution count of this opcode in this hour' CODEC(ZSTD(1)),
    `total_gas` UInt64 COMMENT 'Total gas consumed by this opcode in this hour' CODEC(ZSTD(1)),
    `total_error_count` UInt64 COMMENT 'Total error count for this opcode in this hour' CODEC(ZSTD(1)),
    `avg_count_per_block` Float32 COMMENT 'Average executions per block' CODEC(ZSTD(1)),
    `avg_gas_per_block` Float32 COMMENT 'Average gas per block' CODEC(ZSTD(1)),
    `avg_gas_per_execution` Float32 COMMENT 'Average gas per execution' CODEC(ZSTD(1)),
    PROJECTION p_by_opcode
    (
        SELECT *
        ORDER BY
            opcode,
            hour_start_date_time
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_opcode_gas_by_opcode_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY (hour_start_date_time, opcode)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Hourly per-opcode gas consumption for Top Opcodes by Gas charts'
