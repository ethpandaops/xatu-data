CREATE TABLE hoodi.int_address_storage_slot_first_access
(
    `address` String COMMENT 'The address of the account' CODEC(ZSTD(1)),
    `slot_key` String COMMENT 'The slot key of the storage' CODEC(ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number of the first access' CODEC(ZSTD(1)),
    `value` String COMMENT 'The value of the storage' CODEC(ZSTD(1)),
    `version` UInt32 DEFAULT 4294967295 - block_number COMMENT 'Version for this address + slot key, for internal use in clickhouse to keep first access' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'int_address_storage_slot_first_access_local', cityHash64(address, slot_key))
COMMENT 'Table for storage first access data'
