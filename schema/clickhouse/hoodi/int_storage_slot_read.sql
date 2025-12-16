CREATE TABLE hoodi.int_storage_slot_read
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'The contract address' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The storage slot key' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'int_storage_slot_read_local', cityHash64(block_number, address))
COMMENT 'Storage slot reads aggregated per block - tracks which slots were read per address'
