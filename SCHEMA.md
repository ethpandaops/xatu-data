# Xatu Dataset Schema

<p xmlns:cc="http://creativecommons.org/ns#" >This work is licensed under <a href="http://creativecommons.org/licenses/by/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"></a></p>

## Classes of Data
Xatu data is organized in to different datasets.

Note: View all schemas on one page [here](./SCHEMA.all.md)

<!-- schema_toc_start -->
| Dataset Name | Schema Link | Description | Prefix | EthPandaOps Clickhouse|Public Parquet Files |
|--------------|-------------|-------------|--------|---|---|
| **Beacon API Event Stream** | [Schema](./schema/beacon_api_.md) | Events derived from the Beacon API event stream. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances. These tables are usually fairly slim and contain only a few columns. These tables can be joined with the canonical tables to get a more complete view of the data. For example, you can join the beacon_api_eth_v1_events_block table on block_root or slot with the canonical_beacon_block table to get the block data for each block. | beacon_api_ | ✅ | ✅ |
| **Execution Layer P2P** | [Schema](./schema/mempool_.md) | Events from the execution layer p2p network. This data is usually useful for 'timing' events, such as when a transaction was seen in the mempool by an instance. Because of this it usually has the same data but from many different instances. | mempool_ | ✅ | ✅ |
| **Canonical Beacon** | [Schema](./schema/canonical_beacon_.md) | Events derived from the finalized beacon chain. This data is only derived by a single instance, are deduped, and are more complete and reliable than the beacon_api_ tables. These tables can be reliably JOINed on to hydrate other tables with information | canonical_beacon_ | ✅ | ✅ |
| **Canonical Execution** | [Schema](./schema/canonical_execution_.md) | Data extracted from the execution layer. This data is only derived by a single instance, are deduped, and are more complete and reliable than the execution_layer_p2p tables. These tables can be reliably JOINed on to hydrate other tables with information | canonical_execution_ | ✅ | ✅ |
| **Consensus Layer P2P** | [Schema](./schema/libp2p_.md) | Events from the consensus layer p2p network. This data is usually useful for 'timing' events, such as when a block was seen by a sentry. Because of this it usually has the same data but from many different instances. | libp2p_ | ✅ | ✅ |
| **MEV Relay** | [Schema](./schema/mev_relay_.md) | Events derived from MEV relays. Data is scraped from multiple MEV Relays by multiple instances. | mev_relay_ | ✅ | ✅ |
<!-- schema_toc_end -->
