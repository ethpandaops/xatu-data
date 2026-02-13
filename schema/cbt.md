
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
- [`dim_contract_owner`](#dim_contract_owner)
- [`dim_function_signature`](#dim_function_signature)
- [`dim_node`](#dim_node)
- [`dim_validator_pubkey`](#dim_validator_pubkey)
- [`dim_validator_status`](#dim_validator_status)
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
- [`fct_attestation_inclusion_delay_daily`](#fct_attestation_inclusion_delay_daily)
- [`fct_attestation_inclusion_delay_hourly`](#fct_attestation_inclusion_delay_hourly)
- [`fct_attestation_liveness_by_entity_head`](#fct_attestation_liveness_by_entity_head)
- [`fct_attestation_observation_by_node`](#fct_attestation_observation_by_node)
- [`fct_attestation_participation_rate_daily`](#fct_attestation_participation_rate_daily)
- [`fct_attestation_participation_rate_hourly`](#fct_attestation_participation_rate_hourly)
- [`fct_attestation_vote_correctness_by_validator`](#fct_attestation_vote_correctness_by_validator)
- [`fct_attestation_vote_correctness_by_validator_daily`](#fct_attestation_vote_correctness_by_validator_daily)
- [`fct_attestation_vote_correctness_by_validator_hourly`](#fct_attestation_vote_correctness_by_validator_hourly)
- [`fct_blob_count_daily`](#fct_blob_count_daily)
- [`fct_blob_count_hourly`](#fct_blob_count_hourly)
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
- [`fct_block_proposal_status_daily`](#fct_block_proposal_status_daily)
- [`fct_block_proposal_status_hourly`](#fct_block_proposal_status_hourly)
- [`fct_block_proposer`](#fct_block_proposer)
- [`fct_block_proposer_by_validator`](#fct_block_proposer_by_validator)
- [`fct_block_proposer_entity`](#fct_block_proposer_entity)
- [`fct_block_proposer_head`](#fct_block_proposer_head)
- [`fct_contract_storage_state_by_address_daily`](#fct_contract_storage_state_by_address_daily)
- [`fct_contract_storage_state_by_address_hourly`](#fct_contract_storage_state_by_address_hourly)
- [`fct_contract_storage_state_by_block_daily`](#fct_contract_storage_state_by_block_daily)
- [`fct_contract_storage_state_by_block_hourly`](#fct_contract_storage_state_by_block_hourly)
- [`fct_contract_storage_state_with_expiry_by_address_daily`](#fct_contract_storage_state_with_expiry_by_address_daily)
- [`fct_contract_storage_state_with_expiry_by_address_hourly`](#fct_contract_storage_state_with_expiry_by_address_hourly)
- [`fct_contract_storage_state_with_expiry_by_block_daily`](#fct_contract_storage_state_with_expiry_by_block_daily)
- [`fct_contract_storage_state_with_expiry_by_block_hourly`](#fct_contract_storage_state_with_expiry_by_block_hourly)
- [`fct_data_column_availability_by_epoch`](#fct_data_column_availability_by_epoch)
- [`fct_data_column_availability_by_slot`](#fct_data_column_availability_by_slot)
- [`fct_data_column_availability_by_slot_blob`](#fct_data_column_availability_by_slot_blob)
- [`fct_data_column_availability_daily`](#fct_data_column_availability_daily)
- [`fct_data_column_availability_hourly`](#fct_data_column_availability_hourly)
- [`fct_engine_get_blobs_by_el_client`](#fct_engine_get_blobs_by_el_client)
- [`fct_engine_get_blobs_by_el_client_hourly`](#fct_engine_get_blobs_by_el_client_hourly)
- [`fct_engine_get_blobs_by_slot`](#fct_engine_get_blobs_by_slot)
- [`fct_engine_get_blobs_duration_chunked_50ms`](#fct_engine_get_blobs_duration_chunked_50ms)
- [`fct_engine_new_payload_by_el_client`](#fct_engine_new_payload_by_el_client)
- [`fct_engine_new_payload_by_el_client_hourly`](#fct_engine_new_payload_by_el_client_hourly)
- [`fct_engine_new_payload_by_slot`](#fct_engine_new_payload_by_slot)
- [`fct_engine_new_payload_duration_chunked_50ms`](#fct_engine_new_payload_duration_chunked_50ms)
- [`fct_engine_new_payload_winrate_daily`](#fct_engine_new_payload_winrate_daily)
- [`fct_engine_new_payload_winrate_hourly`](#fct_engine_new_payload_winrate_hourly)
- [`fct_execution_gas_limit_daily`](#fct_execution_gas_limit_daily)
- [`fct_execution_gas_limit_hourly`](#fct_execution_gas_limit_hourly)
- [`fct_execution_gas_limit_signalling_daily`](#fct_execution_gas_limit_signalling_daily)
- [`fct_execution_gas_limit_signalling_hourly`](#fct_execution_gas_limit_signalling_hourly)
- [`fct_execution_gas_used_daily`](#fct_execution_gas_used_daily)
- [`fct_execution_gas_used_hourly`](#fct_execution_gas_used_hourly)
- [`fct_execution_state_size_daily`](#fct_execution_state_size_daily)
- [`fct_execution_state_size_hourly`](#fct_execution_state_size_hourly)
- [`fct_execution_tps_daily`](#fct_execution_tps_daily)
- [`fct_execution_tps_hourly`](#fct_execution_tps_hourly)
- [`fct_execution_transactions_daily`](#fct_execution_transactions_daily)
- [`fct_execution_transactions_hourly`](#fct_execution_transactions_hourly)
- [`fct_head_first_seen_by_node`](#fct_head_first_seen_by_node)
- [`fct_head_vote_correctness_rate_daily`](#fct_head_vote_correctness_rate_daily)
- [`fct_head_vote_correctness_rate_hourly`](#fct_head_vote_correctness_rate_hourly)
- [`fct_mev_bid_count_by_builder`](#fct_mev_bid_count_by_builder)
- [`fct_mev_bid_count_by_relay`](#fct_mev_bid_count_by_relay)
- [`fct_mev_bid_highest_value_by_builder_chunked_50ms`](#fct_mev_bid_highest_value_by_builder_chunked_50ms)
- [`fct_missed_slot_rate_daily`](#fct_missed_slot_rate_daily)
- [`fct_missed_slot_rate_hourly`](#fct_missed_slot_rate_hourly)
- [`fct_node_active_last_24h`](#fct_node_active_last_24h)
- [`fct_node_cpu_utilization_by_process`](#fct_node_cpu_utilization_by_process)
- [`fct_node_disk_io_by_process`](#fct_node_disk_io_by_process)
- [`fct_node_memory_usage_by_process`](#fct_node_memory_usage_by_process)
- [`fct_node_network_io_by_process`](#fct_node_network_io_by_process)
- [`fct_opcode_gas_by_opcode_daily`](#fct_opcode_gas_by_opcode_daily)
- [`fct_opcode_gas_by_opcode_hourly`](#fct_opcode_gas_by_opcode_hourly)
- [`fct_opcode_ops_daily`](#fct_opcode_ops_daily)
- [`fct_opcode_ops_hourly`](#fct_opcode_ops_hourly)
- [`fct_prepared_block`](#fct_prepared_block)
- [`fct_proposer_reward_daily`](#fct_proposer_reward_daily)
- [`fct_proposer_reward_hourly`](#fct_proposer_reward_hourly)
- [`fct_reorg_daily`](#fct_reorg_daily)
- [`fct_reorg_hourly`](#fct_reorg_hourly)
- [`fct_storage_slot_state_by_address_daily`](#fct_storage_slot_state_by_address_daily)
- [`fct_storage_slot_state_by_address_hourly`](#fct_storage_slot_state_by_address_hourly)
- [`fct_storage_slot_state_by_block_daily`](#fct_storage_slot_state_by_block_daily)
- [`fct_storage_slot_state_by_block_hourly`](#fct_storage_slot_state_by_block_hourly)
- [`fct_storage_slot_state_with_expiry_by_address_daily`](#fct_storage_slot_state_with_expiry_by_address_daily)
- [`fct_storage_slot_state_with_expiry_by_address_hourly`](#fct_storage_slot_state_with_expiry_by_address_hourly)
- [`fct_storage_slot_state_with_expiry_by_block_daily`](#fct_storage_slot_state_with_expiry_by_block_daily)
- [`fct_storage_slot_state_with_expiry_by_block_hourly`](#fct_storage_slot_state_with_expiry_by_block_hourly)
- [`fct_storage_slot_top_100_by_bytes`](#fct_storage_slot_top_100_by_bytes)
- [`fct_storage_slot_top_100_by_slots`](#fct_storage_slot_top_100_by_slots)
- [`fct_sync_committee_participation_by_validator`](#fct_sync_committee_participation_by_validator)
- [`fct_sync_committee_participation_by_validator_daily`](#fct_sync_committee_participation_by_validator_daily)
- [`fct_sync_committee_participation_by_validator_hourly`](#fct_sync_committee_participation_by_validator_hourly)
- [`fct_validator_balance`](#fct_validator_balance)
- [`fct_validator_balance_daily`](#fct_validator_balance_daily)
- [`fct_validator_balance_hourly`](#fct_validator_balance_hourly)
- [`helper_contract_storage_next_touch_latest_state`](#helper_contract_storage_next_touch_latest_state)
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
- [`int_block_opcode_gas`](#int_block_opcode_gas)
- [`int_block_proposer_canonical`](#int_block_proposer_canonical)
- [`int_contract_creation`](#int_contract_creation)
- [`int_contract_selfdestruct`](#int_contract_selfdestruct)
- [`int_contract_storage_expiry_12m`](#int_contract_storage_expiry_12m)
- [`int_contract_storage_expiry_18m`](#int_contract_storage_expiry_18m)
- [`int_contract_storage_expiry_1m`](#int_contract_storage_expiry_1m)
- [`int_contract_storage_expiry_24m`](#int_contract_storage_expiry_24m)
- [`int_contract_storage_expiry_6m`](#int_contract_storage_expiry_6m)
- [`int_contract_storage_next_touch`](#int_contract_storage_next_touch)
- [`int_contract_storage_reactivation_12m`](#int_contract_storage_reactivation_12m)
- [`int_contract_storage_reactivation_18m`](#int_contract_storage_reactivation_18m)
- [`int_contract_storage_reactivation_1m`](#int_contract_storage_reactivation_1m)
- [`int_contract_storage_reactivation_24m`](#int_contract_storage_reactivation_24m)
- [`int_contract_storage_reactivation_6m`](#int_contract_storage_reactivation_6m)
- [`int_contract_storage_state`](#int_contract_storage_state)
- [`int_contract_storage_state_by_address`](#int_contract_storage_state_by_address)
- [`int_contract_storage_state_by_block`](#int_contract_storage_state_by_block)
- [`int_contract_storage_state_with_expiry`](#int_contract_storage_state_with_expiry)
- [`int_contract_storage_state_with_expiry_by_address`](#int_contract_storage_state_with_expiry_by_address)
- [`int_contract_storage_state_with_expiry_by_block`](#int_contract_storage_state_with_expiry_by_block)
- [`int_custody_probe`](#int_custody_probe)
- [`int_custody_probe_order_by_slot`](#int_custody_probe_order_by_slot)
- [`int_engine_get_blobs`](#int_engine_get_blobs)
- [`int_engine_new_payload`](#int_engine_new_payload)
- [`int_engine_new_payload_fastest_execution_by_node_class`](#int_engine_new_payload_fastest_execution_by_node_class)
- [`int_execution_block_by_date`](#int_execution_block_by_date)
- [`int_storage_selfdestruct_diffs`](#int_storage_selfdestruct_diffs)
- [`int_storage_slot_diff`](#int_storage_slot_diff)
- [`int_storage_slot_diff_by_address_slot`](#int_storage_slot_diff_by_address_slot)
- [`int_storage_slot_expiry_12m`](#int_storage_slot_expiry_12m)
- [`int_storage_slot_expiry_18m`](#int_storage_slot_expiry_18m)
- [`int_storage_slot_expiry_1m`](#int_storage_slot_expiry_1m)
- [`int_storage_slot_expiry_24m`](#int_storage_slot_expiry_24m)
- [`int_storage_slot_expiry_6m`](#int_storage_slot_expiry_6m)
- [`int_storage_slot_next_touch`](#int_storage_slot_next_touch)
- [`int_storage_slot_reactivation_12m`](#int_storage_slot_reactivation_12m)
- [`int_storage_slot_reactivation_18m`](#int_storage_slot_reactivation_18m)
- [`int_storage_slot_reactivation_1m`](#int_storage_slot_reactivation_1m)
- [`int_storage_slot_reactivation_24m`](#int_storage_slot_reactivation_24m)
- [`int_storage_slot_reactivation_6m`](#int_storage_slot_reactivation_6m)
- [`int_storage_slot_read`](#int_storage_slot_read)
- [`int_storage_slot_state`](#int_storage_slot_state)
- [`int_storage_slot_state_by_address`](#int_storage_slot_state_by_address)
- [`int_storage_slot_state_by_block`](#int_storage_slot_state_by_block)
- [`int_storage_slot_state_with_expiry`](#int_storage_slot_state_with_expiry)
- [`int_storage_slot_state_with_expiry_by_address`](#int_storage_slot_state_with_expiry_by_address)
- [`int_storage_slot_state_with_expiry_by_block`](#int_storage_slot_state_with_expiry_by_block)
- [`int_transaction_call_frame`](#int_transaction_call_frame)
- [`int_transaction_call_frame_opcode_gas`](#int_transaction_call_frame_opcode_gas)
- [`int_transaction_opcode_gas`](#int_transaction_opcode_gas)
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
    FROM cluster('{cbt_cluster}', mainnet.dim_block_blob_submitter) FINAL
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

## dim_contract_owner

Contract owner information from Dune Analytics, growthepie, and eth-labels for top storage slot contracts

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.dim_contract_owner`
- **sepolia**: `sepolia.dim_contract_owner`
- **holesky**: `holesky.dim_contract_owner`
- **hoodi**: `hoodi.dim_contract_owner`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.dim_contract_owner FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.dim_contract_owner) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **contract_address** | `String` | *The contract address* |
| **owner_key** | `Nullable(String)` | *Owner key identifier* |
| **account_owner** | `Nullable(String)` | *Account owner of the contract* |
| **contract_name** | `Nullable(String)` | *Name of the contract* |
| **factory_contract** | `Nullable(String)` | *Factory contract or deployer address* |
| **labels** | `Array(String)` | *Labels/categories (e.g., stablecoin, dex, circle)* |
| **sources** | `Array(String)` | *Sources of the label data (e.g., growthepie, dune, eth-labels)* |

## dim_function_signature

Function signature lookup table populated from Sourcify signature database.

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.dim_function_signature`
- **sepolia**: `sepolia.dim_function_signature`
- **holesky**: `holesky.dim_function_signature`
- **hoodi**: `hoodi.dim_function_signature`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.dim_function_signature FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.dim_function_signature) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **selector** | `String` | *Function selector (first 4 bytes of keccak256 hash, hex encoded with 0x prefix)* |
| **name** | `String` | *Function signature name (e.g., transfer(address,uint256))* |
| **has_verified_contract** | `Bool` | *Whether this signature comes from a verified contract source* |

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
    FROM cluster('{cbt_cluster}', mainnet.dim_node) FINAL
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

## dim_validator_pubkey

Validator index to pubkey mapping — one row per validator with the latest pubkey

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.dim_validator_pubkey`
- **sepolia**: `sepolia.dim_validator_pubkey`
- **holesky**: `holesky.dim_validator_pubkey`
- **hoodi**: `hoodi.dim_validator_pubkey`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.dim_validator_pubkey FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.dim_validator_pubkey) FINAL
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
| **pubkey** | `String` | *The public key of the validator* |

## dim_validator_status

Validator lifecycle status transitions — one row per (validator_index, status) with the first epoch observed

### Availability
Data is partitioned by **toStartOfMonth(epoch_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.dim_validator_status`
- **sepolia**: `sepolia.dim_validator_status`
- **holesky**: `holesky.dim_validator_status`
- **hoodi**: `hoodi.dim_validator_status`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.dim_validator_status FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.dim_validator_status) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **version** | `UInt32` | *ReplacingMergeTree version: 4294967295 - epoch, keeps earliest epoch* |
| **validator_index** | `UInt32` | *The index of the validator* |
| **pubkey** | `String` | *The public key of the validator* |
| **status** | `LowCardinality(String)` | *Beacon chain validator status (e.g. pending_initialized, active_ongoing)* |
| **epoch** | `UInt32` | *First epoch this status was observed* |
| **epoch_start_date_time** | `DateTime` | *Wall clock time of the first observed epoch* |
| **activation_epoch** | `Nullable(UInt64)` | *Epoch when activation is/was scheduled* |
| **activation_eligibility_epoch** | `Nullable(UInt64)` | *Epoch when validator became eligible for activation* |
| **exit_epoch** | `Nullable(UInt64)` | *Epoch when exit is/was scheduled* |
| **withdrawable_epoch** | `Nullable(UInt64)` | *Epoch when withdrawal becomes possible* |
| **slashed** | `Bool` | *Whether the validator was slashed at this transition* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_address_access_chunked_10000) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_address_access_total) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_address_storage_slot_chunked_10000) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_address_storage_slot_expired_top_100_by_contract) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_address_storage_slot_top_100_by_contract) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_address_storage_slot_total) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_correctness_by_validator_canonical) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_correctness_by_validator_head) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_correctness_canonical) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_correctness_head) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_first_seen_chunked_50ms) FINAL
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

## fct_attestation_inclusion_delay_daily

Daily aggregated attestation inclusion delay statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_inclusion_delay_daily`
- **sepolia**: `sepolia.fct_attestation_inclusion_delay_daily`
- **holesky**: `holesky.fct_attestation_inclusion_delay_daily`
- **hoodi**: `hoodi.fct_attestation_inclusion_delay_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_inclusion_delay_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_inclusion_delay_daily) FINAL
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
| **slot_count** | `UInt32` | *Number of slots in this day* |
| **avg_inclusion_delay** | `Float32` | *Average inclusion delay (slots)* |
| **min_inclusion_delay** | `Float32` | *Minimum inclusion delay (slots)* |
| **max_inclusion_delay** | `Float32` | *Maximum inclusion delay (slots)* |
| **p05_inclusion_delay** | `Float32` | *5th percentile inclusion delay* |
| **p50_inclusion_delay** | `Float32` | *50th percentile (median) inclusion delay* |
| **p95_inclusion_delay** | `Float32` | *95th percentile inclusion delay* |
| **stddev_inclusion_delay** | `Float32` | *Standard deviation of inclusion delay* |
| **upper_band_inclusion_delay** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_inclusion_delay** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_inclusion_delay** | `Float32` | *Moving average inclusion delay (7-day window)* |

## fct_attestation_inclusion_delay_hourly

Hourly aggregated attestation inclusion delay statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_inclusion_delay_hourly`
- **sepolia**: `sepolia.fct_attestation_inclusion_delay_hourly`
- **holesky**: `holesky.fct_attestation_inclusion_delay_hourly`
- **hoodi**: `hoodi.fct_attestation_inclusion_delay_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_inclusion_delay_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_inclusion_delay_hourly) FINAL
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
| **slot_count** | `UInt32` | *Number of slots in this hour* |
| **avg_inclusion_delay** | `Float32` | *Average inclusion delay (slots)* |
| **min_inclusion_delay** | `Float32` | *Minimum inclusion delay (slots)* |
| **max_inclusion_delay** | `Float32` | *Maximum inclusion delay (slots)* |
| **p05_inclusion_delay** | `Float32` | *5th percentile inclusion delay* |
| **p50_inclusion_delay** | `Float32` | *50th percentile (median) inclusion delay* |
| **p95_inclusion_delay** | `Float32` | *95th percentile inclusion delay* |
| **stddev_inclusion_delay** | `Float32` | *Standard deviation of inclusion delay* |
| **upper_band_inclusion_delay** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_inclusion_delay** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_inclusion_delay** | `Float32` | *Moving average inclusion delay (6-hour window)* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_liveness_by_entity_head) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_observation_by_node) FINAL
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

## fct_attestation_participation_rate_daily

Daily aggregated attestation participation rate statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_participation_rate_daily`
- **sepolia**: `sepolia.fct_attestation_participation_rate_daily`
- **holesky**: `holesky.fct_attestation_participation_rate_daily`
- **hoodi**: `hoodi.fct_attestation_participation_rate_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_participation_rate_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_participation_rate_daily) FINAL
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
| **slot_count** | `UInt32` | *Number of slots in this day* |
| **avg_participation_rate** | `Float32` | *Average participation rate (%)* |
| **min_participation_rate** | `Float32` | *Minimum participation rate (%)* |
| **max_participation_rate** | `Float32` | *Maximum participation rate (%)* |
| **p05_participation_rate** | `Float32` | *5th percentile participation rate* |
| **p50_participation_rate** | `Float32` | *50th percentile (median) participation rate* |
| **p95_participation_rate** | `Float32` | *95th percentile participation rate* |
| **stddev_participation_rate** | `Float32` | *Standard deviation of participation rate* |
| **upper_band_participation_rate** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_participation_rate** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_participation_rate** | `Float32` | *Moving average participation rate (7-day window)* |

## fct_attestation_participation_rate_hourly

Hourly aggregated attestation participation rate statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_participation_rate_hourly`
- **sepolia**: `sepolia.fct_attestation_participation_rate_hourly`
- **holesky**: `holesky.fct_attestation_participation_rate_hourly`
- **hoodi**: `hoodi.fct_attestation_participation_rate_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_participation_rate_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_participation_rate_hourly) FINAL
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
| **slot_count** | `UInt32` | *Number of slots in this hour* |
| **avg_participation_rate** | `Float32` | *Average participation rate (%)* |
| **min_participation_rate** | `Float32` | *Minimum participation rate (%)* |
| **max_participation_rate** | `Float32` | *Maximum participation rate (%)* |
| **p05_participation_rate** | `Float32` | *5th percentile participation rate* |
| **p50_participation_rate** | `Float32` | *50th percentile (median) participation rate* |
| **p95_participation_rate** | `Float32` | *95th percentile participation rate* |
| **stddev_participation_rate** | `Float32` | *Standard deviation of participation rate* |
| **upper_band_participation_rate** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_participation_rate** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_participation_rate** | `Float32` | *Moving average participation rate (6-hour window)* |

## fct_attestation_vote_correctness_by_validator

Per-slot attestation vote correctness by validator

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_vote_correctness_by_validator`
- **sepolia**: `sepolia.fct_attestation_vote_correctness_by_validator`
- **holesky**: `holesky.fct_attestation_vote_correctness_by_validator`
- **hoodi**: `hoodi.fct_attestation_vote_correctness_by_validator`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_vote_correctness_by_validator FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_vote_correctness_by_validator) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt64` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The start time of the slot* |
| **validator_index** | `UInt32` | *The index of the validator* |
| **attested** | `Bool` | *Whether the validator attested in this slot* |
| **head_correct** | `Nullable(Bool)` | *Whether the head vote was correct. NULL if not attested* |
| **target_correct** | `Nullable(Bool)` | *Whether the target vote was correct. NULL if not attested* |
| **source_correct** | `Nullable(Bool)` | *Whether the source vote was correct. NULL if not attested* |
| **inclusion_distance** | `Nullable(UInt32)` | *Inclusion distance for the attestation. NULL if not attested* |

## fct_attestation_vote_correctness_by_validator_daily

Daily aggregation of per-validator attestation vote correctness

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_vote_correctness_by_validator_daily`
- **sepolia**: `sepolia.fct_attestation_vote_correctness_by_validator_daily`
- **holesky**: `holesky.fct_attestation_vote_correctness_by_validator_daily`
- **hoodi**: `hoodi.fct_attestation_vote_correctness_by_validator_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_vote_correctness_by_validator_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_vote_correctness_by_validator_daily) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **day_start_date** | `Date` | *The start of the day for this aggregation* |
| **validator_index** | `UInt32` | *The index of the validator* |
| **total_duties** | `UInt32` | *Total attestation duties for the validator in this day* |
| **attested_count** | `UInt32` | *Number of attestations made* |
| **missed_count** | `UInt32` | *Number of attestations missed* |
| **head_correct_count** | `UInt32` | *Number of head votes that were correct* |
| **target_correct_count** | `UInt32` | *Number of target votes that were correct* |
| **source_correct_count** | `UInt32` | *Number of source votes that were correct* |
| **avg_inclusion_distance** | `Nullable(Float32)` | *Average inclusion distance for attested slots. NULL if no attestations* |

## fct_attestation_vote_correctness_by_validator_hourly

Hourly aggregation of per-validator attestation vote correctness

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_attestation_vote_correctness_by_validator_hourly`
- **sepolia**: `sepolia.fct_attestation_vote_correctness_by_validator_hourly`
- **holesky**: `holesky.fct_attestation_vote_correctness_by_validator_hourly`
- **hoodi**: `hoodi.fct_attestation_vote_correctness_by_validator_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_attestation_vote_correctness_by_validator_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_attestation_vote_correctness_by_validator_hourly) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **hour_start_date_time** | `DateTime` | *The start of the hour for this aggregation* |
| **validator_index** | `UInt32` | *The index of the validator* |
| **total_duties** | `UInt32` | *Total attestation duties for the validator in this hour* |
| **attested_count** | `UInt32` | *Number of attestations made* |
| **missed_count** | `UInt32` | *Number of attestations missed* |
| **head_correct_count** | `UInt32` | *Number of head votes that were correct* |
| **target_correct_count** | `UInt32` | *Number of target votes that were correct* |
| **source_correct_count** | `UInt32` | *Number of source votes that were correct* |
| **avg_inclusion_distance** | `Nullable(Float32)` | *Average inclusion distance for attested slots. NULL if no attestations* |

## fct_blob_count_daily

Daily aggregated consensus layer blob count statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_blob_count_daily`
- **sepolia**: `sepolia.fct_blob_count_daily`
- **holesky**: `holesky.fct_blob_count_daily`
- **hoodi**: `hoodi.fct_blob_count_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_blob_count_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_blob_count_daily) FINAL
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
| **block_count** | `UInt32` | *Number of slots with blobs in this day* |
| **total_blobs** | `UInt64` | *Total blobs in this day* |
| **avg_blob_count** | `Float32` | *Average blob count per slot* |
| **min_blob_count** | `UInt32` | *Minimum blob count in a slot* |
| **max_blob_count** | `UInt32` | *Maximum blob count in a slot* |
| **p05_blob_count** | `Float32` | *5th percentile blob count* |
| **p50_blob_count** | `Float32` | *50th percentile (median) blob count* |
| **p95_blob_count** | `Float32` | *95th percentile blob count* |
| **stddev_blob_count** | `Float32` | *Standard deviation of blob count* |
| **upper_band_blob_count** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_blob_count** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_blob_count** | `Float32` | *Moving average blob count (7-day window)* |

## fct_blob_count_hourly

Hourly aggregated consensus layer blob count statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_blob_count_hourly`
- **sepolia**: `sepolia.fct_blob_count_hourly`
- **holesky**: `holesky.fct_blob_count_hourly`
- **hoodi**: `hoodi.fct_blob_count_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_blob_count_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_blob_count_hourly) FINAL
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
| **block_count** | `UInt32` | *Number of slots with blobs in this hour* |
| **total_blobs** | `UInt64` | *Total blobs in this hour* |
| **avg_blob_count** | `Float32` | *Average blob count per slot* |
| **min_blob_count** | `UInt32` | *Minimum blob count in a slot* |
| **max_blob_count** | `UInt32` | *Maximum blob count in a slot* |
| **p05_blob_count** | `Float32` | *5th percentile blob count* |
| **p50_blob_count** | `Float32` | *50th percentile (median) blob count* |
| **p95_blob_count** | `Float32` | *95th percentile blob count* |
| **stddev_blob_count** | `Float32` | *Standard deviation of blob count* |
| **upper_band_blob_count** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_blob_count** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_blob_count** | `Float32` | *Moving average blob count (6-hour window)* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_block) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_blob_count) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_blob_count_head) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_blob_first_seen_by_node) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_data_column_sidecar_first_seen) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_data_column_sidecar_first_seen_by_node) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_first_seen_by_node) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_head) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_mev) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_mev_head) FINAL
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

## fct_block_proposal_status_daily

Daily block proposal status counts by status type

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_proposal_status_daily`
- **sepolia**: `sepolia.fct_block_proposal_status_daily`
- **holesky**: `holesky.fct_block_proposal_status_daily`
- **hoodi**: `hoodi.fct_block_proposal_status_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_proposal_status_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_proposal_status_daily) FINAL
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
| **status** | `LowCardinality(String)` | *Block proposal status (canonical, orphaned, missed)* |
| **slot_count** | `UInt32` | *Number of slots with this status* |

## fct_block_proposal_status_hourly

Hourly block proposal status counts by status type

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_proposal_status_hourly`
- **sepolia**: `sepolia.fct_block_proposal_status_hourly`
- **holesky**: `holesky.fct_block_proposal_status_hourly`
- **hoodi**: `hoodi.fct_block_proposal_status_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_proposal_status_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_proposal_status_hourly) FINAL
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
| **status** | `LowCardinality(String)` | *Block proposal status (canonical, orphaned, missed)* |
| **slot_count** | `UInt32` | *Number of slots with this status* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_proposer) FINAL
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

## fct_block_proposer_by_validator

Block proposers re-indexed by validator for efficient validator lookups

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_block_proposer_by_validator`
- **sepolia**: `sepolia.fct_block_proposer_by_validator`
- **holesky**: `holesky.fct_block_proposer_by_validator`
- **hoodi**: `hoodi.fct_block_proposer_by_validator`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_block_proposer_by_validator FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_proposer_by_validator) FINAL
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
| **validator_index** | `UInt32` | *The validator index of the proposer* |
| **pubkey** | `String` | *The public key of the proposer* |
| **block_root** | `Nullable(String)` | *The beacon block root hash. NULL if missed* |
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_proposer_entity) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_block_proposer_head) FINAL
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

## fct_contract_storage_state_by_address_daily

Contract storage state metrics per address aggregated by day

### Availability
Data is partitioned by **toYYYYMM(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_contract_storage_state_by_address_daily`
- **sepolia**: `sepolia.fct_contract_storage_state_by_address_daily`
- **holesky**: `holesky.fct_contract_storage_state_by_address_daily`
- **hoodi**: `hoodi.fct_contract_storage_state_by_address_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_contract_storage_state_by_address_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_contract_storage_state_by_address_daily) FINAL
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
| **day_start_date** | `Date` | *Start of the day period* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of day* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of day* |

## fct_contract_storage_state_by_address_hourly

Contract storage state metrics per address aggregated by hour

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_contract_storage_state_by_address_hourly`
- **sepolia**: `sepolia.fct_contract_storage_state_by_address_hourly`
- **holesky**: `holesky.fct_contract_storage_state_by_address_hourly`
- **hoodi**: `hoodi.fct_contract_storage_state_by_address_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_contract_storage_state_by_address_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_contract_storage_state_by_address_hourly) FINAL
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
| **hour_start_date_time** | `DateTime` | *Start of the hour period* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of hour* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of hour* |

## fct_contract_storage_state_by_block_daily

Contract storage state metrics aggregated by day

### Availability
Data is partitioned by **toYYYYMM(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_contract_storage_state_by_block_daily`
- **sepolia**: `sepolia.fct_contract_storage_state_by_block_daily`
- **holesky**: `holesky.fct_contract_storage_state_by_block_daily`
- **hoodi**: `hoodi.fct_contract_storage_state_by_block_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_contract_storage_state_by_block_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_contract_storage_state_by_block_daily) FINAL
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
| **active_contracts** | `Int64` | *Cumulative count of contracts with at least one active slot at end of day* |

## fct_contract_storage_state_by_block_hourly

Contract storage state metrics aggregated by hour

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_contract_storage_state_by_block_hourly`
- **sepolia**: `sepolia.fct_contract_storage_state_by_block_hourly`
- **holesky**: `holesky.fct_contract_storage_state_by_block_hourly`
- **hoodi**: `hoodi.fct_contract_storage_state_by_block_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_contract_storage_state_by_block_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_contract_storage_state_by_block_hourly) FINAL
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
| **active_contracts** | `Int64` | *Cumulative count of contracts with at least one active slot at end of hour* |

## fct_contract_storage_state_with_expiry_by_address_daily

Contract-level expiry state metrics per address aggregated by day

### Availability
Data is partitioned by **(expiry_policy, toYYYYMM(day_start_date))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_contract_storage_state_with_expiry_by_address_daily`
- **sepolia**: `sepolia.fct_contract_storage_state_with_expiry_by_address_daily`
- **holesky**: `holesky.fct_contract_storage_state_with_expiry_by_address_daily`
- **hoodi**: `hoodi.fct_contract_storage_state_with_expiry_by_address_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_contract_storage_state_with_expiry_by_address_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_contract_storage_state_with_expiry_by_address_daily) FINAL
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
| **day_start_date** | `Date` | *Start of the day period* |
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **active_slots** | `Int64` | *Active storage slots in this contract at end of day (0 if expired)* |
| **effective_bytes** | `Int64` | *Effective bytes at end of day (0 if expired)* |

## fct_contract_storage_state_with_expiry_by_address_hourly

Contract-level expiry state metrics per address aggregated by hour

### Availability
Data is partitioned by **(expiry_policy, toStartOfMonth(hour_start_date_time))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_contract_storage_state_with_expiry_by_address_hourly`
- **sepolia**: `sepolia.fct_contract_storage_state_with_expiry_by_address_hourly`
- **holesky**: `holesky.fct_contract_storage_state_with_expiry_by_address_hourly`
- **hoodi**: `hoodi.fct_contract_storage_state_with_expiry_by_address_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_contract_storage_state_with_expiry_by_address_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_contract_storage_state_with_expiry_by_address_hourly) FINAL
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
| **hour_start_date_time** | `DateTime` | *Start of the hour period* |
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **active_slots** | `Int64` | *Active storage slots in this contract at end of hour (0 if expired)* |
| **effective_bytes** | `Int64` | *Effective bytes at end of hour (0 if expired)* |

## fct_contract_storage_state_with_expiry_by_block_daily

Contract-level expiry state metrics aggregated by day

### Availability
Data is partitioned by **(expiry_policy, toYYYYMM(day_start_date))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_contract_storage_state_with_expiry_by_block_daily`
- **sepolia**: `sepolia.fct_contract_storage_state_with_expiry_by_block_daily`
- **holesky**: `holesky.fct_contract_storage_state_with_expiry_by_block_daily`
- **hoodi**: `hoodi.fct_contract_storage_state_with_expiry_by_block_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_contract_storage_state_with_expiry_by_block_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_contract_storage_state_with_expiry_by_block_daily) FINAL
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
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **active_slots** | `Int64` | *Total active storage slots at end of day (with expiry applied)* |
| **effective_bytes** | `Int64` | *Total effective bytes at end of day (with expiry applied)* |
| **active_contracts** | `Int64` | *Count of contracts with active_slots > 0 at end of day* |

## fct_contract_storage_state_with_expiry_by_block_hourly

Contract-level expiry state metrics aggregated by hour

### Availability
Data is partitioned by **(expiry_policy, toStartOfMonth(hour_start_date_time))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_contract_storage_state_with_expiry_by_block_hourly`
- **sepolia**: `sepolia.fct_contract_storage_state_with_expiry_by_block_hourly`
- **holesky**: `holesky.fct_contract_storage_state_with_expiry_by_block_hourly`
- **hoodi**: `hoodi.fct_contract_storage_state_with_expiry_by_block_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_contract_storage_state_with_expiry_by_block_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_contract_storage_state_with_expiry_by_block_hourly) FINAL
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
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **active_slots** | `Int64` | *Total active storage slots at end of hour (with expiry applied)* |
| **effective_bytes** | `Int64` | *Total effective bytes at end of hour (with expiry applied)* |
| **active_contracts** | `Int64` | *Count of contracts with active_slots > 0 at end of hour* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_data_column_availability_by_epoch) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_data_column_availability_by_slot) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_data_column_availability_by_slot_blob) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_data_column_availability_daily) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_data_column_availability_hourly) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_engine_get_blobs_by_el_client) FINAL
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

## fct_engine_get_blobs_by_el_client_hourly

Hourly aggregated engine_getBlobs statistics by execution client with true percentiles

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_get_blobs_by_el_client_hourly`
- **sepolia**: `sepolia.fct_engine_get_blobs_by_el_client_hourly`
- **holesky**: `holesky.fct_engine_get_blobs_by_el_client_hourly`
- **hoodi**: `hoodi.fct_engine_get_blobs_by_el_client_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_get_blobs_by_el_client_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_engine_get_blobs_by_el_client_hourly) FINAL
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
| **meta_execution_implementation** | `LowCardinality(String)` | *Execution client implementation (e.g., Geth, Nethermind, Besu, Reth)* |
| **meta_execution_version** | `LowCardinality(String)` | *Execution client version string* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **slot_count** | `UInt32` | *Number of unique slots in this hour* |
| **observation_count** | `UInt32` | *Total number of observations for this client in this hour* |
| **unique_node_count** | `UInt32` | *Number of unique nodes reporting for this client* |
| **success_count** | `UInt64` | *Number of observations with SUCCESS status* |
| **partial_count** | `UInt64` | *Number of observations with PARTIAL status* |
| **empty_count** | `UInt64` | *Number of observations with EMPTY status* |
| **unsupported_count** | `UInt64` | *Number of observations with UNSUPPORTED status* |
| **error_count** | `UInt64` | *Number of observations with ERROR status* |
| **avg_returned_count** | `Float64` | *Average number of blobs returned* |
| **avg_duration_ms** | `UInt64` | *Average duration of engine_getBlobs calls in milliseconds* |
| **p50_duration_ms** | `UInt64` | *50th percentile (median) duration in milliseconds* |
| **p95_duration_ms** | `UInt64` | *95th percentile duration in milliseconds* |
| **min_duration_ms** | `UInt64` | *Minimum duration in milliseconds* |
| **max_duration_ms** | `UInt64` | *Maximum duration in milliseconds* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_engine_get_blobs_by_slot) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_engine_get_blobs_duration_chunked_50ms) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_engine_new_payload_by_el_client) FINAL
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

## fct_engine_new_payload_by_el_client_hourly

Hourly aggregated engine_newPayload statistics by execution client with true percentiles

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_new_payload_by_el_client_hourly`
- **sepolia**: `sepolia.fct_engine_new_payload_by_el_client_hourly`
- **holesky**: `holesky.fct_engine_new_payload_by_el_client_hourly`
- **hoodi**: `hoodi.fct_engine_new_payload_by_el_client_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_by_el_client_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_engine_new_payload_by_el_client_hourly) FINAL
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
| **meta_execution_implementation** | `LowCardinality(String)` | *Execution client implementation (e.g., Geth, Nethermind, Besu, Reth)* |
| **meta_execution_version** | `LowCardinality(String)` | *Execution client version string* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **slot_count** | `UInt32` | *Number of unique slots in this hour* |
| **observation_count** | `UInt32` | *Total number of observations for this client in this hour* |
| **unique_node_count** | `UInt32` | *Number of unique nodes reporting for this client* |
| **valid_count** | `UInt64` | *Number of observations with VALID status* |
| **invalid_count** | `UInt64` | *Number of observations with INVALID status* |
| **syncing_count** | `UInt64` | *Number of observations with SYNCING status* |
| **accepted_count** | `UInt64` | *Number of observations with ACCEPTED status* |
| **avg_duration_ms** | `UInt64` | *Average duration of engine_newPayload calls in milliseconds* |
| **p50_duration_ms** | `UInt64` | *50th percentile (median) duration in milliseconds* |
| **p95_duration_ms** | `UInt64` | *95th percentile duration in milliseconds* |
| **min_duration_ms** | `UInt64` | *Minimum duration in milliseconds* |
| **max_duration_ms** | `UInt64` | *Maximum duration in milliseconds* |
| **avg_gas_used** | `UInt64` | *Average gas used per block (VALID status only)* |
| **avg_gas_limit** | `UInt64` | *Average gas limit per block (VALID status only)* |
| **avg_tx_count** | `Float32` | *Average transaction count per block (VALID status only)* |
| **avg_blob_count** | `Float32` | *Average blob count per block (VALID status only)* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_engine_new_payload_by_slot) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_engine_new_payload_duration_chunked_50ms) FINAL
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

## fct_engine_new_payload_winrate_daily

Daily execution client winrate based on fastest engine_newPayload duration per slot

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_new_payload_winrate_daily`
- **sepolia**: `sepolia.fct_engine_new_payload_winrate_daily`
- **holesky**: `holesky.fct_engine_new_payload_winrate_daily`
- **hoodi**: `hoodi.fct_engine_new_payload_winrate_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_winrate_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_engine_new_payload_winrate_daily) FINAL
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
| **meta_execution_implementation** | `LowCardinality(String)` | *Execution client implementation name (e.g., Reth, Nethermind, Besu)* |
| **win_count** | `UInt32` | *Number of slots where this client had the fastest engine_newPayload duration* |

## fct_engine_new_payload_winrate_hourly

Hourly execution client winrate based on fastest engine_newPayload duration per slot

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_engine_new_payload_winrate_hourly`
- **sepolia**: `sepolia.fct_engine_new_payload_winrate_hourly`
- **holesky**: `holesky.fct_engine_new_payload_winrate_hourly`
- **hoodi**: `hoodi.fct_engine_new_payload_winrate_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_engine_new_payload_winrate_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_engine_new_payload_winrate_hourly) FINAL
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
| **meta_execution_implementation** | `LowCardinality(String)` | *Execution client implementation name (e.g., Reth, Nethermind, Besu)* |
| **win_count** | `UInt32` | *Number of slots where this client had the fastest engine_newPayload duration* |

## fct_execution_gas_limit_daily

Daily aggregated execution layer gas limit statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_gas_limit_daily`
- **sepolia**: `sepolia.fct_execution_gas_limit_daily`
- **holesky**: `holesky.fct_execution_gas_limit_daily`
- **hoodi**: `hoodi.fct_execution_gas_limit_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_gas_limit_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_gas_limit_daily) FINAL
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
| **block_count** | `UInt32` | *Number of blocks in this day* |
| **total_gas_limit** | `UInt64` | *Total gas limit in this day* |
| **avg_gas_limit** | `UInt64` | *Average gas limit per block* |
| **min_gas_limit** | `UInt64` | *Minimum gas limit in a block* |
| **max_gas_limit** | `UInt64` | *Maximum gas limit in a block* |
| **p05_gas_limit** | `UInt64` | *5th percentile gas limit* |
| **p50_gas_limit** | `UInt64` | *50th percentile (median) gas limit* |
| **p95_gas_limit** | `UInt64` | *95th percentile gas limit* |
| **stddev_gas_limit** | `UInt64` | *Standard deviation of gas limit* |
| **upper_band_gas_limit** | `UInt64` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_gas_limit** | `Int64` | *Lower Bollinger band (avg - 2*stddev), can be negative during high volatility* |
| **moving_avg_gas_limit** | `UInt64` | *Moving average gas limit (7-day window)* |

## fct_execution_gas_limit_hourly

Hourly aggregated execution layer gas limit statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_gas_limit_hourly`
- **sepolia**: `sepolia.fct_execution_gas_limit_hourly`
- **holesky**: `holesky.fct_execution_gas_limit_hourly`
- **hoodi**: `hoodi.fct_execution_gas_limit_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_gas_limit_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_gas_limit_hourly) FINAL
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
| **block_count** | `UInt32` | *Number of blocks in this hour* |
| **total_gas_limit** | `UInt64` | *Total gas limit in this hour* |
| **avg_gas_limit** | `UInt64` | *Average gas limit per block* |
| **min_gas_limit** | `UInt64` | *Minimum gas limit in a block* |
| **max_gas_limit** | `UInt64` | *Maximum gas limit in a block* |
| **p05_gas_limit** | `UInt64` | *5th percentile gas limit* |
| **p50_gas_limit** | `UInt64` | *50th percentile (median) gas limit* |
| **p95_gas_limit** | `UInt64` | *95th percentile gas limit* |
| **stddev_gas_limit** | `UInt64` | *Standard deviation of gas limit* |
| **upper_band_gas_limit** | `UInt64` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_gas_limit** | `Int64` | *Lower Bollinger band (avg - 2*stddev), can be negative during high volatility* |
| **moving_avg_gas_limit** | `UInt64` | *Moving average gas limit (6-hour window)* |

## fct_execution_gas_limit_signalling_daily

Daily snapshots of validator gas limit signalling using rolling 7-day window

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_gas_limit_signalling_daily`
- **sepolia**: `sepolia.fct_execution_gas_limit_signalling_daily`
- **holesky**: `holesky.fct_execution_gas_limit_signalling_daily`
- **hoodi**: `hoodi.fct_execution_gas_limit_signalling_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_gas_limit_signalling_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_gas_limit_signalling_daily) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | ** |
| **day_start_date** | `Date` | ** |
| **gas_limit_band_counts** | `Map(String, UInt32)` | ** |

## fct_execution_gas_limit_signalling_hourly

Hourly snapshots of validator gas limit signalling using rolling 7-day window

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_gas_limit_signalling_hourly`
- **sepolia**: `sepolia.fct_execution_gas_limit_signalling_hourly`
- **holesky**: `holesky.fct_execution_gas_limit_signalling_hourly`
- **hoodi**: `hoodi.fct_execution_gas_limit_signalling_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_gas_limit_signalling_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_gas_limit_signalling_hourly) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | ** |
| **hour_start_date_time** | `DateTime` | ** |
| **gas_limit_band_counts** | `Map(String, UInt32)` | ** |

## fct_execution_gas_used_daily

Daily aggregated execution layer gas used statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_gas_used_daily`
- **sepolia**: `sepolia.fct_execution_gas_used_daily`
- **holesky**: `holesky.fct_execution_gas_used_daily`
- **hoodi**: `hoodi.fct_execution_gas_used_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_gas_used_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_gas_used_daily) FINAL
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
| **block_count** | `UInt32` | *Number of blocks in this day* |
| **total_gas_used** | `UInt64` | *Total gas used in this day* |
| **cumulative_gas_used** | `UInt64` | *Cumulative gas used since genesis* |
| **avg_gas_used** | `UInt64` | *Average gas used per block* |
| **min_gas_used** | `UInt64` | *Minimum gas used in a block* |
| **max_gas_used** | `UInt64` | *Maximum gas used in a block* |
| **p05_gas_used** | `UInt64` | *5th percentile gas used* |
| **p50_gas_used** | `UInt64` | *50th percentile (median) gas used* |
| **p95_gas_used** | `UInt64` | *95th percentile gas used* |
| **stddev_gas_used** | `UInt64` | *Standard deviation of gas used* |
| **upper_band_gas_used** | `UInt64` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_gas_used** | `Int64` | *Lower Bollinger band (avg - 2*stddev), can be negative during high volatility* |
| **moving_avg_gas_used** | `UInt64` | *Moving average gas used (7-day window)* |

## fct_execution_gas_used_hourly

Hourly aggregated execution layer gas used statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_gas_used_hourly`
- **sepolia**: `sepolia.fct_execution_gas_used_hourly`
- **holesky**: `holesky.fct_execution_gas_used_hourly`
- **hoodi**: `hoodi.fct_execution_gas_used_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_gas_used_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_gas_used_hourly) FINAL
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
| **block_count** | `UInt32` | *Number of blocks in this hour* |
| **total_gas_used** | `UInt64` | *Total gas used in this hour* |
| **cumulative_gas_used** | `UInt64` | *Cumulative gas used since genesis* |
| **avg_gas_used** | `UInt64` | *Average gas used per block* |
| **min_gas_used** | `UInt64` | *Minimum gas used in a block* |
| **max_gas_used** | `UInt64` | *Maximum gas used in a block* |
| **p05_gas_used** | `UInt64` | *5th percentile gas used* |
| **p50_gas_used** | `UInt64` | *50th percentile (median) gas used* |
| **p95_gas_used** | `UInt64` | *95th percentile gas used* |
| **stddev_gas_used** | `UInt64` | *Standard deviation of gas used* |
| **upper_band_gas_used** | `UInt64` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_gas_used** | `Int64` | *Lower Bollinger band (avg - 2*stddev), can be negative during high volatility* |
| **moving_avg_gas_used** | `UInt64` | *Moving average gas used (6-hour window)* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_state_size_daily) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_state_size_hourly) FINAL
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

## fct_execution_tps_daily

Daily aggregated execution layer TPS statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_tps_daily`
- **sepolia**: `sepolia.fct_execution_tps_daily`
- **holesky**: `holesky.fct_execution_tps_daily`
- **hoodi**: `hoodi.fct_execution_tps_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_tps_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_tps_daily) FINAL
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
| **block_count** | `UInt32` | *Number of blocks in this day* |
| **total_transactions** | `UInt64` | *Total transactions in this day* |
| **total_seconds** | `UInt32` | *Total actual seconds covered by blocks (sum of block time gaps)* |
| **avg_tps** | `Float32` | *Average TPS using actual block time gaps* |
| **min_tps** | `Float32` | *Minimum per-block TPS* |
| **max_tps** | `Float32` | *Maximum per-block TPS* |
| **p05_tps** | `Float32` | *5th percentile TPS* |
| **p50_tps** | `Float32` | *50th percentile (median) TPS* |
| **p95_tps** | `Float32` | *95th percentile TPS* |
| **stddev_tps** | `Float32` | *Standard deviation of TPS* |
| **upper_band_tps** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_tps** | `Float32` | *Lower Bollinger band (avg - 2*stddev), can be negative during high volatility* |
| **moving_avg_tps** | `Float32` | *Moving average TPS (7-day window)* |

## fct_execution_tps_hourly

Hourly aggregated execution layer TPS statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_tps_hourly`
- **sepolia**: `sepolia.fct_execution_tps_hourly`
- **holesky**: `holesky.fct_execution_tps_hourly`
- **hoodi**: `hoodi.fct_execution_tps_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_tps_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_tps_hourly) FINAL
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
| **block_count** | `UInt32` | *Number of blocks in this hour* |
| **total_transactions** | `UInt64` | *Total transactions in this hour* |
| **total_seconds** | `UInt32` | *Total actual seconds covered by blocks (sum of block time gaps)* |
| **avg_tps** | `Float32` | *Average TPS using actual block time gaps* |
| **min_tps** | `Float32` | *Minimum per-block TPS* |
| **max_tps** | `Float32` | *Maximum per-block TPS* |
| **p05_tps** | `Float32` | *5th percentile TPS* |
| **p50_tps** | `Float32` | *50th percentile (median) TPS* |
| **p95_tps** | `Float32` | *95th percentile TPS* |
| **stddev_tps** | `Float32` | *Standard deviation of TPS* |
| **upper_band_tps** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_tps** | `Float32` | *Lower Bollinger band (avg - 2*stddev), can be negative during high volatility* |
| **moving_avg_tps** | `Float32` | *Moving average TPS (6-hour window)* |

## fct_execution_transactions_daily

Daily aggregated execution layer transaction counts with cumulative totals and per-block statistics

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_transactions_daily`
- **sepolia**: `sepolia.fct_execution_transactions_daily`
- **holesky**: `holesky.fct_execution_transactions_daily`
- **hoodi**: `hoodi.fct_execution_transactions_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_transactions_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_transactions_daily) FINAL
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
| **block_count** | `UInt32` | *Number of blocks in this day* |
| **total_transactions** | `UInt64` | *Total transactions in this day* |
| **cumulative_transactions** | `UInt64` | *Cumulative transaction count since genesis* |
| **avg_txn_per_block** | `Float32` | *Average transactions per block* |
| **min_txn_per_block** | `UInt32` | *Minimum transactions in a block* |
| **max_txn_per_block** | `UInt32` | *Maximum transactions in a block* |
| **p50_txn_per_block** | `UInt32` | *50th percentile (median) transactions per block* |
| **p95_txn_per_block** | `UInt32` | *95th percentile transactions per block* |
| **p05_txn_per_block** | `UInt32` | *5th percentile transactions per block* |
| **stddev_txn_per_block** | `Float32` | *Standard deviation of transactions per block* |
| **upper_band_txn_per_block** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_txn_per_block** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_txn_per_block** | `Float32` | *Moving average transactions per block (7-day window)* |

## fct_execution_transactions_hourly

Hourly aggregated execution layer transaction counts with cumulative totals and per-block statistics

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_execution_transactions_hourly`
- **sepolia**: `sepolia.fct_execution_transactions_hourly`
- **holesky**: `holesky.fct_execution_transactions_hourly`
- **hoodi**: `hoodi.fct_execution_transactions_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_execution_transactions_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_execution_transactions_hourly) FINAL
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
| **block_count** | `UInt32` | *Number of blocks in this hour* |
| **total_transactions** | `UInt64` | *Total transactions in this hour* |
| **cumulative_transactions** | `UInt64` | *Cumulative transaction count since genesis* |
| **avg_txn_per_block** | `Float32` | *Average transactions per block* |
| **min_txn_per_block** | `UInt32` | *Minimum transactions in a block* |
| **max_txn_per_block** | `UInt32` | *Maximum transactions in a block* |
| **p50_txn_per_block** | `UInt32` | *50th percentile (median) transactions per block* |
| **p95_txn_per_block** | `UInt32` | *95th percentile transactions per block* |
| **p05_txn_per_block** | `UInt32` | *5th percentile transactions per block* |
| **stddev_txn_per_block** | `Float32` | *Standard deviation of transactions per block* |
| **upper_band_txn_per_block** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_txn_per_block** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_txn_per_block** | `Float32` | *Moving average transactions per block (6-hour window)* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_head_first_seen_by_node) FINAL
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

## fct_head_vote_correctness_rate_daily

Daily aggregated head vote correctness rate statistics

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_head_vote_correctness_rate_daily`
- **sepolia**: `sepolia.fct_head_vote_correctness_rate_daily`
- **holesky**: `holesky.fct_head_vote_correctness_rate_daily`
- **hoodi**: `hoodi.fct_head_vote_correctness_rate_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_head_vote_correctness_rate_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_head_vote_correctness_rate_daily) FINAL
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
| **slot_count** | `UInt32` | *Number of slots in this day* |
| **avg_head_vote_rate** | `Float32` | *Average head vote correctness rate (%)* |
| **min_head_vote_rate** | `Float32` | *Minimum head vote correctness rate (%)* |
| **max_head_vote_rate** | `Float32` | *Maximum head vote correctness rate (%)* |
| **p05_head_vote_rate** | `Float32` | *5th percentile head vote correctness rate* |
| **p50_head_vote_rate** | `Float32` | *50th percentile (median) head vote correctness rate* |
| **p95_head_vote_rate** | `Float32` | *95th percentile head vote correctness rate* |
| **stddev_head_vote_rate** | `Float32` | *Standard deviation of head vote correctness rate* |
| **upper_band_head_vote_rate** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_head_vote_rate** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_head_vote_rate** | `Float32` | *Moving average head vote correctness rate (7-day window)* |

## fct_head_vote_correctness_rate_hourly

Hourly aggregated head vote correctness rate statistics

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_head_vote_correctness_rate_hourly`
- **sepolia**: `sepolia.fct_head_vote_correctness_rate_hourly`
- **holesky**: `holesky.fct_head_vote_correctness_rate_hourly`
- **hoodi**: `hoodi.fct_head_vote_correctness_rate_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_head_vote_correctness_rate_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_head_vote_correctness_rate_hourly) FINAL
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
| **slot_count** | `UInt32` | *Number of slots in this hour* |
| **avg_head_vote_rate** | `Float32` | *Average head vote correctness rate (%)* |
| **min_head_vote_rate** | `Float32` | *Minimum head vote correctness rate (%)* |
| **max_head_vote_rate** | `Float32` | *Maximum head vote correctness rate (%)* |
| **p05_head_vote_rate** | `Float32` | *5th percentile head vote correctness rate* |
| **p50_head_vote_rate** | `Float32` | *50th percentile (median) head vote correctness rate* |
| **p95_head_vote_rate** | `Float32` | *95th percentile head vote correctness rate* |
| **stddev_head_vote_rate** | `Float32` | *Standard deviation of head vote correctness rate* |
| **upper_band_head_vote_rate** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_head_vote_rate** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_head_vote_rate** | `Float32` | *Moving average head vote correctness rate (6-hour window)* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_mev_bid_count_by_builder) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_mev_bid_count_by_relay) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_mev_bid_highest_value_by_builder_chunked_50ms) FINAL
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

## fct_missed_slot_rate_daily

Daily missed slot rate with moving averages

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_missed_slot_rate_daily`
- **sepolia**: `sepolia.fct_missed_slot_rate_daily`
- **holesky**: `holesky.fct_missed_slot_rate_daily`
- **hoodi**: `hoodi.fct_missed_slot_rate_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_missed_slot_rate_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_missed_slot_rate_daily) FINAL
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
| **slot_count** | `UInt32` | *Total number of slots in this day* |
| **missed_count** | `UInt32` | *Number of missed slots in this day* |
| **missed_rate** | `Float32` | *Missed slot rate (%)* |
| **moving_avg_missed_rate** | `Float32` | *Moving average missed rate (7-day window)* |

## fct_missed_slot_rate_hourly

Hourly missed slot rate with moving averages

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_missed_slot_rate_hourly`
- **sepolia**: `sepolia.fct_missed_slot_rate_hourly`
- **holesky**: `holesky.fct_missed_slot_rate_hourly`
- **hoodi**: `hoodi.fct_missed_slot_rate_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_missed_slot_rate_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_missed_slot_rate_hourly) FINAL
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
| **slot_count** | `UInt32` | *Total number of slots in this hour* |
| **missed_count** | `UInt32` | *Number of missed slots in this hour* |
| **missed_rate** | `Float32` | *Missed slot rate (%)* |
| **moving_avg_missed_rate** | `Float32` | *Moving average missed rate (6-hour window)* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_node_active_last_24h) FINAL
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

## fct_node_cpu_utilization_by_process

Node CPU utilization per sub-slot window enriched with node classification

### Availability
Data is partitioned by **toStartOfMonth(wallclock_slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_node_cpu_utilization_by_process`
- **sepolia**: `sepolia.fct_node_cpu_utilization_by_process`
- **holesky**: `holesky.fct_node_cpu_utilization_by_process`
- **hoodi**: `hoodi.fct_node_cpu_utilization_by_process`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_node_cpu_utilization_by_process FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_node_cpu_utilization_by_process) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **window_start** | `DateTime64(3)` | *Start of the sub-slot aggregation window* |
| **wallclock_slot** | `UInt32` | *The wallclock slot number* |
| **wallclock_slot_start_date_time** | `DateTime64(3)` | *The wall clock time when the slot started* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the observoor client that collected the data* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |
| **pid** | `UInt32` | *Process ID of the monitored client* |
| **client_type** | `LowCardinality(String)` | *Client type: CL or EL* |
| **system_cores** | `UInt16` | *Total system CPU cores* |
| **mean_core_pct** | `Float32` | *Mean CPU core utilization percentage (100pct = 1 core)* |
| **min_core_pct** | `Float32` | *Minimum CPU core utilization percentage (100pct = 1 core)* |
| **max_core_pct** | `Float32` | *Maximum CPU core utilization percentage (100pct = 1 core)* |
| **node_class** | `LowCardinality(String)` | *Node classification for filtering (e.g. eip7870)* |

## fct_node_disk_io_by_process

Node disk I/O per sub-slot window aggregated across devices with node classification

### Availability
Data is partitioned by **toStartOfMonth(wallclock_slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_node_disk_io_by_process`
- **sepolia**: `sepolia.fct_node_disk_io_by_process`
- **holesky**: `holesky.fct_node_disk_io_by_process`
- **hoodi**: `hoodi.fct_node_disk_io_by_process`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_node_disk_io_by_process FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_node_disk_io_by_process) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **window_start** | `DateTime64(3)` | *Start of the sub-slot aggregation window* |
| **wallclock_slot** | `UInt32` | *The wallclock slot number* |
| **wallclock_slot_start_date_time** | `DateTime64(3)` | *The wall clock time when the slot started* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the observoor client that collected the data* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |
| **pid** | `UInt32` | *Process ID of the monitored client* |
| **client_type** | `LowCardinality(String)` | *Client type: CL or EL* |
| **rw** | `LowCardinality(String)` | *I/O direction: read or write* |
| **io_bytes** | `Float32` | *Total bytes transferred across all devices in this window* |
| **io_ops** | `UInt32` | *Total I/O operations across all devices in this window* |
| **node_class** | `LowCardinality(String)` | *Node classification for filtering (e.g. eip7870)* |

## fct_node_memory_usage_by_process

Node memory usage per sub-slot window enriched with node classification

### Availability
Data is partitioned by **toStartOfMonth(wallclock_slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_node_memory_usage_by_process`
- **sepolia**: `sepolia.fct_node_memory_usage_by_process`
- **holesky**: `holesky.fct_node_memory_usage_by_process`
- **hoodi**: `hoodi.fct_node_memory_usage_by_process`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_node_memory_usage_by_process FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_node_memory_usage_by_process) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **window_start** | `DateTime64(3)` | *Start of the sub-slot aggregation window* |
| **wallclock_slot** | `UInt32` | *The wallclock slot number* |
| **wallclock_slot_start_date_time** | `DateTime64(3)` | *The wall clock time when the slot started* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the observoor client that collected the data* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |
| **pid** | `UInt32` | *Process ID of the monitored client* |
| **client_type** | `LowCardinality(String)` | *Client type: CL or EL* |
| **vm_rss_bytes** | `UInt64` | *Resident set size in bytes (total physical memory used)* |
| **rss_anon_bytes** | `UInt64` | *Anonymous RSS in bytes (heap, stack, anonymous mmap)* |
| **rss_file_bytes** | `UInt64` | *File-backed RSS in bytes (shared libraries, mmap files)* |
| **vm_swap_bytes** | `UInt64` | *Swap usage in bytes* |
| **node_class** | `LowCardinality(String)` | *Node classification for filtering (e.g. eip7870)* |

## fct_node_network_io_by_process

Node network I/O per port per sub-slot window with node classification

### Availability
Data is partitioned by **toStartOfMonth(wallclock_slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_node_network_io_by_process`
- **sepolia**: `sepolia.fct_node_network_io_by_process`
- **holesky**: `holesky.fct_node_network_io_by_process`
- **hoodi**: `hoodi.fct_node_network_io_by_process`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_node_network_io_by_process FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_node_network_io_by_process) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **window_start** | `DateTime64(3)` | *Start of the sub-slot aggregation window* |
| **wallclock_slot** | `UInt32` | *The wallclock slot number* |
| **wallclock_slot_start_date_time** | `DateTime64(3)` | *The wall clock time when the slot started* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the observoor client that collected the data* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |
| **pid** | `UInt32` | *Process ID of the monitored client* |
| **client_type** | `LowCardinality(String)` | *Client type: CL or EL* |
| **port_label** | `LowCardinality(String)` | *Port classification (e.g. cl_p2p_tcp, el_json_rpc, unknown)* |
| **direction** | `LowCardinality(String)` | *Traffic direction: tx or rx* |
| **io_bytes** | `Float32` | *Total bytes transferred in this window* |
| **io_count** | `UInt32` | *Total packet or event count in this window* |
| **node_class** | `LowCardinality(String)` | *Node classification for filtering (e.g. eip7870)* |

## fct_opcode_gas_by_opcode_daily

Daily per-opcode gas consumption for Top Opcodes by Gas charts

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_opcode_gas_by_opcode_daily`
- **sepolia**: `sepolia.fct_opcode_gas_by_opcode_daily`
- **holesky**: `holesky.fct_opcode_gas_by_opcode_daily`
- **hoodi**: `hoodi.fct_opcode_gas_by_opcode_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_opcode_gas_by_opcode_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_opcode_gas_by_opcode_daily) FINAL
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
| **opcode** | `LowCardinality(String)` | *The EVM opcode name (e.g., SLOAD, ADD, CALL)* |
| **block_count** | `UInt32` | *Number of blocks containing this opcode in this day* |
| **total_count** | `UInt64` | *Total execution count of this opcode in this day* |
| **total_gas** | `UInt64` | *Total gas consumed by this opcode in this day* |
| **total_error_count** | `UInt64` | *Total error count for this opcode in this day* |
| **avg_count_per_block** | `Float32` | *Average executions per block* |
| **avg_gas_per_block** | `Float32` | *Average gas per block* |
| **avg_gas_per_execution** | `Float32` | *Average gas per execution* |

## fct_opcode_gas_by_opcode_hourly

Hourly per-opcode gas consumption for Top Opcodes by Gas charts

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_opcode_gas_by_opcode_hourly`
- **sepolia**: `sepolia.fct_opcode_gas_by_opcode_hourly`
- **holesky**: `holesky.fct_opcode_gas_by_opcode_hourly`
- **hoodi**: `hoodi.fct_opcode_gas_by_opcode_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_opcode_gas_by_opcode_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_opcode_gas_by_opcode_hourly) FINAL
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
| **opcode** | `LowCardinality(String)` | *The EVM opcode name (e.g., SLOAD, ADD, CALL)* |
| **block_count** | `UInt32` | *Number of blocks containing this opcode in this hour* |
| **total_count** | `UInt64` | *Total execution count of this opcode in this hour* |
| **total_gas** | `UInt64` | *Total gas consumed by this opcode in this hour* |
| **total_error_count** | `UInt64` | *Total error count for this opcode in this hour* |
| **avg_count_per_block** | `Float32` | *Average executions per block* |
| **avg_gas_per_block** | `Float32` | *Average gas per block* |
| **avg_gas_per_execution** | `Float32` | *Average gas per execution* |

## fct_opcode_ops_daily

Daily aggregated opcode execution rate statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_opcode_ops_daily`
- **sepolia**: `sepolia.fct_opcode_ops_daily`
- **holesky**: `holesky.fct_opcode_ops_daily`
- **hoodi**: `hoodi.fct_opcode_ops_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_opcode_ops_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_opcode_ops_daily) FINAL
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
| **block_count** | `UInt32` | *Number of blocks in this day* |
| **total_opcode_count** | `UInt64` | *Total opcode executions in this day* |
| **total_gas** | `UInt64` | *Total gas consumed by opcodes in this day* |
| **total_seconds** | `UInt32` | *Total actual seconds covered by blocks (sum of block time gaps)* |
| **avg_ops** | `Float32` | *Average opcodes per second using actual block time gaps* |
| **min_ops** | `Float32` | *Minimum per-block ops/sec* |
| **max_ops** | `Float32` | *Maximum per-block ops/sec* |
| **p05_ops** | `Float32` | *5th percentile ops/sec* |
| **p50_ops** | `Float32` | *50th percentile (median) ops/sec* |
| **p95_ops** | `Float32` | *95th percentile ops/sec* |
| **stddev_ops** | `Float32` | *Standard deviation of ops/sec* |
| **upper_band_ops** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_ops** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_ops** | `Float32` | *Moving average ops/sec (7-day window)* |

## fct_opcode_ops_hourly

Hourly aggregated opcode execution rate statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_opcode_ops_hourly`
- **sepolia**: `sepolia.fct_opcode_ops_hourly`
- **holesky**: `holesky.fct_opcode_ops_hourly`
- **hoodi**: `hoodi.fct_opcode_ops_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_opcode_ops_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_opcode_ops_hourly) FINAL
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
| **block_count** | `UInt32` | *Number of blocks in this hour* |
| **total_opcode_count** | `UInt64` | *Total opcode executions in this hour* |
| **total_gas** | `UInt64` | *Total gas consumed by opcodes in this hour* |
| **total_seconds** | `UInt32` | *Total actual seconds covered by blocks (sum of block time gaps)* |
| **avg_ops** | `Float32` | *Average opcodes per second using actual block time gaps* |
| **min_ops** | `Float32` | *Minimum per-block ops/sec* |
| **max_ops** | `Float32` | *Maximum per-block ops/sec* |
| **p05_ops** | `Float32` | *5th percentile ops/sec* |
| **p50_ops** | `Float32` | *50th percentile (median) ops/sec* |
| **p95_ops** | `Float32` | *95th percentile ops/sec* |
| **stddev_ops** | `Float32` | *Standard deviation of ops/sec* |
| **upper_band_ops** | `Float32` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_ops** | `Float32` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_ops** | `Float32` | *Moving average ops/sec (6-hour window)* |

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
    FROM cluster('{cbt_cluster}', mainnet.fct_prepared_block) FINAL
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

## fct_proposer_reward_daily

Daily aggregated MEV proposer reward statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_proposer_reward_daily`
- **sepolia**: `sepolia.fct_proposer_reward_daily`
- **holesky**: `holesky.fct_proposer_reward_daily`
- **hoodi**: `hoodi.fct_proposer_reward_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_proposer_reward_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_proposer_reward_daily) FINAL
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
| **block_count** | `UInt32` | *Number of MEV relay blocks in this day* |
| **total_reward_eth** | `Float64` | *Total proposer reward in ETH* |
| **avg_reward_eth** | `Float64` | *Average proposer reward in ETH* |
| **min_reward_eth** | `Float64` | *Minimum proposer reward in ETH* |
| **max_reward_eth** | `Float64` | *Maximum proposer reward in ETH* |
| **p05_reward_eth** | `Float64` | *5th percentile proposer reward* |
| **p50_reward_eth** | `Float64` | *50th percentile (median) proposer reward* |
| **p95_reward_eth** | `Float64` | *95th percentile proposer reward* |
| **stddev_reward_eth** | `Float64` | *Standard deviation of proposer reward* |
| **upper_band_reward_eth** | `Float64` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_reward_eth** | `Float64` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_reward_eth** | `Float64` | *Moving average proposer reward (7-day window)* |

## fct_proposer_reward_hourly

Hourly aggregated MEV proposer reward statistics with percentiles, Bollinger bands, and moving averages

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_proposer_reward_hourly`
- **sepolia**: `sepolia.fct_proposer_reward_hourly`
- **holesky**: `holesky.fct_proposer_reward_hourly`
- **hoodi**: `hoodi.fct_proposer_reward_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_proposer_reward_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_proposer_reward_hourly) FINAL
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
| **block_count** | `UInt32` | *Number of MEV relay blocks in this hour* |
| **total_reward_eth** | `Float64` | *Total proposer reward in ETH* |
| **avg_reward_eth** | `Float64` | *Average proposer reward in ETH* |
| **min_reward_eth** | `Float64` | *Minimum proposer reward in ETH* |
| **max_reward_eth** | `Float64` | *Maximum proposer reward in ETH* |
| **p05_reward_eth** | `Float64` | *5th percentile proposer reward* |
| **p50_reward_eth** | `Float64` | *50th percentile (median) proposer reward* |
| **p95_reward_eth** | `Float64` | *95th percentile proposer reward* |
| **stddev_reward_eth** | `Float64` | *Standard deviation of proposer reward* |
| **upper_band_reward_eth** | `Float64` | *Upper Bollinger band (avg + 2*stddev)* |
| **lower_band_reward_eth** | `Float64` | *Lower Bollinger band (avg - 2*stddev)* |
| **moving_avg_reward_eth** | `Float64` | *Moving average proposer reward (6-hour window)* |

## fct_reorg_daily

Daily reorg event counts by depth

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_reorg_daily`
- **sepolia**: `sepolia.fct_reorg_daily`
- **holesky**: `holesky.fct_reorg_daily`
- **hoodi**: `hoodi.fct_reorg_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_reorg_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_reorg_daily) FINAL
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
| **depth** | `UInt16` | *Reorg depth (number of consecutive orphaned slots)* |
| **reorg_count** | `UInt32` | *Number of reorg events at this depth* |

## fct_reorg_hourly

Hourly reorg event counts by depth

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_reorg_hourly`
- **sepolia**: `sepolia.fct_reorg_hourly`
- **holesky**: `holesky.fct_reorg_hourly`
- **hoodi**: `hoodi.fct_reorg_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_reorg_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_reorg_hourly) FINAL
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
| **depth** | `UInt16` | *Reorg depth (number of consecutive orphaned slots)* |
| **reorg_count** | `UInt32` | *Number of reorg events at this depth* |

## fct_storage_slot_state_by_address_daily

Storage slot state metrics per address aggregated by day

### Availability
Data is partitioned by **toYYYYMM(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_by_address_daily`
- **sepolia**: `sepolia.fct_storage_slot_state_by_address_daily`
- **holesky**: `holesky.fct_storage_slot_state_by_address_daily`
- **hoodi**: `hoodi.fct_storage_slot_state_by_address_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_by_address_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_storage_slot_state_by_address_daily) FINAL
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
| **day_start_date** | `Date` | *Start of the day period* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of day* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of day* |

## fct_storage_slot_state_by_address_hourly

Storage slot state metrics per address aggregated by hour

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_by_address_hourly`
- **sepolia**: `sepolia.fct_storage_slot_state_by_address_hourly`
- **holesky**: `holesky.fct_storage_slot_state_by_address_hourly`
- **hoodi**: `hoodi.fct_storage_slot_state_by_address_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_by_address_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_storage_slot_state_by_address_hourly) FINAL
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
| **hour_start_date_time** | `DateTime` | *Start of the hour period* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of hour* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of hour* |

## fct_storage_slot_state_by_block_daily

Storage slot state metrics aggregated by day

### Availability
Data is partitioned by **toYYYYMM(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_by_block_daily`
- **sepolia**: `sepolia.fct_storage_slot_state_by_block_daily`
- **holesky**: `holesky.fct_storage_slot_state_by_block_daily`
- **hoodi**: `hoodi.fct_storage_slot_state_by_block_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_by_block_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_storage_slot_state_by_block_daily) FINAL
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

## fct_storage_slot_state_by_block_hourly

Storage slot state metrics aggregated by hour

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_by_block_hourly`
- **sepolia**: `sepolia.fct_storage_slot_state_by_block_hourly`
- **holesky**: `holesky.fct_storage_slot_state_by_block_hourly`
- **hoodi**: `hoodi.fct_storage_slot_state_by_block_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_by_block_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_storage_slot_state_by_block_hourly) FINAL
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

## fct_storage_slot_state_with_expiry_by_address_daily

Storage slot state metrics per address with expiry policies aggregated by day

### Availability
Data is partitioned by **(expiry_policy, toYYYYMM(day_start_date))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_with_expiry_by_address_daily`
- **sepolia**: `sepolia.fct_storage_slot_state_with_expiry_by_address_daily`
- **holesky**: `holesky.fct_storage_slot_state_with_expiry_by_address_daily`
- **hoodi**: `hoodi.fct_storage_slot_state_with_expiry_by_address_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_with_expiry_by_address_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_storage_slot_state_with_expiry_by_address_daily) FINAL
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
| **day_start_date** | `Date` | *Start of the day period* |
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of day (with expiry applied)* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of day (with expiry applied)* |

## fct_storage_slot_state_with_expiry_by_address_hourly

Storage slot state metrics per address with expiry policies aggregated by hour

### Availability
Data is partitioned by **(expiry_policy, toStartOfMonth(hour_start_date_time))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_with_expiry_by_address_hourly`
- **sepolia**: `sepolia.fct_storage_slot_state_with_expiry_by_address_hourly`
- **holesky**: `holesky.fct_storage_slot_state_with_expiry_by_address_hourly`
- **hoodi**: `hoodi.fct_storage_slot_state_with_expiry_by_address_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_with_expiry_by_address_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_storage_slot_state_with_expiry_by_address_hourly) FINAL
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
| **hour_start_date_time** | `DateTime` | *Start of the hour period* |
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of hour (with expiry applied)* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of hour (with expiry applied)* |

## fct_storage_slot_state_with_expiry_by_block_daily

Storage slot state metrics with expiry policies aggregated by day

### Availability
Data is partitioned by **(expiry_policy, toYYYYMM(day_start_date))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_with_expiry_by_block_daily`
- **sepolia**: `sepolia.fct_storage_slot_state_with_expiry_by_block_daily`
- **holesky**: `holesky.fct_storage_slot_state_with_expiry_by_block_daily`
- **hoodi**: `hoodi.fct_storage_slot_state_with_expiry_by_block_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_with_expiry_by_block_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_storage_slot_state_with_expiry_by_block_daily) FINAL
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
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of day (with expiry applied)* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of day (with expiry applied)* |

## fct_storage_slot_state_with_expiry_by_block_hourly

Storage slot state metrics with expiry policies aggregated by hour

### Availability
Data is partitioned by **(expiry_policy, toStartOfMonth(hour_start_date_time))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_state_with_expiry_by_block_hourly`
- **sepolia**: `sepolia.fct_storage_slot_state_with_expiry_by_block_hourly`
- **holesky**: `holesky.fct_storage_slot_state_with_expiry_by_block_hourly`
- **hoodi**: `hoodi.fct_storage_slot_state_with_expiry_by_block_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_state_with_expiry_by_block_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_storage_slot_state_with_expiry_by_block_hourly) FINAL
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
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at end of hour (with expiry applied)* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at end of hour (with expiry applied)* |

## fct_storage_slot_top_100_by_bytes

Top 100 contracts by effective storage bytes with expiry policies applied

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_top_100_by_bytes`
- **sepolia**: `sepolia.fct_storage_slot_top_100_by_bytes`
- **holesky**: `holesky.fct_storage_slot_top_100_by_bytes`
- **hoodi**: `hoodi.fct_storage_slot_top_100_by_bytes`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_top_100_by_bytes FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_storage_slot_top_100_by_bytes) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **expiry_policy** | `Nullable(String)` | *Expiry policy identifier: NULL (raw), 1m, 6m, 12m, 18m, 24m* |
| **rank** | `UInt32` | *Rank by effective bytes (1=highest), based on raw state* |
| **contract_address** | `String` | *The contract address* |
| **effective_bytes** | `Int64` | *Effective bytes of storage for this contract* |
| **active_slots** | `Int64` | *Number of active storage slots for this contract* |
| **owner_key** | `Nullable(String)` | *Owner key identifier* |
| **account_owner** | `Nullable(String)` | *Account owner of the contract* |
| **contract_name** | `Nullable(String)` | *Name of the contract* |
| **factory_contract** | `Nullable(String)` | *Factory contract or deployer address* |
| **labels** | `Array(String)` | *Labels/categories (e.g., stablecoin, dex, circle)* |

## fct_storage_slot_top_100_by_slots

Top 100 contracts by active storage slot count with expiry policies applied

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_storage_slot_top_100_by_slots`
- **sepolia**: `sepolia.fct_storage_slot_top_100_by_slots`
- **holesky**: `holesky.fct_storage_slot_top_100_by_slots`
- **hoodi**: `hoodi.fct_storage_slot_top_100_by_slots`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_storage_slot_top_100_by_slots FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_storage_slot_top_100_by_slots) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **expiry_policy** | `Nullable(String)` | *Expiry policy identifier: NULL (raw), 1m, 6m, 12m, 18m, 24m* |
| **rank** | `UInt32` | *Rank by active slots (1=highest), based on raw state* |
| **contract_address** | `String` | *The contract address* |
| **active_slots** | `Int64` | *Number of active storage slots for this contract* |
| **effective_bytes** | `Int64` | *Effective bytes of storage for this contract* |
| **owner_key** | `Nullable(String)` | *Owner key identifier* |
| **account_owner** | `Nullable(String)` | *Account owner of the contract* |
| **contract_name** | `Nullable(String)` | *Name of the contract* |
| **factory_contract** | `Nullable(String)` | *Factory contract or deployer address* |
| **labels** | `Array(String)` | *Labels/categories (e.g., stablecoin, dex, circle)* |

## fct_sync_committee_participation_by_validator

Per-slot sync committee participation by validator

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_sync_committee_participation_by_validator`
- **sepolia**: `sepolia.fct_sync_committee_participation_by_validator`
- **holesky**: `holesky.fct_sync_committee_participation_by_validator`
- **hoodi**: `hoodi.fct_sync_committee_participation_by_validator`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_sync_committee_participation_by_validator FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_sync_committee_participation_by_validator) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt64` | *The slot number* |
| **slot_start_date_time** | `DateTime` | *The start time of the slot* |
| **validator_index** | `UInt32` | *Index of the validator* |
| **participated** | `Bool` | *Whether the validator participated in sync committee for this slot* |

## fct_sync_committee_participation_by_validator_daily

Daily aggregation of per-validator sync committee participation

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_sync_committee_participation_by_validator_daily`
- **sepolia**: `sepolia.fct_sync_committee_participation_by_validator_daily`
- **holesky**: `holesky.fct_sync_committee_participation_by_validator_daily`
- **hoodi**: `hoodi.fct_sync_committee_participation_by_validator_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_sync_committee_participation_by_validator_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_sync_committee_participation_by_validator_daily) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **day_start_date** | `Date` | *The start of the day for this aggregation* |
| **validator_index** | `UInt32` | *Index of the validator* |
| **total_slots** | `UInt32` | *Total sync committee slots for the validator in this day* |
| **participated_count** | `UInt32` | *Number of slots where validator participated* |
| **missed_count** | `UInt32` | *Number of slots where validator missed* |

## fct_sync_committee_participation_by_validator_hourly

Hourly aggregation of per-validator sync committee participation

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_sync_committee_participation_by_validator_hourly`
- **sepolia**: `sepolia.fct_sync_committee_participation_by_validator_hourly`
- **holesky**: `holesky.fct_sync_committee_participation_by_validator_hourly`
- **hoodi**: `hoodi.fct_sync_committee_participation_by_validator_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_sync_committee_participation_by_validator_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_sync_committee_participation_by_validator_hourly) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **hour_start_date_time** | `DateTime` | *The start of the hour for this aggregation* |
| **validator_index** | `UInt32` | *Index of the validator* |
| **total_slots** | `UInt32` | *Total sync committee slots for the validator in this hour* |
| **participated_count** | `UInt32` | *Number of slots where validator participated* |
| **missed_count** | `UInt32` | *Number of slots where validator missed* |

## fct_validator_balance

Per-epoch validator balance and status

### Availability
Data is partitioned by **toStartOfMonth(epoch_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_validator_balance`
- **sepolia**: `sepolia.fct_validator_balance`
- **holesky**: `holesky.fct_validator_balance`
- **hoodi**: `hoodi.fct_validator_balance`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_validator_balance FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_validator_balance) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **epoch** | `UInt32` | *The epoch number* |
| **epoch_start_date_time** | `DateTime` | *The start time of the epoch* |
| **validator_index** | `UInt32` | *The index of the validator* |
| **balance** | `UInt64` | *Validator balance at this epoch in Gwei* |
| **effective_balance** | `UInt64` | *Effective balance at this epoch in Gwei* |
| **status** | `LowCardinality(String)` | *Validator status at this epoch* |
| **slashed** | `Bool` | *Whether the validator was slashed (as of this epoch)* |

## fct_validator_balance_daily

Daily validator balance snapshots aggregated from per-epoch data

### Availability
Data is partitioned by **toStartOfMonth(day_start_date)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_validator_balance_daily`
- **sepolia**: `sepolia.fct_validator_balance_daily`
- **holesky**: `holesky.fct_validator_balance_daily`
- **hoodi**: `hoodi.fct_validator_balance_daily`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_validator_balance_daily FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_validator_balance_daily) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **day_start_date** | `Date` | *The start of the day for this aggregation* |
| **validator_index** | `UInt32` | *The index of the validator* |
| **start_epoch** | `UInt32` | *First epoch in this day for this validator* |
| **end_epoch** | `UInt32` | *Last epoch in this day for this validator* |
| **start_balance** | `Nullable(UInt64)` | *Balance at start of day (first epoch) in Gwei* |
| **end_balance** | `Nullable(UInt64)` | *Balance at end of day (last epoch) in Gwei* |
| **min_balance** | `Nullable(UInt64)` | *Minimum balance during the day in Gwei* |
| **max_balance** | `Nullable(UInt64)` | *Maximum balance during the day in Gwei* |
| **effective_balance** | `Nullable(UInt64)` | *Effective balance at end of day in Gwei* |
| **status** | `LowCardinality(String)` | *Validator status at end of day* |
| **slashed** | `Bool` | *Whether the validator was slashed (as of end of day)* |

## fct_validator_balance_hourly

Hourly validator balance snapshots aggregated from per-epoch data

### Availability
Data is partitioned by **toStartOfMonth(hour_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.fct_validator_balance_hourly`
- **sepolia**: `sepolia.fct_validator_balance_hourly`
- **holesky**: `holesky.fct_validator_balance_hourly`
- **hoodi**: `hoodi.fct_validator_balance_hourly`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.fct_validator_balance_hourly FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.fct_validator_balance_hourly) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **hour_start_date_time** | `DateTime` | *The start of the hour for this aggregation* |
| **validator_index** | `UInt32` | *The index of the validator* |
| **start_epoch** | `UInt32` | *First epoch in this hour for this validator* |
| **end_epoch** | `UInt32` | *Last epoch in this hour for this validator* |
| **start_balance** | `Nullable(UInt64)` | *Balance at start of hour (first epoch) in Gwei* |
| **end_balance** | `Nullable(UInt64)` | *Balance at end of hour (last epoch) in Gwei* |
| **min_balance** | `Nullable(UInt64)` | *Minimum balance during the hour in Gwei* |
| **max_balance** | `Nullable(UInt64)` | *Maximum balance during the hour in Gwei* |
| **effective_balance** | `Nullable(UInt64)` | *Effective balance at end of hour in Gwei* |
| **status** | `LowCardinality(String)` | *Validator status at end of hour* |
| **slashed** | `Bool` | *Whether the validator was slashed (as of end of hour)* |

## helper_contract_storage_next_touch_latest_state

Latest state per contract for efficient lookups. Helper table for int_contract_storage_next_touch.

### Availability
This table has no partitioning.

Available in the following network-specific databases:

- **mainnet**: `mainnet.helper_contract_storage_next_touch_latest_state`
- **sepolia**: `sepolia.helper_contract_storage_next_touch_latest_state`
- **holesky**: `holesky.helper_contract_storage_next_touch_latest_state`
- **hoodi**: `hoodi.helper_contract_storage_next_touch_latest_state`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.helper_contract_storage_next_touch_latest_state FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.helper_contract_storage_next_touch_latest_state) FINAL
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
| **block_number** | `UInt32` | *The block number of the latest touch for this contract* |
| **next_touch_block** | `Nullable(UInt32)` | *The next block where this contract was touched (NULL if no subsequent touch yet)* |

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
    FROM cluster('{cbt_cluster}', mainnet.helper_storage_slot_next_touch_latest_state) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_address_first_access) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_address_last_access) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_address_storage_slot_first_access) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_address_storage_slot_last_access) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_attestation_attested_canonical) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_attestation_attested_head) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_attestation_first_seen) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_beacon_committee_head) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_block_blob_count_canonical) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_block_canonical) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_block_mev_canonical) FINAL
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

## int_block_opcode_gas

Aggregated opcode-level gas usage per block. Derived from int_transaction_opcode_gas.

### Availability
Data is partitioned by **intDiv(block_number, 201600)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_block_opcode_gas`
- **sepolia**: `sepolia.int_block_opcode_gas`
- **holesky**: `holesky.int_block_opcode_gas`
- **hoodi**: `hoodi.int_block_opcode_gas`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_block_opcode_gas FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_block_opcode_gas) FINAL
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
| **opcode** | `LowCardinality(String)` | *The EVM opcode name (e.g., SLOAD, ADD, CALL)* |
| **count** | `UInt64` | *Total execution count of this opcode across all transactions in the block* |
| **gas** | `UInt64` | *Total gas consumed by this opcode across all transactions in the block* |
| **error_count** | `UInt64` | *Number of times this opcode resulted in an error across all transactions* |
| **meta_network_name** | `LowCardinality(String)` | *The name of the network* |

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
    FROM cluster('{cbt_cluster}', mainnet.int_block_proposer_canonical) FINAL
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

## int_contract_creation

Contract creation events with projection for efficient address lookups

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_creation`
- **sepolia**: `sepolia.int_contract_creation`
- **holesky**: `holesky.int_contract_creation`
- **hoodi**: `hoodi.int_contract_creation`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_creation FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_creation) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *Block where contract was created* |
| **transaction_hash** | `String` | *Transaction hash* |
| **transaction_index** | `UInt16` | *Position in block* |
| **internal_index** | `UInt32` | *Position within transaction* |
| **contract_address** | `String` | *Address of created contract* |
| **deployer** | `String` | *Address that deployed the contract* |
| **factory** | `String` | *Factory contract address if applicable* |
| **init_code_hash** | `String` | *Hash of the initialization code* |

## int_contract_selfdestruct

SELFDESTRUCT operations with EIP-6780 storage clearing implications

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_selfdestruct`
- **sepolia**: `sepolia.int_contract_selfdestruct`
- **holesky**: `holesky.int_contract_selfdestruct`
- **hoodi**: `hoodi.int_contract_selfdestruct`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_selfdestruct FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_selfdestruct) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *Block where SELFDESTRUCT occurred* |
| **transaction_hash** | `String` | *Transaction hash* |
| **transaction_index** | `UInt16` | *Position in block* |
| **internal_index** | `UInt32` | *Position within transaction traces* |
| **address** | `String` | *Contract that was destroyed* |
| **beneficiary** | `String` | *Address receiving the ETH* |
| **value_transferred** | `UInt256` | *Amount of ETH sent to beneficiary* |
| **ephemeral** | `Bool` | *True if contract was created and destroyed in the same transaction - storage always cleared per EIP-6780* |
| **storage_cleared** | `Bool` | *True if storage was cleared (pre-Shanghai OR ephemeral)* |
| **creation_block** | `Nullable(UInt32)` | *Block where contract was created (if known)* |
| **creation_transaction_hash** | `Nullable(String)` | *Transaction that created the contract (if known)* |

## int_contract_storage_expiry_12m

Contract-level 12-month expiries - waterfalls from 6m tier

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_expiry_12m`
- **sepolia**: `sepolia.int_contract_storage_expiry_12m`
- **holesky**: `holesky.int_contract_storage_expiry_12m`
- **hoodi**: `hoodi.int_contract_storage_expiry_12m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_expiry_12m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_expiry_12m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this contract expiry is recorded* |
| **address** | `String` | *The contract address* |
| **touch_block** | `UInt32` | *The original touch block that led to this expiry (propagates through waterfall chain)* |
| **active_slots** | `UInt64` | *Count of slots in the contract at expiry time* |
| **effective_bytes** | `UInt64` | *Sum of effective bytes across all slots in the contract at expiry time* |

## int_contract_storage_expiry_18m

Contract-level 18-month expiries - waterfalls from 12m tier

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_expiry_18m`
- **sepolia**: `sepolia.int_contract_storage_expiry_18m`
- **holesky**: `holesky.int_contract_storage_expiry_18m`
- **hoodi**: `hoodi.int_contract_storage_expiry_18m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_expiry_18m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_expiry_18m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this contract expiry is recorded* |
| **address** | `String` | *The contract address* |
| **touch_block** | `UInt32` | *The original touch block that led to this expiry (propagates through waterfall chain)* |
| **active_slots** | `UInt64` | *Count of slots in the contract at expiry time* |
| **effective_bytes** | `UInt64` | *Sum of effective bytes across all slots in the contract at expiry time* |

## int_contract_storage_expiry_1m

Contract-level 1-month expiries - base tier of waterfall chain

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_expiry_1m`
- **sepolia**: `sepolia.int_contract_storage_expiry_1m`
- **holesky**: `holesky.int_contract_storage_expiry_1m`
- **hoodi**: `hoodi.int_contract_storage_expiry_1m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_expiry_1m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_expiry_1m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this contract expiry is recorded* |
| **address** | `String` | *The contract address* |
| **touch_block** | `UInt32` | *The original touch block that led to this expiry (propagates through waterfall chain)* |
| **active_slots** | `UInt64` | *Count of slots in the contract at expiry time* |
| **effective_bytes** | `UInt64` | *Sum of effective bytes across all slots in the contract at expiry time* |

## int_contract_storage_expiry_24m

Contract-level 24-month expiries - waterfalls from 18m tier

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_expiry_24m`
- **sepolia**: `sepolia.int_contract_storage_expiry_24m`
- **holesky**: `holesky.int_contract_storage_expiry_24m`
- **hoodi**: `hoodi.int_contract_storage_expiry_24m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_expiry_24m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_expiry_24m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this contract expiry is recorded* |
| **address** | `String` | *The contract address* |
| **touch_block** | `UInt32` | *The original touch block that led to this expiry (propagates through waterfall chain)* |
| **active_slots** | `UInt64` | *Count of slots in the contract at expiry time* |
| **effective_bytes** | `UInt64` | *Sum of effective bytes across all slots in the contract at expiry time* |

## int_contract_storage_expiry_6m

Contract-level 6-month expiries - waterfalls from 1m tier

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_expiry_6m`
- **sepolia**: `sepolia.int_contract_storage_expiry_6m`
- **holesky**: `holesky.int_contract_storage_expiry_6m`
- **hoodi**: `hoodi.int_contract_storage_expiry_6m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_expiry_6m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_expiry_6m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this contract expiry is recorded* |
| **address** | `String` | *The contract address* |
| **touch_block** | `UInt32` | *The original touch block that led to this expiry (propagates through waterfall chain)* |
| **active_slots** | `UInt64` | *Count of slots in the contract at expiry time* |
| **effective_bytes** | `UInt64` | *Sum of effective bytes across all slots in the contract at expiry time* |

## int_contract_storage_next_touch

Contract-level touches with precomputed next touch block - a touch is any slot read or write on the contract

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_next_touch`
- **sepolia**: `sepolia.int_contract_storage_next_touch`
- **holesky**: `holesky.int_contract_storage_next_touch`
- **hoodi**: `hoodi.int_contract_storage_next_touch`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_next_touch FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_next_touch) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this contract was touched* |
| **address** | `String` | *The contract address* |
| **next_touch_block** | `Nullable(UInt32)` | *The next block number where this contract was touched (NULL if no subsequent touch)* |

## int_contract_storage_reactivation_12m

Contract-level 12-month reactivations - contracts touched after 12m expiry

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_reactivation_12m`
- **sepolia**: `sepolia.int_contract_storage_reactivation_12m`
- **holesky**: `holesky.int_contract_storage_reactivation_12m`
- **hoodi**: `hoodi.int_contract_storage_reactivation_12m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_reactivation_12m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_reactivation_12m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this contract was reactivated* |
| **address** | `String` | *The contract address* |
| **touch_block** | `UInt32` | *The original touch block that expired (for matching with expiry records)* |
| **active_slots** | `UInt64` | *Count of slots being reactivated* |
| **effective_bytes** | `UInt64` | *Sum of effective bytes being reactivated* |

## int_contract_storage_reactivation_18m

Contract-level 18-month reactivations - contracts touched after 18m expiry

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_reactivation_18m`
- **sepolia**: `sepolia.int_contract_storage_reactivation_18m`
- **holesky**: `holesky.int_contract_storage_reactivation_18m`
- **hoodi**: `hoodi.int_contract_storage_reactivation_18m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_reactivation_18m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_reactivation_18m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this contract was reactivated* |
| **address** | `String` | *The contract address* |
| **touch_block** | `UInt32` | *The original touch block that expired (for matching with expiry records)* |
| **active_slots** | `UInt64` | *Count of slots being reactivated* |
| **effective_bytes** | `UInt64` | *Sum of effective bytes being reactivated* |

## int_contract_storage_reactivation_1m

Contract-level 1-month reactivations - contracts touched after 1m expiry

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_reactivation_1m`
- **sepolia**: `sepolia.int_contract_storage_reactivation_1m`
- **holesky**: `holesky.int_contract_storage_reactivation_1m`
- **hoodi**: `hoodi.int_contract_storage_reactivation_1m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_reactivation_1m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_reactivation_1m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this contract was reactivated* |
| **address** | `String` | *The contract address* |
| **touch_block** | `UInt32` | *The original touch block that expired (for matching with expiry records)* |
| **active_slots** | `UInt64` | *Count of slots being reactivated* |
| **effective_bytes** | `UInt64` | *Sum of effective bytes being reactivated* |

## int_contract_storage_reactivation_24m

Contract-level 24-month reactivations - contracts touched after 24m expiry

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_reactivation_24m`
- **sepolia**: `sepolia.int_contract_storage_reactivation_24m`
- **holesky**: `holesky.int_contract_storage_reactivation_24m`
- **hoodi**: `hoodi.int_contract_storage_reactivation_24m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_reactivation_24m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_reactivation_24m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this contract was reactivated* |
| **address** | `String` | *The contract address* |
| **touch_block** | `UInt32` | *The original touch block that expired (for matching with expiry records)* |
| **active_slots** | `UInt64` | *Count of slots being reactivated* |
| **effective_bytes** | `UInt64` | *Sum of effective bytes being reactivated* |

## int_contract_storage_reactivation_6m

Contract-level 6-month reactivations - contracts touched after 6m expiry

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_reactivation_6m`
- **sepolia**: `sepolia.int_contract_storage_reactivation_6m`
- **holesky**: `holesky.int_contract_storage_reactivation_6m`
- **hoodi**: `hoodi.int_contract_storage_reactivation_6m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_reactivation_6m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_reactivation_6m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this contract was reactivated* |
| **address** | `String` | *The contract address* |
| **touch_block** | `UInt32` | *The original touch block that expired (for matching with expiry records)* |
| **active_slots** | `UInt64` | *Count of slots being reactivated* |
| **effective_bytes** | `UInt64` | *Sum of effective bytes being reactivated* |

## int_contract_storage_state

Cumulative contract storage state per block per address - tracks active slots and effective bytes with per-block deltas

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_state`
- **sepolia**: `sepolia.int_contract_storage_state`
- **holesky**: `holesky.int_contract_storage_state`
- **hoodi**: `hoodi.int_contract_storage_state`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_state FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_state) FINAL
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
| **slots_delta** | `Int32` | *Change in active slots for this block (positive=activated, negative=deactivated)* |
| **bytes_delta** | `Int64` | *Change in effective bytes for this block* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots for this contract at this block* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes for this contract at this block* |

## int_contract_storage_state_by_address

Cumulative contract storage state per block per address - ordered by address for efficient address-based queries

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_state_by_address`
- **sepolia**: `sepolia.int_contract_storage_state_by_address`
- **holesky**: `holesky.int_contract_storage_state_by_address`
- **hoodi**: `hoodi.int_contract_storage_state_by_address`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_state_by_address FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_state_by_address) FINAL
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
| **slots_delta** | `Int32` | *Change in active slots for this block (positive=activated, negative=deactivated)* |
| **bytes_delta** | `Int64` | *Change in effective bytes for this block* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots for this contract at this block* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes for this contract at this block* |

## int_contract_storage_state_by_block

Cumulative contract storage state per block - tracks active slots, effective bytes, and active contracts with per-block deltas

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_state_by_block`
- **sepolia**: `sepolia.int_contract_storage_state_by_block`
- **holesky**: `holesky.int_contract_storage_state_by_block`
- **hoodi**: `hoodi.int_contract_storage_state_by_block`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_state_by_block FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_state_by_block) FINAL
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
| **contracts_delta** | `Int32` | *Change in active contracts for this block (positive=activated, negative=deactivated)* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at this block* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes across all active slots at this block* |
| **active_contracts** | `Int64` | *Cumulative count of contracts with at least one active slot at this block* |

## int_contract_storage_state_with_expiry

Contract-level expiry state base table - tracks deltas and cumulative adjustments per address per policy

### Availability
Data is partitioned by **(expiry_policy, intDiv(block_number, 5000000))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_state_with_expiry`
- **sepolia**: `sepolia.int_contract_storage_state_with_expiry`
- **holesky**: `holesky.int_contract_storage_state_with_expiry`
- **hoodi**: `hoodi.int_contract_storage_state_with_expiry`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_state_with_expiry FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_state_with_expiry) FINAL
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
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **net_slots_delta** | `Int32` | *Net slot adjustment this block (negative=expiry, positive=reactivation)* |
| **net_bytes_delta** | `Int64` | *Net bytes adjustment this block (negative=expiry, positive=reactivation)* |
| **cumulative_net_slots** | `Int64` | *Cumulative net slot adjustment up to this block* |
| **cumulative_net_bytes** | `Int64` | *Cumulative net bytes adjustment up to this block* |
| **active_slots** | `Int64` | *Number of active storage slots in this contract (with expiry applied)* |
| **effective_bytes** | `Int64` | *Effective bytes for this contract (with expiry applied)* |
| **prev_active_slots** | `Int64` | *Previous block active_slots for this address (for transition detection)* |
| **prev_effective_bytes** | `Int64` | *Previous block effective_bytes for this address (for delta calculation)* |

## int_contract_storage_state_with_expiry_by_address

Contract-level expiry state ordered by address - tracks active_slots and effective_bytes per contract

### Availability
Data is partitioned by **(expiry_policy, intDiv(block_number, 5000000))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_state_with_expiry_by_address`
- **sepolia**: `sepolia.int_contract_storage_state_with_expiry_by_address`
- **holesky**: `holesky.int_contract_storage_state_with_expiry_by_address`
- **hoodi**: `hoodi.int_contract_storage_state_with_expiry_by_address`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_state_with_expiry_by_address FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_state_with_expiry_by_address) FINAL
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
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **active_slots** | `Int64` | *Number of active storage slots in this contract (0 if expired)* |
| **effective_bytes** | `Int64` | *Effective bytes for this contract (0 if expired)* |

## int_contract_storage_state_with_expiry_by_block

Contract-level expiry state per block network-wide - totals for slots, bytes, and active contracts

### Availability
Data is partitioned by **expiry_policy**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_contract_storage_state_with_expiry_by_block`
- **sepolia**: `sepolia.int_contract_storage_state_with_expiry_by_block`
- **holesky**: `holesky.int_contract_storage_state_with_expiry_by_block`
- **hoodi**: `hoodi.int_contract_storage_state_with_expiry_by_block`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_contract_storage_state_with_expiry_by_block FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_contract_storage_state_with_expiry_by_block) FINAL
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
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **active_slots** | `Int64` | *Total active storage slots network-wide (with expiry applied)* |
| **effective_bytes** | `Int64` | *Total effective bytes network-wide (with expiry applied)* |
| **active_contracts** | `Int64` | *Count of contracts with active_slots > 0 (with expiry applied)* |

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
    FROM cluster('{cbt_cluster}', mainnet.int_custody_probe) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_custody_probe_order_by_slot) FINAL
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

## int_engine_get_blobs

Individual engine_getBlobs observations enriched with slot context from beacon blob sidecar data

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_engine_get_blobs`
- **sepolia**: `sepolia.int_engine_get_blobs`
- **holesky**: `holesky.int_engine_get_blobs`
- **hoodi**: `hoodi.int_engine_get_blobs`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_engine_get_blobs FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_engine_get_blobs) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event* |
| **requested_date_time** | `DateTime64(3)` | *When the engine_getBlobs call was initiated* |
| **duration_ms** | `UInt32` | *How long the engine_getBlobs call took in milliseconds* |
| **slot** | `UInt32` | *Slot number of the beacon block containing the blobs* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number derived from the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *Root of the beacon block (hex encoded with 0x prefix)* |
| **block_parent_root** | `FixedString(66)` | *Root of the parent beacon block (hex encoded with 0x prefix)* |
| **proposer_index** | `UInt32` | *Validator index of the block proposer* |
| **requested_count** | `UInt32` | *Number of blobs requested (length of versioned_hashes array)* |
| **versioned_hashes** | `Array(FixedString(66))` | *Versioned hashes of the requested blobs* |
| **returned_count** | `UInt32` | *Number of blobs actually returned* |
| **returned_blob_indexes** | `Array(UInt8)` | *Indexes of the returned blobs* |
| **status** | `LowCardinality(String)` | *Engine API response status (SUCCESS, PARTIAL, EMPTY, UNSUPPORTED, ERROR)* |
| **error_message** | `Nullable(String)` | *Error message when the call fails* |
| **method_version** | `LowCardinality(String)` | *Version of the engine_getBlobs method* |
| **source** | `LowCardinality(String)` | *Source of the engine event* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **meta_execution_version** | `LowCardinality(String)` | *Full execution client version string from web3_clientVersion RPC* |
| **meta_execution_implementation** | `LowCardinality(String)` | *Execution client implementation name (e.g., Geth, Nethermind, Besu, Reth)* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client that generated the event* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client that generated the event* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client that generated the event* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client that generated the event* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client that generated the event* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client that generated the event* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client that generated the event* |

## int_engine_new_payload

Individual engine_newPayload observations enriched with block size from fct_block_head

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_engine_new_payload`
- **sepolia**: `sepolia.int_engine_new_payload`
- **holesky**: `holesky.int_engine_new_payload`
- **hoodi**: `hoodi.int_engine_new_payload`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_engine_new_payload FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_engine_new_payload) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the sentry received the event* |
| **requested_date_time** | `DateTime64(3)` | *When the engine_newPayload call was initiated* |
| **duration_ms** | `UInt64` | *How long the engine_newPayload call took in milliseconds* |
| **slot** | `UInt32` | *Slot number of the beacon block containing the payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number derived from the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *Root of the beacon block (hex encoded with 0x prefix)* |
| **block_hash** | `FixedString(66)` | *Execution block hash (hex encoded with 0x prefix)* |
| **block_number** | `UInt64` | *Execution block number* |
| **parent_block_root** | `FixedString(66)` | *Root of the parent beacon block (hex encoded with 0x prefix)* |
| **parent_hash** | `FixedString(66)` | *Parent execution block hash (hex encoded with 0x prefix)* |
| **proposer_index** | `UInt32` | *Validator index of the block proposer* |
| **gas_used** | `UInt64` | *Total gas used by all transactions in the block* |
| **gas_limit** | `UInt64` | *Gas limit of the block* |
| **tx_count** | `UInt32` | *Number of transactions in the block* |
| **blob_count** | `UInt32` | *Number of blobs in the block* |
| **status** | `LowCardinality(String)` | *Engine API response status (VALID, INVALID, SYNCING, ACCEPTED, INVALID_BLOCK_HASH, ERROR)* |
| **validation_error** | `Nullable(String)` | *Error message when validation fails* |
| **latest_valid_hash** | `Nullable(FixedString(66))` | *Latest valid hash when status is INVALID (hex encoded with 0x prefix)* |
| **method_version** | `LowCardinality(String)` | *Version of the engine_newPayload method (e.g., V3, V4)* |
| **block_total_bytes** | `Nullable(UInt32)` | *The total bytes of the beacon block payload* |
| **block_total_bytes_compressed** | `Nullable(UInt32)` | *The total bytes of the beacon block payload when compressed using snappy* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block (phase0, altair, bellatrix, capella, deneb)* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **meta_execution_version** | `LowCardinality(String)` | *Full execution client version string from web3_clientVersion RPC* |
| **meta_execution_implementation** | `LowCardinality(String)` | *Execution client implementation name (e.g., Geth, Nethermind, Besu, Reth)* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client that generated the event* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client that generated the event* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client that generated the event* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client that generated the event* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client that generated the event* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client that generated the event* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client that generated the event* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client that generated the event* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client that generated the event* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *Autonomous system number of the client that generated the event* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *Autonomous system organization of the client that generated the event* |

## int_engine_new_payload_fastest_execution_by_node_class

Fastest valid engine_newPayload observation per slot per node_class

### Availability
Data is partitioned by **toStartOfMonth(slot_start_date_time)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_engine_new_payload_fastest_execution_by_node_class`
- **sepolia**: `sepolia.int_engine_new_payload_fastest_execution_by_node_class`
- **holesky**: `holesky.int_engine_new_payload_fastest_execution_by_node_class`
- **hoodi**: `hoodi.int_engine_new_payload_fastest_execution_by_node_class`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_engine_new_payload_fastest_execution_by_node_class FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_engine_new_payload_fastest_execution_by_node_class) FINAL
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
| **duration_ms** | `UInt64` | *Duration of the fastest engine_newPayload call in milliseconds* |
| **node_class** | `LowCardinality(String)` | *Node classification for grouping observations (e.g., eip7870-block-builder, or empty for general nodes)* |
| **meta_execution_implementation** | `LowCardinality(String)` | *Execution client implementation name (e.g., Geth, Nethermind, Besu, Reth)* |
| **meta_execution_version** | `LowCardinality(String)` | *Full execution client version string from web3_clientVersion RPC* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client that generated the event* |

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
    FROM cluster('{cbt_cluster}', mainnet.int_execution_block_by_date) FINAL
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

## int_storage_selfdestruct_diffs

Synthetic storage diffs for selfdestructs that clear all storage slots

### Availability
Data is partitioned by **intDiv(block_number, 1000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_selfdestruct_diffs`
- **sepolia**: `sepolia.int_storage_selfdestruct_diffs`
- **holesky**: `holesky.int_storage_selfdestruct_diffs`
- **hoodi**: `hoodi.int_storage_selfdestruct_diffs`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_selfdestruct_diffs FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_selfdestruct_diffs) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *Block where SELFDESTRUCT occurred* |
| **transaction_index** | `UInt32` | *Transaction index within the block* |
| **transaction_hash** | `FixedString(66)` | *Transaction hash of the SELFDESTRUCT* |
| **internal_index** | `UInt32` | *Internal index of the SELFDESTRUCT trace* |
| **address** | `String` | *Contract address that was selfdestructed* |
| **slot** | `String` | *Storage slot key being cleared* |
| **from_value** | `String` | *Value before clearing (last known value)* |
| **to_value** | `String` | *Value after clearing (always 0x00...00)* |

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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_diff) FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_diff_by_address_slot) FINAL
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

## int_storage_slot_expiry_12m

Storage slot 12-month expiries - waterfalls from 6m tier

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_expiry_12m`
- **sepolia**: `sepolia.int_storage_slot_expiry_12m`
- **holesky**: `holesky.int_storage_slot_expiry_12m`
- **hoodi**: `hoodi.int_storage_slot_expiry_12m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_expiry_12m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_expiry_12m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot expiry is recorded* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **touch_block** | `UInt32` | *The original touch block that led to this expiry (propagates through waterfall chain)* |
| **effective_bytes** | `UInt8` | *Number of effective bytes that were set (0-32)* |

## int_storage_slot_expiry_18m

Storage slot 18-month expiries - waterfalls from 12m tier

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_expiry_18m`
- **sepolia**: `sepolia.int_storage_slot_expiry_18m`
- **holesky**: `holesky.int_storage_slot_expiry_18m`
- **hoodi**: `hoodi.int_storage_slot_expiry_18m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_expiry_18m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_expiry_18m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot expiry is recorded* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **touch_block** | `UInt32` | *The original touch block that led to this expiry (propagates through waterfall chain)* |
| **effective_bytes** | `UInt8` | *Number of effective bytes that were set (0-32)* |

## int_storage_slot_expiry_1m

Storage slot 1-month expiries - base tier of waterfall chain

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_expiry_1m`
- **sepolia**: `sepolia.int_storage_slot_expiry_1m`
- **holesky**: `holesky.int_storage_slot_expiry_1m`
- **hoodi**: `hoodi.int_storage_slot_expiry_1m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_expiry_1m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_expiry_1m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot expiry is recorded* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **touch_block** | `UInt32` | *The original touch block that led to this expiry (propagates through waterfall chain)* |
| **effective_bytes** | `UInt8` | *Number of effective bytes that were set (0-32)* |

## int_storage_slot_expiry_24m

Storage slot 24-month expiries - waterfalls from 18m tier

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_expiry_24m`
- **sepolia**: `sepolia.int_storage_slot_expiry_24m`
- **holesky**: `holesky.int_storage_slot_expiry_24m`
- **hoodi**: `hoodi.int_storage_slot_expiry_24m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_expiry_24m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_expiry_24m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot expiry is recorded* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **touch_block** | `UInt32` | *The original touch block that led to this expiry (propagates through waterfall chain)* |
| **effective_bytes** | `UInt8` | *Number of effective bytes that were set (0-32)* |

## int_storage_slot_expiry_6m

Storage slot 6-month expiries - waterfalls from 1m tier

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_expiry_6m`
- **sepolia**: `sepolia.int_storage_slot_expiry_6m`
- **holesky**: `holesky.int_storage_slot_expiry_6m`
- **hoodi**: `hoodi.int_storage_slot_expiry_6m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_expiry_6m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_expiry_6m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot expiry is recorded* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **touch_block** | `UInt32` | *The original touch block that led to this expiry (propagates through waterfall chain)* |
| **effective_bytes** | `UInt8` | *Number of effective bytes that were set (0-32)* |

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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_next_touch) FINAL
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

## int_storage_slot_reactivation_12m

Storage slot 12-month reactivations - slots touched after 12m expiry

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_reactivation_12m`
- **sepolia**: `sepolia.int_storage_slot_reactivation_12m`
- **holesky**: `holesky.int_storage_slot_reactivation_12m`
- **hoodi**: `hoodi.int_storage_slot_reactivation_12m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_reactivation_12m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_reactivation_12m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot was reactivated* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **touch_block** | `UInt32` | *The original touch block that expired (for matching with expiry records)* |
| **effective_bytes** | `UInt8` | *Number of effective bytes being reactivated (0-32)* |

## int_storage_slot_reactivation_18m

Storage slot 18-month reactivations - slots touched after 18m expiry

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_reactivation_18m`
- **sepolia**: `sepolia.int_storage_slot_reactivation_18m`
- **holesky**: `holesky.int_storage_slot_reactivation_18m`
- **hoodi**: `hoodi.int_storage_slot_reactivation_18m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_reactivation_18m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_reactivation_18m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot was reactivated* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **touch_block** | `UInt32` | *The original touch block that expired (for matching with expiry records)* |
| **effective_bytes** | `UInt8` | *Number of effective bytes being reactivated (0-32)* |

## int_storage_slot_reactivation_1m

Storage slot 1-month reactivations - slots touched after 1m expiry

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_reactivation_1m`
- **sepolia**: `sepolia.int_storage_slot_reactivation_1m`
- **holesky**: `holesky.int_storage_slot_reactivation_1m`
- **hoodi**: `hoodi.int_storage_slot_reactivation_1m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_reactivation_1m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_reactivation_1m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot was reactivated* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **touch_block** | `UInt32` | *The original touch block that expired (for matching with expiry records)* |
| **effective_bytes** | `UInt8` | *Number of effective bytes being reactivated (0-32)* |

## int_storage_slot_reactivation_24m

Storage slot 24-month reactivations - slots touched after 24m expiry

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_reactivation_24m`
- **sepolia**: `sepolia.int_storage_slot_reactivation_24m`
- **holesky**: `holesky.int_storage_slot_reactivation_24m`
- **hoodi**: `hoodi.int_storage_slot_reactivation_24m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_reactivation_24m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_reactivation_24m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot was reactivated* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **touch_block** | `UInt32` | *The original touch block that expired (for matching with expiry records)* |
| **effective_bytes** | `UInt8` | *Number of effective bytes being reactivated (0-32)* |

## int_storage_slot_reactivation_6m

Storage slot 6-month reactivations - slots touched after 6m expiry

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_reactivation_6m`
- **sepolia**: `sepolia.int_storage_slot_reactivation_6m`
- **holesky**: `holesky.int_storage_slot_reactivation_6m`
- **hoodi**: `hoodi.int_storage_slot_reactivation_6m`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_reactivation_6m FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_reactivation_6m) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt32` | *The block number where this slot was reactivated* |
| **address** | `String` | *The contract address* |
| **slot_key** | `String` | *The storage slot key* |
| **touch_block** | `UInt32` | *The original touch block that expired (for matching with expiry records)* |
| **effective_bytes** | `UInt8` | *Number of effective bytes being reactivated (0-32)* |

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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_read) FINAL
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

## int_storage_slot_state

Cumulative storage slot state per block per address - tracks active slots and effective bytes with per-block deltas

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_state`
- **sepolia**: `sepolia.int_storage_slot_state`
- **holesky**: `holesky.int_storage_slot_state`
- **hoodi**: `hoodi.int_storage_slot_state`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_state FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_state) FINAL
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
| **slots_delta** | `Int32` | *Change in active slots for this block (positive=activated, negative=deactivated)* |
| **bytes_delta** | `Int64` | *Change in effective bytes for this block* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots for this address at this block* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes for this address at this block* |

## int_storage_slot_state_by_address

Cumulative storage slot state per block per address - ordered by address for efficient address-based queries

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_state_by_address`
- **sepolia**: `sepolia.int_storage_slot_state_by_address`
- **holesky**: `holesky.int_storage_slot_state_by_address`
- **hoodi**: `hoodi.int_storage_slot_state_by_address`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_state_by_address FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_state_by_address) FINAL
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
| **slots_delta** | `Int32` | *Change in active slots for this block (positive=activated, negative=deactivated)* |
| **bytes_delta** | `Int64` | *Change in effective bytes for this block* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots for this address at this block* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes for this address at this block* |

## int_storage_slot_state_by_block

Cumulative storage slot state per block - tracks active slots and effective bytes with per-block deltas

### Availability
Data is partitioned by **intDiv(block_number, 5000000)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_state_by_block`
- **sepolia**: `sepolia.int_storage_slot_state_by_block`
- **holesky**: `holesky.int_storage_slot_state_by_block`
- **hoodi**: `hoodi.int_storage_slot_state_by_block`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_state_by_block FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_state_by_block) FINAL
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

## int_storage_slot_state_with_expiry

Cumulative storage slot state per block per address with expiry policies - supports 1m, 6m, 12m, 18m, 24m waterfall

### Availability
Data is partitioned by **(expiry_policy, intDiv(block_number, 5000000))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_state_with_expiry`
- **sepolia**: `sepolia.int_storage_slot_state_with_expiry`
- **holesky**: `holesky.int_storage_slot_state_with_expiry`
- **hoodi**: `hoodi.int_storage_slot_state_with_expiry`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_state_with_expiry FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_state_with_expiry) FINAL
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
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **net_slots_delta** | `Int32` | *Net slot adjustment this block (negative=expiry, positive=reactivation)* |
| **net_bytes_delta** | `Int64` | *Net bytes adjustment this block (negative=expiry, positive=reactivation)* |
| **cumulative_net_slots** | `Int64` | *Cumulative net slot adjustment up to this block* |
| **cumulative_net_bytes** | `Int64` | *Cumulative net bytes adjustment up to this block* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots for this address at this block (with expiry applied)* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes for this address at this block (with expiry applied)* |

## int_storage_slot_state_with_expiry_by_address

Cumulative storage slot state per block per address with expiry policies - ordered by address for efficient address lookups

### Availability
Data is partitioned by **(expiry_policy, intDiv(block_number, 5000000))**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_state_with_expiry_by_address`
- **sepolia**: `sepolia.int_storage_slot_state_with_expiry_by_address`
- **holesky**: `holesky.int_storage_slot_state_with_expiry_by_address`
- **hoodi**: `hoodi.int_storage_slot_state_with_expiry_by_address`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_state_with_expiry_by_address FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_state_with_expiry_by_address) FINAL
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
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **net_slots_delta** | `Int32` | *Net slot adjustment this block (negative=expiry, positive=reactivation)* |
| **net_bytes_delta** | `Int64` | *Net bytes adjustment this block (negative=expiry, positive=reactivation)* |
| **cumulative_net_slots** | `Int64` | *Cumulative net slot adjustment up to this block* |
| **cumulative_net_bytes** | `Int64` | *Cumulative net bytes adjustment up to this block* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots for this address at this block (with expiry applied)* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes for this address at this block (with expiry applied)* |

## int_storage_slot_state_with_expiry_by_block

Cumulative storage slot state per block with expiry policies - supports 1m, 6m, 12m, 18m, 24m waterfall

### Availability
Data is partitioned by **expiry_policy**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_storage_slot_state_with_expiry_by_block`
- **sepolia**: `sepolia.int_storage_slot_state_with_expiry_by_block`
- **holesky**: `holesky.int_storage_slot_state_with_expiry_by_block`
- **hoodi**: `hoodi.int_storage_slot_state_with_expiry_by_block`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_storage_slot_state_with_expiry_by_block FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_storage_slot_state_with_expiry_by_block) FINAL
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
| **expiry_policy** | `LowCardinality(String)` | *Expiry policy identifier: 1m, 6m, 12m, 18m, 24m* |
| **net_slots_delta** | `Int32` | *Net slot adjustment this block (negative=expiry, positive=reactivation)* |
| **net_bytes_delta** | `Int64` | *Net bytes adjustment this block (negative=expiry, positive=reactivation)* |
| **cumulative_net_slots** | `Int64` | *Cumulative net slot adjustment up to this block* |
| **cumulative_net_bytes** | `Int64` | *Cumulative net bytes adjustment up to this block* |
| **active_slots** | `Int64` | *Cumulative count of active storage slots at this block (with expiry applied)* |
| **effective_bytes** | `Int64` | *Cumulative sum of effective bytes at this block (with expiry applied)* |

## int_transaction_call_frame

Aggregated call frame activity per transaction for call tree analysis

### Availability
Data is partitioned by **intDiv(block_number, 201600)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_transaction_call_frame`
- **sepolia**: `sepolia.int_transaction_call_frame`
- **holesky**: `holesky.int_transaction_call_frame`
- **hoodi**: `hoodi.int_transaction_call_frame`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_transaction_call_frame FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_transaction_call_frame) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number containing this transaction* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash (hex encoded with 0x prefix)* |
| **transaction_index** | `UInt32` | *Position of the transaction within the block* |
| **call_frame_id** | `UInt32` | *Sequential frame ID within the transaction (0 = root)* |
| **parent_call_frame_id** | `Nullable(UInt32)` | *Parent frame ID (NULL for root frame)* |
| **depth** | `UInt32` | *Call depth (0 = root transaction execution)* |
| **target_address** | `Nullable(String)` | *Contract address being called (hex encoded with 0x prefix)* |
| **call_type** | `LowCardinality(String)` | *Type of call opcode (CALL, DELEGATECALL, STATICCALL, CALLCODE, CREATE, CREATE2)* |
| **function_selector** | `Nullable(String)` | *Function selector (first 4 bytes of call input, hex encoded with 0x prefix). Populated for all frames from traces.* |
| **opcode_count** | `UInt64` | *Number of opcodes executed in this frame* |
| **error_count** | `UInt64` | *Number of opcodes that resulted in errors* |
| **gas** | `UInt64` | *Gas consumed by this frame only, excludes child frames. sum(gas) = EVM execution gas. This is "self" gas in flame graphs.* |
| **gas_cumulative** | `UInt64` | *Gas consumed by this frame + all descendants. Root frame value = total EVM execution gas.* |
| **gas_refund** | `Nullable(UInt64)` | *Total accumulated refund. Only populated for root frame, only for successful txs (refund not applied on failure).* |
| **intrinsic_gas** | `Nullable(UInt64)` | *Intrinsic tx cost (21000 + calldata). Only populated for root frame of successful txs.* |
| **receipt_gas_used** | `Nullable(UInt64)` | *Actual gas used from transaction receipt. Only populated for root frame (call_frame_id=0). Source of truth for total gas display.* |

## int_transaction_call_frame_opcode_gas

Aggregated opcode-level gas usage per call frame. Enables per-frame opcode analysis.

### Availability
Data is partitioned by **intDiv(block_number, 201600)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_transaction_call_frame_opcode_gas`
- **sepolia**: `sepolia.int_transaction_call_frame_opcode_gas`
- **holesky**: `holesky.int_transaction_call_frame_opcode_gas`
- **hoodi**: `hoodi.int_transaction_call_frame_opcode_gas`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_transaction_call_frame_opcode_gas FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_transaction_call_frame_opcode_gas) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number containing the transaction* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash (hex encoded with 0x prefix)* |
| **transaction_index** | `UInt32` | *The index of the transaction within the block* |
| **call_frame_id** | `UInt32` | *Sequential frame ID within transaction (0 = root)* |
| **opcode** | `LowCardinality(String)` | *The EVM opcode name (e.g., SLOAD, ADD, CALL)* |
| **count** | `UInt64` | *Number of times this opcode was executed in this frame* |
| **gas** | `UInt64` | *Gas consumed by this opcode in this frame. sum(gas) = frame gas* |
| **gas_cumulative** | `UInt64` | *For CALL opcodes: includes all descendant frame gas. For others: same as gas* |
| **error_count** | `UInt64` | *Number of times this opcode resulted in an error in this frame* |
| **meta_network_name** | `LowCardinality(String)` | *The name of the network* |

## int_transaction_opcode_gas

Aggregated opcode-level gas usage per transaction. Source: canonical_execution_transaction_structlog

### Availability
Data is partitioned by **intDiv(block_number, 201600)**.

Available in the following network-specific databases:

- **mainnet**: `mainnet.int_transaction_opcode_gas`
- **sepolia**: `sepolia.int_transaction_opcode_gas`
- **holesky**: `holesky.int_transaction_opcode_gas`
- **hoodi**: `hoodi.int_transaction_opcode_gas`

### Examples

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM mainnet.int_transaction_opcode_gas FINAL
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
    FROM cluster('{cbt_cluster}', mainnet.int_transaction_opcode_gas) FINAL
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **block_number** | `UInt64` | *The block number containing the transaction* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash (hex encoded with 0x prefix)* |
| **transaction_index** | `UInt32` | *The index of the transaction within the block* |
| **opcode** | `LowCardinality(String)` | *The EVM opcode name (e.g., SLOAD, ADD, CALL)* |
| **count** | `UInt64` | *Number of times this opcode was executed in the transaction* |
| **gas** | `UInt64` | *Gas consumed by this opcode. sum(gas) = transaction executed gas* |
| **gas_cumulative** | `UInt64` | *For CALL opcodes: includes all descendant frame gas. For others: same as gas* |
| **error_count** | `UInt64` | *Number of times this opcode resulted in an error* |
| **meta_network_name** | `LowCardinality(String)` | *The name of the network* |

<!-- schema_end -->
