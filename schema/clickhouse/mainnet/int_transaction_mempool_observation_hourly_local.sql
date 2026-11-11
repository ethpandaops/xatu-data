CREATE TABLE mainnet.int_transaction_mempool_observation_hourly_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The start of the hour bucket the sightings fall in' CODEC(DoubleDelta, ZSTD(1)),
    `hash` FixedString(66) COMMENT 'The transaction hash' CODEC(ZSTD(1)),
    `first_seen_date_time` DateTime64(3) COMMENT 'Earliest sighting of the transaction by any sentry within this hour' CODEC(DoubleDelta, ZSTD(1)),
    `last_seen_date_time` DateTime64(3) COMMENT 'Latest sighting of the transaction by any sentry within this hour' CODEC(DoubleDelta, ZSTD(1)),
    `sighting_count` UInt32 COMMENT 'Number of sightings of the transaction within this hour across all sentries' CODEC(ZSTD(1)),
    `unique_sentries` UInt32 COMMENT 'Number of distinct sentries that sighted the transaction within this hour' CODEC(ZSTD(1)),
    `from` FixedString(42) COMMENT 'The address of the account that sent the transaction' CODEC(ZSTD(1)),
    `to` Nullable(FixedString(42)) COMMENT 'The address of the transaction recipient, null for contract creation' CODEC(ZSTD(1)),
    `nonce` UInt64 COMMENT 'The nonce of the sender account at the time of the transaction' CODEC(ZSTD(1)),
    `type` Nullable(UInt8) COMMENT 'The type of the transaction' CODEC(ZSTD(1)),
    `gas` UInt64 COMMENT 'The maximum gas provided for the transaction execution' CODEC(ZSTD(1)),
    `gas_price` UInt128 COMMENT 'The gas price of the transaction in wei' CODEC(ZSTD(1)),
    `gas_tip_cap` Nullable(UInt128) COMMENT 'The priority fee (tip) the user has set for the transaction in wei' CODEC(ZSTD(1)),
    `gas_fee_cap` Nullable(UInt128) COMMENT 'The max fee the user has set for the transaction in wei' CODEC(ZSTD(1)),
    `value` UInt128 COMMENT 'The value transferred with the transaction in wei' CODEC(ZSTD(1)),
    `size` UInt32 COMMENT 'The size of the transaction data in bytes' CODEC(ZSTD(1)),
    `call_data_size` UInt32 COMMENT 'The size of the call data of the transaction in bytes' CODEC(ZSTD(1)),
    `blob_gas` Nullable(UInt64) COMMENT 'The maximum gas provided for the blob transaction execution' CODEC(ZSTD(1)),
    `blob_gas_fee_cap` Nullable(UInt128) COMMENT 'The max blob fee the user has set for the transaction in wei' CODEC(ZSTD(1)),
    `blob_hashes` Array(String) COMMENT 'The hashes of the blob commitments for blob transactions' CODEC(ZSTD(1)),
    `is_cancel_shape` Bool COMMENT 'Whether the transaction is a self-transfer of zero value, the common wallet cancellation pattern' CODEC(ZSTD(1)),
    `first_sentry_name` LowCardinality(String) COMMENT 'Name of the sentry with the earliest sighting this hour, ties broken by sentry name' CODEC(ZSTD(1)),
    `first_sentry_geo_city` LowCardinality(String) COMMENT 'City of the first-sighting sentry' CODEC(ZSTD(1)),
    `first_sentry_geo_country` LowCardinality(String) COMMENT 'Country of the first-sighting sentry' CODEC(ZSTD(1)),
    `first_sentry_geo_country_code` LowCardinality(String) COMMENT 'Country code of the first-sighting sentry' CODEC(ZSTD(1)),
    `first_sentry_geo_continent_code` LowCardinality(String) COMMENT 'Continent code of the first-sighting sentry' CODEC(ZSTD(1)),
    PROJECTION p_by_hash
    (
        SELECT *
        ORDER BY
            hash,
            hour_start_date_time
    ),
    PROJECTION p_by_nonce_group
    (
        SELECT *
        ORDER BY
            from,
            nonce,
            hour_start_date_time
    )
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/int_transaction_mempool_observation_hourly_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(hour_start_date_time)
ORDER BY (hour_start_date_time, hash)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'One row per transaction hash per hour in which it was sighted in the public mempool by at least one sentry. Rows summarise the sightings within that hour only. A transaction sighted across multiple hours has multiple rows'
