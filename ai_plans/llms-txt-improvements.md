# Xatu Data llms.txt & llms-full.txt Generation Script Improvements

## Overview

Xatu is a data collection and processing pipeline for Ethereum network data. This project contains multiple datasets that are available through both Parquet files and a Clickhouse database. This plan outlines improvements to the `generate-llmstxt.sh` script to create an enhanced `llms.txt` file and a new, more comprehensive `llms-full.txt` file to better assist Large Language Models (LLMs) in accessing and understanding the data.

## Current State Assessment

The current `generate-llmstxt.sh` script:
- Creates a basic `llms.txt` file with dataset overview, URL patterns, and query examples
- Extracts dataset information from the config.yaml file
- Lists tables with basic metadata (partitioning type, network availability, etc.)
- Has a somewhat hard-to-follow structure with multiple embedded cat/EOF blocks
- Does not generate a more comprehensive `llms-full.txt` file
- Does not emphasize enough the importance of partitioning column filtering

## Goals

1. Enhance the `generate-llmstxt.sh` script to:
   - Generate both `llms.txt` and `llms-full.txt` files
   - Include stronger warnings about partition filtering requirements
   - Improve the structure of content for better LLM parsing
   - Add more comprehensive examples, especially for Parquet access
   - Make the script more modular and maintainable

2. Ensure both output files:
   - Follow best practices for LLM consumption
   - Clearly explain data access patterns
   - Emphasize critical performance considerations
   - Provide useful examples for different access methods

## Script Modification Approach

### 1. Script Structure Improvements

- Add support for generating two different output files
- Create modular functions for each section instead of large cat/EOF blocks
- Use variables for common content to reduce duplication
- Add command-line parameters for customization
- Create clear separation between content templates and data extraction

### 2. Content Generation Improvements

- Generate hierarchically structured content according to LLM best practices
- Use proper heading levels (H1, H2, H3) consistently
- Add blockquote descriptions for clear parsing
- Include warning emojis for critical information
- Extract more detailed information from the config.yaml file
- Include more examples of code and queries

### 3. Specific Script Changes

1. **Add Parameters and Configuration**:
   ```bash
   # Configuration
   llms_txt_file="llms.txt"
   llms_full_txt_file="llms-full.txt"
   github_config_url="https://raw.githubusercontent.com/ethpandaops/xatu-data/master/config.yaml"

   # Command line options
   while getopts "c:s:f:l:h" opt; do
     case $opt in
       c) config_file="$OPTARG" ;;  # Custom config file
       s) schema_dir="$OPTARG" ;;   # Custom schema directory
       f) llms_full_txt_file="$OPTARG" ;;  # Custom llms-full.txt output file
       l) llms_txt_file="$OPTARG" ;;      # Custom llms.txt output file
       h) show_help; exit 0 ;;
       *) show_help; exit 1 ;;
     esac
   done
   ```

2. **Create Modular Functions**:
   ```bash
   # Generate the common sections that appear in both files
   generate_common_header() {
     local output_file=$1
     cat > "$output_file" << 'EOF'
   # Xatu Dataset
   > Comprehensive Ethereum network data collection focusing on blockchain metrics, client performance, and network analysis.

   ## Overview
   
   Xatu is a data collection and processing pipeline for Ethereum network data.
   - Xatu contains multiple "modules" that each derive Ethereum data differently
   - The data is stored in a Clickhouse database and published to Parquet files
   - ethPandaOps runs all modules, with community members also contributing data
   - Public Parquet files are available with a 1-3 day delay with some privacy redactions
   EOF
   }

   # Generate warnings section
   generate_warnings_section() {
     local output_file=$1
     cat >> "$output_file" << 'EOF'
   
   ## ⚠️ Critical Usage Warning
   
   **You MUST filter on the partitioning column when querying these datasets.**
   - Failure to do so will result in extremely slow queries that scan entire tables
   - This is especially important for large tables with billions of rows
   - Always check the table's partitioning column and type before querying
   EOF
   }
   
   # Add more functions for other sections...
   ```

