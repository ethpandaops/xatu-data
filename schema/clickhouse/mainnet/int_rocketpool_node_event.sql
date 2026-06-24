CREATE TABLE mainnet.int_rocketpool_node_event
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `event_name` LowCardinality(String) COMMENT 'Node event name: node_registered, rpl_staked, rpl_withdrawn or smoothing_pool_state_changed',
    `node_address` String COMMENT 'The Rocket Pool node operator address, lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `rpl_amount_wei` UInt256 COMMENT 'RPL amount in wei for rpl_staked/rpl_withdrawn events, otherwise 0' CODEC(ZSTD(1)),
    `smoothing_state` Bool COMMENT 'Smoothing pool membership state for smoothing_pool_state_changed events, otherwise false',
    `event_block_number` UInt64 COMMENT 'Execution block number the event was emitted in' CODEC(DoubleDelta, ZSTD(1)),
    `event_date_time` DateTime COMMENT 'Wall clock time of the block the event was emitted in' CODEC(DoubleDelta, ZSTD(1)),
    `log_index` UInt32 COMMENT 'Log index of the event within the block' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'int_rocketpool_node_event_local', cityHash64(event_name, node_address))
COMMENT 'Rocket Pool node lifecycle events (registration, RPL stake/withdraw, smoothing pool) decoded from execution layer logs'
