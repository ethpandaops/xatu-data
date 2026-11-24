CREATE TABLE holesky.int_watchlist_eth_outflow
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'Execution block number of the transfer' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_index` UInt32 COMMENT 'Position of the transaction in the block' CODEC(ZSTD(1)),
    `transaction_hash` FixedString(66) COMMENT 'Execution transaction hash of the transfer' CODEC(ZSTD(1)),
    `internal_index` UInt32 COMMENT 'Position of the trace frame within the transaction' CODEC(ZSTD(1)),
    `trace_address` String COMMENT 'Trace address of the frame within the call tree' CODEC(ZSTD(1)),
    `from_address` LowCardinality(String) COMMENT 'Watched address that sent the ETH, lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `to_address` String COMMENT 'Address that received the ETH, lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `value` UInt256 COMMENT 'ETH sent in wei' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_watchlist_eth_outflow_local', cityHash64(to_address))
COMMENT 'ETH sent out of a fixed list of addresses, ordered by recipient'
