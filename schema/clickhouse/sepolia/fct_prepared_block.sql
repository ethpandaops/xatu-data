CREATE TABLE sepolia.fct_prepared_block
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'The slot number from beacon block',
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started',
    `event_date_time` DateTime COMMENT 'The wall clock time when the event was received',
    `meta_client_name` String COMMENT 'Name of the client that generated the event',
    `meta_client_version` String COMMENT 'Version of the client that generated the event',
    `meta_client_implementation` String COMMENT 'Implementation of the client that generated the event',
    `meta_consensus_implementation` String COMMENT 'Consensus implementation of the validator',
    `meta_consensus_version` String COMMENT 'Consensus version of the validator',
    `meta_client_geo_city` String COMMENT 'City of the client that generated the event',
    `meta_client_geo_country` String COMMENT 'Country of the client that generated the event',
    `meta_client_geo_country_code` String COMMENT 'Country code of the client that generated the event',
    `block_version` LowCardinality(String) COMMENT 'The version of the beacon block',
    `block_total_bytes` Nullable(UInt32) COMMENT 'The total bytes of the beacon block payload',
    `block_total_bytes_compressed` Nullable(UInt32) COMMENT 'The total bytes of the beacon block payload when compressed using snappy',
    `execution_payload_value` Nullable(UInt64) COMMENT 'The value of the execution payload in wei',
    `consensus_payload_value` Nullable(UInt64) COMMENT 'The value of the consensus payload in wei',
    `execution_payload_block_number` UInt32 COMMENT 'The block number of the execution payload',
    `execution_payload_gas_limit` Nullable(UInt64) COMMENT 'Gas limit for execution payload',
    `execution_payload_gas_used` Nullable(UInt64) COMMENT 'Gas used for execution payload',
    `execution_payload_transactions_count` Nullable(UInt32) COMMENT 'The transaction count of the execution payload',
    `execution_payload_transactions_total_bytes` Nullable(UInt32) COMMENT 'The transaction total bytes of the execution payload'
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_prepared_block_local', cityHash64(slot_start_date_time, slot, meta_client_name))
COMMENT 'Prepared block proposals showing what would have been built if the validator had been selected as proposer'
