CREATE TABLE sepolia.fct_execution_state_size_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'Start of the UTC hour. The first row is the hour of block 1, never 1970-01-01 (the mainnet genesis block has timestamp 0)' CODEC(DoubleDelta, ZSTD(1)),
    `accounts` UInt64 COMMENT 'Total accounts at end of hour' CODEC(ZSTD(1)),
    `account_bytes` UInt64 COMMENT 'Account bytes at end of hour' CODEC(ZSTD(1)),
    `account_trienodes` UInt64 COMMENT 'Account trie nodes at end of hour' CODEC(ZSTD(1)),
    `account_trienode_bytes` UInt64 COMMENT 'Account trie node bytes at end of hour' CODEC(ZSTD(1)),
    `contract_codes` UInt64 COMMENT 'Contract codes at end of hour' CODEC(ZSTD(1)),
    `contract_code_bytes` UInt64 COMMENT 'Contract code bytes at end of hour' CODEC(ZSTD(1)),
    `storages` UInt64 COMMENT 'Storage slots at end of hour' CODEC(ZSTD(1)),
    `storage_bytes` UInt64 COMMENT 'Storage bytes at end of hour' CODEC(ZSTD(1)),
    `storage_trienodes` UInt64 COMMENT 'Storage trie nodes at end of hour' CODEC(ZSTD(1)),
    `storage_trienode_bytes` UInt64 COMMENT 'Storage trie node bytes at end of hour' CODEC(ZSTD(1)),
    `total_bytes` UInt64 COMMENT 'Total state size in bytes' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_execution_state_size_hourly_local', cityHash64(hour_start_date_time))
COMMENT 'Execution layer state size at the last canonical block of each UTC hour. Starts at the hour of block 1, the genesis block is not given a row of its own'
