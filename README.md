# Xatu data

This **dataset** contains a wealth of information about the **Ethereum network**, including detailed data on **beacon chain** events, **mempool** activity, and **canonical chain** events. Read more in our [announcement post](https://ethpandaops.io/posts/open-source-xatu-data/).

<p xmlns:cc="http://creativecommons.org/ns#" >This work is licensed under <a href="http://creativecommons.org/licenses/by/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"></a></p>

> [!IMPORTANT]  
> Join the Xatu Data Telegram group to stay up to date: `https://t[dot]me/+JanoQFu_nO8yNzQ1`


## Table of contents

- [Available data](#available-data)
  - [Schema](#schema)
- [Working with the data](#working-with-the-data)
- [License](#license)
- [Maintainers](#maintainers)

## Available data

<!-- datasets_start -->
| Dataset Name | Schema | Description | Prefix | EthPandaOps Clickhouse|Public Parquet Files |
|--------------|--------|-------------|--------|---|---|
| **Beacon API Event Stream** | [Schema](./schema/beacon_api_.md) | Events derived from the Beacon API event stream | beacon_api_ | ✅ | ✅ |
| **Execution Layer P2P** | [Schema](./schema/mempool_.md) | Events from the execution layer p2p network | mempool_ | ✅ | ✅ |
| **Canonical Beacon** | [Schema](./schema/canonical_beacon_.md) | Events derived from the finalized beacon chain | canonical_beacon_ | ✅ | ✅ |
| **Consensus Layer P2P** | [Schema](./schema/libp2p_.md) | Events from the consensus layer p2p network | libp2p_ | ✅ | ✅ |
| **MEV Relay** | [Schema](./schema/mev_relay_.md) | Events derived from MEV relays | mev_relay_ | ✅ | ✅ |
<!-- datasets_end -->

>Note: **Public parquet files are available to everyone.** Access to EthPandaOps Clickhouse is restricted. If you need access please reach out to us at ethpandaops at ethereum.org.

Check out the visual representation of the [extraction process](./assets/extraction.png).

### Schema

For a detailed description of the data schema, please refer to the [Schema Documentation](./SCHEMA.md).

## Working with the data

Public data is available in the form of Apache Parquet files. You can use any tool that supports the Apache Parquet format to query the data. 

If you have access to EthPandaOps Clickhouse you can query the data directly. Skip ahead to [Using EthPandaOps Clickhouse](#using-ethpandaops-clickhouse).

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
       clickhouse client --query="SELECT * FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/20.parquet', 'Parquet') LIMIT 10 FORMAT Pretty"
       ```
    2. Use globs to query multiple files, e.g., 15th to 20th March
       ```bash
       clickhouse client --query="SELECT COUNT(*) FROM url('https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/2024/3/{15..20}.parquet', 'Parquet') FORMAT Pretty"
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

#### Show the amount of times a block was seen per sentry for the 20th to 27th of March 2024

  ```sql
  clickhouse client --query="""
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

#### Jupyter Notebooks

There are some examples for both Parquet and Clickhouse and SQLAlchemy in the [examples/parquet](./examples/parquet) and [examples/clickhouse](./examples/clickhouse) directories respectively.

## License

- Code: [MIT](./LICENSE)
- Data: [CC BY](https://creativecommons.org/licenses/by/4.0/deed.en)

## Maintainers

Sam - [@samcmau](https://twitter.com/samcmau)

Andrew - [@savid](https://twitter.com/Savid)
