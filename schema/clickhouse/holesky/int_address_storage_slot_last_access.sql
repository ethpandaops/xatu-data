CREATE TABLE holesky.int_address_storage_slot_last_access
(
    `address` String COMMENT 'The address of the account' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The slot key of the storage' CODEC(ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number of the last access' CODEC(ZSTD(1)),
    `value` String COMMENT 'The value of the storage' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_address_storage_slot_last_access_local', cityHash64(address, slot_key))
COMMENT 'Table for storage last access data'
