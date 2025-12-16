
Events from the consensus layer p2p network. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances.


The libp2p dataset captures peer-to-peer network events from the consensus layer, however due to the large volume of network traffic, data is sampled using a sharding strategy. This ensures manageable data sizes while maintaining significance. Not all events are captured - the sampling rate varies by event type and topic, with high-volume topics being more aggressively sampled.

## Event Categorization

Events are categorized into four groups based on their available sharding keys:

### Group A: Topic + MsgID Events
Events with both topic and message ID, enabling full sharding flexibility:
- `PUBLISH_MESSAGE`, `DELIVER_MESSAGE`, `DUPLICATE_MESSAGE`, `REJECT_MESSAGE`
- `GOSSIPSUB_BEACON_BLOCK`, `GOSSIPSUB_BEACON_ATTESTATION`, `GOSSIPSUB_BLOB_SIDECAR`
- `RPC_META_MESSAGE`, `RPC_META_CONTROL_IHAVE`

**Sharding**: Uses message ID for sharding, with topic-based configuration

### Group B: Topic-Only Events
Events with only topic information:
- `JOIN`, `LEAVE`, `GRAFT`, `PRUNE`
- `RPC_META_CONTROL_GRAFT`, `RPC_META_CONTROL_PRUNE`, `RPC_META_SUBSCRIPTION`

**Sharding**: Uses topic hash for sharding decisions

### Group C: MsgID-Only Events
Events with only message ID:
- `RPC_META_CONTROL_IWANT`, `RPC_META_CONTROL_IDONTWANT`

**Sharding**: Uses message ID with default configuration

### Group D: No Sharding Key Events
Events without sharding keys:
- `ADD_PEER`, `REMOVE_PEER`, `CONNECTED`, `DISCONNECTED`
- `RECV_RPC`, `SEND_RPC`, `DROP_RPC` (parent events only)
- `HANDLE_METADATA`, `HANDLE_STATUS`

**Sharding**: All-or-nothing based on configuration

