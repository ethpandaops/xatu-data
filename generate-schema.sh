#!/bin/bash

set -e

source ./scripts/date.sh

# Configuration
clickhouse_host=${CLICKHOUSE_HOST:-http://localhost:8123}
mode=${MODE:-}
config_file=${CONFIG:-config.yaml}
main_schema_file=${SCHEMA:-SCHEMA.md}

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
    local table_config=$(yq e ".tables[] | select(.name == \"$table_name\")" "$config_file")
    local database=$(echo "$table_config" | yq e '.database' -)
    local quirks=$(echo "$table_config" | yq e '.quirks' -)
    local partition_column=$(echo "$table_config" | yq e '.partitioning.column' -)
    local partition_type=$(echo "$table_config" | yq e '.partitioning.type' -)
    local partition_interval=$(echo "$table_config" | yq e '.partitioning.interval' -)
    local mainnet_to_date=$(echo "$table_config" | yq e '.networks.mainnet.to' -)
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
        example_url="https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/{50..51}${zeros}.parquet"
    fi

    local table_description=$(curl -s "$clickhouse_host" --data "SELECT comment FROM system.tables WHERE table = '${table_name}_local' FORMAT TabSeparated")
    local table_engine=$(curl -s "$clickhouse_host" --data "SELECT engine FROM system.tables WHERE table = '${table_name}_local' FORMAT TabSeparated")
    local should_use_final=false
    if [[ "$table_engine" =~ "Replacing" ]]; then
        should_use_final=true
    fi

    local excluded_columns=$(echo "$table_config" | yq e '.excluded_columns[]' - | tr '\n' ' ')
    local schema=$(curl -s "$clickhouse_host" --data "SELECT name, type, comment FROM system.columns WHERE table = '$table_name' FORMAT TabSeparated")

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
    if [ "$partition_type" = "datetime" ]; then
        echo "Data is partitioned **$partition_interval** on **$partition_column** for the following networks:"
    elif [ "$partition_type" = "integer" ]; then
        echo "Data is partitioned in chunks of **$partition_interval** on **$partition_column** for the following networks:"
    fi
    echo ""
    echo "$table_config" | yq e '.networks | to_entries[] | "**" + .key + "**: `" + .value.from + "` to `" + .value.to + "`"' - | while read -r network_info; do
        echo "- $network_info"
    done
    echo ""
    echo "### Examples"
    echo ""
    echo "<details>"
    echo "<summary>Parquet file</summary>"
    echo ""
    echo "> $formated_url"
    if [ "$partition_type" = "integer" ]; then
        echo ""
        echo "To find the parquet file with the \`${partition_column}\` you're looking for, you need the correct \`CHUNK_NUMBER\` which is in intervals of \`${partition_interval}\`. Take the following examples;"
        echo ""
        echo "Contains \`${partition_column}\` between \`0\` and \`$(( partition_interval - 1 ))\`:"
        echo "> https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/0.parquet"
        echo ""
        echo "Contains \`${partition_column}\` between \`$(( partition_interval * 50 ))\` and \`$(( partition_interval * 50 + partition_interval - 1 ))\`:"
        echo "> https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/50${zeros}.parquet"
        echo ""
        echo "Contains \`${partition_column}\` between \`$(( partition_interval * 1000 ))\` and \`$(( partition_interval * 1000 + 2 * partition_interval - 1 ))\`:"
        echo "> https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${partition_interval}/{1000..1001}${zeros}.parquet"
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
    echo "    FROM ${database}.${table_name}$(if [ "$should_use_final" = true ]; then echo " FINAL"; fi)"
    echo "    WHERE"
    if [ "$partition_type" = "datetime" ]; then
        echo "        $partition_column >= NOW() - INTERVAL '1 HOUR'"
    elif [ "$partition_type" = "integer" ]; then
        echo "        $partition_column BETWEEN $(( partition_interval * 50 )) AND $(( partition_interval * 51 ))"
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
    echo "    FROM ${database}.${table_name}$(if [ "$should_use_final" = true ]; then echo " FINAL"; fi)"
    echo "    WHERE"
    if [ "$partition_type" = "datetime" ]; then
        echo "        $partition_column >= NOW() - INTERVAL '1 HOUR'"
    elif [ "$partition_type" = "integer" ]; then
        echo "        $partition_column BETWEEN $(( partition_interval * 50 )) AND $(( partition_interval * 51 ))"
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
    mkdir -p "./schema/clickhouse/${database}"

    # Get the _local table definition
    local sql_ddl_local=$(curl -s "$clickhouse_host" --data "SHOW CREATE TABLE ${database}.${table_name}_local")

    # Replace escaped newlines with actual newlines and fix escaped quotes
    sql_ddl_local=$(echo "$sql_ddl_local" | sed 's/\\n/\n/g' | sed "s/\\\\'/'/g")

    # Save the _local table definition
    echo "$sql_ddl_local" > "./schema/clickhouse/${database}/${table_name}_local.sql"

    # Get the distributed table definition
    local sql_ddl_distributed=$(curl -s "$clickhouse_host" --data "SHOW CREATE TABLE ${database}.${table_name}")

    # Replace escaped newlines with actual newlines and fix escaped quotes
    sql_ddl_distributed=$(echo "$sql_ddl_distributed" | sed 's/\\n/\n/g' | sed "s/\\\\'/'/g")

    # Save the distributed table definition
    echo "$sql_ddl_distributed" > "./schema/clickhouse/${database}/${table_name}.sql"
}

# Generate schema for each dataset
generate_dataset_schema() {
    local dataset_name=$1
    local dataset_config=$(yq e ".datasets[] | select(.name == \"$dataset_name\")" "$config_file")
    local dataset_description=$(echo "$dataset_config" | yq e '.description' -)
    local table_prefix=$(echo "$dataset_config" | yq e '.tables.prefix' -)
    local additional_info=$(echo "$dataset_config" | yq e '.additional_info' -)

    # Start writing to the schema file
    if [ "$mode" = "all" ]; then
        echo "# $table_prefix"
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
    for table_name in $(yq e '.tables[] | select(.name | test("^'"$table_prefix"'")) | .name' "$config_file"); do
        echo "- [\`$table_name\`](#$(echo "$table_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g'))"
    done
    echo "<!-- schema_toc_end -->"
    echo
    echo "<!-- schema_start -->"
    for table_name in $(yq e '.tables[] | select(.name | test("^'"$table_prefix"'")) | .name' "$config_file"); do
        table_config=$(yq e '.tables[] | select(.name == "'"$table_name"'")' "$config_file")
        generate_table_schema "$table_name" "$table_config"
    done
    echo "<!-- schema_end -->"
}

# Remove all existing SQL files
rm -rf "./schema/clickhouse/"


# Generate schemas for all datasets
yq e '.datasets[].name' "$config_file" | while read -r dataset_name; do
    echo "Generating schema for dataset: $dataset_name"
    dataset_config=$(yq e ".datasets[] | select(.name == \"$dataset_name\")" "$config_file")
    table_prefix=$(echo "$dataset_config" | yq e '.tables.prefix' -)
    generate_dataset_schema "$dataset_name" > "schema/${table_prefix}.md"
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
        if [ "${mode}" = "hugo" ]; then
            dataset_link="./${dataset_prefix}"
        fi
        if [ "${mode}" = "docusaurus" ]; then
            dataset_link="/data/xatu/schema/${dataset_prefix}/"
        fi
        if [ "${mode}" = "all" ]; then
            dataset_link="#${dataset_prefix}"
        fi
        if [ "${mode}" = "" ]; then
            dataset_link="./schema/$dataset_prefix.md"
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
