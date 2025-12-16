
Data extracted from the execution layer. This data is only derived by a single instance, are deduped, and are more complete and reliable than the execution_layer_p2p tables. These tables can be reliably JOINed on to hydrate other tables with information

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
- [`canonical_execution_transaction_structlog`](#canonical_execution_transaction_structlog)
<!-- schema_toc_end -->

<!-- schema_start -->
## canonical_execution_block

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_block
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_block
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_transaction

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_transaction
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_transaction
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_traces

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9569000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_traces
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_traces
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_logs

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_logs
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_logs
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_contracts

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9569000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_contracts
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_contracts
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_four_byte_counts

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))


> Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_four_byte_counts
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_four_byte_counts
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_address_appearances

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4659000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_address_appearances
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_address_appearances
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_balance_diffs

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_balance_diffs
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_balance_diffs
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_balance_reads

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))


> Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4652000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_balance_reads
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_balance_reads
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_erc20_transfers

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_erc20_transfers
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_erc20_transfers
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_erc721_transfers

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_erc721_transfers
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_erc721_transfers
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_native_transfers

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_native_transfers
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_native_transfers
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_nonce_diffs

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_nonce_diffs
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_nonce_diffs
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_nonce_reads

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))


> Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4657000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_nonce_reads
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_nonce_reads
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_storage_diffs

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **mainnet**: `0` to `24021000`
- **holesky**: `0` to `4710000`
- **sepolia**: `0` to `9849000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_storage_diffs
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_storage_diffs
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_storage_reads

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))


> Mainnet is currently back-filling and not yet available publicly. Holesky is currently stuck at block `2402609`, waiting for reth release including the [fix](https://github.com/paradigmxyz/reth/issues/11272).

### Availability
Data is partitioned in chunks of **1000** on **block_number** for the following networks:

- **holesky**: `0` to `4652000`
- **sepolia**: `0` to `9850000`

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

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_storage_reads
    WHERE
        block_number BETWEEN 50000 AND 51000
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_storage_reads
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
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

## canonical_execution_transaction_structlog

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned in chunks of **100** on **block_number** for the following networks:

- **mainnet**: `22731300` to `23812500`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/canonical_execution_transaction_structlog/100/CHUNK_NUMBER.parquet

To find the parquet file with the `block_number` you're looking for, you need the correct `CHUNK_NUMBER` which is in intervals of `100`. Take the following examples;

Contains `block_number` between `0` and `99`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction_structlog/100/0.parquet

Contains `block_number` between `22731300` and `22731399`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction_structlog/100/22731300.parquet

Contains `block_number` between `100000` and `100199`:
> https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction_structlog/100/{1000..1001}00.parquet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_transaction_structlog/100/{227313..227314}00.parquet', 'Parquet')
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>Your Clickhouse</summary>

```bash
docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM default.canonical_execution_transaction_structlog
    WHERE
        block_number BETWEEN 5000 AND 5100
    LIMIT 10
    FORMAT Pretty
"""
```
</details>

<details>
<summary>EthPandaOps Clickhouse</summary>

```bash
echo """
    SELECT
        *
    FROM default.canonical_execution_transaction_structlog
    WHERE
        block_number BETWEEN 5000 AND 5100
    LIMIT 3
    FORMAT Pretty
""" | curl "https://clickhouse.xatu.ethpandaops.io" -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" --data-binary @-
```
</details>

### Columns
| Name | Type | Description |
|--------|------|-------------|
| **Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.** | `` | ** |
| **If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/** | `` | ** |
| **on the settings page for the corresponding service.** | `` | ** |
| **If you have installed ClickHouse and forgot password you can reset it in the configuration file.** | `` | ** |
| **The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml** | `` | ** |
| **and deleting this file will reset the password.** | `` | ** |
| **See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.** | `` | ** |
| **. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))** | `` | ** |

<!-- schema_end -->
