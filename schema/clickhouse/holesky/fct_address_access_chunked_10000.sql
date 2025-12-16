CREATE TABLE holesky.fct_address_access_chunked_10000
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `chunk_start_block_number` UInt32 COMMENT 'Start block number of the chunk' CODEC(ZSTD(1)),
    `first_accessed_accounts` UInt32 COMMENT 'Number of accounts first accessed in the chunk' CODEC(ZSTD(1)),
    `last_accessed_accounts` UInt32 COMMENT 'Number of accounts last accessed in the chunk' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_address_access_chunked_10000_local', rand())
COMMENT 'Address access totals chunked by 10000 blocks'