3. **Main Execution Flow**:
   ```bash
   # Generate llms.txt (concise version)
   log "Generating $llms_txt_file file..."
   generate_common_header "$llms_txt_file"
   generate_warnings_section "$llms_txt_file"
   generate_access_methods_section "$llms_txt_file"
   generate_datasets_section "$llms_txt_file" "concise"
   generate_examples_section "$llms_txt_file" "concise"
   generate_footer "$llms_txt_file"
   
   # Generate llms-full.txt (comprehensive version)
   log "Generating $llms_full_txt_file file..."
   generate_common_header "$llms_full_txt_file"
   generate_warnings_section "$llms_full_txt_file"
   generate_data_architecture_section "$llms_full_txt_file"
   generate_access_methods_section "$llms_full_txt_file" "detailed"
   generate_datasets_section "$llms_full_txt_file" "detailed"
   generate_examples_section "$llms_full_txt_file" "detailed"
   generate_full_schema_section "$llms_full_txt_file"
   generate_programmatic_section "$llms_full_txt_file"
   generate_glossary_section "$llms_full_txt_file"
   generate_footer "$llms_full_txt_file"
   ```

### 4. Including Table Schemas in llms-full.txt

The `llms-full.txt` should include complete schema information for each table. We'll add a function to generate this section:

```bash
# Generate schema section for llms-full.txt
generate_full_schema_section() {
  local output_file=$1
  
  cat >> "$output_file" << 'EOF'
## Complete Table Schemas

This section contains the full CREATE TABLE statements for all tables in the Xatu dataset.
These schemas can be used to create tables in your own Clickhouse instance.

### How to Access Table Schemas

You can access any table's schema directly using:

```bash
# View a specific table schema
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/TABLE_NAME.sql

# Find and view a schema for a specific table
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/canonical_beacon_block.sql
```

To search for a specific table's schema, you can use:

```bash
# List all available schemas
curl -s https://api.github.com/repos/ethpandaops/xatu-data/contents/schema/clickhouse/default | jq -r '.[].name'

# Fetch and find details about a specific table
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/beacon_api_eth_v1_events_block.sql | grep -A 50 "CREATE TABLE"
```
EOF

  # Include actual schemas by reading from the schema directory
  echo >> "$output_file"
  echo "### Table Schemas" >> "$output_file"
  echo >> "$output_file"
  
  # Loop through all database directories in the schema/clickhouse directory
  for db_dir in ./schema/clickhouse/*; do
    if [ -d "$db_dir" ]; then
      db_name=$(basename "$db_dir")
      echo "#### Database: $db_name" >> "$output_file"
      echo >> "$output_file"
      
      # Loop through all table SQL files in the database directory
      for sql_file in "$db_dir"/*.sql; do
        # Only include the non-_local files to avoid duplication
        if [[ ! "$sql_file" == *"_local.sql" ]]; then
          table_name=$(basename "$sql_file" .sql)
          echo "##### Table: $table_name" >> "$output_file"
          echo >> "$output_file"
          echo '```sql' >> "$output_file"
          cat "$sql_file" >> "$output_file"
          echo '```' >> "$output_file"
          echo >> "$output_file"
        fi
      done
    fi
  done
}
```

### 5. Sample Programmatic Access Examples

```bash
generate_programmatic_section() {
  local output_file=$1
  cat >> "$output_file" << 'EOF'

## Programmatic Access Examples

### Python with Pandas
```python
import pandas as pd
from datetime import datetime, timedelta

# Set date range
start_date = datetime(2024, 4, 1)
end_date = datetime(2024, 4, 2)

# Generate URLs for the date range
base_url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/"
urls = [f"{base_url}{date.year}/{date.month}/{date.day}.parquet" 
        for date in (start_date + timedelta(days=n) 
                    for n in range((end_date - start_date).days + 1))]

# Download and load data
dfs = []
for url in urls:
    df = pd.read_parquet(url)
    df['slot_start_date_time'] = pd.to_datetime(df['slot_start_date_time'], unit='s')
    dfs.append(df)

# Combine and analyze
df_combined = pd.concat(dfs)
grouped = df_combined.groupby('slot_start_date_time')['propagation_slot_start_diff'].median()
```

### Python with Polars (Lazy Evaluation)
```python
import polars as pl
from datetime import datetime, timedelta

# Set date range
start_date = datetime(2024, 4, 1)
end_date = datetime(2024, 4, 2)

# Generate URLs
base_url = "https://data.ethpandaops.io/xatu/mainnet/databases/default/beacon_api_eth_v1_events_block/"
urls = [f"{base_url}{date.year}/{date.month}/{date.day}.parquet" 
        for date in (start_date + timedelta(days=n) 
                    for n in range((end_date - start_date).days + 1))]

# Create lazy DataFrames
lazy_dfs = [pl.scan_parquet(url) for url in urls]
combined = pl.concat(lazy_dfs)

# Analyze with lazy evaluation
result = (combined
    .group_by("slot_start_date_time")
    .agg(pl.col("propagation_slot_start_diff").median())
    .collect())
```
EOF
}
```

## Expected Output Structure

### llms.txt (Concise Version)
```
# Xatu Dataset
> Comprehensive Ethereum network data collection focusing on blockchain metrics, client performance, and network analysis.

