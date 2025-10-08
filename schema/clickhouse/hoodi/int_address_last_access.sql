CREATE TABLE hoodi.int_address_last_access
(
    `address` String COMMENT 'The address of the account' CODEC(ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number of the last access' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'int_address_last_access_local', cityHash64(address))
COMMENT 'Table for accounts last access data'
