
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
- [`fct_block`](#fct_block)
- [`fct_block_blob_count`](#fct_block_blob_count)
- [`fct_block_blob_count_head`](#fct_block_blob_count_head)
- [`fct_block_blob_first_seen_by_node`](#fct_block_blob_first_seen_by_node)
- [`fct_block_first_seen_by_node`](#fct_block_first_seen_by_node)
- [`fct_block_head`](#fct_block_head)
- [`fct_block_mev`](#fct_block_mev)
- [`fct_block_mev_head`](#fct_block_mev_head)
- [`fct_block_proposer`](#fct_block_proposer)
- [`fct_block_proposer_entity`](#fct_block_proposer_entity)
- [`fct_block_proposer_head`](#fct_block_proposer_head)
- [`fct_mev_bid_count_by_builder`](#fct_mev_bid_count_by_builder)
- [`fct_mev_bid_count_by_relay`](#fct_mev_bid_count_by_relay)
- [`fct_mev_bid_highest_value_by_builder_chunked_50ms`](#fct_mev_bid_highest_value_by_builder_chunked_50ms)
- [`fct_node_active_last_24h`](#fct_node_active_last_24h)
- [`fct_prepared_block`](#fct_prepared_block)
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
<!-- schema_toc_end -->

<!-- schema_start -->
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
    FROM cbt.dim_node FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.dim_node FINAL
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
    FROM cbt.fct_address_access_chunked_10000 FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_address_access_chunked_10000 FINAL
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
    FROM cbt.fct_address_access_total FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_address_access_total FINAL
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
    FROM cbt.fct_address_storage_slot_chunked_10000 FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_address_storage_slot_chunked_10000 FINAL
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
    FROM cbt.fct_address_storage_slot_expired_top_100_by_contract FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_address_storage_slot_expired_top_100_by_contract FINAL
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
    FROM cbt.fct_address_storage_slot_top_100_by_contract FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_address_storage_slot_top_100_by_contract FINAL
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
    FROM cbt.fct_address_storage_slot_total FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_address_storage_slot_total FINAL
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
    FROM cbt.fct_attestation_correctness_by_validator_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_attestation_correctness_by_validator_canonical FINAL
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
    FROM cbt.fct_attestation_correctness_by_validator_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_attestation_correctness_by_validator_head FINAL
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
    FROM cbt.fct_attestation_correctness_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_attestation_correctness_canonical FINAL
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
    FROM cbt.fct_attestation_correctness_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_attestation_correctness_head FINAL
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
    FROM cbt.fct_attestation_first_seen_chunked_50ms FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_attestation_first_seen_chunked_50ms FINAL
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
    FROM cbt.fct_block FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_block FINAL
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
    FROM cbt.fct_block_blob_count FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_block_blob_count FINAL
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
    FROM cbt.fct_block_blob_count_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_block_blob_count_head FINAL
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
    FROM cbt.fct_block_blob_first_seen_by_node FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_block_blob_first_seen_by_node FINAL
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
    FROM cbt.fct_block_first_seen_by_node FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_block_first_seen_by_node FINAL
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
    FROM cbt.fct_block_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_block_head FINAL
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
    FROM cbt.fct_block_mev FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_block_mev FINAL
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
    FROM cbt.fct_block_mev_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_block_mev_head FINAL
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
    FROM cbt.fct_block_proposer FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_block_proposer FINAL
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
    FROM cbt.fct_block_proposer_entity FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_block_proposer_entity FINAL
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
    FROM cbt.fct_block_proposer_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_block_proposer_head FINAL
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
    FROM cbt.fct_mev_bid_count_by_builder FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_mev_bid_count_by_builder FINAL
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
    FROM cbt.fct_mev_bid_count_by_relay FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_mev_bid_count_by_relay FINAL
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
    FROM cbt.fct_mev_bid_highest_value_by_builder_chunked_50ms FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_mev_bid_highest_value_by_builder_chunked_50ms FINAL
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
    FROM cbt.fct_node_active_last_24h FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_node_active_last_24h FINAL
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
    FROM cbt.fct_prepared_block FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.fct_prepared_block FINAL
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
    FROM cbt.int_address_first_access FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_address_first_access FINAL
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
    FROM cbt.int_address_last_access FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_address_last_access FINAL
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
    FROM cbt.int_address_storage_slot_first_access FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_address_storage_slot_first_access FINAL
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
    FROM cbt.int_address_storage_slot_last_access FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_address_storage_slot_last_access FINAL
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
    FROM cbt.int_attestation_attested_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_attestation_attested_canonical FINAL
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
    FROM cbt.int_attestation_attested_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_attestation_attested_head FINAL
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
    FROM cbt.int_attestation_first_seen FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_attestation_first_seen FINAL
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
    FROM cbt.int_beacon_committee_head FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_beacon_committee_head FINAL
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
    FROM cbt.int_block_blob_count_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_block_blob_count_canonical FINAL
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
    FROM cbt.int_block_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_block_canonical FINAL
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
    FROM cbt.int_block_mev_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_block_mev_canonical FINAL
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
    FROM cbt.int_block_proposer_canonical FINAL
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM cbt.int_block_proposer_canonical FINAL
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

<!-- schema_end -->
