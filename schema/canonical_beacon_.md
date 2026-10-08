
Events derived from the finalized beacon chain. This data is only derived by a single instance, are deduped, and are more complete and reliable than the beacon_api_ tables. These tables can be reliably JOINed on to hydrate other tables with information

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`canonical_beacon_block`](#canonical_beacon_block)
- [`canonical_beacon_committee`](#canonical_beacon_committee)
- [`canonical_beacon_block_attester_slashing`](#canonical_beacon_block_attester_slashing)
- [`canonical_beacon_block_proposer_slashing`](#canonical_beacon_block_proposer_slashing)
- [`canonical_beacon_block_bls_to_execution_change`](#canonical_beacon_block_bls_to_execution_change)
- [`canonical_beacon_block_execution_transaction`](#canonical_beacon_block_execution_transaction)
- [`canonical_beacon_block_voluntary_exit`](#canonical_beacon_block_voluntary_exit)
- [`canonical_beacon_block_deposit`](#canonical_beacon_block_deposit)
- [`canonical_beacon_block_withdrawal`](#canonical_beacon_block_withdrawal)
- [`canonical_beacon_blob_sidecar`](#canonical_beacon_blob_sidecar)
- [`canonical_beacon_proposer_duty`](#canonical_beacon_proposer_duty)
- [`canonical_beacon_elaborated_attestation`](#canonical_beacon_elaborated_attestation)
- [`canonical_beacon_validators`](#canonical_beacon_validators)
- [`canonical_beacon_validators_pubkeys`](#canonical_beacon_validators_pubkeys)
- [`canonical_beacon_block_access_list`](#canonical_beacon_block_access_list)
- [`canonical_beacon_block_access_list_summary`](#canonical_beacon_block_access_list_summary)
- [`canonical_beacon_block_execution_payload_bid`](#canonical_beacon_block_execution_payload_bid)
- [`canonical_beacon_block_payload_attestation`](#canonical_beacon_block_payload_attestation)
- [`canonical_beacon_block_execution_request_builder_deposit`](#canonical_beacon_block_execution_request_builder_deposit)
- [`canonical_beacon_block_execution_request_builder_exit`](#canonical_beacon_block_execution_request_builder_exit)
- [`canonical_beacon_state_builder`](#canonical_beacon_state_builder)
- [`canonical_beacon_state_builder_pending_payment`](#canonical_beacon_state_builder_pending_payment)
- [`canonical_beacon_state_execution_payload_availability`](#canonical_beacon_state_execution_payload_availability)
- [`canonical_beacon_state_ptc_member`](#canonical_beacon_state_ptc_member)
<!-- schema_toc_end -->

<!-- schema_start -->
## canonical_beacon_block

Contains beacon block from a beacon node.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2026-10-07`
- **holesky**: `2023-09-23` to `2025-10-26`
- **sepolia**: `2022-06-20` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block/2026/10/7.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
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
| **execution_payload_block_hash** | `Nullable(FixedString(66))` | *The block hash of the execution payload* |
| **execution_payload_block_number** | `Nullable(UInt32)` | *The block number of the execution payload* |
| **execution_payload_fee_recipient** | `Nullable(String)` | *The recipient of the fee for this execution payload* |
| **execution_payload_base_fee_per_gas** | `Nullable(UInt128)` | *Base fee per gas for execution payload* |
| **execution_payload_blob_gas_used** | `Nullable(UInt64)` | *Gas used for blobs in execution payload* |
| **execution_payload_excess_blob_gas** | `Nullable(UInt64)` | *Excess gas used for blobs in execution payload* |
| **execution_payload_slot_number** | `Nullable(UInt64)` | ** |
| **execution_payload_block_access_list_root** | `Nullable(FixedString(66))` | ** |
| **builder_index** | `Nullable(UInt64)` | *Builder index from the bid (Gloas+). NULL for self-built payloads (BUILDER_INDEX_SELF_BUILD) and before Gloas* |
| **bid_value** | `Nullable(UInt64)` | *Bid value in Gwei (Gloas+)* |
| **execution_payment** | `Nullable(UInt64)` | *Execution payment in Gwei (Gloas+)* |
| **payload_present** | `Nullable(Bool)` | *Whether execution payload was delivered (Gloas+)* |
| **execution_payload_gas_limit** | `Nullable(UInt64)` | *Gas limit for execution payload* |
| **execution_payload_gas_used** | `Nullable(UInt64)` | *Gas used for execution payload* |
| **execution_payload_state_root** | `Nullable(FixedString(66))` | *The state root of the execution payload* |
| **execution_payload_parent_hash** | `Nullable(FixedString(66))` | *The parent hash of the execution payload* |
| **execution_payload_transactions_count** | `Nullable(UInt32)` | *The transaction count of the execution payload* |
| **execution_payload_transactions_total_bytes** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload* |
| **execution_payload_transactions_total_bytes_compressed** | `Nullable(UInt32)` | *The transaction total bytes of the execution payload when compressed using snappy* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_committee

Contains canonical beacon API /eth/v1/beacon/committees data.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2026-10-07`
- **holesky**: `2023-09-23` to `2025-10-26`
- **sepolia**: `2022-06-20` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_committee/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_committee/2026/10/7.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_committee FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_committee FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number in the beacon API committee payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **committee_index** | `LowCardinality(String)` | *The committee index in the beacon API committee payload* |
| **validators** | `Array(UInt32)` | *The validator indices in the beacon API committee payload* |
| **epoch** | `UInt32` | *The epoch number in the beacon API committee payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_block_attester_slashing

Contains attester slashing from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2026-08-27`
- **holesky**: `2023-09-23` to `2025-10-03`
- **sepolia**: `2022-06-22` to `null`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_attester_slashing/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_attester_slashing/2026/8/27.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_attester_slashing FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_attester_slashing FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **attestation_1_attesting_indices** | `Array(UInt32)` | *The attesting indices from the first attestation in the slashing payload* |
| **attestation_1_signature** | `String` | *The signature from the first attestation in the slashing payload* |
| **attestation_1_data_beacon_block_root** | `FixedString(66)` | *The beacon block root from the first attestation in the slashing payload* |
| **attestation_1_data_slot** | `UInt32` | *The slot number from the first attestation in the slashing payload* |
| **attestation_1_data_index** | `UInt32` | *The attestor index from the first attestation in the slashing payload* |
| **attestation_1_data_source_epoch** | `UInt32` | *The source epoch number from the first attestation in the slashing payload* |
| **attestation_1_data_source_root** | `FixedString(66)` | *The source root from the first attestation in the slashing payload* |
| **attestation_1_data_target_epoch** | `UInt32` | *The target epoch number from the first attestation in the slashing payload* |
| **attestation_1_data_target_root** | `FixedString(66)` | *The target root from the first attestation in the slashing payload* |
| **attestation_2_attesting_indices** | `Array(UInt32)` | *The attesting indices from the second attestation in the slashing payload* |
| **attestation_2_signature** | `String` | *The signature from the second attestation in the slashing payload* |
| **attestation_2_data_beacon_block_root** | `FixedString(66)` | *The beacon block root from the second attestation in the slashing payload* |
| **attestation_2_data_slot** | `UInt32` | *The slot number from the second attestation in the slashing payload* |
| **attestation_2_data_index** | `UInt32` | *The attestor index from the second attestation in the slashing payload* |
| **attestation_2_data_source_epoch** | `UInt32` | *The source epoch number from the second attestation in the slashing payload* |
| **attestation_2_data_source_root** | `FixedString(66)` | *The source root from the second attestation in the slashing payload* |
| **attestation_2_data_target_epoch** | `UInt32` | *The target epoch number from the second attestation in the slashing payload* |
| **attestation_2_data_target_root** | `FixedString(66)` | *The target root from the second attestation in the slashing payload* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_block_proposer_slashing

Contains proposer slashing from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-04-27`
- **holesky**: `2023-09-23` to `2025-04-27`
- **sepolia**: `2022-06-22` to `null`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_proposer_slashing/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_proposer_slashing/2025/4/27.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_proposer_slashing FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_proposer_slashing FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **signed_header_1_message_slot** | `UInt32` | *The slot number from the first signed header in the slashing payload* |
| **signed_header_1_message_proposer_index** | `UInt32` | *The proposer index from the first signed header in the slashing payload* |
| **signed_header_1_message_body_root** | `FixedString(66)` | *The body root from the first signed header in the slashing payload* |
| **signed_header_1_message_parent_root** | `FixedString(66)` | *The parent root from the first signed header in the slashing payload* |
| **signed_header_1_message_state_root** | `FixedString(66)` | *The state root from the first signed header in the slashing payload* |
| **signed_header_1_signature** | `String` | *The signature for the first signed header in the slashing payload* |
| **signed_header_2_message_slot** | `UInt32` | *The slot number from the second signed header in the slashing payload* |
| **signed_header_2_message_proposer_index** | `UInt32` | *The proposer index from the second signed header in the slashing payload* |
| **signed_header_2_message_body_root** | `FixedString(66)` | *The body root from the second signed header in the slashing payload* |
| **signed_header_2_message_parent_root** | `FixedString(66)` | *The parent root from the second signed header in the slashing payload* |
| **signed_header_2_message_state_root** | `FixedString(66)` | *The state root from the second signed header in the slashing payload* |
| **signed_header_2_signature** | `String` | *The signature for the second signed header in the slashing payload* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_block_bls_to_execution_change

Contains bls to execution change from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-04-12` to `2026-10-07`
- **holesky**: `2023-09-28` to `2025-05-09`
- **sepolia**: `2022-06-22` to `2025-05-16`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_bls_to_execution_change/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_bls_to_execution_change/2026/10/7.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_bls_to_execution_change FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_bls_to_execution_change FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **exchanging_message_validator_index** | `UInt32` | *The validator index from the exchanging message* |
| **exchanging_message_from_bls_pubkey** | `String` | *The BLS public key from the exchanging message* |
| **exchanging_message_to_execution_address** | `FixedString(42)` | *The execution address from the exchanging message* |
| **exchanging_signature** | `String` | *The signature for the exchanging message* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_block_execution_transaction

Contains execution transaction from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2022-09-06` to `2026-10-07`
- **holesky**: `2023-09-23` to `2025-10-26`
- **sepolia**: `2022-06-22` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_execution_transaction/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_execution_transaction/2026/10/7.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_execution_transaction FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_execution_transaction FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **position** | `UInt32` | *The position of the transaction in the beacon block* |
| **hash** | `FixedString(66)` | *The hash of the transaction* |
| **from** | `FixedString(42)` | *The address of the account that sent the transaction* |
| **to** | `Nullable(FixedString(42))` | *The address of the account that is the transaction recipient* |
| **nonce** | `UInt64` | *The nonce of the sender account at the time of the transaction* |
| **gas_price** | `UInt128` | *The gas price of the transaction in wei* |
| **gas** | `UInt64` | *The maximum gas provided for the transaction execution* |
| **gas_tip_cap** | `Nullable(UInt128)` | *The priority fee (tip) the user has set for the transaction* |
| **gas_fee_cap** | `Nullable(UInt128)` | *The max fee the user has set for the transaction* |
| **value** | `UInt128` | *The value transferred with the transaction in wei* |
| **type** | `UInt8` | *The type of the transaction* |
| **size** | `UInt32` | *The size of the transaction data in bytes* |
| **call_data_size** | `UInt32` | *The size of the call data of the transaction in bytes* |
| **blob_gas** | `Nullable(UInt64)` | *The maximum gas provided for the blob transaction execution* |
| **blob_gas_fee_cap** | `Nullable(UInt128)` | *The max fee the user has set for the transaction* |
| **blob_hashes** | `Array(String)` | *The hashes of the blob commitments for blob transactions* |
| **blob_sidecars_size** | `Nullable(UInt32)` | *The total size of the sidecars for blob transactions in bytes* |
| **blob_sidecars_empty_size** | `Nullable(UInt32)` | *The total empty size of the sidecars for blob transactions in bytes* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_block_voluntary_exit

Contains a voluntary exit from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2026-10-07`
- **holesky**: `2023-09-23` to `2025-08-06`
- **sepolia**: `2022-06-22` to `2025-10-22`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_voluntary_exit/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_voluntary_exit/2026/10/7.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_voluntary_exit FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_voluntary_exit FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **voluntary_exit_message_epoch** | `UInt32` | *The epoch number from the exit message* |
| **voluntary_exit_message_validator_index** | `UInt32` | *The validator index from the exit message* |
| **voluntary_exit_signature** | `String` | *The signature of the exit message* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_block_deposit

Contains a deposit from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-05-14`
- **holesky**: `2023-09-23` to `2025-04-27`
- **sepolia**: `2022-06-22` to `2025-04-27`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_deposit/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_deposit/2025/5/14.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_deposit FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_deposit FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **deposit_proof** | `Array(String)` | *The proof of the deposit data* |
| **deposit_data_pubkey** | `String` | *The BLS public key of the validator from the deposit data* |
| **deposit_data_withdrawal_credentials** | `FixedString(66)` | *The withdrawal credentials of the validator from the deposit data* |
| **deposit_data_amount** | `UInt128` | *The amount of the deposit from the deposit data* |
| **deposit_data_signature** | `String` | *The signature of the deposit data* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_block_withdrawal

Contains a withdrawal from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-04-12` to `2026-10-07`
- **holesky**: `2023-09-23` to `2025-10-26`
- **sepolia**: `2023-02-28` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_withdrawal/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_withdrawal/2026/10/7.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_withdrawal FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_withdrawal FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **withdrawal_index** | `UInt32` | *The index of the withdrawal* |
| **withdrawal_validator_index** | `UInt32` | *The validator index from the withdrawal data* |
| **withdrawal_address** | `FixedString(42)` | *The address of the account that is the withdrawal recipient* |
| **withdrawal_amount** | `UInt128` | *The amount of the withdrawal from the withdrawal data* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |
| **withdrawal_type** | `LowCardinality(String)` | *Classification of the withdrawal recipient (Gloas+: validator|builder, pre-Gloas: empty)* |

## canonical_beacon_blob_sidecar

Contains a blob sidecar from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-03-13` to `2026-10-07`
- **holesky**: `2024-02-07` to `2025-10-15`
- **sepolia**: `2024-01-30` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_blob_sidecar/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_blob_sidecar/2026/10/7.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_blob_sidecar FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_blob_sidecar FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_parent_root** | `FixedString(66)` | *The root hash of the parent beacon block* |
| **versioned_hash** | `FixedString(66)` | *The versioned hash in the beacon API event stream payload* |
| **kzg_commitment** | `FixedString(98)` | *The KZG commitment in the blob sidecar payload* |
| **kzg_proof** | `FixedString(98)` | *The KZG proof in the blob sidecar payload* |
| **proposer_index** | `UInt32` | *The index of the validator that proposed the beacon block* |
| **blob_index** | `UInt64` | *The index of blob sidecar in the blob sidecar payload* |
| **blob_size** | `UInt32` | *The total bytes of the blob* |
| **blob_empty_size** | `Nullable(UInt32)` | *The total empty size of the blob in bytes* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_proposer_duty

Contains a proposer duty from a beacon block.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2026-10-07`
- **holesky**: `2023-09-23` to `2025-10-26`
- **sepolia**: `2022-06-20` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_proposer_duty/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_proposer_duty/2026/10/7.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_proposer_duty FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_proposer_duty FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number for which the proposer duty is assigned* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number containing the slot* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **proposer_validator_index** | `UInt32` | *The validator index of the proposer for the slot* |
| **proposer_pubkey** | `String` | *The public key of the validator proposer* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_elaborated_attestation

Contains elaborated attestations from beacon blocks.

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2026-10-07`
- **holesky**: `2023-09-23` to `2025-10-26`
- **sepolia**: `2022-06-20` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_elaborated_attestation/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_elaborated_attestation/2026/10/7.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_elaborated_attestation FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_elaborated_attestation FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **block_slot** | `UInt32` | *The slot number of the block containing the attestation* |
| **block_slot_start_date_time** | `DateTime` | *The wall clock time when the block slot started* |
| **block_epoch** | `UInt32` | *The epoch number of the block containing the attestation* |
| **block_epoch_start_date_time** | `DateTime` | *The wall clock time when the block epoch started* |
| **position_in_block** | `UInt32` | *The position of the attestation in the block* |
| **block_root** | `FixedString(66)` | *The root of the block containing the attestation* |
| **validators** | `Array(UInt32)` | *Array of validator indices participating in the attestation* |
| **committee_index** | `LowCardinality(String)` | *The index of the committee making the attestation* |
| **beacon_block_root** | `FixedString(66)` | *The root of the beacon block being attested to* |
| **slot** | `UInt32` | *The slot number being attested to* |
| **slot_start_date_time** | `DateTime` | ** |
| **epoch** | `UInt32` | ** |
| **epoch_start_date_time** | `DateTime` | ** |
| **source_epoch** | `UInt32` | *The source epoch referenced in the attestation* |
| **source_epoch_start_date_time** | `DateTime` | *The wall clock time when the source epoch started* |
| **source_root** | `FixedString(66)` | *The root of the source checkpoint in the attestation* |
| **target_epoch** | `UInt32` | *The target epoch referenced in the attestation* |
| **target_epoch_start_date_time** | `DateTime` | *The wall clock time when the target epoch started* |
| **target_root** | `FixedString(66)` | *The root of the target checkpoint in the attestation* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_validators

Contains a validator state for an epoch.

### Availability
Data is partitioned **hourly** on **epoch_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2026-10-06`
- **holesky**: `2023-09-23` to `2025-10-26`
- **sepolia**: `2022-06-20` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_validators/YYYY/M/D/H.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_validators/2026/10/6/0.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_validators FINAL
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_validators FINAL
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **index** | `UInt32` | *The index of the validator* |
| **balance** | `Nullable(UInt64)` | *The balance of the validator* |
| **status** | `LowCardinality(String)` | *The status of the validator* |
| **effective_balance** | `Nullable(UInt64)` | *The effective balance of the validator* |
| **slashed** | `Bool` | *Whether the validator is slashed* |
| **activation_epoch** | `Nullable(UInt64)` | *The epoch when the validator was activated* |
| **activation_eligibility_epoch** | `Nullable(UInt64)` | *The epoch when the validator was activated* |
| **exit_epoch** | `Nullable(UInt64)` | *The epoch when the validator exited* |
| **withdrawable_epoch** | `Nullable(UInt64)` | *The epoch when the validator can withdraw* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_validators_pubkeys

Contains a validator state for an epoch.


> A new parquet file is only created once there is 50 new validator index's assigned and finalized. Also available in chunks of 10,000.

### Availability
Data is partitioned in chunks of **50** on **index** for the following networks:

- **mainnet**: `0` to `2380550`
- **holesky**: `0` to `1923800`
- **sepolia**: `0` to `2000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_validators_pubkeys/50/CHUNK_NUMBER.parquet

To find the parquet file with the `index` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `50`. Take the following examples;

Contains `index` between `0` and `49`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_validators_pubkeys/50/0.parquet

Contains `index` between `2500` and `2549`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_validators_pubkeys/50/500.parquet

Contains `index` between `50000` and `50099`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_validators_pubkeys/50/{1000..1001}0.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_validators_pubkeys/50/{50..51}0.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_validators_pubkeys FINAL
    WHERE
        index BETWEEN 2500 AND 2550
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_validators_pubkeys FINAL
    WHERE
        index BETWEEN 2500 AND 2550
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **index** | `UInt32` | *The index of the validator* |
| **pubkey** | `String` | *The public key of the validator* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_block_access_list




> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_access_list/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_access_list/2026/10/1.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_access_list FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_access_list FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | ** |
| **slot** | `UInt32` | ** |
| **slot_start_date_time** | `DateTime` | ** |
| **epoch** | `UInt32` | ** |
| **epoch_start_date_time** | `DateTime` | ** |
| **block_root** | `FixedString(66)` | ** |
| **block_number** | `UInt64` | ** |
| **block_hash** | `FixedString(66)` | ** |
| **address** | `FixedString(42)` | ** |
| **change_type** | `LowCardinality(String)` | ** |
| **block_access_index** | `UInt32` | ** |
| **storage_key** | `Nullable(FixedString(66))` | ** |
| **new_value** | `Nullable(String)` | ** |
| **meta_client_name** | `LowCardinality(String)` | ** |
| **meta_client_id** | `String` | ** |
| **meta_client_version** | `LowCardinality(String)` | ** |
| **meta_client_implementation** | `LowCardinality(String)` | ** |
| **meta_client_os** | `LowCardinality(String)` | ** |
| **meta_client_ip** | `Nullable(IPv6)` | ** |
| **meta_client_geo_city** | `LowCardinality(String)` | ** |
| **meta_client_geo_country** | `LowCardinality(String)` | ** |
| **meta_client_geo_country_code** | `LowCardinality(String)` | ** |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | ** |
| **meta_client_geo_longitude** | `Nullable(Float64)` | ** |
| **meta_client_geo_latitude** | `Nullable(Float64)` | ** |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | ** |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | ** |
| **meta_network_id** | `Int32` | ** |
| **meta_network_name** | `LowCardinality(String)` | ** |
| **meta_consensus_version** | `LowCardinality(String)` | ** |
| **meta_consensus_version_major** | `LowCardinality(String)` | ** |
| **meta_consensus_version_minor** | `LowCardinality(String)` | ** |
| **meta_consensus_version_patch** | `LowCardinality(String)` | ** |
| **meta_consensus_implementation** | `LowCardinality(String)` | ** |
| **meta_labels** | `Map(String, String)` | ** |

## canonical_beacon_block_access_list_summary

Contains a per-block summary of the EIP-7928 block access list from a beacon block (1 row per block).


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_access_list_summary/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_access_list_summary/2026/10/1.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_access_list_summary FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_access_list_summary FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_number** | `UInt64` | *The execution block number from the execution payload* |
| **block_hash** | `FixedString(66)` | *The execution block hash from the execution payload* |
| **accounts_touched** | `UInt32` | *The number of distinct addresses in the block access list* |
| **storage_slots_changed** | `UInt32` | *The number of distinct (address, slot) pairs written at least once* |
| **storage_changes** | `UInt32` | *The number of individual storage write records (one per slot and block access index)* |
| **storage_reads** | `UInt32` | *The number of distinct (address, slot) pairs that were only read* |
| **balance_changes** | `UInt32` | *The number of balance change records* |
| **nonce_changes** | `UInt32` | *The number of nonce change records* |
| **code_changes** | `UInt32` | *The number of code change records* |
| **total_changes** | `UInt32` | *The total number of change records: storage_changes + balance_changes + nonce_changes + code_changes* |
| **bal_size_bytes** | `UInt32` | *The length in bytes of the RLP encoded block access list as carried in the execution payload* |
| **bal_hash** | `FixedString(66)` | *The keccak256 hash of the RLP encoded block access list as carried in the execution payload* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client that generated the event* |
| **meta_client_id** | `String` | *Unique Session ID of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_os** | `LowCardinality(String)` | *Operating system of the client* |
| **meta_client_ip** | `Nullable(IPv6)` | *IP address of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *ASN of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *AS organization of the client* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |
| **meta_consensus_version** | `LowCardinality(String)` | *Consensus client version* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Consensus client major version* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Consensus client minor version* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Consensus client patch version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Consensus client implementation* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_block_execution_payload_bid

Winning execution payload bid from canonical beacon blocks (1 per block).


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_execution_payload_bid/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_execution_payload_bid/2026/10/1.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_execution_payload_bid FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_execution_payload_bid FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number of the block containing this bid* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *Root of the block containing this bid* |
| **block_version** | `LowCardinality(String)` | *Block version (e.g. gloas)* |
| **builder_index** | `Nullable(UInt64)` | *Index of the builder in the builder registry, NULL when self-built* |
| **block_hash** | `FixedString(66)` | *Execution block hash committed to in the bid* |
| **parent_block_hash** | `FixedString(66)` | *Parent execution block hash* |
| **parent_block_root** | `FixedString(66)` | *Parent beacon block root* |
| **value** | `UInt64` | *Bid value in Gwei* |
| **execution_payment** | `UInt64` | *Execution payment in Gwei* |
| **fee_recipient** | `FixedString(42)` | *Fee recipient address* |
| **gas_limit** | `UInt64` | *Gas limit for the execution payload* |
| **prev_randao** | `FixedString(66)` | *Previous RANDAO value* |
| **blob_kzg_commitment_count** | `UInt32` | *Number of blob KZG commitments* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client that generated the event* |
| **meta_client_id** | `String` | *Unique Session ID of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_os** | `LowCardinality(String)` | *Operating system of the client* |
| **meta_client_ip** | `Nullable(IPv6)` | *IP address of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *ASN of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *AS organization of the client* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |
| **meta_consensus_version** | `LowCardinality(String)` | *Consensus client version* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Consensus client major version* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Consensus client minor version* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Consensus client patch version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Consensus client implementation* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_block_payload_attestation

Aggregated PTC payload attestations from canonical beacon blocks (max 4 per block).


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_payload_attestation/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_payload_attestation/2026/10/1.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_payload_attestation FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_payload_attestation FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **slot** | `UInt32` | *Slot number of the block containing this payload attestation* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *Epoch number* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *Root of the block containing this attestation* |
| **block_version** | `LowCardinality(String)` | *Block version (e.g. gloas)* |
| **position** | `UInt32` | *Position of the payload attestation in the block body (0-3)* |
| **beacon_block_root** | `FixedString(66)` | *The block root being attested to by the PTC* |
| **payload_present** | `Bool` | *Whether the PTC attests payload was present* |
| **blob_data_available** | `Bool` | *Whether the PTC attests blob data was available* |
| **aggregation_bits** | `String` | *Bitvector of PTC members (512 bits) as hex* |
| **attesting_validator_count** | `UInt32` | *Number of PTC validators in this aggregation* |
| **meta_client_name** | `LowCardinality(String)` | *Name of the client that generated the event* |
| **meta_client_id** | `String` | *Unique Session ID of the client* |
| **meta_client_version** | `LowCardinality(String)` | *Version of the client* |
| **meta_client_implementation** | `LowCardinality(String)` | *Implementation of the client* |
| **meta_client_os** | `LowCardinality(String)` | *Operating system of the client* |
| **meta_client_ip** | `Nullable(IPv6)` | *IP address of the client* |
| **meta_client_geo_city** | `LowCardinality(String)` | *City of the client* |
| **meta_client_geo_country** | `LowCardinality(String)` | *Country of the client* |
| **meta_client_geo_country_code** | `LowCardinality(String)` | *Country code of the client* |
| **meta_client_geo_continent_code** | `LowCardinality(String)` | *Continent code of the client* |
| **meta_client_geo_longitude** | `Nullable(Float64)` | *Longitude of the client* |
| **meta_client_geo_latitude** | `Nullable(Float64)` | *Latitude of the client* |
| **meta_client_geo_autonomous_system_number** | `Nullable(UInt32)` | *ASN of the client* |
| **meta_client_geo_autonomous_system_organization** | `Nullable(String)` | *AS organization of the client* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |
| **meta_consensus_version** | `LowCardinality(String)` | *Consensus client version* |
| **meta_consensus_version_major** | `LowCardinality(String)` | *Consensus client major version* |
| **meta_consensus_version_minor** | `LowCardinality(String)` | *Consensus client minor version* |
| **meta_consensus_version_patch** | `LowCardinality(String)` | *Consensus client patch version* |
| **meta_consensus_implementation** | `LowCardinality(String)` | *Consensus client implementation* |
| **meta_labels** | `Map(String, String)` | *Labels associated with the event* |

## canonical_beacon_block_execution_request_builder_deposit

Contains an EIP-8282 execution request builder deposit from a beacon block.


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_execution_request_builder_deposit/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_execution_request_builder_deposit/2026/10/1.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_execution_request_builder_deposit FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_execution_request_builder_deposit FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_number** | `UInt64` | *The execution block number from the execution payload* |
| **block_hash** | `FixedString(66)` | *The execution block hash from the execution payload* |
| **position_in_block** | `UInt32` | *The index of the builder deposit within the block builder deposit requests* |
| **pubkey** | `String` | *The public key of the builder from the builder deposit request* |
| **withdrawal_credentials** | `FixedString(66)` | *The withdrawal credentials from the builder deposit request* |
| **amount** | `UInt128` | *The builder deposit amount in gwei* |
| **signature** | `String` | *The builder deposit signature* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_block_execution_request_builder_exit

Contains an EIP-8282 execution request builder exit from a beacon block.


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_block_execution_request_builder_exit/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_block_execution_request_builder_exit/2026/10/1.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_block_execution_request_builder_exit FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_block_execution_request_builder_exit FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot number from beacon block payload* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number from beacon block payload* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *The root hash of the beacon block* |
| **block_version** | `LowCardinality(String)` | *The version of the beacon block* |
| **block_number** | `UInt64` | *The execution block number from the execution payload* |
| **block_hash** | `FixedString(66)` | *The execution block hash from the execution payload* |
| **position_in_block** | `UInt32` | *The index of the builder exit within the block builder exit requests* |
| **source_address** | `FixedString(42)` | *The source address that initiated the builder exit request* |
| **pubkey** | `String` | *The public key of the builder the exit targets* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_state_builder

Contains the Gloas builder registry snapshot for a canonical beacon state epoch.


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **epoch_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_state_builder/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_state_builder/2026/10/1.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_state_builder FINAL
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_state_builder FINAL
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **epoch** | `UInt32` | *The epoch number the builder registry snapshot is for* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **state_id** | `LowCardinality(String)` | *The state ID the registry was read from* |
| **builder_index** | `UInt64` | *The index of the builder in the registry* |
| **pubkey** | `FixedString(98)` | *The public key of the builder* |
| **version** | `UInt8` | *The builder version byte* |
| **execution_address** | `FixedString(42)` | *The execution address of the builder* |
| **balance** | `UInt64` | *The builder balance in gwei* |
| **deposit_epoch** | `UInt64` | *The epoch in which the builder was added to the registry* |
| **withdrawable_epoch** | `UInt64` | *The epoch from which the builder can be withdrawn, FAR_FUTURE_EPOCH while no exit was initiated* |
| **status** | `LowCardinality(String)` | *The builder status (pending, active or exited) evaluated against the finalized checkpoint of the state* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_state_builder_pending_payment

Contains the non-empty Gloas builder pending payments of a canonical beacon state epoch.


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **epoch_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_state_builder_pending_payment/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_state_builder_pending_payment/2026/10/1.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_state_builder_pending_payment FINAL
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_state_builder_pending_payment FINAL
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **epoch** | `UInt32` | *The epoch number the builder pending payments snapshot is for* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **state_id** | `LowCardinality(String)` | *The state ID the payments were read from* |
| **payment_index** | `UInt32` | *The index into builder_pending_payments, below SLOTS_PER_EPOCH for the previous epoch and above for the current epoch* |
| **slot** | `UInt32` | *The slot the payment belongs to* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **weight** | `UInt64` | *The attestation weight accumulated for the payment in gwei* |
| **fee_recipient** | `FixedString(42)` | *The fee recipient of the payment withdrawal* |
| **amount** | `UInt64` | *The payment amount in gwei* |
| **builder_index** | `UInt64` | *The index of the paying builder* |
| **proposer_index** | `UInt32` | *The validator index of the slot proposer* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_state_execution_payload_availability

Contains the Gloas execution payload availability bit of each slot, as recorded by the canonical beacon state.


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_state_execution_payload_availability/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_state_execution_payload_availability/2026/10/1.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_state_execution_payload_availability FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_state_execution_payload_availability FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot the availability bit is for* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number the slot belongs to* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **state_id** | `LowCardinality(String)` | *The state ID the bit was read from* |
| **available** | `Bool` | *Whether the slot execution payload was revealed and applied to the state* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_beacon_state_ptc_member

Contains the ordered payload timeliness committee of each Gloas slot, one row per committee position.


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_beacon_state_ptc_member/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_beacon_state_ptc_member/2026/10/1.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_beacon_state_ptc_member FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_beacon_state_ptc_member FINAL
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse-raw.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **updated_date_time** | `DateTime` | *When this row was last updated* |
| **slot** | `UInt32` | *The slot the payload timeliness committee serves* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **epoch** | `UInt32` | *The epoch number the slot belongs to* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **state_id** | `LowCardinality(String)` | *The state ID the committee was read from* |
| **position** | `UInt32` | *The index of the member within the committee, equal to its bit index in a payload attestation aggregation_bits* |
| **validator_index** | `UInt32` | *The validator holding this position, which can repeat within a committee* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

<!-- schema_end -->
