#!/bin/bash

set -e

source ./scripts/date.sh

# Configuration
clickhouse_host=${CLICKHOUSE_HOST:-http://localhost:8125}
cbt_clickhouse_host=${CBT_CLICKHOUSE_HOST:-http://localhost:8123}
clickhouse_user=${CLICKHOUSE_USER:-default}
clickhouse_password=${CLICKHOUSE_PASSWORD:-supersecret}
mode=${MODE:-}
config_file=${CONFIG:-config.yaml}
main_schema_file=${SCHEMA:-SCHEMA.md}

# Build curl auth args if credentials are provided
clickhouse_curl_auth=""
if [ -n "$clickhouse_password" ]; then
    clickhouse_curl_auth="-u ${clickhouse_user}:${clickhouse_password}"
fi

if [ "$mode" != "" ]; then
    echo "Running in $mode mode"
else
    echo "Running in default mode"
fi

temp_schema_file=$(mktemp)

# Availability overrides
availability_overrides_keys=("public" "ethpandaops-clickhouse")
availability_overrides_values=("Public Parquet Files" "EthPandaOps Clickhouse")


# Logging function
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# Function to get availability override
get_availability_override() {
    local key="$1"
    for i in "${!availability_overrides_keys[@]}"; do
        if [[ "${availability_overrides_keys[$i]}" == "$key" ]]; then
            echo "${availability_overrides_values[$i]}"
            return
        fi
    done
    echo "$key"
}

# Generate schema for a single table
generate_table_schema() {
    set -e;
    local table_name=$1
    local table_config="$2"

    # If table_config not provided, try to get it from config file
    if [ -z "$table_config" ] || [ "$table_config" = "" ]; then
        table_config=$(yq e ".tables[] | select(.name == \"$table_name\")" "$config_file")
    fi
    local database=$(echo "$table_config" | yq e '.database' -)
    local quirks=$(echo "$table_config" | yq e '.quirks' -)
    local is_cbt_table=$(echo "$table_config" | yq e '.cbt_table // false' -)
    local partition_column=$(echo "$table_config" | yq e '.partitioning.column' -)
    local partition_type=$(echo "$table_config" | yq e '.partitioning.type' -)
    local partition_interval=$(echo "$table_config" | yq e '.partitioning.interval' -)
    local mainnet_to_date=$(echo "$table_config" | yq e '.networks.mainnet.to' -)
    local mainnet_from=$(echo "$table_config" | yq e '.networks.mainnet.from' -)
    local formated_url=""
    local example_url=""

    if [ "$partition_type" = "datetime" ]; then
        # Use mainnet 'to' date if available, otherwise fall back to "1 week ago"
        if [ -n "$mainnet_to_date" ] && [ "$mainnet_to_date" != "null" ]; then
            local example_date=$(date -d "$mainnet_to_date" +"%Y/%-m/%-d")
        else
            local example_date=$(date -d "1 week ago" +"%Y/%-m/%-d")
        fi
        if [ "$partition_interval" = "daily" ]; then
            formated_url="https://data.ethpandaops.io/xatu/NETWORK/databases/${database}/${table_name}/YYYY/MM/DD.parquet"
            example_url="https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${example_date}.parquet"
        elif [ "$partition_interval" = "hourly" ]; then
            formated_url="https://data.ethpandaops.io/xatu/NETWORK/databases/${database}/${table_name}/YYYY/M/D/H.parquet"
            example_url="https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${example_date}/0.parquet"
        fi
    fi

    if [ "$partition_type" = "integer" ]; then
        formated_url="https://data.ethpandaops.io/xatu/NETWORK/databases/${database}/${table_name}/${partition_interval}/CHUNK_NUMBER.parquet"
        # Calculate the number of zeros based on partition_interval
        local zeros_count=$((${#partition_interval} - 1))
        local zeros=$(printf '%0*d' $zeros_count 0)

        # Use mainnet_from if available and greater than 0, otherwise default to 50..51
        if [ -n "$mainnet_from" ] && [ "$mainnet_from" != "null" ] && [ "$mainnet_from" -gt 0 ]; then
            # Calculate the chunk numbers based on mainnet_from
            local start_chunk=$(( mainnet_from / partition_interval ))
            local end_chunk=$(( start_chunk + 1 ))
            example_url="https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/{${start_chunk}..${end_chunk}}${zeros}.parquet"
        else
            example_url="https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/{50..51}${zeros}.parquet"
        fi
    fi

    # For CBT tables, query from mainnet database (use mainnet as reference)
    if [ "$is_cbt_table" = "true" ]; then
        local actual_database="mainnet"  # Always query from mainnet for CBT tables
        local table_description=$(curl -s $clickhouse_curl_auth "$cbt_clickhouse_host" --data "SELECT comment FROM system.tables WHERE database = '${actual_database}' AND name = '${table_name}_local' FORMAT TabSeparated")
        local table_engine=$(curl -s $clickhouse_curl_auth "$cbt_clickhouse_host" --data "SELECT engine FROM system.tables WHERE database = '${actual_database}' AND name = '${table_name}_local' FORMAT TabSeparated")
        local partition_key=$(curl -s $clickhouse_curl_auth "$cbt_clickhouse_host" --data "SELECT partition_key FROM system.tables WHERE database = '${actual_database}' AND name = '${table_name}_local' FORMAT TabSeparated")
    else
        local table_description=$(curl -s $clickhouse_curl_auth "$clickhouse_host" --data "SELECT comment FROM system.tables WHERE table = '${table_name}_local' FORMAT TabSeparated")
        local table_engine=$(curl -s $clickhouse_curl_auth "$clickhouse_host" --data "SELECT engine FROM system.tables WHERE table = '${table_name}_local' FORMAT TabSeparated")
    fi

    local should_use_final=false
    if [[ "$table_engine" =~ "Replacing" ]]; then
        should_use_final=true
    fi

    local excluded_columns=$(echo "$table_config" | yq e '.excluded_columns[]' - | tr '\n' ' ')

    # For CBT tables, query schema from mainnet database
    if [ "$is_cbt_table" = "true" ]; then
        local actual_database="mainnet"  # Always query from mainnet for CBT tables
        local schema=$(curl -s $clickhouse_curl_auth "$cbt_clickhouse_host" --data "SELECT name, type, comment FROM system.columns WHERE database = '${actual_database}' AND table = '$table_name' FORMAT TabSeparated")
    else
        local schema=$(curl -s $clickhouse_curl_auth "$clickhouse_host" --data "SELECT name, type, comment FROM system.columns WHERE database = '${database}' AND table = '$table_name' FORMAT TabSeparated")
    fi

    echo "## $table_name"
    echo ""
    echo "$table_description"
    echo ""

    if [ ! -z "$quirks" ] && [ "$quirks" != "null" ]; then
        echo ""
        echo "> $quirks"
        echo ""
    fi
    echo "### Availability"
    if [ "$is_cbt_table" = "true" ]; then
        # CBT tables use network-specific databases
        if [ ! -z "$partition_key" ] && [ "$partition_key" != "tuple()" ]; then
            echo "Data is partitioned by **$partition_key**."
        else
            echo "This table has no partitioning."
        fi
        echo ""
        echo "Available in the following network-specific databases:"
        echo ""
        echo "$table_config" | yq e '.networks | to_entries[] | "**" + .key + "**: `" + .key + "." + "'"$table_name"'" + "`"' - | while read -r network_info; do
            echo "- $network_info"
        done
    else
        if [ "$partition_type" = "datetime" ]; then
            echo "Data is partitioned **$partition_interval** on **$partition_column** for the following networks:"
        elif [ "$partition_type" = "integer" ]; then
            echo "Data is partitioned in chunks of **$partition_interval** on **$partition_column** for the following networks:"
        fi
        echo ""
        echo "$table_config" | yq e '.networks | to_entries[] | "**" + .key + "**: `" + .value.from + "` to `" + .value.to + "`"' - | while read -r network_info; do
            echo "- $network_info"
        done
    fi
    echo ""
    echo "### Examples"
    echo ""
    if [ "$is_cbt_table" != "true" ]; then
        echo "<details>"
        echo "<summary>Parquet file</summary>"
    echo ""
    echo "> $formated_url"
    if [ "$partition_type" = "integer" ]; then
        echo ""
        echo "To find the parquet file with the \`${partition_column}\` you're looking for, you need the correct \`CHUNK_NUMBER\` which is in intervals of \`${partition_interval}\`. Take the following examples;"
        echo ""

        # Use mainnet_from if available and greater than 0 for the middle example
        if [ -n "$mainnet_from" ] && [ "$mainnet_from" != "null" ] && [ "$mainnet_from" -gt 0 ]; then
            local example_chunk=$(( mainnet_from / partition_interval ))
            echo "Contains \`${partition_column}\` between \`0\` and \`$(( partition_interval - 1 ))\`:"
            echo "> https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/0.parquet"
            echo ""
            echo "Contains \`${partition_column}\` between \`$(( example_chunk * partition_interval ))\` and \`$(( example_chunk * partition_interval + partition_interval - 1 ))\`:"
            echo "> https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/${example_chunk}${zeros}.parquet"
            echo ""
            echo "Contains \`${partition_column}\` between \`$(( partition_interval * 1000 ))\` and \`$(( partition_interval * 1000 + 2 * partition_interval - 1 ))\`:"
            echo "> https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/{1000..1001}${zeros}.parquet"
        else
            echo "Contains \`${partition_column}\` between \`0\` and \`$(( partition_interval - 1 ))\`:"
            echo "> https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/0.parquet"
            echo ""
            echo "Contains \`${partition_column}\` between \`$(( partition_interval * 50 ))\` and \`$(( partition_interval * 50 + partition_interval - 1 ))\`:"
            echo "> https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/50${zeros}.parquet"
            echo ""
            echo "Contains \`${partition_column}\` between \`$(( partition_interval * 1000 ))\` and \`$(( partition_interval * 1000 + 2 * partition_interval - 1 ))\`:"
            echo "> https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/{1000..1001}${zeros}.parquet"
        fi
        echo ""
    fi
        echo "\`\`\`bash"
        echo "docker run --rm -it clickhouse/clickhouse-server clickhouse local --query --query=\"\"\""
        echo "    SELECT"
        echo "        *"
        echo "    FROM url('$example_url', 'Parquet')"
        echo "    LIMIT 10"
        echo "    FORMAT Pretty"
        echo "\"\"\""
        echo "\`\`\`"
        echo "</details>"
        echo ""
    fi

    echo "<details>"
    echo "<summary>Your Clickhouse</summary>"
    if [ "$should_use_final" = true ]; then
        echo ""
        echo "> **Note:** [\`FINAL\`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table"
    fi
    echo ""
    echo "\`\`\`bash"
    echo "docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client --query=\"\"\""
    echo "    SELECT"
    echo "        *"
    # For CBT tables, always use mainnet as example database
    local example_database="${database}"
    if [ "$is_cbt_table" = "true" ]; then
        example_database="mainnet"
    fi
    echo "    FROM ${example_database}.${table_name}$(if [ "$should_use_final" = true ]; then echo " FINAL"; fi)"
    if [ "$is_cbt_table" != "true" ]; then
        echo "    WHERE"
        if [ "$partition_type" = "datetime" ]; then
            echo "        $partition_column >= NOW() - INTERVAL '1 HOUR'"
        elif [ "$partition_type" = "integer" ]; then
            echo "        $partition_column BETWEEN $(( partition_interval * 50 )) AND $(( partition_interval * 51 ))"
        fi
    fi
    echo "    LIMIT 10"
    echo "    FORMAT Pretty"
    echo "\"\"\""
    echo "\`\`\`"

    echo "</details>"
    echo ""
    echo "<details>"
    echo "<summary>EthPandaOps Clickhouse</summary>"
    if [ "$should_use_final" = true ]; then
        echo ""
        echo "> **Note:** [\`FINAL\`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table"
    fi
    echo ""
    echo "\`\`\`bash"
    echo "echo \"\"\""
    echo "    SELECT"
    echo "        *"
    echo "    FROM ${example_database}.${table_name}$(if [ "$should_use_final" = true ]; then echo " FINAL"; fi)"
    if [ "$is_cbt_table" != "true" ]; then
        echo "    WHERE"
        if [ "$partition_type" = "datetime" ]; then
            echo "        $partition_column >= NOW() - INTERVAL '1 HOUR'"
        elif [ "$partition_type" = "integer" ]; then
            echo "        $partition_column BETWEEN $(( partition_interval * 50 )) AND $(( partition_interval * 51 ))"
        fi
    fi
    echo "    LIMIT 3"
    echo "    FORMAT Pretty"
    echo "\"\"\" | curl \"https://clickhouse.xatu.ethpandaops.io\" -u \"\$CLICKHOUSE_USER:\$CLICKHOUSE_PASSWORD\" --data-binary @-"
    echo "\`\`\`"
    echo "</details>"
    echo ""
    echo "### Columns"
    echo "| Name | Type | Description |"
    echo "|--------|------|-------------|"

    echo "$schema" | while IFS=$'\t' read -r name type comment; do
        if [[ ! " $excluded_columns " =~ " $name " ]]; then
            echo "| **$name** | \`$type\` | *$comment* |"
        fi
    done

    echo

    # Create directory for SQL files
    if [ "$is_cbt_table" = "true" ]; then
        # For CBT tables, generate SQL files for each network
        # Always query from mainnet and replace the database name for other networks
        local networks=$(echo "$table_config" | yq e '.networks | keys | .[]' -)
        local source_database="mainnet"

        # Get the base _local table definition from mainnet
        local base_sql_ddl_local=$(curl -s $clickhouse_curl_auth "$cbt_clickhouse_host" --data "SHOW CREATE TABLE ${source_database}.${table_name}_local")
        base_sql_ddl_local=$(echo "$base_sql_ddl_local" | sed 's/\\n/\n/g' | sed "s/\\\\'/'/g")

        # Get the base distributed table definition from mainnet
        local base_sql_ddl_distributed=$(curl -s $clickhouse_curl_auth "$cbt_clickhouse_host" --data "SHOW CREATE TABLE ${source_database}.${table_name}")
        base_sql_ddl_distributed=$(echo "$base_sql_ddl_distributed" | sed 's/\\n/\n/g' | sed "s/\\\\'/'/g")

        for network in $networks; do
            mkdir -p "./schema/clickhouse/${network}"

            # Replace database name in the SQL (both dot notation and quoted in ENGINE clause)
            local sql_ddl_local=$(echo "$base_sql_ddl_local" | sed "s/${source_database}\./${network}\./g" | sed "s/CREATE TABLE ${source_database}\./CREATE TABLE ${network}\./g" | sed "s/'${source_database}'/'${network}'/g")
            local sql_ddl_distributed=$(echo "$base_sql_ddl_distributed" | sed "s/${source_database}\./${network}\./g" | sed "s/CREATE TABLE ${source_database}\./CREATE TABLE ${network}\./g" | sed "s/'${source_database}'/'${network}'/g")

            # Save the _local table definition
            echo "$sql_ddl_local" > "./schema/clickhouse/${network}/${table_name}_local.sql"

            # Save the distributed table definition
            echo "$sql_ddl_distributed" > "./schema/clickhouse/${network}/${table_name}.sql"
        done
    else
        # For non-CBT tables, use the database name
        mkdir -p "./schema/clickhouse/${database}"

        # Get the _local table definition
        local sql_ddl_local=$(curl -s $clickhouse_curl_auth "$clickhouse_host" --data "SHOW CREATE TABLE ${database}.${table_name}_local")

        # Replace escaped newlines with actual newlines and fix escaped quotes
        sql_ddl_local=$(echo "$sql_ddl_local" | sed 's/\\n/\n/g' | sed "s/\\\\'/'/g")

        # Save the _local table definition
        echo "$sql_ddl_local" > "./schema/clickhouse/${database}/${table_name}_local.sql"

        # Get the distributed table definition
        local sql_ddl_distributed=$(curl -s $clickhouse_curl_auth "$clickhouse_host" --data "SHOW CREATE TABLE ${database}.${table_name}")

        # Replace escaped newlines with actual newlines and fix escaped quotes
        sql_ddl_distributed=$(echo "$sql_ddl_distributed" | sed 's/\\n/\n/g' | sed "s/\\\\'/'/g")

        # Save the distributed table definition
        echo "$sql_ddl_distributed" > "./schema/clickhouse/${database}/${table_name}.sql"
    fi
}

# Auto-discover CBT tables from ClickHouse
discover_cbt_tables() {
    local cbt_database="mainnet"

    # Get all tables from mainnet database, excluding views, admin tables, and schema_migrations
    local result=$(curl -s $clickhouse_curl_auth "$cbt_clickhouse_host" --data "
        SELECT name
        FROM system.tables
        WHERE database = '$cbt_database'
          AND engine NOT LIKE '%View%'
          AND name NOT LIKE 'admin_%'
          AND name NOT IN ('schema_migrations', 'schema_migrations_local')
          AND name NOT LIKE '%_local'
        ORDER BY name
        FORMAT TabSeparated
    ")

    # Filter to only valid table names (alphanumeric, underscore, no special chars)
    echo "$result" | grep -E '^[a-zA-Z_][a-zA-Z0-9_]*$'
}

# Build a dynamic config for a CBT table
build_cbt_table_config() {
    local table_name=$1
    local cbt_database="mainnet"

    # Get table description
    local description=$(curl -s $clickhouse_curl_auth "$cbt_clickhouse_host" --data "SELECT comment FROM system.tables WHERE database = '$cbt_database' AND name = '${table_name}_local' FORMAT TabSeparated")

    # Get ORDER BY clause
    local sorting_key=$(curl -s $clickhouse_curl_auth "$cbt_clickhouse_host" --data "SELECT sorting_key FROM system.tables WHERE database = '$cbt_database' AND name = '${table_name}_local' FORMAT TabSeparated")

    # Extract first column from ORDER BY (e.g., "slot_start_date_time, meta_network_name" -> "slot_start_date_time")
    local partition_column=$(echo "$sorting_key" | sed 's/,.*//; s/^[[:space:]]*//; s/[[:space:]]*$//')

    # Get column type to determine partition type
    local column_type=$(curl -s $clickhouse_curl_auth "$cbt_clickhouse_host" --data "SELECT type FROM system.columns WHERE database = '$cbt_database' AND table = '${table_name}_local' AND name = '$partition_column' FORMAT TabSeparated")

    # Determine partition type based on column type
    local partition_type="none"
    local partition_interval=""
    if [[ "$column_type" =~ ^DateTime || "$column_type" =~ ^Date ]]; then
        partition_type="datetime"
        partition_interval="daily"
    elif [[ "$column_type" =~ ^UInt || "$column_type" =~ ^Int ]]; then
        partition_type="integer"
        partition_interval="1000"
    fi

    # Build a YAML-like config structure that can be parsed
    cat <<EOF
name: "$table_name"
description: "$description"
database: "cbt"
cbt_table: true
partitioning:
  column: "$partition_column"
  type: "$partition_type"
  interval: "$partition_interval"
networks:
  mainnet: {available: true}
  sepolia: {available: true}
  holesky: {available: true}
  hoodi: {available: true}
tags: []
excluded_columns: []
quirks: null
EOF
}

# Generate schema for each dataset
generate_dataset_schema() {
    local dataset_name=$1
    local schema_filename=$2
    local dataset_config=$(yq e ".datasets[] | select(.name == \"$dataset_name\")" "$config_file")
    local dataset_description=$(echo "$dataset_config" | yq e '.description' -)
    local table_prefix=$(echo "$dataset_config" | yq e '.tables.prefix' -)
    local additional_info=$(echo "$dataset_config" | yq e '.additional_info' -)

    # Start writing to the schema file
    if [ "$mode" = "all" ]; then
        echo "# $schema_filename"
    fi
    echo
    echo "$dataset_description"
    echo
    if [ ! -z "$additional_info" ] && [ "$additional_info" != "null" ]; then
        echo ""
        echo "$additional_info"
        echo ""
    fi
    echo "## Availability"
    echo "$dataset_config" | yq e '.availability[]' - | while read -r availability; do
        echo "- $(get_availability_override $availability)"
    done
    echo
    echo "## Tables"
    echo
    echo "<!-- schema_toc_start -->"
    # Handle datasets with empty prefix (CBT tables) - auto-discover from ClickHouse
    if [ -z "$table_prefix" ] || [ "$table_prefix" = "null" ]; then
        for table_name in $(discover_cbt_tables); do
            # Skip invalid table names (e.g., from failed ClickHouse queries)
            if [[ "$table_name" =~ [/:] ]] || [[ -z "$table_name" ]]; then
                continue
            fi
            echo "- [\`$table_name\`](#$(echo "$table_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g'))"
        done
    else
        for table_name in $(yq e '.tables[] | select(.name | test("^'"$table_prefix"'")) | .name' "$config_file"); do
            echo "- [\`$table_name\`](#$(echo "$table_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g'))"
        done
    fi
    echo "<!-- schema_toc_end -->"
    echo
    echo "<!-- schema_start -->"
    # Handle datasets with empty prefix (CBT tables) - auto-discover from ClickHouse
    if [ -z "$table_prefix" ] || [ "$table_prefix" = "null" ]; then
        for table_name in $(discover_cbt_tables); do
            # Skip invalid table names (e.g., from failed ClickHouse queries)
            if [[ "$table_name" =~ [/:] ]] || [[ -z "$table_name" ]]; then
                log "WARNING: Skipping invalid table name: $table_name"
                continue
            fi
            # Build dynamic config for this CBT table
            table_config=$(build_cbt_table_config "$table_name")
            generate_table_schema "$table_name" "$table_config"
        done
    else
        for table_name in $(yq e '.tables[] | select(.name | test("^'"$table_prefix"'")) | .name' "$config_file"); do
            table_config=$(yq e '.tables[] | select(.name == "'"$table_name"'")' "$config_file")
            generate_table_schema "$table_name" "$table_config"
        done
    fi
    echo "<!-- schema_end -->"
}

# Remove all existing SQL files
rm -rf "./schema/clickhouse/"


# Generate schemas for all datasets
yq e '.datasets[].name' "$config_file" | while read -r dataset_name; do
    echo "Generating schema for dataset: $dataset_name"
    dataset_config=$(yq e ".datasets[] | select(.name == \"$dataset_name\")" "$config_file")
    table_prefix=$(echo "$dataset_config" | yq e '.tables.prefix' -)

    # Handle empty prefix (CBT dataset) - use a specific filename
    if [ -z "$table_prefix" ] || [ "$table_prefix" = "null" ]; then
        schema_filename="cbt"
    else
        schema_filename="$table_prefix"
    fi

    generate_dataset_schema "$dataset_name" "$schema_filename" > "schema/${schema_filename}.md"
    echo "Schema generation completed for $dataset_name"
done


# Generate the datasets table markdown
generate_datasets_table() {
    # Extract all unique availability options for datasets
    dataset_availability_options=$(yq e '.datasets[].availability[]' "$config_file" | sort | uniq)

    # Print the header row
    header_columns=$(for option in $dataset_availability_options; do echo -n "$(get_availability_override "$option")|"; done | sed 's/|$//')
    echo "| Dataset Name | Schema Link | Description | Prefix | $header_columns |"
    echo "|--------------|-------------|-------------|--------|$(echo "$dataset_availability_options" | sed 's/.*/---/g' | tr '\n' '|' | sed 's/|$//')|"

    # Print each dataset's availability
    yq e '.datasets[]' "$config_file" -o=json | jq -c '.' | while read -r dataset_config; do
        dataset_name=$(echo "$dataset_config" | jq -r '.name')
        dataset_description=$(echo "$dataset_config" | jq -r '.description')
        dataset_prefix=$(echo "$dataset_config" | jq -r '.tables.prefix')

        # Handle empty prefix (CBT dataset) - use 'cbt' as the filename
        if [ -z "$dataset_prefix" ] || [ "$dataset_prefix" = "null" ]; then
            schema_file="cbt"
        else
            schema_file="$dataset_prefix"
        fi

        if [ "${mode}" = "hugo" ]; then
            dataset_link="./${schema_file}"
        fi
        if [ "${mode}" = "docusaurus" ]; then
            dataset_link="/data/xatu/schema/${schema_file}/"
        fi
        if [ "${mode}" = "all" ]; then
            dataset_link="#${schema_file}"
        fi
        if [ "${mode}" = "" ]; then
            dataset_link="./schema/${schema_file}.md"
        fi
        echo -n "| **$dataset_name** | [Schema]($dataset_link) | $dataset_description | $dataset_prefix |"
        for option in $dataset_availability_options; do
            if echo "$dataset_config" | jq -r '.availability[]' | grep -q "$option"; then
                echo -n " ✅ |"
            else
                echo -n " ❌ |"
            fi
        done
        echo
    done
}

# Update main schema file
log "Updating main schema file $main_schema_file"

# Generate the new schema_toc content
schema_toc=$(generate_datasets_table)

echo "$schema_toc"

# update ToC
{
    awk '/<!-- schema_toc_start -->/{exit}1' "$main_schema_file"

    echo "<!-- schema_toc_start -->"
    echo "$schema_toc"
    echo "<!-- schema_toc_end -->"

    awk '/<!-- schema_toc_end -->/{flag=1}flag' "$main_schema_file" | tail -n +2
} > "$temp_schema_file"

if [ "${mode}" = "all" ]; then
    echo "Generating all schemas"

    temp_schema_file_all=$(mktemp)
    yq e '.datasets[].name' "$config_file" | while read -r dataset_name; do
        echo "Generating schema for dataset: $dataset_name"
        generate_dataset_schema "$dataset_name" >> "$temp_schema_file_all"
        echo "Schema generation completed for $dataset_name"
    done

    # Update Schema.all.md
    {
        awk '/<!-- schema_start -->/{exit}1' "$main_schema_file"

        echo "<!-- schema_start -->"
        cat "$temp_schema_file_all"
        echo "<!-- schema_end -->"

        awk '/<!-- schema_end -->/{flag=1}flag' "$main_schema_file" | tail -n +2
    } > "$temp_schema_file"
fi
# Replace the original README with the new content
mv "$temp_schema_file" "$main_schema_file"

log "Schema update completed"
