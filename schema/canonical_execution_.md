# canonical_execution_

Data extracted from the execution layer

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`canonical_execution_block`](#canonical_execution_block)
- [`canonical_execution_transaction`](#canonical_execution_transaction)
- [`canonical_execution_traces`](#canonical_execution_traces)
- [`canonical_execution_logs`](#canonical_execution_logs)
- [`canonical_execution_contracts`](#canonical_execution_contracts)
- [`canonical_execution_four_byte_counts`](#canonical_execution_four_byte_counts)
- [`canonical_execution_address_appearances`](#canonical_execution_address_appearances)
- [`canonical_execution_balance_diffs`](#canonical_execution_balance_diffs)
- [`canonical_execution_balance_reads`](#canonical_execution_balance_reads)
- [`canonical_execution_erc20_transfers`](#canonical_execution_erc20_transfers)
- [`canonical_execution_erc721_transfers`](#canonical_execution_erc721_transfers)
- [`canonical_execution_native_transfers`](#canonical_execution_native_transfers)
- [`canonical_execution_nonce_diffs`](#canonical_execution_nonce_diffs)
- [`canonical_execution_nonce_reads`](#canonical_execution_nonce_reads)
- [`canonical_execution_storage_diffs`](#canonical_execution_storage_diffs)
- [`canonical_execution_storage_reads`](#canonical_execution_storage_reads)
<!-- schema_toc_end -->

<!-- schema_start -->
## canonical_execution_block

Contains canonical execution block data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_block/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_block FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_block FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **block_hash** | `FixedString(66)` | *The block hash* |
| **author** | `Nullable(String)` | *The block author* |
| **gas_used** | `Nullable(UInt64)` | *The block gas used* |
| **extra_data** | `Nullable(String)` | *The block extra data in hex* |
| **extra_data_string** | `Nullable(String)` | *The block extra data in UTF-8 string* |
| **base_fee_per_gas** | `Nullable(UInt64)` | *The block base fee per gas* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_transaction

Contains canonical execution transaction data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_transaction/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_transaction FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_transaction FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt64` | *The transaction index* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **nonce** | `UInt64` | *The transaction nonce* |
| **from_address** | `String` | *The transaction from address* |
| **to_address** | `Nullable(String)` | *The transaction to address* |
| **value** | `UInt256` | *The transaction value in float64* |
| **input** | `Nullable(String)` | *The transaction input in hex* |
| **gas_limit** | `UInt64` | *The transaction gas limit* |
| **gas_used** | `UInt64` | *The transaction gas used* |
| **gas_price** | `UInt64` | *The transaction gas price* |
| **transaction_type** | `UInt32` | *The transaction type* |
| **max_priority_fee_per_gas** | `UInt64` | *The transaction max priority fee per gas* |
| **max_fee_per_gas** | `UInt64` | *The transaction max fee per gas* |
| **success** | `Bool` | *The transaction success* |
| **n_input_bytes** | `UInt32` | *The transaction input bytes* |
| **n_input_zero_bytes** | `UInt32` | *The transaction input zero bytes* |
| **n_input_nonzero_bytes** | `UInt32` | *The transaction input nonzero bytes* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_traces

Contains canonical execution traces data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_traces/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_traces/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_traces/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_traces/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_traces/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_traces FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_traces FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt32` | *The transaction index* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **internal_index** | `UInt32` | *The internal index of the trace within the transaction* |
| **action_from** | `String` | *The from address of the action* |
| **action_to** | `Nullable(String)` | *The to address of the action* |
| **action_value** | `String` | *The value of the action* |
| **action_gas** | `UInt32` | *The gas provided for the action* |
| **action_input** | `Nullable(String)` | *The input data for the action* |
| **action_call_type** | `LowCardinality(String)` | *The call type of the action* |
| **action_init** | `Nullable(String)` | *The initialization code for the action* |
| **action_reward_type** | `String` | *The reward type for the action* |
| **action_type** | `LowCardinality(String)` | *The type of the action* |
| **result_gas_used** | `UInt32` | *The gas used in the result* |
| **result_output** | `Nullable(String)` | *The output of the result* |
| **result_code** | `Nullable(String)` | *The code returned in the result* |
| **result_address** | `Nullable(String)` | *The address returned in the result* |
| **trace_address** | `Nullable(String)` | *The trace address* |
| **subtraces** | `UInt32` | *The number of subtraces* |
| **error** | `Nullable(String)` | *The error, if any, in the trace* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_logs

Contains canonical execution logs data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_logs/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_logs/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_logs/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_logs/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_logs/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_logs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_logs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt32` | *The transaction index* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash associated with the log* |
| **internal_index** | `UInt32` | *The internal index of the log within the transaction* |
| **log_index** | `UInt32` | *The log index within the block* |
| **address** | `String` | *The address associated with the log* |
| **topic0** | `String` | *The first topic of the log* |
| **topic1** | `Nullable(String)` | *The second topic of the log* |
| **topic2** | `Nullable(String)` | *The third topic of the log* |
| **topic3** | `Nullable(String)` | *The fourth topic of the log* |
| **data** | `Nullable(String)` | *The data associated with the log* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_contracts

Contains canonical execution contract data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_contracts/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_contracts/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_contracts/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_contracts/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_contracts/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_contracts FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_contracts FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_hash** | `FixedString(66)` | *The transaction hash that created the contract* |
| **internal_index** | `UInt32` | *The internal index of the contract creation within the transaction* |
| **create_index** | `UInt32` | *The create index* |
| **contract_address** | `String` | *The contract address* |
| **deployer** | `String` | *The address of the contract deployer* |
| **factory** | `String` | *The address of the factory that deployed the contract* |
| **init_code** | `String` | *The initialization code of the contract* |
| **code** | `Nullable(String)` | *The code of the contract* |
| **init_code_hash** | `String` | *The hash of the initialization code* |
| **n_init_code_bytes** | `UInt32` | *Number of bytes in the initialization code* |
| **n_code_bytes** | `UInt32` | *Number of bytes in the contract code* |
| **code_hash** | `String` | *The hash of the contract code* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_four_byte_counts

Contains canonical execution four byte count data.


> Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21029000`
- **holesky**: `0` to `2401000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_four_byte_counts/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_four_byte_counts/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_four_byte_counts/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_four_byte_counts/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_four_byte_counts/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_four_byte_counts FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_four_byte_counts FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **signature** | `String` | *The signature of the four byte count* |
| **size** | `UInt64` | *The size of the four byte count* |
| **count** | `UInt64` | *The count of the four byte count* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_address_appearances

Contains canonical execution address appearance data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_address_appearances/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_address_appearances/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_address_appearances/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_address_appearances/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_address_appearances/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_address_appearances FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_address_appearances FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_hash** | `FixedString(66)` | *The transaction hash that caused the address appearance* |
| **internal_index** | `UInt32` | *The internal index of the address appearance within the transaction* |
| **address** | `String` | *The address of the address appearance* |
| **relationship** | `LowCardinality(String)` | *The relationship of the address to the transaction* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_balance_diffs

Contains canonical execution balance diff data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_balance_diffs/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_diffs/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_diffs/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_diffs/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_diffs/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_balance_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_balance_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash that caused the balance diff* |
| **internal_index** | `UInt32` | *The internal index of the balance diff within the transaction* |
| **address** | `String` | *The address of the balance diff* |
| **from_value** | `UInt256` | *The from value of the balance diff* |
| **to_value** | `UInt256` | *The to value of the balance diff* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_balance_reads

Contains canonical execution balance read data.


> Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21029000`
- **holesky**: `0` to `2401000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_balance_reads/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_reads/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_reads/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_reads/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_balance_reads/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_balance_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_balance_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash that caused the balance read* |
| **internal_index** | `UInt32` | *The internal index of the balance read within the transaction* |
| **address** | `String` | *The address of the balance read* |
| **balance** | `UInt256` | *The balance that was read* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_erc20_transfers

Contains canonical execution erc20 transfer data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_erc20_transfers/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc20_transfers/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc20_transfers/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc20_transfers/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc20_transfers/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_erc20_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_erc20_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **internal_index** | `UInt32` | *The internal index of the transfer within the transaction* |
| **log_index** | `UInt64` | *The log index in the block* |
| **erc20** | `String` | *The erc20 address* |
| **from_address** | `String` | *The from address* |
| **to_address** | `String` | *The to address* |
| **value** | `UInt256` | *The value of the transfer* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_erc721_transfers

Contains canonical execution erc721 transfer data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_erc721_transfers/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc721_transfers/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc721_transfers/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc721_transfers/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_erc721_transfers/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_erc721_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_erc721_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **internal_index** | `UInt32` | *The internal index of the transfer within the transaction* |
| **log_index** | `UInt64` | *The log index in the block* |
| **erc20** | `String` | *The erc20 address* |
| **from_address** | `String` | *The from address* |
| **to_address** | `String` | *The to address* |
| **token** | `UInt256` | *The token id* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_native_transfers

Contains canonical execution native transfer data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_native_transfers/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_native_transfers/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_native_transfers/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_native_transfers/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_native_transfers/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_native_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_native_transfers FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash* |
| **internal_index** | `UInt32` | *The internal index of the transfer within the transaction* |
| **transfer_index** | `UInt64` | *The transfer index* |
| **from_address** | `String` | *The from address* |
| **to_address** | `String` | *The to address* |
| **value** | `UInt256` | *The value of the approval* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_nonce_diffs

Contains canonical execution nonce diff data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_nonce_diffs/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_diffs/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_diffs/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_diffs/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_diffs/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_nonce_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_nonce_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash that caused the nonce diff* |
| **internal_index** | `UInt32` | *The internal index of the nonce diff within the transaction* |
| **address** | `String` | *The address of the nonce diff* |
| **from_value** | `UInt64` | *The from value of the nonce diff* |
| **to_value** | `UInt64` | *The to value of the nonce diff* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_nonce_reads

Contains canonical execution nonce read data.


> Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21029000`
- **holesky**: `0` to `2401000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_nonce_reads/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_reads/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_reads/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_reads/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_nonce_reads/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_nonce_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_nonce_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt64` | *The transaction index in the block* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash that caused the nonce read* |
| **internal_index** | `UInt32` | *The internal index of the nonce read within the transaction* |
| **address** | `String` | *The address of the nonce read* |
| **nonce** | `UInt64` | *The nonce that was read* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_storage_diffs

Contains canonical execution storage diffs data.

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `21189000`
- **holesky**: `0` to `2669000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_storage_diffs/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_diffs/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_diffs/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_diffs/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_diffs/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_storage_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_storage_diffs FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt32` | *The transaction index* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash associated with the storage diff* |
| **internal_index** | `UInt32` | *The internal index of the storage diff within the transaction* |
| **address** | `String` | *The address associated with the storage diff* |
| **slot** | `String` | *The storage slot key* |
| **from_value** | `String` | *The original value before the storage diff* |
| **to_value** | `String` | *The new value after the storage diff* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

## canonical_execution_storage_reads

Contains canonical execution storage reads data.


> Mainnet is currently back-filling and not yet available publicly. Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **holesky**: `0` to `2401000`
- **sepolia**: `0` to `7078000`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_storage_reads/1000/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `1000`. Take the following examples;

Contains `block_number` between `0` and `999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_reads/1000/0.parquet

Contains `block_number` between `50000` and `50999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_reads/1000/50000.parquet

Contains `block_number` between `1000000` and `1001999`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_reads/1000/{1000..1001}000.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_storage_reads/1000/{50..51}000.parquet', 'Parquet')
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
    FROM default.canonical_execution_storage_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

> **Note:** [`FINAL`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_storage_reads FINAL
    WHERE
        block_number BETWEEN 50000 AND 51000
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
| **transaction_index** | `UInt32` | *The transaction index* |
| **transaction_hash** | `FixedString(66)` | *The transaction hash associated with the storage read* |
| **internal_index** | `UInt32` | *The internal index of the storage read within the transaction* |
| **contract_address** | `String` | *The contract address associated with the storage read* |
| **slot** | `String` | *The storage slot key* |
| **value** | `String` | *The value read from the storage slot* |
| **meta_network_id** | `Int32` | *Ethereum network ID* |
| **meta_network_name** | `LowCardinality(String)` | *Ethereum network name* |

<!-- schema_end -->
