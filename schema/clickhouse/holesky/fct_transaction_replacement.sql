CREATE TABLE holesky.fct_transaction_replacement
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `group_first_seen_date_time` DateTime64(3) COMMENT 'Earliest sighting of any attempt in the nonce group, the anchor of the group window' CODEC(DoubleDelta, ZSTD(1)),
    `from` FixedString(42) COMMENT 'The address of the account that sent the attempts' CODEC(ZSTD(1)),
    `nonce` UInt64 COMMENT 'The nonce the attempts compete for' CODEC(ZSTD(1)),
    `hash` FixedString(66) COMMENT 'The transaction hash of this attempt' CODEC(ZSTD(1)),
    `attempt_index` UInt16 COMMENT 'The 1-based rank of this attempt within the group, ordered by first sighting with ties broken by hash' CODEC(ZSTD(1)),
    `group_attempt_count` UInt16 COMMENT 'Total number of publicly observed attempts in the group window' CODEC(ZSTD(1)),
    `first_seen_date_time` DateTime64(3) COMMENT 'Earliest sighting of this attempt' CODEC(DoubleDelta, ZSTD(1)),
    `previous_hash` Nullable(FixedString(66)) COMMENT 'The hash of the attempt immediately before this one in the group, null for the first attempt' CODEC(ZSTD(1)),
    `to` Nullable(FixedString(42)) COMMENT 'The address of the attempt recipient, null for contract creation' CODEC(ZSTD(1)),
    `type` Nullable(UInt8) COMMENT 'The type of the transaction' CODEC(ZSTD(1)),
    `gas_price` UInt128 COMMENT 'The gas price of the attempt in wei' CODEC(ZSTD(1)),
    `gas_tip_cap` Nullable(UInt128) COMMENT 'The priority fee (tip) of the attempt in wei' CODEC(ZSTD(1)),
    `gas_fee_cap` Nullable(UInt128) COMMENT 'The max fee of the attempt in wei' CODEC(ZSTD(1)),
    `value` UInt128 COMMENT 'The value transferred with the attempt in wei' CODEC(ZSTD(1)),
    `gas_tip_cap_delta` Nullable(Int128) COMMENT 'This attempt gas_tip_cap minus the previous attempt gas_tip_cap, null for the first attempt or when either side is null' CODEC(ZSTD(1)),
    `gas_fee_cap_delta` Nullable(Int128) COMMENT 'This attempt gas_fee_cap minus the previous attempt gas_fee_cap, null for the first attempt or when either side is null' CODEC(ZSTD(1)),
    `is_cancel_shape` Bool COMMENT 'Whether the attempt is a self-transfer of zero value, the common wallet cancellation pattern' CODEC(ZSTD(1)),
    `is_winner` Bool COMMENT 'Whether this attempt is the one that was included on chain' CODEC(ZSTD(1)),
    `group_outcome` LowCardinality(String) COMMENT 'Outcome of the nonce group within 7 days of the group anchor: included or unincluded' CODEC(ZSTD(1)),
    `winner_hash` Nullable(FixedString(66)) COMMENT 'The hash of the included attempt, null when the group resolved unincluded' CODEC(ZSTD(1)),
    `resolution_date_time` DateTime64(3) COMMENT 'When the group resolved: the winner inclusion slot start, or the group anchor plus 7 days when unincluded' CODEC(DoubleDelta, ZSTD(1)),
    `observed_after_resolution` Bool COMMENT 'Whether this attempt was first sighted after the group had already resolved' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_transaction_replacement_local', cityHash64(from, nonce))
COMMENT 'One row per publicly observed attempt in nonce groups with at least two attempts, emitted when the group resolves. A nonce group is all transactions sharing a from address and nonce whose first sightings fall within 7 days of the group anchor'
