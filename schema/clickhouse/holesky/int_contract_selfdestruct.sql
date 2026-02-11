CREATE TABLE holesky.int_contract_selfdestruct
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `block_number` UInt32 COMMENT 'Block where SELFDESTRUCT occurred' CODEC(DoubleDelta, ZSTD(1)),
    `transaction_hash` String COMMENT 'Transaction hash' CODEC(ZSTD(1)),
    `transaction_index` UInt16 COMMENT 'Position in block' CODEC(DoubleDelta, ZSTD(1)),
    `internal_index` UInt32 COMMENT 'Position within transaction traces' CODEC(DoubleDelta, ZSTD(1)),
    `address` String COMMENT 'Contract that was destroyed' CODEC(ZSTD(1)),
    `beneficiary` String COMMENT 'Address receiving the ETH' CODEC(ZSTD(1)),
    `value_transferred` UInt256 COMMENT 'Amount of ETH sent to beneficiary' CODEC(ZSTD(1)),
    `ephemeral` Bool COMMENT 'True if contract was created and destroyed in the same transaction - storage always cleared per EIP-6780' CODEC(ZSTD(1)),
    `storage_cleared` Bool COMMENT 'True if storage was cleared (pre-Shanghai OR ephemeral)' CODEC(ZSTD(1)),
    `creation_block` Nullable(UInt32) COMMENT 'Block where contract was created (if known)' CODEC(ZSTD(1)),
    `creation_transaction_hash` Nullable(String) COMMENT 'Transaction that created the contract (if known)' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'int_contract_selfdestruct_local', cityHash64(block_number, address))
COMMENT 'SELFDESTRUCT operations with EIP-6780 storage clearing implications'
