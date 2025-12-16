
Pre-aggregated analytical tables for common blockchain queries. These tables are transformation tables similar to DBT, powered by [xatu-cbt](https://github.com/ethpandaops/xatu-cbt) using [ClickHouse Build Tools (CBT)](https://github.com/ethpandaops/cbt).


CBT tables are organized by network-specific databases. To query these tables, you must target the correct database for your network:
- `mainnet.table_name` for Mainnet data
- `sepolia.table_name` for Sepolia data
- `holesky.table_name` for Holesky data
- `hoodi.table_name` for Hoodi data

Unlike other Xatu datasets, CBT tables do not use `meta_network_name` for filtering. The network is determined by the database you query.

CBT tables include dimension tables (prefixed with `dim_`), fact tables (prefixed with `fct_`), and intermediate tables (prefixed with `int_`).

## Availability
- EthPandaOps Clickhouse

## Tables

<!-- schema_toc_start -->
<!-- schema_toc_end -->

<!-- schema_start -->
<!-- schema_end -->
