# Xatu Dataset Schema

<p xmlns:cc="http://creativecommons.org/ns#" >This work is licensed under <a href="http://creativecommons.org/licenses/by/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"></a></p>

## Classes of Data
Xatu data is organized in to different datasets.

Note: View all schemas on one page [here](./SCHEMA.all.md)

<!-- schema_toc_start -->
| Dataset Name | Schema Link | Description | Prefix | EthPandaOps Clickhouse|Public Parquet Files |
|--------------|-------------|-------------|--------|---|---|
| **Beacon API Event Stream** | [Schema](./schema/beacon_api_.md) | Events derived from the Beacon API event stream | beacon_api_ | ✅ | ✅ |
| **Execution Layer P2P** | [Schema](./schema/mempool_.md) | Events from the execution layer p2p network | mempool_ | ✅ | ✅ |
| **Canonical Beacon** | [Schema](./schema/canonical_beacon_.md) | Events derived from the finalized beacon chain | canonical_beacon_ | ✅ | ✅ |
| **Canonical Execution** | [Schema](./schema/canonical_execution_.md) | Data extracted from the execution layer | canonical_execution_ | ✅ | ✅ |
| **Consensus Layer P2P** | [Schema](./schema/libp2p_.md) | Events from the consensus layer p2p network | libp2p_ | ✅ | ✅ |
| **MEV Relay** | [Schema](./schema/mev_relay_.md) | Events derived from MEV relays | mev_relay_ | ✅ | ✅ |
<!-- schema_toc_end -->
