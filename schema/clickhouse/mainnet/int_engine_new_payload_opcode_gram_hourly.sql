CREATE TABLE mainnet.int_engine_new_payload_opcode_gram_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the hour, by block timestamp' CODEC(DoubleDelta, ZSTD(1)),
    `node_class` LowCardinality(String) COMMENT 'Node classification the timings come from (e.g., eip7870-block-builder)',
    `meta_execution_implementation` LowCardinality(String) COMMENT 'Execution client implementation (e.g., Geth, Nethermind, Besu, Reth)',
    `meta_execution_version` LowCardinality(String) COMMENT 'Execution client version string',
    `block_count` UInt32 COMMENT 'Blocks in the regression after trimming outliers' CODEC(ZSTD(1)),
    `trimmed_block_count` UInt32 COMMENT 'Blocks dropped as outliers (above the hourly P99 duration, or above 3x the hourly median ms per Mgas)' CODEC(ZSTD(1)),
    `min_block_number` UInt64 COMMENT 'Lowest execution block number in the hour' CODEC(DoubleDelta, ZSTD(1)),
    `max_block_number` UInt64 COMMENT 'Highest execution block number in the hour' CODEC(DoubleDelta, ZSTD(1)),
    `feature_names` Array(LowCardinality(String)) COMMENT 'Regression features, in order: INTERCEPT (1 per block), TX_COUNT (transactions / 100), NON_OPCODE_GAS (gas used minus opcode gas, in Mgas), then gas per opcode group in Mgas',
    `xtx` Array(Float64) COMMENT 'Upper triangle (row-major, including the diagonal) of X^T X, where X is blocks by feature_names' CODEC(ZSTD(1)),
    `xty` Array(Float64) COMMENT 'X^T y, where y is the median engine_newPayload duration in milliseconds across the node class' CODEC(ZSTD(1)),
    `yty` Float64 COMMENT 'y^T y, the sum of squared durations in ms^2' CODEC(ZSTD(1)),
    `opcode_count` Array(UInt64) COMMENT 'Executions per opcode group, aligned with feature_names after the first three features' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'int_engine_new_payload_opcode_gram_hourly_local', cityHash64(hour_start_date_time, node_class, meta_execution_implementation, meta_execution_version))
COMMENT 'Hourly least-squares sufficient statistics for regressing engine_newPayload duration on gas per opcode group, by execution client version'
