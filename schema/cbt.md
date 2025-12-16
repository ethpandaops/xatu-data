
Pre-aggregated analytical tables for common blockchain queries. These tables are transformation tables similar to DBT, powered by [xatu-cbt](https://github.com/ethpandaops/xatu-cbt) using [ClickHouse Build Tools (CBT)](https://github.com/ethpandaops/cbt).


CBT tables are organized by network-specific databases. To query these tables, you must target the correct database for your network:
- `mainnet.table_name` for Mainnet data
- `sepolia.table_name` for Sepolia data
- `holesky.table_name` for Holesky data
- `hoodi.table_name` for Hoodi data

Unlike other Xatu datasets, CBT tables do not use `meta_network_name` for filtering. The network is determined by the database you query.

CBT tables include dimension tables (prefixed with `dim_`), fact tables (prefixed with `fct_`), and intermediate tables (prefixed with `int_`).

## Availability
- EthPandaOps Clickhouse

## Tables

<!-- schema_toc_start -->
- [`dim_block_blob_submitter`](#dim_block_blob_submitter)
- [`dim_node`](#dim_node)
- [`fct_address_access_chunked_10000`](#fct_address_access_chunked_10000)
- [`fct_address_access_total`](#fct_address_access_total)
- [`fct_address_storage_slot_chunked_10000`](#fct_address_storage_slot_chunked_10000)
- [`fct_address_storage_slot_expired_top_100_by_contract`](#fct_address_storage_slot_expired_top_100_by_contract)
- [`fct_address_storage_slot_top_100_by_contract`](#fct_address_storage_slot_top_100_by_contract)
- [`fct_address_storage_slot_total`](#fct_address_storage_slot_total)
- [`fct_attestation_correctness_by_validator_canonical`](#fct_attestation_correctness_by_validator_canonical)
- [`fct_attestation_correctness_by_validator_head`](#fct_attestation_correctness_by_validator_head)
- [`fct_attestation_correctness_canonical`](#fct_attestation_correctness_canonical)
- [`fct_attestation_correctness_head`](#fct_attestation_correctness_head)
- [`fct_attestation_first_seen_chunked_50ms`](#fct_attestation_first_seen_chunked_50ms)
- [`fct_attestation_liveness_by_entity_head`](#fct_attestation_liveness_by_entity_head)
- [`fct_attestation_observation_by_node`](#fct_attestation_observation_by_node)
- [`fct_block`](#fct_block)
- [`fct_block_blob_count`](#fct_block_blob_count)
- [`fct_block_blob_count_head`](#fct_block_blob_count_head)
- [`fct_block_blob_first_seen_by_node`](#fct_block_blob_first_seen_by_node)
- [`fct_block_data_column_sidecar_first_seen`](#fct_block_data_column_sidecar_first_seen)
- [`fct_block_data_column_sidecar_first_seen_by_node`](#fct_block_data_column_sidecar_first_seen_by_node)
- [`fct_block_first_seen_by_node`](#fct_block_first_seen_by_node)
- [`fct_block_head`](#fct_block_head)
- [`fct_block_mev`](#fct_block_mev)
- [`fct_block_mev_head`](#fct_block_mev_head)
- [`fct_block_proposer`](#fct_block_proposer)
- [`fct_block_proposer_entity`](#fct_block_proposer_entity)
- [`fct_block_proposer_head`](#fct_block_proposer_head)
- [`fct_data_column_availability_by_epoch`](#fct_data_column_availability_by_epoch)
- [`fct_data_column_availability_by_slot`](#fct_data_column_availability_by_slot)
- [`fct_data_column_availability_by_slot_blob`](#fct_data_column_availability_by_slot_blob)
- [`fct_data_column_availability_daily`](#fct_data_column_availability_daily)
- [`fct_data_column_availability_hourly`](#fct_data_column_availability_hourly)
- [`fct_engine_get_blobs_by_el_client`](#fct_engine_get_blobs_by_el_client)
- [`fct_engine_get_blobs_by_slot`](#fct_engine_get_blobs_by_slot)
- [`fct_engine_get_blobs_duration_chunked_50ms`](#fct_engine_get_blobs_duration_chunked_50ms)
- [`fct_engine_get_blobs_status_daily`](#fct_engine_get_blobs_status_daily)
- [`fct_engine_get_blobs_status_hourly`](#fct_engine_get_blobs_status_hourly)
- [`fct_engine_new_payload_by_el_client`](#fct_engine_new_payload_by_el_client)
- [`fct_engine_new_payload_by_slot`](#fct_engine_new_payload_by_slot)
- [`fct_engine_new_payload_duration_chunked_50ms`](#fct_engine_new_payload_duration_chunked_50ms)
- [`fct_engine_new_payload_status_daily`](#fct_engine_new_payload_status_daily)
- [`fct_engine_new_payload_status_hourly`](#fct_engine_new_payload_status_hourly)
- [`fct_execution_state_size_daily`](#fct_execution_state_size_daily)
- [`fct_execution_state_size_hourly`](#fct_execution_state_size_hourly)
- [`fct_head_first_seen_by_node`](#fct_head_first_seen_by_node)
- [`fct_mev_bid_count_by_builder`](#fct_mev_bid_count_by_builder)
- [`fct_mev_bid_count_by_relay`](#fct_mev_bid_count_by_relay)
- [`fct_mev_bid_highest_value_by_builder_chunked_50ms`](#fct_mev_bid_highest_value_by_builder_chunked_50ms)
- [`fct_node_active_last_24h`](#fct_node_active_last_24h)
- [`fct_prepared_block`](#fct_prepared_block)
- [`fct_storage_slot_state`](#fct_storage_slot_state)
- [`fct_storage_slot_state_daily`](#fct_storage_slot_state_daily)
- [`fct_storage_slot_state_hourly`](#fct_storage_slot_state_hourly)
- [`fct_storage_slot_state_with_expiry_by_6m`](#fct_storage_slot_state_with_expiry_by_6m)
- [`fct_storage_slot_state_with_expiry_by_6m_daily`](#fct_storage_slot_state_with_expiry_by_6m_daily)
- [`fct_storage_slot_state_with_expiry_by_6m_hourly`](#fct_storage_slot_state_with_expiry_by_6m_hourly)
- [`helper_storage_slot_next_touch_latest_state`](#helper_storage_slot_next_touch_latest_state)
- [`int_address_first_access`](#int_address_first_access)
- [`int_address_last_access`](#int_address_last_access)
- [`int_address_storage_slot_first_access`](#int_address_storage_slot_first_access)
- [`int_address_storage_slot_last_access`](#int_address_storage_slot_last_access)
- [`int_attestation_attested_canonical`](#int_attestation_attested_canonical)
- [`int_attestation_attested_head`](#int_attestation_attested_head)
- [`int_attestation_first_seen`](#int_attestation_first_seen)
- [`int_beacon_committee_head`](#int_beacon_committee_head)
- [`int_block_blob_count_canonical`](#int_block_blob_count_canonical)
- [`int_block_canonical`](#int_block_canonical)
- [`int_block_mev_canonical`](#int_block_mev_canonical)
- [`int_block_proposer_canonical`](#int_block_proposer_canonical)
- [`int_custody_probe`](#int_custody_probe)
- [`int_custody_probe_order_by_slot`](#int_custody_probe_order_by_slot)
- [`int_execution_block_by_date`](#int_execution_block_by_date)
- [`int_storage_slot_diff`](#int_storage_slot_diff)
- [`int_storage_slot_diff_by_address_slot`](#int_storage_slot_diff_by_address_slot)
- [`int_storage_slot_expiry_by_6m`](#int_storage_slot_expiry_by_6m)
- [`int_storage_slot_next_touch`](#int_storage_slot_next_touch)
- [`int_storage_slot_reactivation_by_6m`](#int_storage_slot_reactivation_by_6m)
- [`int_storage_slot_read`](#int_storage_slot_read)
<!-- schema_toc_end -->

<!-- schema_start -->
## dim_block_blob_submitter

Blob transaction to submitter name mapping.

### Availability
Data is partitioned by **intDiv(block_number, 500000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.dim_block_blob_submitter`
- **sepolia**: `sepolia.dim_block_blob_submitter`
- **holesky**: `holesky.dim_block_blob_submitter`
- **hoodi**: `hoodi.dim_block_blob_submitter`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.dim_block_blob_submitter FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.dim_block_blob_submitter FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **transaction_index** | `UInt32` | *The transaction index* |
| **address** | `String` | *The blob submitter address* |
| **versioned_hashes** | `Array(String)` | *The versioned hashes of the blob submitter* |
| **name** | `Nullable(String)` | *The name of the blob submitter* |

## dim_node

Node information for validators

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.dim_node`
- **sepolia**: `sepolia.dim_node`
- **holesky**: `holesky.dim_node`
- **hoodi**: `hoodi.dim_node`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.dim_node FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.dim_node FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **validator_index** | `UInt32` | *The index of the validator* |
| **name** | `Nullable(String)` | *The name of the node* |
| **groups** | `Array(String)` | *Groups the node belongs to* |
| **tags** | `Array(String)` | *Tags associated with the node* |
| **attributes** | `Map(String, String)` | *Additional attributes of the node* |
| **source** | `String` | *The source entity of the node* |

## fct_address_access_chunked_10000

Address access totals chunked by 10000 blocks

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_access_chunked_10000`
- **sepolia**: `sepolia.fct_address_access_chunked_10000`
- **holesky**: `holesky.fct_address_access_chunked_10000`
- **hoodi**: `hoodi.fct_address_access_chunked_10000`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_address_access_chunked_10000 FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_address_access_chunked_10000 FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **chunk_start_block_number** | `UInt32` | *Start block number of the chunk* |
| **first_accessed_accounts** | `UInt32` | *Number of accounts first accessed in the chunk* |
| **last_accessed_accounts** | `UInt32` | *Number of accounts last accessed in the chunk* |

## fct_address_access_total

Address access totals and expiry statistics

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_access_total`
- **sepolia**: `sepolia.fct_address_access_total`
- **holesky**: `holesky.fct_address_access_total`
- **hoodi**: `hoodi.fct_address_access_total`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_address_access_total FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_address_access_total FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **total_accounts** | `UInt64` | *Total number of accounts accessed in last 365 days* |
| **expired_accounts** | `UInt64` | *Number of expired accounts (not accessed in last 365 days)* |
| **total_contract_accounts** | `UInt64` | *Total number of contract accounts accessed in last 365 days* |
| **expired_contracts** | `UInt64` | *Number of expired contracts (not accessed in last 365 days)* |

## fct_address_storage_slot_chunked_10000

Storage slot totals chunked by 10000 blocks

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_storage_slot_chunked_10000`
- **sepolia**: `sepolia.fct_address_storage_slot_chunked_10000`
- **holesky**: `holesky.fct_address_storage_slot_chunked_10000`
- **hoodi**: `hoodi.fct_address_storage_slot_chunked_10000`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_address_storage_slot_chunked_10000 FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_address_storage_slot_chunked_10000 FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **chunk_start_block_number** | `UInt32` | *Start block number of the chunk* |
| **first_accessed_slots** | `UInt32` | *Number of slots first accessed in the chunk* |
| **last_accessed_slots** | `UInt32` | *Number of slots last accessed in the chunk* |

## fct_address_storage_slot_expired_top_100_by_contract

Top 100 contracts by expired storage slots (not accessed in last 365 days)

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_storage_slot_expired_top_100_by_contract`
- **sepolia**: `sepolia.fct_address_storage_slot_expired_top_100_by_contract`
- **holesky**: `holesky.fct_address_storage_slot_expired_top_100_by_contract`
- **hoodi**: `hoodi.fct_address_storage_slot_expired_top_100_by_contract`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_address_storage_slot_expired_top_100_by_contract FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_address_storage_slot_expired_top_100_by_contract FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **rank** | `UInt32` | *Rank by expired storage slots (1=highest)* |
| **contract_address** | `String` | *The contract address* |
| **expired_slots** | `UInt64` | *Number of expired storage slots for this contract* |

## fct_address_storage_slot_top_100_by_contract

Top 100 contracts by storage slots

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_storage_slot_top_100_by_contract`
- **sepolia**: `sepolia.fct_address_storage_slot_top_100_by_contract`
- **holesky**: `holesky.fct_address_storage_slot_top_100_by_contract`
- **hoodi**: `hoodi.fct_address_storage_slot_top_100_by_contract`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_address_storage_slot_top_100_by_contract FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_address_storage_slot_top_100_by_contract FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **rank** | `UInt32` | *Rank by total storage slots (1=highest)* |
| **contract_address** | `String` | *The contract address* |
| **total_storage_slots** | `UInt64` | *Total number of storage slots for this contract* |

## fct_address_storage_slot_total

Storage slot totals and expiry statistics

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_address_storage_slot_total`
- **sepolia**: `sepolia.fct_address_storage_slot_total`
- **holesky**: `holesky.fct_address_storage_slot_total`
- **hoodi**: `hoodi.fct_address_storage_slot_total`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_address_storage_slot_total FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_address_storage_slot_total FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **total_storage_slots** | `UInt64` | *Total number of storage slots accessed in last 365 days* |
| **expired_storage_slots** | `UInt64` | *Number of expired storage slots (not accessed in last 365 days)* |

## fct_attestation_correctness_by_validator_canonical

Attestation correctness by validator for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_correctness_by_validator_canonical`
- **sepolia**: `sepolia.fct_attestation_correctness_by_validator_canonical`
- **holesky**: `holesky.fct_attestation_correctness_by_validator_canonical`
- **hoodi**: `hoodi.fct_attestation_correctness_by_validator_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_correctness_by_validator_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_attestation_correctness_by_validator_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **attesting_validator_index** | `UInt32` | *The index of the validator attesting* |
| **block_root** | `Nullable(String)` | *The beacon block root hash that was attested* |
| **slot_distance** | `Nullable(UInt32)` | *The distance from the slot to the attested block. If the attested block is the same as the slot, the distance is 0, if the attested block is the previous slot, the distance is 1, etc. If null, the attestation was missed, the block was orphaned and never seen by a sentry or the block was more than 64 slots ago* |
| **inclusion_distance** | `Nullable(UInt32)` | *The distance from the slot when the attestation was included in a block* |
| **status** | `LowCardinality(String)` | *Can be "canonical", "orphaned", "missed" or "unknown" (validator attested but block data not available)* |

## fct_attestation_correctness_by_validator_head

Attestation correctness by validator for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_correctness_by_validator_head`
- **sepolia**: `sepolia.fct_attestation_correctness_by_validator_head`
- **holesky**: `holesky.fct_attestation_correctness_by_validator_head`
- **hoodi**: `hoodi.fct_attestation_correctness_by_validator_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_correctness_by_validator_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_attestation_correctness_by_validator_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **attesting_validator_index** | `UInt32` | *The index of the validator attesting* |
| **block_root** | `Nullable(String)` | *The beacon block root hash that was attested, null means the attestation was missed* |
| **slot_distance** | `Nullable(UInt32)` | *The distance from the slot to the attested block. If the attested block is the same as the slot, the distance is 0, if the attested block is the previous slot, the distance is 1, etc. If null, the attestation was missed, the block was orphaned and never seen by a sentry or the block was more than 64 slots ago* |
| **propagation_distance** | `Nullable(UInt32)` | *The distance from the slot when the attestation was propagated. 0 means the attestation was propagated within the same slot as its duty was assigned, 1 means the attestation was propagated within the next slot, etc.* |

## fct_attestation_correctness_canonical

Attestation correctness of a block for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_correctness_canonical`
- **sepolia**: `sepolia.fct_attestation_correctness_canonical`
- **holesky**: `holesky.fct_attestation_correctness_canonical`
- **hoodi**: `hoodi.fct_attestation_correctness_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_correctness_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_attestation_correctness_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `Nullable(String)` | *The beacon block root hash* |
| **votes_max** | `UInt32` | *The maximum number of scheduled votes for the block* |
| **votes_head** | `Nullable(UInt32)` | *The number of votes for the block proposed in the current slot* |
| **votes_other** | `Nullable(UInt32)` | *The number of votes for any blocks proposed in previous slots* |

## fct_attestation_correctness_head

Attestation correctness of a block for the unfinalized chain. Forks in the chain may cause multiple block roots for the same slot to be present

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_correctness_head`
- **sepolia**: `sepolia.fct_attestation_correctness_head`
- **holesky**: `holesky.fct_attestation_correctness_head`
- **hoodi**: `hoodi.fct_attestation_correctness_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_correctness_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_attestation_correctness_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `Nullable(String)` | *The beacon block root hash* |
| **votes_max** | `UInt32` | *The maximum number of scheduled votes for the block* |
| **votes_head** | `Nullable(UInt32)` | *The number of votes for the block proposed in the current slot* |
| **votes_other** | `Nullable(UInt32)` | *The number of votes for any blocks proposed in previous slots* |

## fct_attestation_first_seen_chunked_50ms

Attestations first seen on the unfinalized chain broken down by 50ms chunks. Only includes attestations that were seen within 12000ms of the slot start time. There can be multiple block roots + chunk_slot_start_diff for the same slot, it most likely means votes for prior slot blocks

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_first_seen_chunked_50ms`
- **sepolia**: `sepolia.fct_attestation_first_seen_chunked_50ms`
- **holesky**: `holesky.fct_attestation_first_seen_chunked_50ms`
- **hoodi**: `hoodi.fct_attestation_first_seen_chunked_50ms`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_first_seen_chunked_50ms FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_attestation_first_seen_chunked_50ms FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `String` | *The beacon block root hash that was attested, null means the attestation was missed* |
| **chunk_slot_start_diff** | `UInt32` | *The different between the chunk start time and slot_start_date_time. "1500" would mean this chunk contains attestations first seen between 1500ms 1550ms into the slot* |
| **attestation_count** | `UInt32` | *The number of attestations in this chunk* |

## fct_attestation_liveness_by_entity_head

Attestation liveness aggregated by entity for the head chain. One row per (slot, entity) with counts for both attested and missed attestations.

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_liveness_by_entity_head`
- **sepolia**: `sepolia.fct_attestation_liveness_by_entity_head`
- **holesky**: `holesky.fct_attestation_liveness_by_entity_head`
- **hoodi**: `hoodi.fct_attestation_liveness_by_entity_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_liveness_by_entity_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_attestation_liveness_by_entity_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **entity** | `String` | *The entity (staking provider) associated with the validators, unknown if not mapped* |
| **attestation_count** | `UInt32` | *Number of attestations for this entity* |
| **missed_count** | `UInt32` | *Number of missed attestations for this entity* |

## fct_attestation_observation_by_node

Attestation observations by contributor nodes, aggregated per slot per node for performance

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_observation_by_node`
- **sepolia**: `sepolia.fct_attestation_observation_by_node`
- **holesky**: `holesky.fct_attestation_observation_by_node`
- **hoodi**: `hoodi.fct_attestation_observation_by_node`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_observation_by_node FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_attestation_observation_by_node FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **attestation_count** | `UInt32` | *Number of attestations observed by this node in this slot* |
| **avg_seen_slot_start_diff** | `UInt32` | *Average time from slot start to see attestations (milliseconds, rounded)* |
| **median_seen_slot_start_diff** | `UInt32` | *Median time from slot start to see attestations (milliseconds, rounded)* |
| **min_seen_slot_start_diff** | `UInt32` | *Minimum time from slot start to see an attestation (milliseconds)* |
| **max_seen_slot_start_diff** | `UInt32` | *Maximum time from slot start to see an attestation (milliseconds)* |
| **block_root** | `String` | *Representative beacon block root (from most common attestation target)* |
| **username** | `LowCardinality(String)` | *Username of the node* |
| **node_id** | `String` | *ID of the node* |
| **classification** | `LowCardinality(String)` | *Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation* |

## fct_block

Block details for the finalized chain including orphaned blocks

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block`
- **sepolia**: `sepolia.fct_block`
- **holesky**: `holesky.fct_block`
- **hoodi**: `hoodi.fct_block`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the reorg slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **parent_root** | `FixedString(66)` | *The root hash of the parent beacon block* |
| **state_root** | `FixedString(66)` | *The root hash of the beacon state at this block* |
| **proposer_index** | `UInt32` | *The index of the validator that proposed the beacon block* |
| **eth1_data_block_hash** | `FixedString(66)` | *The block hash of the associated execution block* |
| **eth1_data_deposit_root** | `FixedString(66)` | *The root of the deposit tree in the associated execution block* |
| **execution_payload_block_hash** | `FixedString(66)` | *The block hash of the execution payload* |
| **execution_payload_block_number** | `UInt32` | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | `String` | *The recipient of the fee for this execution payload* |
| **execution_payload_base_fee_per_gas** | `Nullable(UInt128)` | *Base fee per gas for execution payload* |
| **execution_payload_blob_gas_used** | `Nullable(UInt64)` | *Gas used for blobs in execution payload* |
| **execution_payload_excess_blob_gas** | `Nullable(UInt64)` | *Excess gas used for blobs in execution payload* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_state_root** | `FixedString(66)` | *The state root of the execution payload* |
| **execution_payload_parent_hash** | `FixedString(66)` | *The parent hash of the execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |
| **execution_payload_transactions_total_bytes_compressed** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload when compressed using snappy* |
| **status** | `LowCardinality(String)` | *Can be "canonical" or "orphaned"* |

## fct_block_blob_count

Blob count of a block for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_blob_count`
- **sepolia**: `sepolia.fct_block_blob_count`
- **holesky**: `holesky.fct_block_blob_count`
- **hoodi**: `hoodi.fct_block_blob_count`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_blob_count FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_blob_count FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `String` | *The beacon block root hash* |
| **blob_count** | `UInt32` | *The number of blobs in the block* |
| **status** | `LowCardinality(String)` | *Can be "canonical" or "orphaned"* |

## fct_block_blob_count_head

Blob count of a block for the unfinalized chain. Forks in the chain may cause multiple block roots for the same slot to be present

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_blob_count_head`
- **sepolia**: `sepolia.fct_block_blob_count_head`
- **holesky**: `holesky.fct_block_blob_count_head`
- **hoodi**: `hoodi.fct_block_blob_count_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_blob_count_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_blob_count_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `String` | *The beacon block root hash* |
| **blob_count** | `UInt32` | *The number of blobs in the block* |

## fct_block_blob_first_seen_by_node

When the block was first seen on the network by a sentry node

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_blob_first_seen_by_node`
- **sepolia**: `sepolia.fct_block_blob_first_seen_by_node`
- **holesky**: `holesky.fct_block_blob_first_seen_by_node`
- **hoodi**: `hoodi.fct_block_blob_first_seen_by_node`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_blob_first_seen_by_node FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_blob_first_seen_by_node FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **source** | `LowCardinality(String)` | *Source of the event* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **seen_slot_start_diff** | `UInt32` | *The time from slot start for the client to see the block* |
| **block_root** | `String` | *The beacon block root hash* |
| **blob_index** | `UInt32` | *The blob index* |
| **username** | `LowCardinality(String)` | *Username of the node* |
| **node_id** | `String` | *ID of the node* |
| **classification** | `LowCardinality(String)` | *Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation* |

## fct_block_data_column_sidecar_first_seen

When the data column was first seen on the network by any sentry node

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_data_column_sidecar_first_seen`
- **sepolia**: `sepolia.fct_block_data_column_sidecar_first_seen`
- **holesky**: `holesky.fct_block_data_column_sidecar_first_seen`
- **hoodi**: `hoodi.fct_block_data_column_sidecar_first_seen`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_data_column_sidecar_first_seen FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_data_column_sidecar_first_seen FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **source** | `LowCardinality(String)` | *Source of the event* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **seen_slot_start_diff** | `UInt32` | *The time from slot start until the data column was first seen by any node* |
| **block_root** | `String` | *The beacon block root hash* |
| **column_index** | `UInt32` | *The data column index* |
| **row_count** | `UInt32` | *The number of rows (blobs) in the data column sidecar* |
| **username** | `LowCardinality(String)` | *Username of the node that first saw the data column* |
| **node_id** | `String` | *ID of the node that first saw the data column* |
| **classification** | `LowCardinality(String)` | *Classification of the node that first saw the data column, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client that first saw the data column* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client that first saw the data column* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client that first saw the data column* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client that first saw the data column* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client that first saw the data column* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client that first saw the data column* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client that first saw the data column* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client that first saw the data column* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client that first saw the data column* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client that first saw the data column* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client that first saw the data column* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version of the client that first saw the data column* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation of the client that first saw the data column* |

## fct_block_data_column_sidecar_first_seen_by_node

When the data column was first seen on the network by a sentry node

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_data_column_sidecar_first_seen_by_node`
- **sepolia**: `sepolia.fct_block_data_column_sidecar_first_seen_by_node`
- **holesky**: `holesky.fct_block_data_column_sidecar_first_seen_by_node`
- **hoodi**: `hoodi.fct_block_data_column_sidecar_first_seen_by_node`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_data_column_sidecar_first_seen_by_node FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_data_column_sidecar_first_seen_by_node FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **source** | `LowCardinality(String)` | *Source of the event* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **seen_slot_start_diff** | `UInt32` | *The time from slot start for the client to see the data column* |
| **block_root** | `String` | *The beacon block root hash* |
| **column_index** | `UInt32` | *The data column index* |
| **row_count** | `UInt32` | *The number of rows (blobs) in the data column sidecar* |
| **username** | `LowCardinality(String)` | *Username of the node* |
| **node_id** | `String` | *ID of the node* |
| **classification** | `LowCardinality(String)` | *Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation* |

## fct_block_first_seen_by_node

When the block was first seen on the network by a sentry node

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_first_seen_by_node`
- **sepolia**: `sepolia.fct_block_first_seen_by_node`
- **holesky**: `holesky.fct_block_first_seen_by_node`
- **hoodi**: `hoodi.fct_block_first_seen_by_node`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_first_seen_by_node FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_first_seen_by_node FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **source** | `LowCardinality(String)` | *Source of the event* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **seen_slot_start_diff** | `UInt32` | *The time from slot start for the client to see the block* |
| **block_root** | `String` | *The beacon block root hash* |
| **username** | `LowCardinality(String)` | *Username of the node* |
| **node_id** | `String` | *ID of the node* |
| **classification** | `LowCardinality(String)` | *Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation* |

## fct_block_head

Block details for the unfinalized chain. Forks in the chain may cause multiple block roots for the same slot to be present

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_head`
- **sepolia**: `sepolia.fct_block_head`
- **holesky**: `holesky.fct_block_head`
- **hoodi**: `hoodi.fct_block_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the reorg slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **parent_root** | `FixedString(66)` | *The root hash of the parent beacon block* |
| **state_root** | `FixedString(66)` | *The root hash of the beacon state at this block* |
| **proposer_index** | `UInt32` | *The index of the validator that proposed the beacon block* |
| **eth1_data_block_hash** | `FixedString(66)` | *The block hash of the associated execution block* |
| **eth1_data_deposit_root** | `FixedString(66)` | *The root of the deposit tree in the associated execution block* |
| **execution_payload_block_hash** | `FixedString(66)` | *The block hash of the execution payload* |
| **execution_payload_block_number** | `UInt32` | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | `String` | *The recipient of the fee for this execution payload* |
| **execution_payload_base_fee_per_gas** | `Nullable(UInt128)` | *Base fee per gas for execution payload* |
| **execution_payload_blob_gas_used** | `Nullable(UInt64)` | *Gas used for blobs in execution payload* |
| **execution_payload_excess_blob_gas** | `Nullable(UInt64)` | *Excess gas used for blobs in execution payload* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_state_root** | `FixedString(66)` | *The state root of the execution payload* |
| **execution_payload_parent_hash** | `FixedString(66)` | *The parent hash of the execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |
| **execution_payload_transactions_total_bytes_compressed** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload when compressed using snappy* |

## fct_block_mev

MEV relay proposer payload delivered for a block on the finalized chain including orphaned blocks

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_mev`
- **sepolia**: `sepolia.fct_block_mev`
- **holesky**: `holesky.fct_block_mev`
- **hoodi**: `hoodi.fct_block_mev`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_mev FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_mev FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block proposer payload* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the proposer payload is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the proposer payload is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the proposer payload is for* |
| **block_root** | `String` | *The root hash of the beacon block* |
| **earliest_bid_date_time** | `Nullable(DateTime64(3))` | *The earliest timestamp of the accepted bid in milliseconds* |
| **relay_names** | `Array(String)` | *The relay names that delivered the proposer payload* |
| **parent_hash** | `FixedString(66)` | *The parent hash of the proposer payload* |
| **block_number** | `UInt64` | *The block number of the proposer payload* |
| **block_hash** | `FixedString(66)` | *The block hash of the proposer payload* |
| **builder_pubkey** | `String` | *The builder pubkey of the proposer payload* |
| **proposer_pubkey** | `String` | *The proposer pubkey of the proposer payload* |
| **proposer_fee_recipient** | `FixedString(42)` | *The proposer fee recipient of the proposer payload* |
| **gas_limit** | `UInt64` | *The gas limit of the proposer payload* |
| **gas_used** | `UInt64` | *The gas used of the proposer payload* |
| **value** | `Nullable(UInt128)` | *The transaction value in wei* |
| **transaction_count** | `UInt32` | *The number of transactions in the proposer payload* |
| **status** | `LowCardinality(String)` | *Can be "canonical" or "orphaned"* |

## fct_block_mev_head

MEV relay proposer payload delivered for a block on the unfinalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_mev_head`
- **sepolia**: `sepolia.fct_block_mev_head`
- **holesky**: `holesky.fct_block_mev_head`
- **hoodi**: `hoodi.fct_block_mev_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_mev_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_mev_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block proposer payload* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the proposer payload is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the proposer payload is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the proposer payload is for* |
| **block_root** | `String` | *The root hash of the beacon block* |
| **earliest_bid_date_time** | `Nullable(DateTime64(3))` | *The earliest timestamp of the accepted bid in milliseconds* |
| **relay_names** | `Array(String)` | *The relay names that delivered the proposer payload* |
| **parent_hash** | `FixedString(66)` | *The parent hash of the proposer payload* |
| **block_number** | `UInt64` | *The block number of the proposer payload* |
| **block_hash** | `FixedString(66)` | *The block hash of the proposer payload* |
| **builder_pubkey** | `String` | *The builder pubkey of the proposer payload* |
| **proposer_pubkey** | `String` | *The proposer pubkey of the proposer payload* |
| **proposer_fee_recipient** | `FixedString(42)` | *The proposer fee recipient of the proposer payload* |
| **gas_limit** | `UInt64` | *The gas limit of the proposer payload* |
| **gas_used** | `UInt64` | *The gas used of the proposer payload* |
| **value** | `Nullable(UInt128)` | *The transaction value in wei* |
| **transaction_count** | `UInt32` | *The number of transactions in the proposer payload* |

## fct_block_proposer

Block proposers for the finalized chain including orphaned blocks

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_proposer`
- **sepolia**: `sepolia.fct_block_proposer`
- **holesky**: `holesky.fct_block_proposer`
- **hoodi**: `hoodi.fct_block_proposer`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_proposer FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_proposer FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **proposer_validator_index** | `UInt32` | *The validator index of the proposer for the slot* |
| **proposer_pubkey** | `String` | *The public key of the validator proposer* |
| **block_root** | `Nullable(String)` | *The beacon block root hash. Null if a block was never seen by a sentry, aka "missed"* |
| **status** | `LowCardinality(String)` | *Can be "canonical", "orphaned" or "missed"* |

## fct_block_proposer_entity

Block proposer entity for the unfinalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_proposer_entity`
- **sepolia**: `sepolia.fct_block_proposer_entity`
- **holesky**: `holesky.fct_block_proposer_entity`
- **hoodi**: `hoodi.fct_block_proposer_entity`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_proposer_entity FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_proposer_entity FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **entity** | `Nullable(String)` | *The entity that proposed the block* |

## fct_block_proposer_head

Block proposers for the unfinalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_proposer_head`
- **sepolia**: `sepolia.fct_block_proposer_head`
- **holesky**: `holesky.fct_block_proposer_head`
- **hoodi**: `hoodi.fct_block_proposer_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_proposer_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_block_proposer_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **proposer_validator_index** | `UInt32` | *The validator index of the proposer for the slot* |
| **proposer_pubkey** | `String` | *The public key of the validator proposer* |
| **block_root** | `Nullable(String)` | *The beacon block root hash. Null if a block was never seen by a sentry* |

## fct_data_column_availability_by_epoch

Data column availability by epoch and column index

### Availability
Data is partitioned by **toStartOfMonth(epoch_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_data_column_availability_by_epoch`
- **sepolia**: `sepolia.fct_data_column_availability_by_epoch`
- **holesky**: `holesky.fct_data_column_availability_by_epoch`
- **hoodi**: `hoodi.fct_data_column_availability_by_epoch`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_data_column_availability_by_epoch FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_data_column_availability_by_epoch FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **epoch** | `UInt32` | *Epoch number* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **slot_start_date_time** | `DateTime` | *Earliest slot start time in this epoch (used for CBT position tracking)* |
| **column_index** | `UInt64` | *Column index (0-127)* |
| **slot_count** | `UInt32` | *Number of slots in this epoch aggregation* |
| **total_probe_count** | `UInt64` | *Total probe count across all slots* |
| **total_success_count** | `UInt64` | *Total successful probes across all slots* |
| **total_failure_count** | `UInt64` | *Total failed probes across all slots (result = failure)* |
| **total_missing_count** | `UInt64` | *Total missing probes across all slots (result = missing)* |
| **avg_availability_pct** | `Float64` | *Availability percentage calculated from total counts (total_success_count / total_probe_count * 100, rounded to 2 decimal places)* |
| **min_availability_pct** | `Float64` | *Minimum availability percentage across slots (rounded to 2 decimal places)* |
| **max_availability_pct** | `Float64` | *Maximum availability percentage across slots (rounded to 2 decimal places)* |
| **min_response_time_ms** | `UInt32` | *Minimum response time in milliseconds for successful probes only (rounded to whole number)* |
| **avg_p50_response_time_ms** | `UInt32` | *Average of p50 response times across slots for successful probes only (rounded to whole number)* |
| **avg_p95_response_time_ms** | `UInt32` | *Average of p95 response times across slots for successful probes only (rounded to whole number)* |
| **avg_p99_response_time_ms** | `UInt32` | *Average of p99 response times across slots for successful probes only (rounded to whole number)* |
| **max_response_time_ms** | `UInt32` | *Maximum response time in milliseconds for successful probes only (rounded to whole number)* |
| **max_blob_count** | `UInt16` | *Maximum blob count observed in this epoch* |

## fct_data_column_availability_by_slot

Data column availability by slot and column index

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_data_column_availability_by_slot`
- **sepolia**: `sepolia.fct_data_column_availability_by_slot`
- **holesky**: `holesky.fct_data_column_availability_by_slot`
- **hoodi**: `hoodi.fct_data_column_availability_by_slot`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_data_column_availability_by_slot FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_data_column_availability_by_slot FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number being probed* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **wallclock_request_slot** | `UInt32` | *The wallclock slot when the request was sent* |
| **wallclock_request_slot_start_date_time** | `DateTime` | *The start time for the slot when the request was sent* |
| **wallclock_request_epoch** | `UInt32` | *The wallclock epoch when the request was sent* |
| **wallclock_request_epoch_start_date_time** | `DateTime` | *The start time for the wallclock epoch when the request was sent* |
| **column_index** | `UInt64` | *Column index being probed (0-127)* |
| **beacon_block_root** | `Nullable(FixedString(66))` | *Beacon block root for this slot (from earliest observation, handles reorgs, NULL if unavailable)* |
| **beacon_block_root_variants** | `UInt8` | *Number of unique block roots observed (>1 indicates reorg/fork)* |
| **blob_count** | `UInt16` | *Number of blobs in the slot (max column_rows_count)* |
| **success_count** | `UInt32` | *Count of successful probes* |
| **failure_count** | `UInt32` | *Count of failed probes (result = failure)* |
| **missing_count** | `UInt32` | *Count of missing probes (result = missing)* |
| **probe_count** | `UInt32` | *Total count of probes* |
| **availability_pct** | `Float64` | *Availability percentage (success / total * 100) rounded to 2 decimal places* |
| **min_response_time_ms** | `UInt32` | *Minimum response time in milliseconds for successful probes only* |
| **p50_response_time_ms** | `UInt32` | *Median (p50) response time in milliseconds for successful probes only* |
| **p95_response_time_ms** | `UInt32` | *95th percentile response time in milliseconds for successful probes only* |
| **p99_response_time_ms** | `UInt32` | *99th percentile response time in milliseconds for successful probes only* |
| **max_response_time_ms** | `UInt32` | *Maximum response time in milliseconds for successful probes only* |
| **unique_peer_count** | `UInt32` | *Count of unique peers probed* |
| **unique_client_count** | `UInt32` | *Count of unique client names* |
| **unique_implementation_count** | `UInt32` | *Count of unique client implementations* |
| **custody_probe_count** | `UInt32` | *Count of observations from active RPC custody probes* |
| **gossipsub_count** | `UInt32` | *Count of observations from passive gossipsub propagation* |

## fct_data_column_availability_by_slot_blob

Data column availability by slot, blob index, and column index

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_data_column_availability_by_slot_blob`
- **sepolia**: `sepolia.fct_data_column_availability_by_slot_blob`
- **holesky**: `holesky.fct_data_column_availability_by_slot_blob`
- **hoodi**: `hoodi.fct_data_column_availability_by_slot_blob`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_data_column_availability_by_slot_blob FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_data_column_availability_by_slot_blob FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number being probed* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **wallclock_request_slot** | `UInt32` | *The wallclock slot when the request was sent* |
| **wallclock_request_slot_start_date_time** | `DateTime` | *The start time for the slot when the request was sent* |
| **wallclock_request_epoch** | `UInt32` | *The wallclock epoch when the request was sent* |
| **wallclock_request_epoch_start_date_time** | `DateTime` | *The start time for the wallclock epoch when the request was sent* |
| **blob_index** | `UInt16` | *Blob index within the slot (0-based, typically 0-5)* |
| **column_index** | `UInt64` | *Column index being probed (0-127)* |
| **blob_count** | `UInt16` | *Total number of blobs in the slot* |
| **availability_pct** | `Float64` | *Availability percentage (success / total * 100) rounded to 2 decimal places - same for all blobs in column* |
| **success_count** | `UInt32` | *Count of successful probes* |
| **failure_count** | `UInt32` | *Count of failed probes (result = failure)* |
| **missing_count** | `UInt32` | *Count of missing probes (result = missing)* |
| **probe_count** | `UInt32` | *Total count of probes* |
| **min_response_time_ms** | `UInt32` | *Minimum response time in milliseconds for successful probes only* |
| **p50_response_time_ms** | `UInt32` | *Median (p50) response time in milliseconds for successful probes only* |
| **p95_response_time_ms** | `UInt32` | *95th percentile response time in milliseconds for successful probes only* |
| **p99_response_time_ms** | `UInt32` | *99th percentile response time in milliseconds for successful probes only* |
| **max_response_time_ms** | `UInt32` | *Maximum response time in milliseconds for successful probes only* |
| **unique_peer_count** | `UInt32` | *Count of unique peers probed* |
| **unique_client_count** | `UInt32` | *Count of unique client names* |
| **unique_implementation_count** | `UInt32` | *Count of unique client implementations* |

## fct_data_column_availability_daily

Data column availability by day and column index

### Availability
Data is partitioned by **toYYYYMM(date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_data_column_availability_daily`
- **sepolia**: `sepolia.fct_data_column_availability_daily`
- **holesky**: `holesky.fct_data_column_availability_daily`
- **hoodi**: `hoodi.fct_data_column_availability_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_data_column_availability_daily FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_data_column_availability_daily FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **date** | `Date` | *Date of the aggregation* |
| **column_index** | `UInt64` | *Column index (0-127)* |
| **hour_count** | `UInt32` | *Number of hours in this day aggregation* |
| **avg_availability_pct** | `Float64` | *Availability percentage calculated from total counts (total_success_count / total_probe_count * 100, rounded to 2 decimal places)* |
| **min_availability_pct** | `Float64` | *Minimum availability percentage across hours (rounded to 2 decimal places)* |
| **max_availability_pct** | `Float64` | *Maximum availability percentage across hours (rounded to 2 decimal places)* |
| **total_probe_count** | `UInt64` | *Total probe count across all hours* |
| **total_success_count** | `UInt64` | *Total successful probes across all hours* |
| **total_failure_count** | `UInt64` | *Total failed probes across all hours (result = failure)* |
| **total_missing_count** | `UInt64` | *Total missing probes across all hours (result = missing)* |
| **min_response_time_ms** | `UInt32` | *Minimum response time in milliseconds for successful probes only (rounded to whole number)* |
| **avg_p50_response_time_ms** | `UInt32` | *Average of p50 response times across hours for successful probes only (rounded to whole number)* |
| **avg_p95_response_time_ms** | `UInt32` | *Average of p95 response times across hours for successful probes only (rounded to whole number)* |
| **avg_p99_response_time_ms** | `UInt32` | *Average of p99 response times across hours for successful probes only (rounded to whole number)* |
| **max_response_time_ms** | `UInt32` | *Maximum response time in milliseconds for successful probes only (rounded to whole number)* |
| **max_blob_count** | `UInt16` | *Maximum blob count observed in this day* |

## fct_data_column_availability_hourly

Data column availability by hour and column index

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_data_column_availability_hourly`
- **sepolia**: `sepolia.fct_data_column_availability_hourly`
- **holesky**: `holesky.fct_data_column_availability_hourly`
- **hoodi**: `hoodi.fct_data_column_availability_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_data_column_availability_hourly FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_data_column_availability_hourly FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **hour_start_date_time** | `DateTime` | *Start of the hour period* |
| **column_index** | `UInt64` | *Column index (0-127)* |
| **epoch_count** | `UInt32` | *Number of epochs in this hour aggregation* |
| **avg_availability_pct** | `Float64` | *Availability percentage calculated from total counts (total_success_count / total_probe_count * 100, rounded to 2 decimal places)* |
| **min_availability_pct** | `Float64` | *Minimum availability percentage across epochs (rounded to 2 decimal places)* |
| **max_availability_pct** | `Float64` | *Maximum availability percentage across epochs (rounded to 2 decimal places)* |
| **total_probe_count** | `UInt64` | *Total probe count across all epochs* |
| **total_success_count** | `UInt64` | *Total successful probes across all epochs* |
| **total_failure_count** | `UInt64` | *Total failed probes across all epochs (result = failure)* |
| **total_missing_count** | `UInt64` | *Total missing probes across all epochs (result = missing)* |
| **min_response_time_ms** | `UInt32` | *Minimum response time in milliseconds for successful probes only (rounded to whole number)* |
| **avg_p50_response_time_ms** | `UInt32` | *Average of p50 response times across epochs for successful probes only (rounded to whole number)* |
| **avg_p95_response_time_ms** | `UInt32` | *Average of p95 response times across epochs for successful probes only (rounded to whole number)* |
| **avg_p99_response_time_ms** | `UInt32` | *Average of p99 response times across epochs for successful probes only (rounded to whole number)* |
| **max_response_time_ms** | `UInt32` | *Maximum response time in milliseconds for successful probes only (rounded to whole number)* |
| **max_blob_count** | `UInt16` | *Maximum blob count observed in this hour* |

## fct_engine_get_blobs_by_el_client

engine_getBlobs observations aggregated by execution client and status for EL comparison

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_get_blobs_by_el_client`
- **sepolia**: `sepolia.fct_engine_get_blobs_by_el_client`
- **holesky**: `holesky.fct_engine_get_blobs_by_el_client`
- **hoodi**: `hoodi.fct_engine_get_blobs_by_el_client`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_get_blobs_by_el_client FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_engine_get_blobs_by_el_client FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number of the beacon block being reconstructed* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number derived from the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *Root of the beacon block (hex encoded with 0x prefix)* |
| **meta_execution_implementation** | `LowCardinality(String)` | *Execution client implementation (e.g., Geth, Nethermind, Besu, Reth)* |
| **meta_execution_version** | `LowCardinality(String)` | *Execution client version string* |
| **status** | `LowCardinality(String)` | *Engine API response status (SUCCESS, PARTIAL, EMPTY, UNSUPPORTED, ERROR)* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **observation_count** | `UInt32` | *Number of observations for this EL client/status* |
| **unique_node_count** | `UInt32` | *Number of unique nodes with this EL client/status* |
| **max_requested_count** | `UInt32` | *Maximum number of versioned hashes requested* |
| **avg_returned_count** | `Float64` | *Average number of non-null blobs returned* |
| **avg_duration_ms** | `UInt64` | *Average duration of engine_getBlobs calls in milliseconds* |
| **median_duration_ms** | `UInt64` | *Median duration of engine_getBlobs calls in milliseconds* |
| **min_duration_ms** | `UInt64` | *Minimum duration of engine_getBlobs calls in milliseconds* |
| **max_duration_ms** | `UInt64` | *Maximum duration of engine_getBlobs calls in milliseconds* |
| **p95_duration_ms** | `UInt64` | *95th percentile duration of engine_getBlobs calls in milliseconds* |

## fct_engine_get_blobs_by_slot

Slot-level aggregated engine_getBlobs observations grouped by status with duration statistics

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_get_blobs_by_slot`
- **sepolia**: `sepolia.fct_engine_get_blobs_by_slot`
- **holesky**: `holesky.fct_engine_get_blobs_by_slot`
- **hoodi**: `hoodi.fct_engine_get_blobs_by_slot`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_get_blobs_by_slot FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_engine_get_blobs_by_slot FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number of the beacon block being reconstructed* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number derived from the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *Root of the beacon block (hex encoded with 0x prefix)* |
| **status** | `LowCardinality(String)` | *Engine API response status (SUCCESS, PARTIAL, EMPTY, UNSUPPORTED, ERROR)* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **observation_count** | `UInt32` | *Number of observations for this slot/block/status* |
| **unique_node_count** | `UInt32` | *Number of unique nodes that observed this block with this status* |
| **max_requested_count** | `UInt32` | *Maximum number of versioned hashes requested* |
| **avg_returned_count** | `Float64` | *Average number of non-null blobs returned* |
| **full_return_pct** | `Nullable(Float64)` | *Percentage of observations where returned_count equals requested_count* |
| **avg_duration_ms** | `UInt64` | *Average duration of engine_getBlobs calls in milliseconds* |
| **median_duration_ms** | `UInt64` | *Median duration of engine_getBlobs calls in milliseconds* |
| **min_duration_ms** | `UInt64` | *Minimum duration of engine_getBlobs calls in milliseconds* |
| **max_duration_ms** | `UInt64` | *Maximum duration of engine_getBlobs calls in milliseconds* |
| **p95_duration_ms** | `UInt64` | *95th percentile duration of engine_getBlobs calls in milliseconds* |
| **unique_cl_implementation_count** | `UInt32` | *Number of unique CL client implementations observing this block* |
| **unique_el_implementation_count** | `UInt32` | *Number of unique EL client implementations observing this block* |

## fct_engine_get_blobs_duration_chunked_50ms

Fine-grained engine_getBlobs duration distribution in 50ms chunks for latency histogram analysis

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_get_blobs_duration_chunked_50ms`
- **sepolia**: `sepolia.fct_engine_get_blobs_duration_chunked_50ms`
- **holesky**: `holesky.fct_engine_get_blobs_duration_chunked_50ms`
- **hoodi**: `hoodi.fct_engine_get_blobs_duration_chunked_50ms`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_get_blobs_duration_chunked_50ms FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_engine_get_blobs_duration_chunked_50ms FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number of the beacon block being reconstructed* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number derived from the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *Root of the beacon block (hex encoded with 0x prefix)* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **chunk_duration_ms** | `Int64` | *Duration bucket in 50ms chunks (0, 50, 100, 150, ...)* |
| **observation_count** | `UInt32` | *Number of observations in this duration chunk* |
| **success_count** | `UInt32` | *Number of SUCCESS status observations in this chunk* |
| **partial_count** | `UInt32` | *Number of PARTIAL status observations in this chunk* |
| **empty_count** | `UInt32` | *Number of EMPTY status observations in this chunk* |
| **error_count** | `UInt32` | *Number of ERROR or UNSUPPORTED status observations in this chunk* |

## fct_engine_get_blobs_status_daily

Daily aggregated engine_getBlobs status distribution and duration statistics

### Availability
Data is partitioned by **toYYYYMM(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_get_blobs_status_daily`
- **sepolia**: `sepolia.fct_engine_get_blobs_status_daily`
- **holesky**: `holesky.fct_engine_get_blobs_status_daily`
- **hoodi**: `hoodi.fct_engine_get_blobs_status_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_get_blobs_status_daily FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_engine_get_blobs_status_daily FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **day_start_date** | `Date` | *Start of the day period* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **slot_count** | `UInt32` | *Number of slots in this day aggregation* |
| **observation_count** | `UInt64` | *Total number of observations in this day* |
| **success_count** | `UInt64` | *Number of observations with SUCCESS status* |
| **partial_count** | `UInt64` | *Number of observations with PARTIAL status* |
| **empty_count** | `UInt64` | *Number of observations with EMPTY status* |
| **unsupported_count** | `UInt64` | *Number of observations with UNSUPPORTED status* |
| **error_count** | `UInt64` | *Number of observations with ERROR status* |
| **success_pct** | `Float64` | *Percentage of observations with SUCCESS status* |
| **avg_duration_ms** | `UInt64` | *Average duration of engine_getBlobs calls in milliseconds* |
| **avg_p50_duration_ms** | `UInt64` | *Average of median durations across slots in milliseconds* |
| **avg_p95_duration_ms** | `UInt64` | *Average of p95 durations across slots in milliseconds* |
| **max_duration_ms** | `UInt64` | *Maximum duration of engine_getBlobs calls in milliseconds* |

## fct_engine_get_blobs_status_hourly

Hourly aggregated engine_getBlobs status distribution and duration statistics

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_get_blobs_status_hourly`
- **sepolia**: `sepolia.fct_engine_get_blobs_status_hourly`
- **holesky**: `holesky.fct_engine_get_blobs_status_hourly`
- **hoodi**: `hoodi.fct_engine_get_blobs_status_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_get_blobs_status_hourly FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_engine_get_blobs_status_hourly FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **hour_start_date_time** | `DateTime` | *Start of the hour period* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **slot_count** | `UInt32` | *Number of slots in this hour aggregation* |
| **observation_count** | `UInt64` | *Total number of observations in this hour* |
| **success_count** | `UInt64` | *Number of observations with SUCCESS status* |
| **partial_count** | `UInt64` | *Number of observations with PARTIAL status* |
| **empty_count** | `UInt64` | *Number of observations with EMPTY status* |
| **unsupported_count** | `UInt64` | *Number of observations with UNSUPPORTED status* |
| **error_count** | `UInt64` | *Number of observations with ERROR status* |
| **success_pct** | `Float64` | *Percentage of observations with SUCCESS status* |
| **avg_duration_ms** | `UInt64` | *Average duration of engine_getBlobs calls in milliseconds* |
| **avg_p50_duration_ms** | `UInt64` | *Average of median durations across slots in milliseconds* |
| **avg_p95_duration_ms** | `UInt64` | *Average of p95 durations across slots in milliseconds* |
| **max_duration_ms** | `UInt64` | *Maximum duration of engine_getBlobs calls in milliseconds* |

## fct_engine_new_payload_by_el_client

engine_newPayload observations aggregated by execution client and status for EL comparison

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_new_payload_by_el_client`
- **sepolia**: `sepolia.fct_engine_new_payload_by_el_client`
- **holesky**: `holesky.fct_engine_new_payload_by_el_client`
- **hoodi**: `hoodi.fct_engine_new_payload_by_el_client`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_by_el_client FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_by_el_client FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number of the beacon block containing the payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number derived from the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *Root of the beacon block (hex encoded with 0x prefix)* |
| **block_hash** | `FixedString(66)` | *Execution block hash (hex encoded with 0x prefix)* |
| **meta_execution_implementation** | `LowCardinality(String)` | *Execution client implementation (e.g., Geth, Nethermind, Besu, Reth)* |
| **meta_execution_version** | `LowCardinality(String)` | *Execution client version string* |
| **status** | `LowCardinality(String)` | *Engine API response status (VALID, INVALID, SYNCING, ACCEPTED, INVALID_BLOCK_HASH, ERROR)* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **gas_used** | `UInt64` | *Total gas used by all transactions in the block* |
| **gas_limit** | `UInt64` | *Gas limit of the block* |
| **tx_count** | `UInt32` | *Number of transactions in the block* |
| **blob_count** | `UInt32` | *Number of blobs in the block* |
| **observation_count** | `UInt32` | *Number of observations for this EL client/status* |
| **unique_node_count** | `UInt32` | *Number of unique nodes with this EL client/status* |
| **avg_duration_ms** | `UInt64` | *Average duration of engine_newPayload calls in milliseconds* |
| **median_duration_ms** | `UInt64` | *Median duration of engine_newPayload calls in milliseconds* |
| **min_duration_ms** | `UInt64` | *Minimum duration of engine_newPayload calls in milliseconds* |
| **max_duration_ms** | `UInt64` | *Maximum duration of engine_newPayload calls in milliseconds* |
| **p95_duration_ms** | `UInt64` | *95th percentile duration of engine_newPayload calls in milliseconds* |

## fct_engine_new_payload_by_slot

Slot-level aggregated engine_newPayload observations grouped by status with duration statistics

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_new_payload_by_slot`
- **sepolia**: `sepolia.fct_engine_new_payload_by_slot`
- **holesky**: `holesky.fct_engine_new_payload_by_slot`
- **hoodi**: `hoodi.fct_engine_new_payload_by_slot`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_by_slot FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_by_slot FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number of the beacon block containing the payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number derived from the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *Root of the beacon block (hex encoded with 0x prefix)* |
| **block_hash** | `FixedString(66)` | *Execution block hash (hex encoded with 0x prefix)* |
| **block_number** | `UInt64` | *Execution block number* |
| **proposer_index** | `UInt32` | *Validator index of the block proposer* |
| **gas_used** | `UInt64` | *Total gas used by all transactions in the block* |
| **gas_limit** | `UInt64` | *Gas limit of the block* |
| **tx_count** | `UInt32` | *Number of transactions in the block* |
| **blob_count** | `UInt32` | *Number of blobs in the block* |
| **status** | `LowCardinality(String)` | *Engine API response status (VALID, INVALID, SYNCING, ACCEPTED, INVALID_BLOCK_HASH, ERROR)* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **observation_count** | `UInt32` | *Number of observations for this slot/block/status* |
| **unique_node_count** | `UInt32` | *Number of unique nodes that observed this block with this status* |
| **avg_duration_ms** | `UInt64` | *Average duration of engine_newPayload calls in milliseconds* |
| **median_duration_ms** | `UInt64` | *Median duration of engine_newPayload calls in milliseconds* |
| **min_duration_ms** | `UInt64` | *Minimum duration of engine_newPayload calls in milliseconds* |
| **max_duration_ms** | `UInt64` | *Maximum duration of engine_newPayload calls in milliseconds* |
| **p95_duration_ms** | `UInt64` | *95th percentile duration of engine_newPayload calls in milliseconds* |
| **p99_duration_ms** | `UInt64` | *99th percentile duration of engine_newPayload calls in milliseconds* |
| **unique_cl_implementation_count** | `UInt32` | *Number of unique CL client implementations observing this block* |
| **unique_el_implementation_count** | `UInt32` | *Number of unique EL client implementations observing this block* |

## fct_engine_new_payload_duration_chunked_50ms

Fine-grained engine_newPayload duration distribution in 50ms chunks for latency histogram analysis

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_new_payload_duration_chunked_50ms`
- **sepolia**: `sepolia.fct_engine_new_payload_duration_chunked_50ms`
- **holesky**: `holesky.fct_engine_new_payload_duration_chunked_50ms`
- **hoodi**: `hoodi.fct_engine_new_payload_duration_chunked_50ms`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_duration_chunked_50ms FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_duration_chunked_50ms FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number of the beacon block containing the payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number derived from the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_hash** | `FixedString(66)` | *Execution block hash (hex encoded with 0x prefix)* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **chunk_duration_ms** | `Int64` | *Duration bucket in 50ms chunks (0, 50, 100, 150, ...)* |
| **observation_count** | `UInt32` | *Number of observations in this duration chunk* |
| **valid_count** | `UInt32` | *Number of VALID status observations in this chunk* |
| **invalid_count** | `UInt32` | *Number of INVALID or INVALID_BLOCK_HASH status observations in this chunk* |

## fct_engine_new_payload_status_daily

Daily aggregated engine_newPayload status distribution and duration statistics

### Availability
Data is partitioned by **toYYYYMM(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_new_payload_status_daily`
- **sepolia**: `sepolia.fct_engine_new_payload_status_daily`
- **holesky**: `holesky.fct_engine_new_payload_status_daily`
- **hoodi**: `hoodi.fct_engine_new_payload_status_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_status_daily FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_status_daily FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **day_start_date** | `Date` | *Start of the day period* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **slot_count** | `UInt32` | *Number of slots in this day aggregation* |
| **observation_count** | `UInt64` | *Total number of observations in this day* |
| **valid_count** | `UInt64` | *Number of observations with VALID status* |
| **invalid_count** | `UInt64` | *Number of observations with INVALID status* |
| **syncing_count** | `UInt64` | *Number of observations with SYNCING status* |
| **accepted_count** | `UInt64` | *Number of observations with ACCEPTED status* |
| **invalid_block_hash_count** | `UInt64` | *Number of observations with INVALID_BLOCK_HASH status* |
| **valid_pct** | `Float64` | *Percentage of observations with VALID status* |
| **avg_duration_ms** | `UInt64` | *Average duration of engine_newPayload calls in milliseconds* |
| **avg_p50_duration_ms** | `UInt64` | *Average of median durations across slots in milliseconds* |
| **avg_p95_duration_ms** | `UInt64` | *Average of p95 durations across slots in milliseconds* |
| **max_duration_ms** | `UInt64` | *Maximum duration of engine_newPayload calls in milliseconds* |

## fct_engine_new_payload_status_hourly

Hourly aggregated engine_newPayload status distribution and duration statistics

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_new_payload_status_hourly`
- **sepolia**: `sepolia.fct_engine_new_payload_status_hourly`
- **holesky**: `holesky.fct_engine_new_payload_status_hourly`
- **hoodi**: `hoodi.fct_engine_new_payload_status_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_status_hourly FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_status_hourly FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **hour_start_date_time** | `DateTime` | *Start of the hour period* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **slot_count** | `UInt32` | *Number of slots in this hour aggregation* |
| **observation_count** | `UInt64` | *Total number of observations in this hour* |
| **valid_count** | `UInt64` | *Number of observations with VALID status* |
| **invalid_count** | `UInt64` | *Number of observations with INVALID status* |
| **syncing_count** | `UInt64` | *Number of observations with SYNCING status* |
| **accepted_count** | `UInt64` | *Number of observations with ACCEPTED status* |
| **invalid_block_hash_count** | `UInt64` | *Number of observations with INVALID_BLOCK_HASH status* |
| **valid_pct** | `Float64` | *Percentage of observations with VALID status* |
| **avg_duration_ms** | `UInt64` | *Average duration of engine_newPayload calls in milliseconds* |
| **avg_p50_duration_ms** | `UInt64` | *Average of median durations across slots in milliseconds* |
| **avg_p95_duration_ms** | `UInt64` | *Average of p95 durations across slots in milliseconds* |
| **max_duration_ms** | `UInt64` | *Maximum duration of engine_newPayload calls in milliseconds* |

## fct_execution_state_size_daily

Execution layer state size metrics aggregated by day

### Availability
Data is partitioned by **toYYYYMM(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_state_size_daily`
- **sepolia**: `sepolia.fct_execution_state_size_daily`
- **holesky**: `holesky.fct_execution_state_size_daily`
- **hoodi**: `hoodi.fct_execution_state_size_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_state_size_daily FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_execution_state_size_daily FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **day_start_date** | `Date` | *Start of the day period* |
| **accounts** | `UInt64` | *Total accounts at end of day* |
| **account_bytes** | `UInt64` | *Account bytes at end of day* |
| **account_trienodes** | `UInt64` | *Account trie nodes at end of day* |
| **account_trienode_bytes** | `UInt64` | *Account trie node bytes at end of day* |
| **contract_codes** | `UInt64` | *Contract codes at end of day* |
| **contract_code_bytes** | `UInt64` | *Contract code bytes at end of day* |
| **storages** | `UInt64` | *Storage slots at end of day* |
| **storage_bytes** | `UInt64` | *Storage bytes at end of day* |
| **storage_trienodes** | `UInt64` | *Storage trie nodes at end of day* |
| **storage_trienode_bytes** | `UInt64` | *Storage trie node bytes at end of day* |
| **total_bytes** | `UInt64` | *Total state size in bytes* |

## fct_execution_state_size_hourly

Execution layer state size metrics aggregated by hour

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_state_size_hourly`
- **sepolia**: `sepolia.fct_execution_state_size_hourly`
- **holesky**: `holesky.fct_execution_state_size_hourly`
- **hoodi**: `hoodi.fct_execution_state_size_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_state_size_hourly FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_execution_state_size_hourly FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **hour_start_date_time** | `DateTime` | *Start of the hour period* |
| **accounts** | `UInt64` | *Total accounts at end of hour* |
| **account_bytes** | `UInt64` | *Account bytes at end of hour* |
| **account_trienodes** | `UInt64` | *Account trie nodes at end of hour* |
| **account_trienode_bytes** | `UInt64` | *Account trie node bytes at end of hour* |
| **contract_codes** | `UInt64` | *Contract codes at end of hour* |
| **contract_code_bytes** | `UInt64` | *Contract code bytes at end of hour* |
| **storages** | `UInt64` | *Storage slots at end of hour* |
| **storage_bytes** | `UInt64` | *Storage bytes at end of hour* |
| **storage_trienodes** | `UInt64` | *Storage trie nodes at end of hour* |
| **storage_trienode_bytes** | `UInt64` | *Storage trie node bytes at end of hour* |
| **total_bytes** | `UInt64` | *Total state size in bytes* |

## fct_head_first_seen_by_node

When the head event was first seen on the network by a sentry node

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_head_first_seen_by_node`
- **sepolia**: `sepolia.fct_head_first_seen_by_node`
- **holesky**: `holesky.fct_head_first_seen_by_node`
- **hoodi**: `hoodi.fct_head_first_seen_by_node`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_head_first_seen_by_node FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_head_first_seen_by_node FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **source** | `LowCardinality(String)` | *Source of the event* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **seen_slot_start_diff** | `UInt32` | *The time from slot start for the client to see the head event* |
| **block_root** | `String` | *The head block root hash* |
| **username** | `LowCardinality(String)` | *Username of the node* |
| **node_id** | `String` | *ID of the node* |
| **classification** | `LowCardinality(String)` | *Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation* |

## fct_mev_bid_count_by_builder

Total number of MEV builder bids for a slot

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_mev_bid_count_by_builder`
- **sepolia**: `sepolia.fct_mev_bid_count_by_builder`
- **holesky**: `holesky.fct_mev_bid_count_by_builder`
- **hoodi**: `hoodi.fct_mev_bid_count_by_builder`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_mev_bid_count_by_builder FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_mev_bid_count_by_builder FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block bid* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the bid is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the bid is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the bid is for* |
| **builder_pubkey** | `String` | *The relay that the bid was fetched from* |
| **bid_total** | `UInt32` | *The total number of bids from the builder* |

## fct_mev_bid_count_by_relay

Total number of MEV relay bids for a slot by relay

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_mev_bid_count_by_relay`
- **sepolia**: `sepolia.fct_mev_bid_count_by_relay`
- **holesky**: `holesky.fct_mev_bid_count_by_relay`
- **hoodi**: `hoodi.fct_mev_bid_count_by_relay`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_mev_bid_count_by_relay FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_mev_bid_count_by_relay FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block bid* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the bid is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the bid is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the bid is for* |
| **relay_name** | `String` | *The relay that the bid was fetched from* |
| **bid_total** | `UInt32` | *The total number of bids for the relay* |

## fct_mev_bid_highest_value_by_builder_chunked_50ms

Highest value bid from each builder per slot broken down by 50ms chunks. Each block_hash appears in the chunk determined by its earliest bid timestamp. Only includes bids within -12000ms to +12000ms of slot start time

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_mev_bid_highest_value_by_builder_chunked_50ms`
- **sepolia**: `sepolia.fct_mev_bid_highest_value_by_builder_chunked_50ms`
- **holesky**: `holesky.fct_mev_bid_highest_value_by_builder_chunked_50ms`
- **hoodi**: `hoodi.fct_mev_bid_highest_value_by_builder_chunked_50ms`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_mev_bid_highest_value_by_builder_chunked_50ms FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_mev_bid_highest_value_by_builder_chunked_50ms FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block bid* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the bid is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the bid is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the bid is for* |
| **chunk_slot_start_diff** | `Int32` | *The difference between the chunk start time and slot_start_date_time. "1500" would mean the earliest bid for this block_hash was between 1500ms and 1550ms into the slot. Negative values indicate bids received before slot start* |
| **earliest_bid_date_time** | `DateTime64(3)` | *The timestamp of the earliest bid for this block_hash from this builder* |
| **relay_names** | `Array(String)` | *The relay that the bid was fetched from* |
| **block_hash** | `FixedString(66)` | *The execution block hash of the bid* |
| **builder_pubkey** | `String` | *The builder pubkey of the bid* |
| **value** | `UInt128` | *The transaction value in wei* |

## fct_node_active_last_24h

Active nodes for the network

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_node_active_last_24h`
- **sepolia**: `sepolia.fct_node_active_last_24h`
- **holesky**: `holesky.fct_node_active_last_24h`
- **hoodi**: `hoodi.fct_node_active_last_24h`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_node_active_last_24h FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_node_active_last_24h FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **last_seen_date_time** | `DateTime` | *Timestamp when the node was last seen* |
| **username** | `String` | *Username of the node* |
| **node_id** | `String` | *ID of the node* |
| **classification** | `String` | *Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation* |

## fct_prepared_block

Prepared block proposals showing what would have been built if the validator had been selected as proposer

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_prepared_block`
- **sepolia**: `sepolia.fct_prepared_block`
- **holesky**: `holesky.fct_prepared_block`
- **hoodi**: `hoodi.fct_prepared_block`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_prepared_block FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_prepared_block FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **event_date_time** | `DateTime` | *The wall clock time when the event was received* |
| **meta_client_name** | `String` | *Name of the client that generated the event* |
| **meta_client_version** | `String` | *Version of the client that generated the event* |
| **meta_client_implementation** | `String` | *Implementation of the client that generated the event* |
| **meta_consensus_implementation** | `String` | *Consensus implementation of the validator* |
| **meta_consensus_version** | `String` | *Consensus version of the validator* |
| **meta_client_geo_city** | `String` | *City of the client that generated the event* |
| **meta_client_geo_country** | `String` | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | `String` | *Country code of the client that generated the event* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **execution_payload_value** | `Nullable(UInt64)` | *The value of the execution payload in wei* |
| **consensus_payload_value** | `Nullable(UInt64)` | *The value of the consensus payload in wei* |
| **execution_payload_block_number** | `UInt32` | *The block number of the execution payload* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |

## fct_storage_slot_state

Cumulative storage slot state per block - tracks active slots and effective bytes with per-block deltas

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state`
- **sepolia**: `sepolia.fct_storage_slot_state`
- **holesky**: `holesky.fct_storage_slot_state`
- **hoodi**: `hoodi.fct_storage_slot_state`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_storage_slot_state FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number* |
| **slots_delta** | `Int32` | *Change in active slots for this block (positive=activated, negative=deactivated)* |
| **bytes_delta** | `Int64` | *Change in effective bytes for this block* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at this block* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes across all active slots at this block* |

## fct_storage_slot_state_daily

Storage slot state metrics aggregated by day

### Availability
Data is partitioned by **toYYYYMM(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_daily`
- **sepolia**: `sepolia.fct_storage_slot_state_daily`
- **holesky**: `holesky.fct_storage_slot_state_daily`
- **hoodi**: `hoodi.fct_storage_slot_state_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_daily FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_daily FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **day_start_date** | `Date` | *Start of the day period* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of day* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of day* |

## fct_storage_slot_state_hourly

Storage slot state metrics aggregated by hour

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_hourly`
- **sepolia**: `sepolia.fct_storage_slot_state_hourly`
- **holesky**: `holesky.fct_storage_slot_state_hourly`
- **hoodi**: `hoodi.fct_storage_slot_state_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_hourly FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_hourly FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **hour_start_date_time** | `DateTime` | *Start of the hour period* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of hour* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of hour* |

## fct_storage_slot_state_with_expiry_by_6m

Cumulative storage slot state per block with 6-month expiry policy applied - slots unused for 6 months are cleared

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_with_expiry_by_6m`
- **sepolia**: `sepolia.fct_storage_slot_state_with_expiry_by_6m`
- **holesky**: `holesky.fct_storage_slot_state_with_expiry_by_6m`
- **hoodi**: `hoodi.fct_storage_slot_state_with_expiry_by_6m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_with_expiry_by_6m FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_with_expiry_by_6m FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number* |
| **net_slots_delta** | `Int32` | *Net slot adjustment this block (negative=expiry, positive=reactivation)* |
| **net_bytes_delta** | `Int64` | *Net bytes adjustment this block (negative=expiry, positive=reactivation)* |
| **cumulative_net_slots** | `Int64` | *Cumulative net slot adjustment up to this block* |
| **cumulative_net_bytes** | `Int64` | *Cumulative net bytes adjustment up to this block* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at this block (with 6-month expiry applied)* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes across all active slots at this block (with 6-month expiry applied)* |

## fct_storage_slot_state_with_expiry_by_6m_daily

Storage slot state metrics with 6-month expiry policy aggregated by day

### Availability
Data is partitioned by **toYYYYMM(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_with_expiry_by_6m_daily`
- **sepolia**: `sepolia.fct_storage_slot_state_with_expiry_by_6m_daily`
- **holesky**: `holesky.fct_storage_slot_state_with_expiry_by_6m_daily`
- **hoodi**: `hoodi.fct_storage_slot_state_with_expiry_by_6m_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_with_expiry_by_6m_daily FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_with_expiry_by_6m_daily FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **day_start_date** | `Date` | *Start of the day period* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of day (with 6m expiry policy)* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of day (with 6m expiry policy)* |

## fct_storage_slot_state_with_expiry_by_6m_hourly

Storage slot state metrics with 6-month expiry policy aggregated by hour

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_with_expiry_by_6m_hourly`
- **sepolia**: `sepolia.fct_storage_slot_state_with_expiry_by_6m_hourly`
- **holesky**: `holesky.fct_storage_slot_state_with_expiry_by_6m_hourly`
- **hoodi**: `hoodi.fct_storage_slot_state_with_expiry_by_6m_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_with_expiry_by_6m_hourly FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_with_expiry_by_6m_hourly FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **hour_start_date_time** | `DateTime` | *Start of the hour period* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of hour (with 6m expiry policy)* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of hour (with 6m expiry policy)* |

## helper_storage_slot_next_touch_latest_state

Latest state per storage slot for efficient lookups. Helper table for int_storage_slot_next_touch.

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.helper_storage_slot_next_touch_latest_state`
- **sepolia**: `sepolia.helper_storage_slot_next_touch_latest_state`
- **holesky**: `holesky.helper_storage_slot_next_touch_latest_state`
- **hoodi**: `hoodi.helper_storage_slot_next_touch_latest_state`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.helper_storage_slot_next_touch_latest_state FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.helper_storage_slot_next_touch_latest_state FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **block_number** | `UInt32` | *The block number of the latest touch for this slot* |
| **next_touch_block** | `Nullable(UInt32)` | *The next block where this slot was touched (NULL if no subsequent touch yet)* |

## int_address_first_access

Table for accounts first access data

### Availability
Data is partitioned by **cityHash64(address) % 16**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_address_first_access`
- **sepolia**: `sepolia.int_address_first_access`
- **holesky**: `holesky.int_address_first_access`
- **hoodi**: `hoodi.int_address_first_access`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_address_first_access FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_address_first_access FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **address** | `String` | *The address of the account* |
| **block_number** | `UInt32` | *The block number of the first access* |
| **version** | `UInt32` | *Version for this address, for internal use in clickhouse to keep first access* |

## int_address_last_access

Table for accounts last access data

### Availability
Data is partitioned by **cityHash64(address) % 16**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_address_last_access`
- **sepolia**: `sepolia.int_address_last_access`
- **holesky**: `holesky.int_address_last_access`
- **hoodi**: `hoodi.int_address_last_access`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_address_last_access FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_address_last_access FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **address** | `String` | *The address of the account* |
| **block_number** | `UInt32` | *The block number of the last access* |

## int_address_storage_slot_first_access

Table for storage first access data

### Availability
Data is partitioned by **cityHash64(address) % 16**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_address_storage_slot_first_access`
- **sepolia**: `sepolia.int_address_storage_slot_first_access`
- **holesky**: `holesky.int_address_storage_slot_first_access`
- **hoodi**: `hoodi.int_address_storage_slot_first_access`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_address_storage_slot_first_access FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_address_storage_slot_first_access FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **address** | `String` | *The address of the account* |
| **slot_key** | `String` | *The slot key of the storage* |
| **block_number** | `UInt32` | *The block number of the first access* |
| **value** | `String` | *The value of the storage* |
| **version** | `UInt32` | *Version for this address + slot key, for internal use in clickhouse to keep first access* |

## int_address_storage_slot_last_access

Table for storage last access data

### Availability
Data is partitioned by **cityHash64(address) % 16**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_address_storage_slot_last_access`
- **sepolia**: `sepolia.int_address_storage_slot_last_access`
- **holesky**: `holesky.int_address_storage_slot_last_access`
- **hoodi**: `hoodi.int_address_storage_slot_last_access`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_address_storage_slot_last_access FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_address_storage_slot_last_access FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **address** | `String` | *The address of the account* |
| **slot_key** | `String` | *The slot key of the storage* |
| **block_number** | `UInt32` | *The block number of the last access* |
| **value** | `String` | *The value of the storage* |

## int_attestation_attested_canonical

Attested head of a block for the unfinalized chain.

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_attestation_attested_canonical`
- **sepolia**: `sepolia.int_attestation_attested_canonical`
- **holesky**: `holesky.int_attestation_attested_canonical`
- **hoodi**: `hoodi.int_attestation_attested_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_attestation_attested_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_attestation_attested_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **source_epoch** | `UInt32` | *The source epoch number in the attestation group* |
| **source_epoch_start_date_time** | `DateTime` | *The wall clock time when the source epoch started* |
| **source_root** | `FixedString(66)` | *The source beacon block root hash in the attestation group* |
| **target_epoch** | `UInt32` | *The target epoch number in the attestation group* |
| **target_epoch_start_date_time** | `DateTime` | *The wall clock time when the target epoch started* |
| **target_root** | `FixedString(66)` | *The target beacon block root hash in the attestation group* |
| **block_root** | `String` | *The beacon block root hash* |
| **attesting_validator_index** | `UInt32` | *The index of the validator attesting* |
| **inclusion_distance** | `UInt32` | *The distance from the slot when the attestation was included* |

## int_attestation_attested_head

Attested head of a block for the unfinalized chain.

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_attestation_attested_head`
- **sepolia**: `sepolia.int_attestation_attested_head`
- **holesky**: `holesky.int_attestation_attested_head`
- **hoodi**: `hoodi.int_attestation_attested_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_attestation_attested_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_attestation_attested_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **source_epoch** | `UInt32` | *The source epoch number in the attestation group* |
| **source_epoch_start_date_time** | `DateTime` | *The wall clock time when the source epoch started* |
| **source_root** | `FixedString(66)` | *The source beacon block root hash in the attestation group* |
| **target_epoch** | `UInt32` | *The target epoch number in the attestation group* |
| **target_epoch_start_date_time** | `DateTime` | *The wall clock time when the target epoch started* |
| **target_root** | `FixedString(66)` | *The target beacon block root hash in the attestation group* |
| **block_root** | `String` | *The beacon block root hash* |
| **attesting_validator_index** | `UInt32` | *The index of the validator attesting* |
| **propagation_distance** | `UInt32` | *The distance from the slot when the attestation was propagated. 0 means the attestation was propagated within the same slot as its duty was assigned, 1 means the attestation was propagated within the next slot, etc.* |

## int_attestation_first_seen

When the attestation was first seen on the network by a sentry node

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_attestation_first_seen`
- **sepolia**: `sepolia.int_attestation_first_seen`
- **holesky**: `holesky.int_attestation_first_seen`
- **hoodi**: `hoodi.int_attestation_first_seen`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_attestation_first_seen FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_attestation_first_seen FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **source** | `LowCardinality(String)` | *Source of the event* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **seen_slot_start_diff** | `UInt32` | *The time from slot start for the client to see the block* |
| **block_root** | `String` | *The beacon block root hash* |
| **attesting_validator_index** | `UInt32` | *The index of the validator attesting* |
| **attesting_validator_committee_index** | `LowCardinality(String)` | *The committee index of the attesting validator* |
| **username** | `LowCardinality(String)` | *Username of the node* |
| **node_id** | `String` | *ID of the node* |
| **classification** | `LowCardinality(String)` | *Classification of the node, e.g. "individual", "corporate", "internal" (aka ethPandaOps) or "unclassified"* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_consensus_version** | `LowCardinality(String)` | *Ethereum consensus client version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Ethereum consensus client implementation* |

## int_beacon_committee_head

Beacon committee head for the unfinalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_beacon_committee_head`
- **sepolia**: `sepolia.int_beacon_committee_head`
- **holesky**: `holesky.int_beacon_committee_head`
- **hoodi**: `hoodi.int_beacon_committee_head`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_beacon_committee_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_beacon_committee_head FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **committee_index** | `LowCardinality(String)` | *The committee index in the beacon API committee payload* |
| **validators** | `Array(UInt32)` | *The validator indices in the beacon API committee payload* |

## int_block_blob_count_canonical

Blob count of a block for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_block_blob_count_canonical`
- **sepolia**: `sepolia.int_block_blob_count_canonical`
- **holesky**: `holesky.int_block_blob_count_canonical`
- **hoodi**: `hoodi.int_block_blob_count_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_block_blob_count_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_block_blob_count_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `String` | *The beacon block root hash* |
| **blob_count** | `UInt32` | *The number of blobs in the block* |

## int_block_canonical

Block details for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_block_canonical`
- **sepolia**: `sepolia.int_block_canonical`
- **holesky**: `holesky.int_block_canonical`
- **hoodi**: `hoodi.int_block_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_block_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_block_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the reorg slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **parent_root** | `FixedString(66)` | *The root hash of the parent beacon block* |
| **state_root** | `FixedString(66)` | *The root hash of the beacon state at this block* |
| **proposer_index** | `UInt32` | *The index of the validator that proposed the beacon block* |
| **eth1_data_block_hash** | `FixedString(66)` | *The block hash of the associated execution block* |
| **eth1_data_deposit_root** | `FixedString(66)` | *The root of the deposit tree in the associated execution block* |
| **execution_payload_block_hash** | `FixedString(66)` | *The block hash of the execution payload* |
| **execution_payload_block_number** | `UInt32` | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | `String` | *The recipient of the fee for this execution payload* |
| **execution_payload_base_fee_per_gas** | `Nullable(UInt128)` | *Base fee per gas for execution payload* |
| **execution_payload_blob_gas_used** | `Nullable(UInt64)` | *Gas used for blobs in execution payload* |
| **execution_payload_excess_blob_gas** | `Nullable(UInt64)` | *Excess gas used for blobs in execution payload* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_state_root** | `FixedString(66)` | *The state root of the execution payload* |
| **execution_payload_parent_hash** | `FixedString(66)` | *The parent hash of the execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |
| **execution_payload_transactions_total_bytes_compressed** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload when compressed using snappy* |

## int_block_mev_canonical

MEV relay proposer payload delivered for a block on the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_block_mev_canonical`
- **sepolia**: `sepolia.int_block_mev_canonical`
- **holesky**: `holesky.int_block_mev_canonical`
- **hoodi**: `hoodi.int_block_mev_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_block_mev_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_block_mev_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number within the block proposer payload* |
| **slot_start_date_time** | `DateTime` | *The start time for the slot that the proposer payload is for* |
| **epoch** | `UInt32` | *Epoch number derived from the slot that the proposer payload is for* |
| **epoch_start_date_time** | `DateTime` | *The start time for the epoch that the proposer payload is for* |
| **block_root** | `String` | *The root hash of the beacon block* |
| **earliest_bid_date_time** | `Nullable(DateTime64(3))` | *The earliest timestamp of the accepted bid in milliseconds* |
| **relay_names** | `Array(String)` | *The relay names that delivered the proposer payload* |
| **parent_hash** | `FixedString(66)` | *The parent hash of the proposer payload* |
| **block_number** | `UInt64` | *The block number of the proposer payload* |
| **block_hash** | `FixedString(66)` | *The block hash of the proposer payload* |
| **builder_pubkey** | `String` | *The builder pubkey of the proposer payload* |
| **proposer_pubkey** | `String` | *The proposer pubkey of the proposer payload* |
| **proposer_fee_recipient** | `FixedString(42)` | *The proposer fee recipient of the proposer payload* |
| **gas_limit** | `UInt64` | *The gas limit of the proposer payload* |
| **gas_used** | `UInt64` | *The gas used of the proposer payload* |
| **value** | `Nullable(UInt128)` | *The transaction value in wei* |
| **transaction_count** | `UInt32` | *The number of transactions in the proposer payload* |

## int_block_proposer_canonical

Block proposers for the finalized chain

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_block_proposer_canonical`
- **sepolia**: `sepolia.int_block_proposer_canonical`
- **holesky**: `holesky.int_block_proposer_canonical`
- **hoodi**: `hoodi.int_block_proposer_canonical`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_block_proposer_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_block_proposer_canonical FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **proposer_validator_index** | `UInt32` | *The validator index of the proposer for the slot* |
| **proposer_pubkey** | `String` | *The public key of the validator proposer* |
| **block_root** | `Nullable(String)` | *The beacon block root hash. Null if a slot was missed* |

## int_custody_probe

Custody probe results per slot with aggregated column indices

### Availability
Data is partitioned by **toYYYYMM(probe_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_custody_probe`
- **sepolia**: `sepolia.int_custody_probe`
- **holesky**: `holesky.int_custody_probe`
- **hoodi**: `hoodi.int_custody_probe`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_custody_probe FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_custody_probe FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **probe_date_time** | `DateTime` | *Earliest event time for this probe batch* |
| **slot** | `UInt32` | *Slot number* |
| **slot_start_date_time** | `DateTime` | *Start date time of the slot* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer* |
| **result** | `LowCardinality(String)` | *Result of the probe (success, failure, missing)* |
| **error** | `String` | *Error message if probe failed* |
| **column_indices** | `Array(UInt64)` | *Array of column indices probed* |
| **blob_submitters** | `Array(String)` | *Array of blob submitter names for this slot (Unknown if not found)* |
| **response_time_ms** | `Int32` | *Response time in milliseconds* |
| **username** | `LowCardinality(String)` | *Username extracted from client name* |
| **node_id** | `LowCardinality(String)` | *Node ID extracted from client name* |
| **classification** | `LowCardinality(String)` | *Classification of client (individual, corporate, internal, unclassified)* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_os** | `LowCardinality(String)` | *Operating system of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_peer_implementation** | `LowCardinality(String)` | *Implementation of the probed peer* |
| **meta_peer_version** | `LowCardinality(String)` | *Version of the probed peer* |
| **meta_peer_platform** | `LowCardinality(String)` | *Platform of the probed peer* |
| **meta_peer_geo_city** | `LowCardinality(String)` | *City of the probed peer* |
| **meta_peer_geo_country** | `LowCardinality(String)` | *Country of the probed peer* |
| **meta_peer_geo_country_code** | `LowCardinality(String)` | *Country code of the probed peer* |
| **meta_peer_geo_continent_code** | `LowCardinality(String)` | *Continent code of the probed peer* |
| **meta_peer_geo_longitude** | `Nullable(Float64)` | *Longitude of the probed peer* |
| **meta_peer_geo_latitude** | `Nullable(Float64)` | *Latitude of the probed peer* |
| **meta_peer_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the probed peer* |
| **meta_peer_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the probed peer* |

## int_custody_probe_order_by_slot

Custody probe results per slot with aggregated column indices

### Availability
Data is partitioned by **toYYYYMM(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_custody_probe_order_by_slot`
- **sepolia**: `sepolia.int_custody_probe_order_by_slot`
- **holesky**: `holesky.int_custody_probe_order_by_slot`
- **hoodi**: `hoodi.int_custody_probe_order_by_slot`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_custody_probe_order_by_slot FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_custody_probe_order_by_slot FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **probe_date_time** | `DateTime` | *Earliest event time for this probe batch* |
| **slot** | `UInt32` | *Slot number* |
| **slot_start_date_time** | `DateTime` | *Start date time of the slot* |
| **peer_id_unique_key** | `Int64` | *Unique key associated with the identifier of the peer* |
| **result** | `LowCardinality(String)` | *Result of the probe (success, failure, missing)* |
| **error** | `String` | *Error message if probe failed* |
| **column_indices** | `Array(UInt64)` | *Array of column indices probed* |
| **blob_submitters** | `Array(String)` | *Array of blob submitter names for this slot (Unknown if not found)* |
| **response_time_ms** | `Int32` | *Response time in milliseconds* |
| **username** | `LowCardinality(String)` | *Username extracted from client name* |
| **node_id** | `LowCardinality(String)` | *Node ID extracted from client name* |
| **classification** | `LowCardinality(String)` | *Classification of client (individual, corporate, internal, unclassified)* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_os** | `LowCardinality(String)` | *Operating system of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client* |
| **meta_peer_implementation** | `LowCardinality(String)` | *Implementation of the probed peer* |
| **meta_peer_version** | `LowCardinality(String)` | *Version of the probed peer* |
| **meta_peer_platform** | `LowCardinality(String)` | *Platform of the probed peer* |
| **meta_peer_geo_city** | `LowCardinality(String)` | *City of the probed peer* |
| **meta_peer_geo_country** | `LowCardinality(String)` | *Country of the probed peer* |
| **meta_peer_geo_country_code** | `LowCardinality(String)` | *Country code of the probed peer* |
| **meta_peer_geo_continent_code** | `LowCardinality(String)` | *Continent code of the probed peer* |
| **meta_peer_geo_longitude** | `Nullable(Float64)` | *Longitude of the probed peer* |
| **meta_peer_geo_latitude** | `Nullable(Float64)` | *Latitude of the probed peer* |
| **meta_peer_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the probed peer* |
| **meta_peer_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the probed peer* |

## int_execution_block_by_date

Execution blocks ordered by timestamp for efficient date range lookups

### Availability
Data is partitioned by **toYYYYMM(block_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_execution_block_by_date`
- **sepolia**: `sepolia.int_execution_block_by_date`
- **holesky**: `holesky.int_execution_block_by_date`
- **hoodi**: `hoodi.int_execution_block_by_date`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_execution_block_by_date FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_execution_block_by_date FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_date_time** | `DateTime64(3)` | *The block timestamp* |
| **block_number** | `UInt64` | *The block number* |

## int_storage_slot_diff

Storage slot diffs aggregated per block - stores effective bytes from first and last value per address/slot

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_diff`
- **sepolia**: `sepolia.int_storage_slot_diff`
- **holesky**: `holesky.int_storage_slot_diff`
- **hoodi**: `hoodi.int_storage_slot_diff`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_diff FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_storage_slot_diff FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **effective_bytes_from** | `UInt8` | *Number of effective bytes in the first from_value of the block (0-32)* |
| **effective_bytes_to** | `UInt8` | *Number of effective bytes in the last to_value of the block (0-32)* |

## int_storage_slot_diff_by_address_slot

Storage slot diffs aggregated per block - stores effective bytes from first and last value per address/slot

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_diff_by_address_slot`
- **sepolia**: `sepolia.int_storage_slot_diff_by_address_slot`
- **holesky**: `holesky.int_storage_slot_diff_by_address_slot`
- **hoodi**: `hoodi.int_storage_slot_diff_by_address_slot`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_diff_by_address_slot FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_storage_slot_diff_by_address_slot FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **effective_bytes_from** | `UInt8` | *Number of effective bytes in the first from_value of the block (0-32)* |
| **effective_bytes_to** | `UInt8` | *Number of effective bytes in the last to_value of the block (0-32)* |

## int_storage_slot_expiry_by_6m

Storage slot expiries - records slots that were set 6 months ago and are now candidates for clearing

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_expiry_by_6m`
- **sepolia**: `sepolia.int_storage_slot_expiry_by_6m`
- **holesky**: `holesky.int_storage_slot_expiry_by_6m`
- **hoodi**: `hoodi.int_storage_slot_expiry_by_6m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_expiry_by_6m FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_storage_slot_expiry_by_6m FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot expiry is recorded (6 months after it was set)* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **effective_bytes** | `UInt8` | *Number of effective bytes that were set and are now being marked for expiry (0-32)* |

## int_storage_slot_next_touch

Storage slot touches with precomputed next touch block - ordered by block_number for efficient range queries

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_next_touch`
- **sepolia**: `sepolia.int_storage_slot_next_touch`
- **holesky**: `holesky.int_storage_slot_next_touch`
- **hoodi**: `hoodi.int_storage_slot_next_touch`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_next_touch FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_storage_slot_next_touch FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot was touched* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **next_touch_block** | `Nullable(UInt32)` | *The next block number where this slot was touched (NULL if no subsequent touch)* |

## int_storage_slot_reactivation_by_6m

Storage slot reactivations/cancellations - records slots that were touched after 6+ months of inactivity, undoing their expiry

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_reactivation_by_6m`
- **sepolia**: `sepolia.int_storage_slot_reactivation_by_6m`
- **holesky**: `holesky.int_storage_slot_reactivation_by_6m`
- **hoodi**: `hoodi.int_storage_slot_reactivation_by_6m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_reactivation_by_6m FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_storage_slot_reactivation_by_6m FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot was reactivated/cancelled (touched after 6+ months of inactivity)* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **effective_bytes** | `UInt8` | *Number of effective bytes being reactivated (must match corresponding expiry record)* |

## int_storage_slot_read

Storage slot reads aggregated per block - tracks which slots were read per address

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_read`
- **sepolia**: `sepolia.int_storage_slot_read`
- **holesky**: `holesky.int_storage_slot_read`
- **hoodi**: `hoodi.int_storage_slot_read`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_read FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM mainnet.int_storage_slot_read FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |

<!-- schema_end -->
