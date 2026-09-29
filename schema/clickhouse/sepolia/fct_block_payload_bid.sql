CREATE TABLE sepolia.fct_block_payload_bid
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number of the block containing the bid' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `block_root` String COMMENT 'The root of the beacon block containing the bid' CODEC(ZSTD(1)),
    `block_version` LowCardinality(String) COMMENT 'The beacon block version, e.g. gloas' CODEC(ZSTD(1)),
    `builder_index` UInt64 COMMENT 'Validator index of the builder, equal to the block proposer index for self-built payloads' CODEC(DoubleDelta, ZSTD(1)),
    `block_hash` FixedString(66) COMMENT 'The execution block hash committed to in the bid' CODEC(ZSTD(1)),
    `parent_block_hash` FixedString(66) COMMENT 'The parent execution block hash' CODEC(ZSTD(1)),
    `parent_block_root` FixedString(66) COMMENT 'The parent beacon block root' CODEC(ZSTD(1)),
    `value` UInt128 COMMENT 'The bid value in wei' CODEC(ZSTD(1)),
    `execution_payment` UInt128 COMMENT 'The execution payment in wei' CODEC(ZSTD(1)),
    `fee_recipient` FixedString(42) COMMENT 'The fee recipient address' CODEC(ZSTD(1)),
    `gas_limit` UInt64 COMMENT 'The gas limit for the execution payload' CODEC(DoubleDelta, ZSTD(1)),
    `blob_kzg_commitment_count` UInt32 COMMENT 'Number of blob KZG commitments in the bid' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_block_payload_bid_local', cityHash64(slot_start_date_time, block_root))
COMMENT 'The winning gloas (ePBS) execution payload bid committed in each canonical beacon block, one per block'
