{{< alert icon="circle-info" >}}
This **dataset** contains a wealth of information about the **Ethereum network**, including detailed data on **beacon chain** events, **mempool** activity, and **canonical chain** events. Read more in our [announcement post]({{< ref "/posts/open-source-xatu-data" >}} "Announcement post").
{{< /alert >}}

<div class="flex gap-1">
  <span class="font-bold text-primary-100">Xatu data is licensed under</span>
  <a href="http://creativecommons.org/licenses/by/4.0" target="_blank" rel="license noopener noreferrer" class="flex gap-1 items-center font-bold"><span>CC BY 4.0</span><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img class="w-5 h-5 m-0" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"></a>
</div>

## Classes of Data

Xatu data is organized in to different datasets.

Note: View all datasets on one page [here](./all)

<!-- schema_toc_start -->
| Dataset Name | Schema Link | Description | Prefix | EthPandaOps Clickhouse|Public Parquet Files |
|--------------|-------------|-------------|--------|---|---|
| **Beacon API Event Stream** | [Schema](./beacon_api_) | Events derived from the Beacon API event stream | beacon_api_ | ✅ | ✅ |
| **Execution Layer P2P** | [Schema](./mempool_) | Events from the execution layer p2p network | mempool_ | ✅ | ✅ |
| **Canonical Beacon** | [Schema](./canonical_beacon_) | Events derived from the finalized beacon chain | canonical_beacon_ | ✅ | ✅ |
| **Consensus Layer P2P** | [Schema](./libp2p_) | Events from the consensus layer p2p network | libp2p_ | ✅ | ✅ |
| **MEV Relay** | [Schema](./mev_relay_) | Events derived from MEV relays | mev_relay_ | ✅ | ✅ |
<!-- schema_toc_end -->