### Sharding Decision Flow
```
┌─────────────┐
│Event Arrives│
└──────┬──────┘
       │
       ▼
┌──────────────┐     ┌─────────────────┐
│Get Event Info├────►│ Event Category? │
└──────────────┘     └────────┬────────┘
                              │
        ┌─────────────────────┼─────────────────────┬─────────────────────┐
        ▼                     ▼                     ▼                     ▼
   ┌─────────┐         ┌─────────┐           ┌─────────┐           ┌─────────┐
   │ Group A │         │ Group B │           │ Group C │           │ Group D │
   │Topic+Msg│         │Topic Only│          │Msg Only │           │ No Keys │
   └────┬────┘         └────┬────┘           └────┬────┘           └────┬────┘
        │                   │                     │                     │
        ▼                   ▼                     ▼                     ▼
   Topic Config?       Topic Config?         Default Shard         Enabled?
        │                   │                     │                     │
     Yes/No              Yes/No                   │                  Yes/No
        │                   │                     │                     │
        ▼                   ▼                     ▼                     ▼
   Shard by Msg       Shard by Topic        Shard by Msg         Process/Drop
```

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`libp2p_gossipsub_beacon_attestation`](#libp2p_gossipsub_beacon_attestation)
- [`libp2p_gossipsub_beacon_block`](#libp2p_gossipsub_beacon_block)
- [`libp2p_gossipsub_blob_sidecar`](#libp2p_gossipsub_blob_sidecar)
- [`libp2p_gossipsub_aggregate_and_proof`](#libp2p_gossipsub_aggregate_and_proof)
- [`libp2p_connected`](#libp2p_connected)
- [`libp2p_disconnected`](#libp2p_disconnected)
- [`libp2p_add_peer`](#libp2p_add_peer)
- [`libp2p_remove_peer`](#libp2p_remove_peer)
- [`libp2p_recv_rpc`](#libp2p_recv_rpc)
- [`libp2p_send_rpc`](#libp2p_send_rpc)
- [`libp2p_drop_rpc`](#libp2p_drop_rpc)
- [`libp2p_join`](#libp2p_join)
- [`libp2p_leave`](#libp2p_leave)
- [`libp2p_graft`](#libp2p_graft)
- [`libp2p_prune`](#libp2p_prune)
- [`libp2p_duplicate_message`](#libp2p_duplicate_message)
- [`libp2p_deliver_message`](#libp2p_deliver_message)
- [`libp2p_handle_metadata`](#libp2p_handle_metadata)
- [`libp2p_handle_status`](#libp2p_handle_status)
- [`libp2p_rpc_meta_control_ihave`](#libp2p_rpc_meta_control_ihave)
- [`libp2p_rpc_meta_control_iwant`](#libp2p_rpc_meta_control_iwant)
- [`libp2p_rpc_meta_control_idontwant`](#libp2p_rpc_meta_control_idontwant)
- [`libp2p_rpc_meta_control_graft`](#libp2p_rpc_meta_control_graft)
- [`libp2p_rpc_meta_control_prune`](#libp2p_rpc_meta_control_prune)
- [`libp2p_rpc_meta_subscription`](#libp2p_rpc_meta_subscription)
- [`libp2p_rpc_meta_message`](#libp2p_rpc_meta_message)
<!-- schema_toc_end -->

<!-- schema_start -->
## libp2p_gossipsub_beacon_attestation

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

- **mainnet**: `2024-05-01` to `2025-12-15`
- **holesky**: `2024-05-01` to `2025-10-26`
- **sepolia**: `2024-05-01` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_beacon_attestation/YYYY/M/D/H.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_beacon_attestation/2025/12/15/0.parquet', 'Parquet')
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
    FROM default.libp2p_gossipsub_beacon_attestation
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
    FROM default.libp2p_gossipsub_beacon_attestation
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

## libp2p_gossipsub_beacon_block

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
- **holesky**: `2024-04-26` to `2025-10-26`
- **sepolia**: `2024-04-26` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_beacon_block/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_beacon_block/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_gossipsub_beacon_block
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
    FROM default.libp2p_gossipsub_beacon_block
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

## libp2p_gossipsub_blob_sidecar

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

- **mainnet**: `2020-12-01` to `2025-12-09`
- **holesky**: `2024-06-03` to `2025-10-07`
- **sepolia**: `2024-06-03` to `2025-10-20`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_blob_sidecar/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_blob_sidecar/2025/12/9.parquet', 'Parquet')
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
    FROM default.libp2p_gossipsub_blob_sidecar
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
    FROM default.libp2p_gossipsub_blob_sidecar
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

## libp2p_gossipsub_aggregate_and_proof

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

- **mainnet**: `2025-07-11` to `2025-12-15`
- **holesky**: `2025-07-11` to `2025-10-26`
- **sepolia**: `2025-07-11` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_gossipsub_aggregate_and_proof/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_gossipsub_aggregate_and_proof/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_gossipsub_aggregate_and_proof
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
    FROM default.libp2p_gossipsub_aggregate_and_proof
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

## libp2p_connected

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

- **mainnet**: `2024-04-24` to `2025-12-15`
- **hoodi**: `2025-03-17` to `2025-12-15`
- **sepolia**: `2024-04-22` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_connected/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_connected/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_connected
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
    FROM default.libp2p_connected
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

## libp2p_disconnected

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

- **mainnet**: `2024-04-24` to `2025-12-15`
- **hoodi**: `2025-03-17` to `2025-12-15`
- **sepolia**: `2024-04-22` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_disconnected/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_disconnected/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_disconnected
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
    FROM default.libp2p_disconnected
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

## libp2p_add_peer

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

- **mainnet**: `2024-04-24` to `2025-12-15`
- **hoodi**: `2025-03-17` to `2025-12-15`
- **sepolia**: `2024-04-22` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_add_peer/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_add_peer/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_add_peer
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
    FROM default.libp2p_add_peer
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

## libp2p_remove_peer

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

- **mainnet**: `2024-04-24` to `2025-12-15`
- **hoodi**: `2025-03-17` to `2025-12-15`
- **sepolia**: `2024-04-22` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_remove_peer/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_remove_peer/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_remove_peer
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
    FROM default.libp2p_remove_peer
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

## libp2p_recv_rpc

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_recv_rpc/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_recv_rpc/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_recv_rpc
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
    FROM default.libp2p_recv_rpc
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

## libp2p_send_rpc

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_send_rpc/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_send_rpc/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_send_rpc
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
    FROM default.libp2p_send_rpc
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

## libp2p_drop_rpc

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-30` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_drop_rpc/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_drop_rpc/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_drop_rpc
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
    FROM default.libp2p_drop_rpc
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

## libp2p_join

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

- **mainnet**: `2024-05-01` to `2025-12-15`
- **hoodi**: `2025-03-17` to `2025-12-15`
- **sepolia**: `2024-05-01` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_join/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_join/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_join
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
    FROM default.libp2p_join
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

## libp2p_leave

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

- **mainnet**: `2025-06-01` to `2025-12-15`
- **hoodi**: `2025-06-01` to `2025-06-01`
- **sepolia**: `2025-06-01` to `2025-06-01`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_leave/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_leave/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_leave
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
    FROM default.libp2p_leave
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

## libp2p_graft

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_graft/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_graft/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_graft
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
    FROM default.libp2p_graft
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

## libp2p_prune

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_prune/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_prune/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_prune
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
    FROM default.libp2p_prune
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

## libp2p_duplicate_message

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_duplicate_message/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_duplicate_message/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_duplicate_message
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
    FROM default.libp2p_duplicate_message
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

## libp2p_deliver_message

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_deliver_message/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_deliver_message/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_deliver_message
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
    FROM default.libp2p_deliver_message
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

## libp2p_handle_metadata

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

- **mainnet**: `2024-04-24` to `2025-12-15`
- **hoodi**: `2025-03-17` to `2025-12-15`
- **sepolia**: `2024-04-22` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_handle_metadata/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_handle_metadata/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_handle_metadata
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
    FROM default.libp2p_handle_metadata
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

## libp2p_handle_status

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

- **mainnet**: `2024-04-24` to `2025-12-15`
- **hoodi**: `2025-03-17` to `2025-12-15`
- **sepolia**: `2024-04-22` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_handle_status/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_handle_status/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_handle_status
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
    FROM default.libp2p_handle_status
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

## libp2p_rpc_meta_control_ihave

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_ihave/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_ihave/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_control_ihave
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
    FROM default.libp2p_rpc_meta_control_ihave
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

## libp2p_rpc_meta_control_iwant

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_iwant/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_iwant/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_control_iwant
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
    FROM default.libp2p_rpc_meta_control_iwant
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

## libp2p_rpc_meta_control_idontwant

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_idontwant/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_idontwant/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_control_idontwant
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
    FROM default.libp2p_rpc_meta_control_idontwant
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

## libp2p_rpc_meta_control_graft

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_graft/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_graft/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_control_graft
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
    FROM default.libp2p_rpc_meta_control_graft
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

## libp2p_rpc_meta_control_prune

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

- **mainnet**: `2025-07-02` to `2025-12-15`
- **hoodi**: `2025-06-23` to `2025-12-15`
- **sepolia**: `2025-06-23` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_control_prune/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_control_prune/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_control_prune
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
    FROM default.libp2p_rpc_meta_control_prune
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

## libp2p_rpc_meta_subscription

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_subscription/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_subscription/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_subscription
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
    FROM default.libp2p_rpc_meta_subscription
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

## libp2p_rpc_meta_message

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

- **mainnet**: `2025-05-30` to `2025-12-15`
- **hoodi**: `2025-05-29` to `2025-12-15`
- **sepolia**: `2025-05-29` to `2025-12-15`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/libp2p_rpc_meta_message/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/libp2p_rpc_meta_message/2025/12/15.parquet', 'Parquet')
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
    FROM default.libp2p_rpc_meta_message
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
    FROM default.libp2p_rpc_meta_message
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
