# Xatu Data Exporter

Python-based pipeline for exporting data from ClickHouse to Parquet files with Iceberg metadata generation.

## Overview

This exporter replaces the Kubernetes CronJob-based export pipeline with a GitHub Actions CI-based solution. It exports data from ClickHouse to Parquet files stored in R2/S3, with automatic Iceberg metadata generation for efficient querying.

## Features

- **Environment-based configuration**: Separate configurations for staging and production
- **Multiple partition strategies**: Daily, hourly, and integer-chunked exports
- **Iceberg metadata generation**: Automatic metadata creation for Apache Iceberg compatibility
- **Column redaction**: Automatic redaction of sensitive columns (IP addresses, geo data)
- **Parallel execution**: Concurrent exports for better performance
- **Dry-run mode**: Test exports without uploading files
- **GitHub Actions integration**: Automated scheduled exports via CI

## Installation

```bash
# Install dependencies
pip install -r requirements.txt

# Or install as editable package with dev dependencies
pip install -e ".[dev]"
```

## Configuration

### Environment Configuration (`config/environments.yaml`)

Defines ClickHouse and storage endpoints for each environment:

```yaml
environments:
  production:
    clickhouse:
      default:
        host: clickhouse.example.com
        port: 8123
        user: exporter
        password_env: CLICKHOUSE_PASSWORD
    storage:
      endpoint: https://r2.cloudflarestorage.com
      bucket: xatu-public
      access_key_env: AWS_ACCESS_KEY_ID
      secret_key_env: AWS_SECRET_ACCESS_KEY
      public_url: https://data.ethpandaops.io
```

### Table Configuration (`config/tables.yaml`)

Defines tables to export, their partitioning strategies, and network configurations:

```yaml
table_groups:
  daily:
    - name: beacon_api_eth_v1_events_block
      database: default
      networks:
        - name: mainnet
          start_date: "2020-12-01"
      partition:
        column: slot_start_date_time
        type: daily
      redacted_columns:
        meta_client_ip: "CAST('0.0.0.0' AS IPv6)"
```

## Usage

### Export Single Table

```bash
# Export yesterday's data for a daily table
python scripts/export_table.py -e production -t beacon_api_eth_v1_events_block -n mainnet

# Export specific date
python scripts/export_table.py -e production -t beacon_api_eth_v1_events_block -n mainnet -d 2024-05-30

# Dry run
python scripts/export_table.py -e production -t beacon_api_eth_v1_events_block -n mainnet --dry-run

# Force re-export
python scripts/export_table.py -e production -t beacon_api_eth_v1_events_block -n mainnet --force
```

### Export All Tables

```bash
# Export all daily tables
python scripts/export_all.py -e production -g daily

# Export all hourly tables with high parallelism
python scripts/export_all.py -e production -g hourly -p 10

# Export all table groups
python scripts/export_all.py -e production -g all
```

### Backfill Iceberg Metadata

For existing Parquet files without Iceberg metadata:

```bash
# Backfill all tables
python scripts/backfill_iceberg.py -e production

# Backfill specific table
python scripts/backfill_iceberg.py -e production -t beacon_api_eth_v1_events_block

# Backfill date range
python scripts/backfill_iceberg.py -e production --start-date 2024-01-01 --end-date 2024-01-31
```

## Development

### Local Development

```bash
# Set up development environment
make dev-setup

# Run local export (dry-run)
make export-local

# Run with custom config
XATU_CONFIG_PATH=config/dev-override.yaml make export-dev TABLE=my_table NETWORK=mainnet

# Run tests
make test

# Lint code
make lint

# Format code
make format
```

### Environment Variables

Required environment variables for each environment:

**Production:**
- `CLICKHOUSE_PASSWORD`
- `EXPERIMENTAL_CLICKHOUSE_PASSWORD`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

**Staging:**
- `CLICKHOUSE_STAGING_PASSWORD`
- `EXPERIMENTAL_CLICKHOUSE_STAGING_PASSWORD`
- `STAGING_AWS_ACCESS_KEY_ID`
- `STAGING_AWS_SECRET_ACCESS_KEY`

## GitHub Actions

The pipeline runs via GitHub Actions workflows:

- **Daily exports**: Runs at 4 AM UTC (`export-daily.yml`)
- **Hourly exports**: Runs 15 minutes past each hour (`export-hourly.yml`)
- **Chunked exports**: Runs every 6 hours (`export-chunked.yml`)
- **Manual exports**: Triggered manually via workflow dispatch (`export-manual.yml`)

## File Structure

Exported files follow this structure:

```
xatu/
└── {network}/
    └── databases/
        └── {database}/
            └── {table}/
                ├── partition_date={YYYY-MM-DD}/
                │   └── {table}.parquet
                ├── partition_hour={HH}/
                │   └── {table}.parquet
                └── partition_chunk={chunk_id}/
                    └── {table}.parquet
```

## Iceberg Metadata

Iceberg metadata is stored alongside data files:

```
xatu/
└── {network}/
    └── databases/
        └── {database}/
            └── {table}/
                └── metadata/
                    ├── version-hint.text
                    ├── v1.metadata.json
                    ├── current.metadata.json
                    └── snap-{id}-manifest-list.json
```

## Monitoring

Export logs are available in:
- GitHub Actions run logs
- Application logs (when run locally)

Key metrics tracked:
- Export duration
- File sizes
- Row counts
- Failed exports

## Migration from Kubernetes

To migrate from the existing Kubernetes CronJob setup:

1. **Parallel run**: Enable GitHub Actions while keeping Kubernetes running
2. **Validation**: Compare outputs between both systems
3. **Cutover**: Disable Kubernetes CronJobs after validation
4. **Backfill**: Run backfill script to generate Iceberg metadata for historical data

## Troubleshooting

Common issues:

1. **Authentication errors**: Check environment variables are set correctly
2. **Network timeouts**: Increase timeout settings in ClickHouse client
3. **Memory issues**: Reduce parallel workers or export smaller date ranges
4. **Missing files**: Check Iceberg metadata is up to date

## Contributing

1. Create a feature branch
2. Make changes and add tests
3. Run `make lint` and `make test`
4. Submit a pull request

## License

See LICENSE file in the repository root.