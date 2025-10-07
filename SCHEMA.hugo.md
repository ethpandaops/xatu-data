{{< alert icon="circle-info" >}}
This **dataset** contains a wealth of information about the **Ethereum network**, including detailed data on **beacon chain** events, **mempool** activity, and **canonical chain** events. Read more in our [announcement post]({{< ref "/posts/open-source-xatu-data" >}} "Announcement post").
{{< /alert >}}

<div class="flex gap-1">
  <span class="font-bold text-primary-100">Xatu data is licensed under</span>
  <a href="http://creativecommons.org/licenses/by/4.0" target="_blank" rel="license noopener noreferrer" class="flex gap-1 items-center font-bold"><span>CC BY 4.0</span><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"></a>
</div>

## Classes of Data

Xatu data is organized in to different datasets.

Note: View all schemas on one page [here](./all)

<!-- schema_toc_start -->
| Dataset Name | Schema Link | Description | Prefix | EthPandaOps Clickhouse|Public Parquet Files |
|--------------|-------------|-------------|--------|---|---|
| **Beacon API Event Stream** | [Schema](./beacon_api_) | Events derived from the Beacon API event stream. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances. These tables are usually fairly slim and contain only a few columns. These tables can be joined with the canonical tables to get a more complete view of the data. For example, you can join the beacon_api_eth_v1_events_block table on block_root or slot with the canonical_beacon_block table to get the block data for each block. | beacon_api_ | ✅ | ✅ |
| **Execution Layer P2P** | [Schema](./mempool_) | Events from the execution layer p2p network. This data is usually useful for 'timing' events, such as when a transaction was seen in the mempool by an instance. Because of this it usually has the same data but from many different instances. | mempool_ | ✅ | ✅ |
| **Canonical Beacon** | [Schema](./canonical_beacon_) | Events derived from the finalized beacon chain. This data is only derived by a single instance, are deduped, and are more complete and reliable than the beacon_api_ tables. These tables can be reliably JOINed on to hydrate other tables with information | canonical_beacon_ | ✅ | ✅ |
| **Canonical Execution** | [Schema](./canonical_execution_) | Data extracted from the execution layer. This data is only derived by a single instance, are deduped, and are more complete and reliable than the execution_layer_p2p tables. These tables can be reliably JOINed on to hydrate other tables with information | canonical_execution_ | ✅ | ✅ |
| **Consensus Layer P2P** | [Schema](./libp2p_) | Events from the consensus layer p2p network. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances. | libp2p_ | ✅ | ✅ |
| **MEV Relay** | [Schema](./mev_relay_) | Events derived from MEV relays. Data is scraped from multiple MEV Relays by multiple instances. | mev_relay_ | ✅ | ✅ |
| **CBT (ClickHouse Build Tools)** | [Schema](./cbt) | Pre-aggregated analytical tables for common blockchain queries. These tables are transformation tables similar to DBT, powered by [xatu-cbt](https://github.com/ethpandaops/xatu-cbt) using [ClickHouse Build Tools (CBT)](https://github.com/ethpandaops/cbt). |  | ✅ | ❌ |
<!-- schema_toc_end -->
