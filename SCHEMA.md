# Xatu Dataset Schema

<div class="flex gap-1">
  <span class="font-bold text-primary-100">Xatu data is licensed under</span>
  <a href="http://creativecommons.org/licenses/by/4.0" target="_blank" rel="license noopener noreferrer" class="flex gap-1 items-center font-bold"><span>CC BY 4.0</span><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"></a>
</div>

## Classes of Data
Xatu data is organized into the following classes:

<!-- schema_toc_start -->
| Dataset Name | Schema Link | Description | Prefix | EthPandaOps Clickhouse|Public Parquet Files |
|--------------|-------------|-------------|--------|---|---|
| **Beacon API Event Stream** | [Schema](./schema/beacon_api_.md) | Events derived from the Beacon API event stream | beacon_api_ | ✅ | ✅ |
| **Execution Layer P2P** | [Schema](./schema/mempool_.md) | Events from the execution layer p2p network | mempool_ | ✅ | ✅ |
| **Canonical Beacon** | [Schema](./schema/canonical_beacon_.md) | Events derived from the finalized beacon chain | canonical_beacon_ | ✅ | ✅ |
| **Consensus Layer P2P** | [Schema](./schema/libp2p_.md) | Events from the consensus layer p2p network | libp2p_ | ✅ | ✅ |
| **MEV Relay** | [Schema](./schema/mev_relay_.md) | Events derived from MEV relays | mev_relay_ | ✅ | ✅ |
<!-- schema_toc_end -->
