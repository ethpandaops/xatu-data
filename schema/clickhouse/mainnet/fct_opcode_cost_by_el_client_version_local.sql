CREATE TABLE mainnet.fct_opcode_cost_by_el_client_version_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification the timings come from (e.g., eip7870-block-builder)',
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation (e.g., Geth, Nethermind, Besu, Reth)',
    `meta_execution_version` LowCardinality(String) COMMENT 'Execution client version string',
    `opcode_group` LowCardinality(String) COMMENT 'Opcode, or opcode group (LOG, ARITHMETIC, CONTROL, ENVIRONMENT, MEMORY, STACK)',
    `first_seen_date_time` DateTime COMMENT 'Start of the first hour the version has data' CODEC(DoubleDelta, ZSTD(1)),
    `last_seen_date_time` DateTime COMMENT 'Start of the last hour the version has data' CODEC(DoubleDelta, ZSTD(1)),
    `block_count` UInt32 COMMENT 'Block observations in the fit' CODEC(ZSTD(1)),
    `hour_count` UInt32 COMMENT 'Hours with data in the fit' CODEC(ZSTD(1)),
    `gas_share` Float64 COMMENT 'Share of all opcode and non-opcode gas spent on this opcode group' CODEC(ZSTD(1)),
    `gas_per_op` Float64 COMMENT 'Average gas charged per execution of this opcode group' CODEC(ZSTD(1)),
    `ns_per_gas` Float64 COMMENT 'Fitted execution time per unit of gas for this opcode group, in nanoseconds' CODEC(ZSTD(1)),
    `ns_per_op` Float64 COMMENT 'Fitted execution time per execution of this opcode group, in nanoseconds' CODEC(ZSTD(1)),
    `ns_per_op_lower` Float64 COMMENT '5th percentile of ns_per_op over a 6-hour block bootstrap' CODEC(ZSTD(1)),
    `ns_per_op_upper` Float64 COMMENT '95th percentile of ns_per_op over a 6-hour block bootstrap' CODEC(ZSTD(1)),
    `price_ratio` Float64 COMMENT 'ns_per_gas divided by the client average ns per gas, where 1 means gas prices this opcode group in line with the rest of execution' CODEC(ZSTD(1)),
    `price_ratio_lower` Float64 COMMENT '5th percentile of price_ratio over a 6-hour block bootstrap' CODEC(ZSTD(1)),
    `price_ratio_upper` Float64 COMMENT '95th percentile of price_ratio over a 6-hour block bootstrap' CODEC(ZSTD(1)),
    `client_ns_per_gas` Float64 COMMENT 'Client average execution time per unit of gas, in nanoseconds' CODEC(ZSTD(1)),
    `overhead_ms` Float64 COMMENT 'Fitted fixed cost per block, in milliseconds' CODEC(ZSTD(1)),
    `per_tx_us` Float64 COMMENT 'Fitted cost per transaction, in microseconds' CODEC(ZSTD(1)),
    `r_squared` Float64 COMMENT 'Share of block duration variance the fit explains' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_opcode_cost_by_el_client_version_local', '{replica}', updated_date_time)
ORDER BY (node_class, meta_execution_implementation, meta_execution_version, opcode_group)
SETTINGS index_granularity = 8192
COMMENT 'Execution cost per opcode group for each execution client version, fitted over every hour the version ran'
