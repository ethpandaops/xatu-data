CREATE TABLE holesky.fct_opcode_gas_by_opcode_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `opcode` LowCardinality(String) COMMENT 'The EVM opcode name (e.g., SLOAD, ADD, CALL)',
    `block_count` UInt32 COMMENT 'Number of blocks containing this opcode in this day' CODEC(ZSTD(1)),
    `total_count` UInt64 COMMENT 'Total execution count of this opcode in this day' CODEC(ZSTD(1)),
    `total_gas` UInt64 COMMENT 'Total gas consumed by this opcode in this day' CODEC(ZSTD(1)),
    `total_error_count` UInt64 COMMENT 'Total error count for this opcode in this day' CODEC(ZSTD(1)),
    `avg_count_per_block` Float32 COMMENT 'Average executions per block' CODEC(ZSTD(1)),
    `avg_gas_per_block` Float32 COMMENT 'Average gas per block' CODEC(ZSTD(1)),
    `avg_gas_per_execution` Float32 COMMENT 'Average gas per execution' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_opcode_gas_by_opcode_daily_local', cityHash64(day_start_date))
COMMENT 'Daily per-opcode gas consumption for Top Opcodes by Gas charts'
