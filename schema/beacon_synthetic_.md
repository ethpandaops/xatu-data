
Events synthesized from the internals of instrumented beacon nodes, such as fork choice payload status changes and builder payment settlement. Each instance records its own view, so the same event usually appears once per instance.

## Availability
- EthPandaOps Clickhouse
- Public Parquet Files

## Tables

<!-- schema_toc_start -->
- [`beacon_synthetic_builder_pending_payment_settlement`](#beacon_synthetic_builder_pending_payment_settlement)
- [`beacon_synthetic_payload_attestation_processed`](#beacon_synthetic_payload_attestation_processed)
- [`beacon_synthetic_payload_status_resolved`](#beacon_synthetic_payload_status_resolved)
<!-- schema_toc_end -->

<!-- schema_start -->
## beacon_synthetic_builder_pending_payment_settlement

Builder pending payment settle/drop decisions at epoch boundary (EIP-7732 ePBS) synthesized from TYSM-instrumented beacon node internals. Multi-witness (per-node).


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **epoch_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_synthetic_builder_pending_payment_settlement/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_synthetic_builder_pending_payment_settlement/2026/10/1.parquet', 'Parquet')
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
    FROM default.beacon_synthetic_builder_pending_payment_settlement FINAL
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
    FROM default.beacon_synthetic_builder_pending_payment_settlement FINAL
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
| **updated_date_time** | `DateTime` | *Timestamp when the record was last updated* |
| **event_date_time** | `DateTime64(3)` | *When the beacon node processed this settlement (TYSM ResolvedAt)* |
| **epoch** | `UInt32` | *Epoch boundary at which this settlement was processed* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **builder_index** | `UInt64` | *Index of the builder in the builder registry* |
| **fee_recipient** | `FixedString(42)` | *Builder fee recipient address* |
| **amount** | `UInt64` | *Payment amount in Gwei* |
| **weight** | `UInt64` | *Quorum weight achieved in Gwei* |
| **quorum** | `UInt64` | *Quorum threshold needed in Gwei* |
| **outcome** | `LowCardinality(String)` | *Settlement outcome: SETTLED / DROPPED* |
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

## beacon_synthetic_payload_attestation_processed

PTC votes after full gossip validation completed (EIP-7732 ePBS) synthesized from TYSM-instrumented beacon node internals. Enrichment counterpart to beacon_api_eth_v1_events_payload_attestation. Multi-witness (per-node).


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_synthetic_payload_attestation_processed/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_synthetic_payload_attestation_processed/2026/10/1.parquet', 'Parquet')
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
    FROM default.beacon_synthetic_payload_attestation_processed FINAL
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
    FROM default.beacon_synthetic_payload_attestation_processed FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the beacon node processed this PTC vote (TYSM ProcessedAt)* |
| **slot** | `UInt32` | *Slot the PTC vote applies to* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **propagation_slot_start_diff** | `UInt32` | *Difference between processed_at and slot_start_date_time in ms* |
| **epoch** | `UInt32` | *Epoch number* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **beacon_block_root** | `FixedString(66)` | *Beacon block root the PTC validator attested to* |
| **validator_index** | `UInt32` | *Index of the PTC validator* |
| **payload_present** | `Bool` | *Whether the validator attests payload was present* |
| **blob_data_available** | `Bool` | *Whether the validator attests blob data was available* |
| **peer_id** | `String` | *Peer ID we received this PTC vote from on the gossip wire* |
| **processing_duration_ms** | `UInt64` | *Time from gossip receipt to processing completion in milliseconds* |
| **received_at** | `DateTime64(3)` | *Wall-clock time the PTC vote was first received from gossip* |
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

## beacon_synthetic_payload_status_resolved

Fork-choice payload status transitions (EIP-7732 ePBS) synthesized from TYSM-instrumented beacon node internals. Multi-witness (per-node).


> 🔀 Introduced in the **Glamsterdam** network upgrade (`gloas` fork).

### Availability
Data is partitioned **daily** on **slot_start_date_time** for the following networks:

- **sepolia**: `2026-10-06` to `2026-10-07`

### Examples

<details>
<summary>Parquet file</summary>

> https://data.ethpandaops.io/xatu/NETWORK/databases/default/beacon_synthetic_payload_status_resolved/YYYY/MM/DD.parquet
```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query="""
    SELECT
        *
    FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_synthetic_payload_status_resolved/2026/10/1.parquet', 'Parquet')
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
    FROM default.beacon_synthetic_payload_status_resolved FINAL
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
    FROM default.beacon_synthetic_payload_status_resolved FINAL
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
| **event_date_time** | `DateTime64(3)` | *When the beacon node resolved the status (TYSM ResolvedAt)* |
| **slot** | `UInt32` | *Slot number whose payload status was resolved* |
| **slot_start_date_time** | `DateTime` | *The wall clock time when the slot started* |
| **propagation_slot_start_diff** | `UInt32` | *Difference between event_date_time and slot_start_date_time in ms* |
| **epoch** | `UInt32` | *Epoch number* |
| **epoch_start_date_time** | `DateTime` | *The wall clock time when the epoch started* |
| **block_root** | `FixedString(66)` | *Beacon block root for this slot* |
| **block_hash** | `FixedString(66)` | *Execution block hash (when known)* |
| **status** | `LowCardinality(String)` | *New status: PENDING / FULL / EMPTY / INVALID* |
| **previous_status** | `LowCardinality(String)` | *Previous status before this transition* |
| **payload_timeliness_votes_positive** | `UInt64` | *Count of PTC votes with payload_present=true* |
| **payload_timeliness_votes_negative** | `Nullable(UInt64)` | *Count of PTC votes with payload_present=false (explicit negative). NULL when CL does not surface three-state PR #5180 breakdown* |
| **payload_timeliness_votes_absent** | `Nullable(UInt64)` | *Count of PTC seats with no vote (Optional[bool]==None per PR #5180). NULL when CL does not surface the breakdown* |
| **data_available_votes_positive** | `UInt64` | *Count of PTC votes with blob_data_available=true* |
| **data_available_votes_negative** | `Nullable(UInt64)` | *Count of PTC votes with blob_data_available=false (explicit negative). NULL when CL does not surface three-state PR #5180 breakdown* |
| **data_available_votes_absent** | `Nullable(UInt64)` | *Count of PTC seats with no data-availability vote (Optional[bool]==None per PR #5180). NULL when CL does not surface the breakdown* |
| **ptc_size** | `UInt64` | *Total PTC committee size (typically 512)* |
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

<!-- schema_end -->
