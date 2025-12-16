
Events derived from the Beacon API event stream. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances. These tables are usually fairly slim and contain only a few columns. These tables can be joined with the canonical tables to get a more complete view of the data. For example, you can join the beacon_api_eth_v1_events_block table on block_root or slot with the canonical_beacon_block table to get the block data for each block.

## Availability
- Public Parquet Files
- EthPandaOps Clickhouse

## Tables

<!-- schema_toc_start -->
- [`beacon_api_eth_v1_beacon_committee`](#beacon_api_eth_v1_beacon_committee)
- [`beacon_api_eth_v1_events_attestation`](#beacon_api_eth_v1_events_attestation)
- [`beacon_api_eth_v1_events_blob_sidecar`](#beacon_api_eth_v1_events_blob_sidecar)
- [`beacon_api_eth_v1_events_block`](#beacon_api_eth_v1_events_block)
- [`beacon_api_eth_v1_events_block_gossip`](#beacon_api_eth_v1_events_block_gossip)
- [`beacon_api_eth_v1_events_chain_reorg`](#beacon_api_eth_v1_events_chain_reorg)
- [`beacon_api_eth_v1_events_contribution_and_proof`](#beacon_api_eth_v1_events_contribution_and_proof)
- [`beacon_api_eth_v1_events_finalized_checkpoint`](#beacon_api_eth_v1_events_finalized_checkpoint)
- [`beacon_api_eth_v1_events_head`](#beacon_api_eth_v1_events_head)
- [`beacon_api_eth_v1_events_voluntary_exit`](#beacon_api_eth_v1_events_voluntary_exit)
- [`beacon_api_eth_v1_validator_attestation_data`](#beacon_api_eth_v1_validator_attestation_data)
- [`beacon_api_eth_v2_beacon_block`](#beacon_api_eth_v2_beacon_block)
- [`beacon_api_eth_v1_proposer_duty`](#beacon_api_eth_v1_proposer_duty)
- [`beacon_api_eth_v3_validator_block`](#beacon_api_eth_v3_validator_block)
<!-- schema_toc_end -->

<!-- schema_start -->
## beacon_api_eth_v1_beacon_committee

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))


> Sometimes sentries may [publish different committees](https://github.com/ethpandaops/xatu/issues/288) for the same epoch.

### Availability
Data is partitioned **hourly** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-09-04` to `2025-12-15`
- **holesky**: `2023-09-28` to `2025-10-26`
- **sepolia**: `2022-06-25` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_beacon_committee/YYYY/M/D/H.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_beacon_committee/2025/12/15/0.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_beacon_committee
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_beacon_committee
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v1_events_attestation

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **hourly** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-06-01` to `2025-12-15`
- **holesky**: `2023-09-18` to `2025-11-17`
- **sepolia**: `2023-08-31` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_attestation/YYYY/M/D/H.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_attestation/2025/12/15/0.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_attestation
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_attestation
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v1_events_blob_sidecar

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-03-13` to `2025-12-09`
- **holesky**: `2024-02-07` to `2025-11-03`
- **sepolia**: `2024-01-30` to `2025-10-20`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_blob_sidecar/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_blob_sidecar/2025/12/9.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_blob_sidecar
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_blob_sidecar
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v1_events_block

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-12-15`
- **holesky**: `2020-12-02` to `2025-11-22`
- **sepolia**: `2023-12-24` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_block/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2025/12/15.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_block
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_block
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v1_events_block_gossip

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2025-05-14` to `2025-12-15`
- **holesky**: `2025-05-14` to `2025-11-22`
- **sepolia**: `2025-05-14` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_block_gossip/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block_gossip/2025/12/15.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_block_gossip
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_block_gossip
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v1_events_chain_reorg

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-03-01` to `2025-12-15`
- **holesky**: `2024-02-05` to `2025-11-17`
- **sepolia**: `2023-12-30` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_chain_reorg/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_chain_reorg/2025/12/15.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_chain_reorg
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_chain_reorg
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v1_events_contribution_and_proof

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **contribution_slot_start_date_time** for the following networks:

- **mainnet**: `2023-08-31` to `2025-12-15`
- **holesky**: `2023-12-24` to `2025-10-26`
- **sepolia**: `2023-12-24` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_contribution_and_proof/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_contribution_and_proof/2025/12/15.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_contribution_and_proof
    WHERE
        contribution_slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_contribution_and_proof
    WHERE
        contribution_slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v1_events_finalized_checkpoint

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **epoch_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-12-15`
- **holesky**: `2023-03-26` to `2025-11-03`
- **sepolia**: `2023-03-26` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_finalized_checkpoint/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_finalized_checkpoint/2025/12/15.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_finalized_checkpoint
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_finalized_checkpoint
    WHERE
        epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v1_events_head

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-12-15`
- **holesky**: `2023-12-05` to `2025-11-22`
- **sepolia**: `2023-12-05` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_head/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_head/2025/12/15.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_head
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_head
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v1_events_voluntary_exit

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **wallclock_epoch_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-12-15`
- **holesky**: `2023-09-28` to `2025-08-12`
- **sepolia**: `2023-10-01` to `null`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_events_voluntary_exit/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_voluntary_exit/2025/12/15.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_events_voluntary_exit
    WHERE
        wallclock_epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_events_voluntary_exit
    WHERE
        wallclock_epoch_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v1_validator_attestation_data

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2023-08-31` to `2025-12-15`
- **holesky**: `2023-12-24` to `2025-10-26`
- **sepolia**: `2023-12-24` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_validator_attestation_data/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_validator_attestation_data/2025/12/15.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_validator_attestation_data
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_validator_attestation_data
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v2_beacon_block

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2020-12-01` to `2025-12-15`
- **holesky**: `2023-09-28` to `2025-10-26`
- **sepolia**: `2022-06-20` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v2_beacon_block/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v2_beacon_block/2025/12/15.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v2_beacon_block
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v2_beacon_block
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v1_proposer_duty

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-04-03` to `2025-12-15`
- **holesky**: `2024-04-03` to `2025-10-26`
- **sepolia**: `2024-04-03` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v1_proposer_duty/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_proposer_duty/2025/12/15.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v1_proposer_duty
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v1_proposer_duty
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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

## beacon_api_eth_v3_validator_block

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **mainnet**: `2024-11-25` to `2025-12-15`
- **holesky**: `2024-11-25` to `2025-10-26`
- **sepolia**: `2024-11-25` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_api_eth_v3_validator_block/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v3_validator_block/2025/12/15.parquet', 'Parquet')
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
    FROM default.beacon_api_eth_v3_validator_block
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.beacon_api_eth_v3_validator_block
    WHERE
        slot_start_date_time >= NOW() - INTERVAL '1 HOUR'
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
