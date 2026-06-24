CREATE TABLE sepolia.int_rocketpool_minipool
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `event_name` LowCardinality(String) COMMENT 'Minipool lifecycle event name (created or destroyed)',
    `minipool_address` String COMMENT 'The Rocket Pool minipool contract address, lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `node_operator` String COMMENT 'The Rocket Pool node operator address that owns the minipool, lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `event_block_number` UInt64 COMMENT 'Execution block number the event was emitted in' CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime COMMENT 'Wall clock time the event occurred, decoded from the event payload' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'Execution transaction hash that emitted the event' CODEC(ZSTD(1)),
    `log_index` UInt32 COMMENT 'Log index of the event within the block' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'int_rocketpool_minipool_local', cityHash64(event_name, minipool_address))
COMMENT 'Rocket Pool minipool lifecycle events (created/destroyed) decoded from execution layer logs'
