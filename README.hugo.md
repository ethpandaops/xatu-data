{{< alert icon="circle-info" >}}
This **dataset** contains a wealth of information about the **Ethereum network**, including detailed data on **beacon chain** events, **mempool** activity, and **canonical chain** events. Read more in our [announcement post]({{< ref "/posts/open-source-xatu-data" >}} "Announcement post").
{{< /alert >}}
&nbsp;
{{< article link="/posts/open-source-xatu-data/" >}}

<div class="flex gap-1">
  <span class="font-bold text-primary-100">Xatu data is licensed under</span>
  <a href="http://creativecommons.org/licenses/by/4.0" target="_blank" rel="license noopener noreferrer" class="flex gap-1 items-center font-bold"><span>CC BY 4.0</span><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"></a>
</div>

## Table of contents

<div class="bg-neutral-500/10 rounded-xl py-4 px-2 text-base sm:text-lg md:text-xl">

- [Available data](#available-data)
  - [Schema](#schema)
- [Working with the data](#working-with-the-data)
- [Contribute to Xatu data](#contribute-to-xatu-data)
  - [Data Collection](#data-collection)
  - [Privacy groups](#privacy-groups)
  - [Get Started](#get-started)
- [Issues](#issues)
- [License](#license)
- [Maintainers](#maintainers)

</div>

## Available data
<!-- datasets_start -->
| Dataset Name | Schema | Description | Prefix | EthPandaOps Clickhouse|Public Parquet Files |
|--------------|--------|-------------|--------|---|---|
| **Beacon API Event Stream** | [Schema](./schema/beacon_api_) | Events derived from the Beacon API event stream | beacon_api_ | ✅ | ✅ |
| **Execution Layer P2P** | [Schema](./schema/mempool_) | Events from the execution layer p2p network | mempool_ | ✅ | ✅ |
| **Canonical Beacon** | [Schema](./schema/canonical_beacon_) | Events derived from the finalized beacon chain | canonical_beacon_ | ✅ | ✅ |
| **Canonical Execution** | [Schema](./schema/canonical_execution_) | Events derived from the execution chain | canonical_execution_ | ✅ | ✅ |
| **Consensus Layer P2P** | [Schema](./schema/libp2p_) | Events from the consensus layer p2p network | libp2p_ | ✅ | ✅ |
| **MEV Relay** | [Schema](./schema/mev_relay_) | Events derived from MEV relays | mev_relay_ | ✅ | ✅ |
<!-- datasets_end -->

>Note: **Public parquet files are available to everyone.** Access to EthPandaOps Clickhouse is restricted. If you need access please reach out to us at ethpandaops at ethereum.org.

Check out the visual representation of the [extraction process](https://github.com/ethpandaops/xatu-data/blob/master/assets/extraction.png?raw=true).

### Schema

For a detailed description of the data schema, please refer to the [Schema Documentation]({{< ref "data/xatu/schema" >}} "Schema Documentation").

## Working with the data

Public data is available in the form of Apache Parquet files. You can use any tool that supports the Apache Parquet format to query the data. If you have access to EthPandaOps Clickhouse you can query the data directly.

If you have access to EthPandaOps Clickhouse you can query the data directly. Skip ahead to [**Using EthPandaOps Clickhouse**](#using-ethpandaops-clickhouse).

- [Getting started](#getting-started)
- [Choose your data access method](#choose-your-data-access-method)
  - [Running your own Clickhouse](#running-your-own-clickhouse)
  - [Using EthPandaOps Clickhouse](#using-ethpandaops-clickhouse)
  - [Querying public parquet files](#querying-public-parquet-files)
- [Examples](#examples)
  - [Queries](#queries)
  - [Jupyter Notebooks](#jupyter-notebooks)

### Getting started

There's a few ways to get started with the data.
First install the dependencies:
  1. Install [docker](https://docs.docker.com/get-docker/)
  2. Verify the installation by running the following command:
      ```bash
      docker version
      ```

#### Choose your data access method

There are three options to get started with the data, all of them using Clickhouse. 

- Option 1: **Setup your own Clickhouse server and import the data.**
  
  > Recommended for most use cases.
  > 
  Great for larger, repeated queries or when you want to query the data in a more complex way.


  [Click here to get started](#running-your-own-clickhouse)

- Option 2: **Query the public parquet files directly.**
  
  Great for small queries one-off queriesor when you don't want to setup your own Clickhouse server.
  
  [Click here to get started](#querying-public-parquet-files)

- Option 3: **Use EthPandaOps Clickhouse.**
  
  Great for quick and easy queries. **No setup required but access is limited.**

  [Click here to get started](#using-ethpandaops-clickhouse)


#### Running your own Clickhouse

Running your own Clickhouse cluster is recommended for most use cases. This process will walk you through the steps of setting up a cluster with the Xatu Clickhouse migrations and importing the data straight from the public parquet files.

- **Clone the Xatu repo**  
  Xatu contains a docker compose file to run a Clickhouse cluster locally. This server will automatically have the correct schema migrations applied.
  
  Steps:
    1. Clone the Xatu repo
       ```bash
       git clone https://github.com/ethpandaops/xatu.git;
       cd xatu
       ```
    2. Start the Xatu clickhouse stack
       ```bash
       docker compose --profile clickhouse up --detach
       ```
    3. Verify the Clickhouse server is running and migrations are applied
       ```bash
       docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query "SHOW TABLES FROM default" | grep -v local
       ```
       This should show you the tables that are available in the default database.
       e.g.
       ```
       ...
       beacon_api_eth_v1_beacon_committee
       beacon_api_eth_v1_events_attestation
       beacon_api_eth_v1_events_blob_sidecar
       ...
       ```

- **Load data into Clickhouse**

  Our Clickhouse cluster is running but has no data! Let's import some data.
  
  Steps:
    1. Clone the Xatu-data repository
       ```bash
       cd;
       git clone https://github.com/ethpandaops/xatu-data.git
       cd xatu-data;
       ```
    2. Install clickhouse client
       ```bash
       curl https://clickhouse.com/ | sh
       ```
    3. Import the data into Clickhouse
       ```bash
       ./import-clickhouse.sh mainnet default beacon_api_eth_v1_events_block 2024-03-20 2024-03-27
       ```
       This will import the data for the `default.beacon_api_eth_v1_events_block` table in mainnet from the 20th of March 2024 to the 27th of March 2024.
    4. Verify the data import
       ```bash
       docker run --rm -it --net host \
        clickhouse/clickhouse-server clickhouse client -q "SELECT toStartOfDay(slot_start_date_time) AS day, COUNT(*) FROM default.beacon_api_eth_v1_events_block GROUP BY day FORMAT Pretty"
       ```
       This query will show you the count of events per day.

- **Query Parquet Files Directly**

  Alternatively, you can query the parquet files directly without importing. This is useful if you only need to query a small subset of the data. 
  
  Steps:
    1. Query the first 10 rows of the beacon_api_eth_v1_events_block table for 2024-03-20
       ```bash
       # date based partitioned tables
       clickhouse local --query="SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/20.parquet', 'Parquet') LIMIT 10 FORMAT Pretty"
       ```
    2. Query the first 10 rows of the canonical_execution_block table for chunk `20000000.parquet` (block numbers between `20000000` and `20000999`)
       ```bash
       # integer based partitioned tables
       clickhouse local --query="SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/20000000.parquet', 'Parquet') LIMIT 10 FORMAT Pretty"
       ```
    3. Use globs to query multiple files, e.g., 15th to 20th March or between block `20000000` and `20010000`
       ```bash
       # date based partitioned tables
       clickhouse local --query="SELECT COUNT(*) FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/{15..20}.parquet', 'Parquet') FORMAT Pretty"

       # integer based partitioned tables
       clickhouse local --query="SELECT COUNT(*) FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/{20000..20010}000.parquet', 'Parquet') LIMIT 10 FORMAT Pretty"
       ```

#### Using EthPandaOps Clickhouse
The EthPandaOps Clickhouse cluster already has the data loaded and the schema migrations applied. You can query the data directly.
If you need access please reach out to us at ethpandaops at ethereum.org. Access is limited.

- **Query the data**
  
  Steps:
    1. Setup your credentials

        ```bash
        export CLICKHOUSE_USER=YOUR_USERNAME
        export CLICKHOUSE_PASSWORD=YOUR_PASSWORD
        export CLICKHOUSE_HOST=clickhouse.analytics.production.platform.ethpandaops.io
        ```
  
    2. Execute a query
       ```bash
        curl -G "https://clickhouse.analytics.production.platform.ethpandaops.io" \
        -u "$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD" \
            --data-urlencode "query= \
            SELECT \
                * \
            FROM default.beacon_api_eth_v1_events_block FINAL \
            WHERE \
                slot_start_date_time >= NOW() - INTERVAL '1 HOUR' \
            LIMIT 3 \
            FORMAT Pretty \
            "
       ```

#### Querying public parquet files

Querying the public parquet files is a great way to get started with the data. **We recommend you don't do this for larger queries or queries that you'll run again.**

Examples:

- Count the number of block events per consensus client for the 20th of March 2024 on Mainnet

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query="
  SELECT
    count(*), meta_consensus_implementation 
  FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/20.parquet', 'Parquet')
  GROUP BY meta_consensus_implementation 
  FORMAT Pretty
"
```

- Show the top 5 block builders by block numbers between 20000000 and 20010999

```bash
docker run --rm -it clickhouse/clickhouse-server clickhouse local --query="
  SELECT
      count(*),
      extra_data_string
  FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/canonical_execution_block/1000/{20000..20010}000.parquet', 'Parquet')
  WHERE
      block_number BETWEEN 20000000 AND 20010000
  GROUP BY extra_data_string
  ORDER BY count(*) DESC
  LIMIT 5
  FORMAT Pretty
"
```

### Examples
Once your Clickhouse server is setup and the data is imported, you can query the data.

#### Queries

- Show all block events for the 20th of March 2024 by nimbus sentries on mainnet between 01:20 and 01:30
  
  ```bash
  docker run --rm -it --net host -e CLICKHOUSE_USER=$CLICKHOUSE_USER -e CLICKHOUSE_PASSWORD=$CLICKHOUSE_PASSWORD -e CLICKHOUSE_HOST=$CLICKHOUSE_HOST clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        *
    FROM beacon_api_eth_v1_events_block
    WHERE
        meta_network_name = 'mainnet'
        AND slot_start_date_time BETWEEN '2024-03-20 01:20:00' AND '2024-03-20 01:30:00' -- strongly recommend filtering by the partition key (slot_start_date_time) for query performance
        AND meta_consensus_implementation = 'nimbus'
    FORMAT Pretty
  """
  ```

- Show the 90th, 50th, 05th percentile and min arrival time for blocks per day for the 20th to 27th of March 2024

  ```bash
  docker run --rm -it --net host -e CLICKHOUSE_USER=$CLICKHOUSE_USER -e CLICKHOUSE_PASSWORD=$CLICKHOUSE_PASSWORD -e CLICKHOUSE_HOST=$CLICKHOUSE_HOST clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        toStartOfDay(slot_start_date_time) AS day,
        round(MIN(propagation_slot_start_diff)) AS min_ms,
        round(quantile(0.05)(propagation_slot_start_diff)) AS p05_ms,
        round(quantile(0.50)(propagation_slot_start_diff)) AS p50_ms,
        round(quantile(0.90)(propagation_slot_start_diff)) AS p90_ms
    FROM beacon_api_eth_v1_events_block
    WHERE
        slot_start_date_time BETWEEN '2024-03-20' AND '2024-03-27' -- strongly recommend filtering by the partition key (slot_start_date_time) for query performance
    GROUP BY day
    ORDER BY day AS
    FORMAT Pretty
  """
  ```

- Show the amount of times a block was seen per sentry for the 20th to 27th of March 2024

  ```bash
  docker run --rm -it --net host -e CLICKHOUSE_USER=$CLICKHOUSE_USER -e CLICKHOUSE_PASSWORD=$CLICKHOUSE_PASSWORD -e CLICKHOUSE_HOST=$CLICKHOUSE_HOST clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        meta_client_name AS client_name,
        COUNT(*) AS count
    FROM beacon_api_eth_v1_events_block
    WHERE
        slot_start_date_time BETWEEN '2024-03-20' AND '2024-03-27' -- strongly recommend filtering by the partition key (slot_start_date_time) for query performance
    GROUP BY client_name
    FORMAT Pretty
  """
  ```

- Show the top 5 block builders by block numbers between 20000000 and 20010000

  ```bash
  docker run --rm -it --net host -e CLICKHOUSE_USER=$CLICKHOUSE_USER -e CLICKHOUSE_PASSWORD=$CLICKHOUSE_PASSWORD -e CLICKHOUSE_HOST=$CLICKHOUSE_HOST clickhouse/clickhouse-server clickhouse client --query="""
    SELECT
        count(*),
        extra_data_string
    FROM canonical_execution_block
    WHERE
        block_number BETWEEN 20000000 AND 20010000
    GROUP BY extra_data_string
    ORDER BY count(*) DESC
    LIMIT 5
    FORMAT Pretty
  """
  ```

#### Jupyter Notebooks

There are some examples for both Parquet and Clickhouse and SQLAlchemy in the [examples/parquet](https://github.com/ethpandaops/xatu-data/tree/master/examples/parquet) and [examples/clickhouse](https://github.com/ethpandaops/xatu-data/tree/master/examples/clickhouse) directories respectively.

## Contribute to Xatu data

We're excited to announce that we are opening up the Xatu data collection pipeline to the Ethereum community! This initiative enables community members to contribute valuable data to the Xatu dataset.

As discussions regarding the potential increase in maximum blob count continue **we hope to shed light on the perspective of Ethereum's most crucial participants - home stakers.**

**Summary:**

- Privacy focused. Multiple privacy levels that allow contributors to only disclose data they're comfortable with
- Initially restricted to known community members
- [Data is published daily by the EthPandaOps team](/data/xatu/#working-with-the-data)

### Data Collection
#### Overview

Data is collected by running a Beacon node and the `xatu sentry` sidecar. The data is then sent to a pipeline that we run, which further anonymizes and redacts the data.

{{< mermaid >}}
graph TD
    A1[Home Staker 1] --> B1[Beacon Node]
    A2[You!] --> B2[Beacon Node]
    A3[Home Staker 3] --> B3[Beacon Node]
    B1 --> X1[Xatu Sentry]
    B2 --> X2[Xatu Sentry]
    B3 --> X3[Xatu Sentry]
    C[EthPandaOps]
    C --> D[Data Pipeline]
    
    D --> E[Public Parquet Files]
    
    X1 --> C
    X2 --> C
    X3 --> C

    subgraph "Data Collection"
        A1
        A2
        A3
        B1
        B2
        B3
        X1
        X2
        X3
    end
    
    subgraph " "
        C
        D
    end
    
    subgraph " "
        E
    end
    linkStyle 0 stroke:#f66,stroke-width:2px;
    linkStyle 1 stroke:#f66,stroke-width:2px;
    linkStyle 2 stroke:#f66,stroke-width:2px;
    linkStyle 3 stroke:#f66,stroke-width:2px;
    linkStyle 4 stroke:#f66,stroke-width:2px;
    linkStyle 5 stroke:#f66,stroke-width:2px;
    linkStyle 6 stroke:#f66,stroke-width:2px;
    linkStyle 7 stroke:#f66,stroke-width:2px;
    linkStyle 8 stroke:#f66,stroke-width:2px;
    linkStyle 9 stroke:#f66,stroke-width:2px;
    linkStyle 10 stroke:#f66,stroke-width:2px;
{{< /mermaid >}}

#### Events Collected

The following events will be collected:

- **[beacon_api_eth_v1_events_head](/data/xatu/schema/#beacon_api_eth_v1_events_head)**
    - When the beacon node has a new head block
    - <details>
        <summary>Example payload</summary>
        {{< highlight yaml >}}
data:
  block: "0x43d85cfa70181f60971dbc59d60c0e82e2ff8aea995bc942dc9c27bb16a055ca"
  current_duty_dependent_root: "0xc59a164bf477f138363db57e34f5b0e561c8bb1d30a0526f195b5575b2137513"
  previous_duty_dependent_root: "0xbdbad239bcde3aa281edb7067a86ddba41f7f0a2e55b7ca61d628e57b6f1695f"
  slot: "10098904"
  state: "0xbcf7bbd9f5da8b88d09e3876834e93945edd98a258091339caedad2ec6764576"
event:
  date_time: "2024-10-04T03:01:13.245589039Z"
  id: "b6b13f23-6412-4e74-aa62-8639fc2fa04e"
  name: "BEACON_API_ETH_V1_EVENTS_HEAD_V2"
additional_data:
  epoch:
    number: "315590"
    start_date_time: "2024-10-04T02:56:23Z"
  propagation:
    slot_start_diff: "2245"
  slot:
    start_date_time: "2024-10-04T03:01:11Z"
        {{< /highlight >}}
        </details>
- **[beacon_api_eth_v1_events_block](/data/xatu/schema/#beacon_api_eth_v1_events_block)**
    - When the beacon node has a new block
    - <details>
        <summary>Example payload</summary>
        {{< highlight yaml >}}
data:
  block: "0x7bb7f9e703896d516a0ee56d273dbe8fd71fd994a2f36cc489b8e1b825d74d44"
  slot: "10098966"
event:
  date_time: "2024-10-04T03:13:37.703055591Z"
  id: "58ccd540-81c2-44ce-820d-e73b5af0bea7"
  name: "BEACON_API_ETH_V1_EVENTS_BLOCK_V2"
additional_data:
  epoch:
    number: "315592"
    start_date_time: "2024-10-04T03:09:11Z"
  propagation:
    slot_start_diff: "2703"
  slot:
    number: "10098966"
    start_date_time: "2024-10-04T03:13:35Z"
  
        {{< /highlight >}}
    </details>
- **[beacon_api_eth_v1_events_blob_sidecar](/data/xatu/schema/#beacon_api_eth_v1_events_blob_sidecar)**
    - When the beacon node has recieved a blob sidecar that passes gossip validation.
    - <details>
        <summary>Example payload</summary>
        {{< highlight yaml >}}
data:
  block_root: '0xc78adbc7ce7ab828bed85fedc6429989b4f4451d41aac8dc0c40b9f57839a3d7'
  index: '0'
  kzg_commitment: '0xa8de65da8d07703217d6879c75165a36973ff3ddace933907e7d400662b90e575812bb1302bfd4bb24691a550a0dc02a'
  slot: '10099003'
  versioned_hash: '0x0196e5bc26c289ff58a37c75f72b6824507d67ab0e43577495d1ad7b74716601'
event:
  date_time: '2024-10-04T03:21:00.752889196Z'
  id: adbf1ecb-4e52-404f-b3ba-6f83f6ffc4db
  name: BEACON_API_ETH_V1_EVENTS_BLOB_SIDECAR
additional_data:
  epoch:
    number: '315593'
    start_date_time: '2024-10-04T03:15:35Z'
  propagation:
    slot_start_diff: '1752'
  slot:
    number: '10099003'
    start_date_time: '2024-10-04T03:20:59Z'
        {{< /highlight >}}
    </details>
- **[beacon_api_eth_v1_events_chain_reorg](/data/xatu/schema/#beacon_api_eth_v1_events_chain_reorg)**
    - When the beacon node has reorganized its chain
    - <details>
        <summary>Example payload</summary>
        {{< highlight yaml >}}
data:
  depth: '3'
  epoch: '83615'
  new_head_block: '0x4a99bc2dbb2c5640cf0798102588dcbc3c02d15989c7652bbcf4647e24a14881'
  new_head_state: '0x3e5af57c5c3bd8fa394c21edd8ac5b07378ef1e143ed18a9ff695090c970b23f'
  old_head_block: '0x28e85b3e33721ad20b86c671f35686c8c91b5a29c6fd0cb41698872048d1b8ed'
  old_head_state: '0x00f61794f1da3817bb8ae4591bbc0bc9cc0c72f4a422d5fdda5cd584ee147cd3'
  slot: '2675702'
event:
  date_time: '2024-10-04T03:00:36.161478913Z'
  id: b0db9607-a862-4dd2-b7e6-4faf77e3a949
  name: BEACON_API_ETH_V1_EVENTS_CHAIN_REORG_V2
additional_data:
  epoch:
    number: '83615'
    start_date_time: '2024-10-04T02:56:00Z'
  propagation:
    slot_start_diff: '12161'
  slot:
    start_date_time: '2024-10-04T03:00:24Z'

        {{< /highlight >}}
    </details>
- **[beacon_api_eth_v1_events_finalized_checkpoint](/data/xatu/schema/#beacon_api_eth_v1_events_finalized_checkpoint)**
    - When the beacon node's finalized checkpoint has been updated
    - <details>
        <summary>Example payload</summary>
        {{< highlight yaml >}}
data:
  block: '0x418645de30f82a71b7470dfc9831602f750a3b8e14e507e112791d53b3d3842e'
  epoch: '188220'
  state: '0x195dcdf004596c7afd999c39ff6f718f5bb631f3c8838b445fe87ea8f4f6de52'
event:
  date_time: '2024-10-04T03:00:47.506914227Z'
  id: 57e595a9-c79a-458c-be83-0d6dd58ee81c
  name: BEACON_API_ETH_V1_EVENTS_FINALIZED_CHECKPOINT_V2
additional_data:
  epoch:
    number: '188220'
    start_date_time: '2024-10-04T02:48:00Z'

        {{< /highlight >}}
    </details>

#### Metadata

The following additional metadata is sent with every event:
##### Client Metadata
{{< highlight yaml >}}
clock_drift: '2' # Clock drift of the host machine
ethereum:
    consensus:
        implementation: lighthouse # Beacon node implementation
        version: Lighthouse/v5.3.0-d6ba8c3/x86_64-linux # Beacon node version
    network:
        id: '11155111' # Ethereum network ID
        name: sepolia # Ethereum network name
id: 98df53c0-3de0-477c-a7c9-4ea9b17981c3 # Session ID. Resets on restart
implementation: Xatu
module_name: SENTRY
name: b538bfd92sdv3 # Name of the sentry. Hash of the Beacon Node's node ID.
os: linux # Operating system of the host running sentry
version: v0.0.202-3645eb8 # Xatu version

{{< /highlight >}}

##### Server Metadata
Once we recieve the event, we do some additional processing to get the server metadata. The data that is added to the event is configurable per-user and allows users to only disclose data they're comfortable with. Geo location data is very useful for understanding how data is propagated through the network, but is not required.

{{< highlight yaml >}}
server:
  client:
    geo:
      # OPTIONAL FIELDS
      ## Data about ISP
      autonomous_system_number: 24940 # Autonomous system number of the client
      autonomous_system_organization: "Hetzner Online GmbH" # Organization associated with the autonomous system
      
      ## Data about location
      city: "Helsinki" # City where the client is located
      continent_code: "EU" # Continent code of the client's location
      country: "Finland" # Country where the client is located
      country_code: "FI" # Country code of the client's location
      
      ### ALWAYS REDACTED
      latitude: REDACTED # Latitude coordinate of the client's location
      longitude: REDACTED # Longitude coordinate of the client's location
    group: "asn-city" # Group the client belongs to
    user: "simplefrog47" # Pseudo username that sent the event
    # ALWAYS REDACTED
    ip: "REDACTED" # IP address of the client that sent the event
  event:
    received_date_time: "2024-10-04T03:00:48.533351629Z" # Timestamp when the event was received

{{< /highlight >}}
**Note:** 
- The `client.name` field is re-hashed with a salt that only the EthPandaOps team has access to. This means that the original name of the client is not disclosed, and there is no way to map events back to a specific node id.
- The `client.ip`, `client.geo.latitude`, and `client.geo.longitude` fields are ALWAYS redacted.

### Privacy groups

Privacy is a top priority for us. We have created privacy groups to allow users to only disclose data they're comfortable with.

#### No additional Geo/ASN data
<details>
        <summary>No additional Geo/ASN data</summary>
        {{< highlight yaml >}}
autonomous_system_number: REDACTED # REDACTED
autonomous_system_organization: REDACTED # REDACTED
city: "REDACTED" # REDACTED
country: "REDACTED" # REDACTED
country_code: "REDACTED" # REDACTED
continent_code: "REDACTED"
        {{< /highlight >}}
</details>

#### With ASN data
<details>
        <summary>Share geo location down to the city level</summary>
        {{< highlight yaml >}}
autonomous_system_number: 24940
autonomous_system_organization: "Hetzner Online GmbH"
city: "Helsinki"
continent_code: "EU"
country: "Finland"
country_code: "FI"
        {{< /highlight >}}
</details>

<details>
        <summary>Share geo location down to the country level</summary>
        {{< highlight yaml >}}
autonomous_system_number: 24940
autonomous_system_organization: "Hetzner Online GmbH"
continent_code: "EU"
country: "Finland"
country_code: "FI"

city: "REDACTED" # REDACTED
        {{< /highlight >}}
</details>

<details>
        <summary>Share geo location down to the continent level</summary>
        {{< highlight yaml >}}
autonomous_system_number: 24940
autonomous_system_organization: "Hetzner Online GmbH"
continent_code: "EU"

city: "REDACTED" # REDACTED
country: "REDACTED" # REDACTED
country_code: "REDACTED" # REDACTED
        {{< /highlight >}}
</details>

<details>
        <summary>Share no geo location data</summary>
        {{< highlight yaml >}}
autonomous_system_number: 24940
autonomous_system_organization: "Hetzner Online GmbH"

continent_code: "EU"
city: "REDACTED" # REDACTED
country: "REDACTED" # REDACTED
country_code: "REDACTED" # REDACTED
        {{< /highlight >}}
</details>

#### Without ASN data
<details>
        <summary>Share geo location down to the city level without ASN</summary>
        {{< highlight yaml >}}
city: "Helsinki"
continent_code: "EU"
country: "Finland"
country_code: "FI"

autonomous_system_number: REDACTED # REDACTED
autonomous_system_organization: REDACTED # REDACTED
        {{< /highlight >}}
</details>

<details>
        <summary>Share geo location down to the country level without ASN</summary>
        {{< highlight yaml >}}
continent_code: "EU"
country: "Finland"
country_code: "FI"

autonomous_system_number: REDACTED # REDACTED
autonomous_system_organization: REDACTED # REDACTED
city: "REDACTED" # REDACTED
        {{< /highlight >}}
</details>

<details>
        <summary>Share geo location down to the continent level without ASN</summary>
        {{< highlight yaml >}}
continent_code: "EU"

autonomous_system_number: REDACTED # REDACTED
autonomous_system_organization: REDACTED # REDACTED
city: "REDACTED" # REDACTED
country: "REDACTED" # REDACTED
country_code: "REDACTED" # REDACTED
        {{< /highlight >}}
</details>

### Get Started

Contributing to the Xatu dataset is currently restricted to known community members. We have plans to open this up to the public in the future, but for now, we want to ensure that the data remains high quality and relevant to the home staker community (read: we need to make sure our pipeline can handle the increased load 😂)

If you'd like to contribute to the Xatu dataset, please
**[apply for access here](https://forms.gle/S7g5g8nB8aGG8aTX6)**

Once you've been granted access, you'll receive instructions on how exactly to run `xatu sentry` and start contributing to the dataset.

### Docker
If you're already running a beacon node, running `xatu sentry` is as simple as running a docker container on your node. For example:

```bash
docker run -d \
  --name xatu-sentry \
  --restart unless-stopped \
  --cpus="0.5" \
  --memory="1g" \
  --read-only \
  ethpandaops/xatu:latest sentry \
  --preset ethpandaops \
  --beacon-node-url=http://localhost:5052 \
  --output-authorization=REDACTED
```

### Binary

You can download the binary from our [GitHub Releases](https://github.com/ethpandaops/xatu/releases) page or use the [install script](https://github.com/ethpandaops/xatu?tab=readme-ov-file#install-via-bash-script).

Once you have the `xatu` binary, you can run it with the following command:

```bash
xatu sentry \
  --preset ethpandaops \
  --beacon-node-url=http://localhost:5052 \
  --output-authorization=REDACTED
```

## Issues

{{< github repo="ethpandaops/xatu-data" >}}

## License

- Code: [MIT](./LICENSE)
- Data: [CC BY](https://creativecommons.org/licenses/by/4.0/deed.en)

## Maintainers

Sam - [@samcmau](https://twitter.com/samcmau)

Andrew - [@savid](https://twitter.com/Savid)
