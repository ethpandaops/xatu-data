CREATE TABLE hoodi.int_execution_block_by_date
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_date_time` DateTime64(3) COMMENT 'The block timestamp' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt64 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'int_execution_block_by_date_local', cityHash64(block_number))
COMMENT 'Block number and block time of every canonical execution block of this network, for date range lookups. A range is only written once canonical_execution_block holds every block in it'
