CREATE TABLE mainnet.int_address_first_access
(
    `address` String COMMENT 'The address of the account' CODEC(ZSTD(1)),
    `block_number` UInt32 COMMENT 'The block number of the first access' CODEC(ZSTD(1)),
    `version` UInt32 DEFAULT 4294967295 - block_number COMMENT 'Version for this address, for internal use in clickhouse to keep first access' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'int_address_first_access_local', cityHash64(address))
COMMENT 'Table for accounts first access data'