## Overview
[Brief overview]

## ⚠️ Critical Usage Warning
[Warning about partition filtering]

## Access Methods
### Parquet Files (Public)
### Clickhouse Database (Restricted)

## Core Datasets
[Brief listing of datasets]

## Examples
[Basic query examples including schema access via grep]

## Resources
[Links to more information]
```

### llms-full.txt (Comprehensive Version)
```
# Xatu Dataset: Comprehensive Guide
> Complete documentation for accessing and analyzing Ethereum network data from the Xatu data collection pipeline.

## Overview
[Detailed overview]

## ⚠️ Critical Usage Warning
[Detailed warnings about partition filtering]

## Data Architecture
[Detailed explanation of data structure]

## Access Methods
[Comprehensive access instructions]

## Dataset Catalog
[Detailed information about all datasets]

## Query Examples
[Multiple complex query examples]

## Complete Table Schemas
[How to access schemas and full CREATE TABLE statements for all tables]

## Programmatic Access
[Code examples in Python, R, etc.]

## Common Analysis Patterns
[Examples of analysis patterns]

## Glossary
[Terminology reference]
```

## Both Files: Schema Access Examples

Include clear examples in both files for accessing schemas:

```bash
# In llms.txt
cat >> "$llms_txt_file" << 'EOF'
## Schema Access

To view table schemas:

```bash
# Get a specific table schema
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/TABLE_NAME.sql

# Search within a schema for details
curl -s https://raw.githubusercontent.com/ethpandaops/xatu-data/refs/heads/master/schema/clickhouse/default/beacon_api_eth_v1_events_block.sql | grep -A 50 "CREATE TABLE"
```
EOF
```

## Next Steps

1. Refactor the `generate-llmstxt.sh` script to follow the structure outlined above
2. Add functionality to generate both files with appropriate content detail levels
3. Enhance warning sections about partition filtering requirements
4. Add more comprehensive examples, especially for Parquet file access
5. Incorporate full table schemas in the llms-full.txt file
6. Test the output files with LLMs to ensure they provide clear guidance

## Expected Outcomes

- A more maintainable and modular generation script
- Two well-structured output files for different detail needs
- Clearer warnings about performance optimization
- More comprehensive examples for different access methods
- Complete schema information in the full version
- Better structured content for LLM consumption