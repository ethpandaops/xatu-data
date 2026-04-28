CREATE TABLE mainnet.fct_attestation_first_seen_by_validator_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot the validator was attesting for' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'The epoch containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `validator_index` UInt32 COMMENT 'The validator index' CODEC(ZSTD(1)),
    `committee_index` LowCardinality(String) COMMENT 'The committee the validator was assigned to for this slot',
    `block_root` String COMMENT 'Head vote (beacon block root) for this attestation' CODEC(ZSTD(1)),
    `source_epoch` UInt32 COMMENT 'Source checkpoint epoch for this attestation' CODEC(DoubleDelta, ZSTD(1)),
    `source_root` String COMMENT 'Source checkpoint root for this attestation' CODEC(ZSTD(1)),
    `target_epoch` UInt32 COMMENT 'Target checkpoint epoch for this attestation' CODEC(DoubleDelta, ZSTD(1)),
    `target_root` String COMMENT 'Target checkpoint root for this attestation' CODEC(ZSTD(1)),
    `raw_seen_slot_start_diff` Nullable(UInt32) COMMENT 'Earliest time (ms after slot start) this (validator, vote) was seen as an unaggregated attestation. NULL if never seen raw.' CODEC(ZSTD(1)),
    `raw_source` LowCardinality(String) COMMENT 'Source the raw attestation was first observed from (beacon_api_eth_v1_events_attestation, libp2p_gossipsub_beacon_attestation, or empty)' CODEC(ZSTD(1)),
    `agg_seen_slot_start_diff` Nullable(UInt32) COMMENT 'Earliest time (ms after slot start) this (validator, vote) was seen inside an aggregate. NULL if never seen in an aggregate.' CODEC(ZSTD(1)),
    `agg_source` LowCardinality(String) COMMENT 'Source the earliest aggregate was observed from (beacon_api_eth_v1_events_attestation, libp2p_gossipsub_aggregate_and_proof, or empty)' CODEC(ZSTD(1)),
    PROJECTION p_by_slot
    (
        SELECT *
        ORDER BY
            slot,
            validator_index
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_attestation_first_seen_by_validator_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(slot_start_date_time)
ORDER BY (slot_start_date_time, validator_index, block_root, source_epoch, source_root, target_epoch, target_root)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'One row per (slot, validator, vote) carrying raw and aggregate first-seen times. ORDER BY includes vote fields so slashable double votes stay as separate rows instead of being collapsed by the ReplacingMergeTree.'
