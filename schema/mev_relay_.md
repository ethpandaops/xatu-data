
Events derived from MEV relays. Data is scraped from multiple MEV Relays by multiple instances.

## Availability
- Public Parquet Files
- EthPandaOps Clickhouse

## Tables

<!-- schema_toc_start -->
- [`mev_relay_bid_trace`](#mev_relay_bid_trace)
- [`mev_relay_proposer_payload_delivered`](#mev_relay_proposer_payload_delivered)
- [`mev_relay_validator_registration`](#mev_relay_validator_registration)
<!-- schema_toc_end -->

<!-- schema_start -->
## mev_relay_bid_trace

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

- **mainnet**: `2024-09-13` to `2025-12-15`
- **holesky**: `2024-09-13` to `2025-10-26`
- **sepolia**: `2024-09-13` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mev_relay_bid_trace/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mev_relay_bid_trace/2025/12/15.parquet', 'Parquet')
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
    FROM default.mev_relay_bid_trace
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
    FROM default.mev_relay_bid_trace
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

## mev_relay_proposer_payload_delivered

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

- **mainnet**: `2024-09-16` to `2025-12-15`
- **holesky**: `2024-09-16` to `2025-08-17`
- **sepolia**: `2024-09-16` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mev_relay_proposer_payload_delivered/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mev_relay_proposer_payload_delivered/2025/12/15.parquet', 'Parquet')
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
    FROM default.mev_relay_proposer_payload_delivered
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
    FROM default.mev_relay_proposer_payload_delivered
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

## mev_relay_validator_registration

Code: 194. DB::Exception: default: Authentication failed: password is incorrect, or there is no user with such name.

If you use ClickHouse Cloud, the password can be reset at https://clickhouse.cloud/
on the settings page for the corresponding service.

If you have installed ClickHouse and forgot password you can reset it in the configuration file.
The password for default user is typically located at /etc/clickhouse-server/users.d/default-password.xml
and deleting this file will reset the password.
See also /etc/clickhouse-server/users.xml on the server where ClickHouse is installed.

. (REQUIRED_PASSWORD) (version 25.5.10.95 (official build))

### Availability
Data is partitioned **daily** on **event_date_time** for the following networks:

- **mainnet**: `2024-12-11` to `2025-12-15`
- **holesky**: `2024-12-11` to `2025-04-27`
- **sepolia**: `2024-12-11` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/mev_relay_validator_registration/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/mev_relay_validator_registration/2025/12/15.parquet', 'Parquet')
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
    FROM default.mev_relay_validator_registration
    WHERE
        event_date_time >= NOW() - INTERVAL '1 HOUR'
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
    FROM default.mev_relay_validator_registration
    WHERE
        event_date_time >= NOW() - INTERVAL '1 HOUR'
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
