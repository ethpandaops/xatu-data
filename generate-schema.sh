#!/bin/bash

set -e

source ./scripts/date.sh

# Configuration
clickhouse_host=${CLICKHOUSE_HOST:-http://localhost:8123}
hugo=${HUGO:-false}
config_file=${CONFIG:-config.yaml}
main_schema_file=${SCHEMA:-SCHEMA.md}

# Availability overrides
availability_overrides_keys=("public" "ethpandaops-clickhouse")
availability_overrides_values=("Public Parquet Files" "EthPandaOps Clickhouse")

# Logging function
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# Generate schema for a single table
generate_table_schema() {
    set -e;
    local table_name=$1
    local table_config=$(yq e ".tables[] | select(.name == \"$table_name\")" "$config_file")
    local database=$(echo "$table_config" | yq e '.database' -)
    local quirks=$(echo "$table_config" | yq e '.quirks' -)
    local hourly_partitioning=$(echo "$table_config" | yq e '.hourly_partitioning' -)
    local date_partition_column=$(echo "$table_config" | yq e '.date_partition_column' -)
    local interval="daily"
    local example_date=$(date -d "1 week ago" +"%Y/%-m/%-d")
    local formated_url="https://data.ethpandaops.io/xatu/NETWORK/databases/${database}/${table_name}/YYYY/MM/DD.parquet"
    local example_url="https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${example_date}.parquet"
    
    if [ "$hourly_partitioning" = true ]; then
        interval="hourly"
        formated_url="https://data.ethpandaops.io/xatu/NETWORK/databases/${database}/${table_name}/YYYY/MM/DD/HH.parquet"
        example_url="https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${example_date}/0.parquet"
    fi
    
    local table_description=$(curl -s "$clickhouse_host" --data "SELECT comment FROM system.tables WHERE table = '$table_name' FORMAT TabSeparated")
    local table_engine=$(curl -s "$clickhouse_host" --data "SELECT engine FROM system.tables WHERE table = '${table_name}_local' FORMAT TabSeparated")
    local should_use_final=false
    if [[ "$table_engine" =~ "Replacing" ]]; then
        should_use_final=true
    fi

    local excluded_columns=$(echo "$table_config" | yq e '.excluded_columns[]' - | tr '\n' ' ')
    local schema=$(curl -s "$clickhouse_host" --data "SELECT name, type, comment FROM system.columns WHERE table = '$table_name' FORMAT TabSeparated")

    echo "## $table_name"
    if [ "$hugo" = true ]; then
        echo "{{< lead >}} $table_description {{< /lead >}}"
    else
        echo ""
        echo "$table_description"
        echo ""
    fi

    if [ ! -z "$quirks" ] && [ "$quirks" != "null" ]; then
        if [ "$hugo" = true ]; then
            echo "{{<alert >}} $quirks {{< /alert >}}"
        else
            echo ""
            echo "> $quirks"
            echo ""
        fi
    fi
    echo ""
    echo "### Availability"
    echo "Data is partitioned **$interval** on **$date_partition_column** for the following networks:"
    echo ""
    echo "$table_config" | yq e '.networks | to_entries[] | "**" + .key + "**: `" + .value.from + "` to `" + .value.to + "`"' - | while read -r network_info; do
        echo "- $network_info"
    done
    echo ""
    echo "### Example - Parquet file"
    echo ""
    echo "> $formated_url"
    echo ""
    echo "\`\`\`bash"
    echo "docker run --rm -it clickhouse/clickhouse-server clickhouse local --query \\"
    echo " \"SELECT * \\"
    echo " FROM url('$example_url', 'Parquet') \\"
    echo " LIMIT 10\""
    echo "\`\`\`"
    echo ""
    echo "### Example - Your Clickhouse"
    if [ "$should_use_final" = true ]; then
        echo ""
        echo "> **Note:** [\`FINAL\`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table"
    fi
    echo ""
    echo "\`\`\`bash"
    echo "docker run --rm -it --net host \\"
    echo "    clickhouse/clickhouse-server clickhouse client -q \\"
    echo "    \"SELECT \\"
    echo "        * \\"
    echo "    FROM ${database}.${table_name}$(if [ "$should_use_final" = true ]; then echo " FINAL"; fi) \\"
    echo "    WHERE \\"
    echo "        $date_partition_column >= NOW() - INTERVAL '1 HOUR' \\"
    echo "    LIMIT 10\""
    echo ""
    echo "\`\`\`"

    echo "### Example - EthPandaOps Clickhouse"
    if [ "$should_use_final" = true ]; then
        echo ""
        echo "> **Note:** [\`FINAL\`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table"
    fi
    echo ""
    echo "\`\`\`bash"
    echo "curl -G \"https://clickhouse.analytics.production.platform.ethpandaops.io\" \\"
    echo "-u \"\$CLICKHOUSE_USER:\$CLICKHOUSE_PASSWORD\" \\"
    echo "    --data-urlencode \"query= \\"
    echo "    SELECT \\"
    echo "        * \\"
    echo "    FROM ${database}.${table_name}$(if [ "$should_use_final" = true ]; then echo " FINAL"; fi) \\"
    echo "    WHERE \\"
    echo "        $date_partition_column >= NOW() - INTERVAL '1 HOUR' \\"
    echo "    LIMIT 3 \\"
    echo "    FORMAT Pretty \\"
    echo "    \""
    echo "\`\`\`"
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
}

# Generate schema for each dataset
generate_dataset_schema() {
    local dataset_name=$1
    local dataset_config=$(yq e ".datasets[] | select(.name == \"$dataset_name\")" "$config_file")
    local dataset_description=$(echo "$dataset_config" | yq e '.description' -)
    local table_prefix=$(echo "$dataset_config" | yq e '.tables.prefix' -)
    local schema_file="schema/${table_prefix}.md"

    log "Generating schema for dataset: $dataset_name"

    # Start writing to the schema file
    {
        echo "# $dataset_name"
        echo
        echo "$dataset_description"
        echo
        echo "## Availability"
        echo "$dataset_config" | yq e '.availability[]' - | while read -r availability; do
            echo "- $availability"
        done
        echo
        echo "## Tables"
        echo
        echo "<!-- schema_toc_start -->"
        for table_name in $(yq e '.tables[] | select(.name | test("^'"$table_prefix"'")) | .name' "$config_file"); do
            echo "- [\`$table_name\`](#$(echo "$table_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g'))"
        done
        echo "<!-- schema_toc_end -->"
        echo
        echo "<!-- schema_start -->"
        for table_name in $(yq e '.tables[] | select(.name | test("^'"$table_prefix"'")) | .name' "$config_file"); do
            table_config=$(yq e '.tables[] | select(.name == "'"$table_name"'")' "$config_file")
            generate_table_schema "$table_name" "$table_config"
        done
        echo "<!-- schema_end -->"
    } > "$schema_file"
}

# Generate schemas for all datasets
yq e '.datasets[].name' "$config_file" | while read -r dataset_name; do
    echo "Generating schema for dataset: $dataset_name"
    generate_dataset_schema "$dataset_name"
    echo "Schema generation completed for $dataset_name"
done


# Update main schema file
log "Updating main schema file $main_schema_file"

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
        dataset_link="./schema/$dataset_prefix.md"
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


# Generate the new schema_toc content
new_schema_toc=$(generate_datasets_table)

# Replace the content between the markers directly
sed -i '' -e "/<!-- schema_toc_start -->/,/<!-- schema_toc_end -->/{//!d;}" "$main_schema_file"
sed -i '' -e "/<!-- schema_toc_start -->/r /dev/stdin" "$main_schema_file" <<< "$new_schema_toc"

log "Schema update completed"
