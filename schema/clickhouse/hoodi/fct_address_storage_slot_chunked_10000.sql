CREATE TABLE hoodi.fct_address_storage_slot_chunked_10000
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `chunk_start_block_number` UInt32 COMMENT 'Start block number of the chunk' CODEC(ZSTD(1)),
    `first_accessed_slots` UInt32 COMMENT 'Number of slots first accessed in the chunk' CODEC(ZSTD(1)),
    `last_accessed_slots` UInt32 COMMENT 'Number of slots last accessed in the chunk' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_address_storage_slot_chunked_10000_local', rand())
COMMENT 'Storage slot totals chunked by 10000 blocks'
