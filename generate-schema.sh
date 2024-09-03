#!/bin/bash

source ./scripts/date.sh

# Configuration
clickhouse_host=${CLICKHOUSE_HOST:-http://localhost:8123}
hugo=${HUGO:-false}
config_file=${CONFIG:-config.yaml}
schema_file=${SCHEMA:-SCHEMA.md}

# Temporary files
temp_schema_file=$(mktemp)
temp_toc_readme=$(mktemp)
temp_schema_readme=$(mktemp)

# Generate the schema markdown
generate_schema() {
    yq e '.tables[]' "$config_file" -o=json | jq -c '.' | while read -r table_config; do
        table_name=$(echo "$table_config" | jq -r '.name')
        database=$(echo "$table_config" | jq -r '.database')
        quirks=$(echo "$table_config" | jq -r '.quirks')
        hourly_partitioning=$(echo "$table_config" | jq -r '.hourly_partitioning')
        date_partition_column=$(echo "$table_config" | jq -r '.date_partition_column')
        interval="daily"
        # get today's date - 1 week as 2024/3/20
        example_date=$(date -d "1 week ago" +"%Y/%-m/%-d")
        formated_url="https://data.ethpandaops.io/xatu/NETWORK/databases/${database}/${table_name}/YYYY/MM/DD.parquet"
        example_url="https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${example_date}.parquet"
        if [ "$hourly_partitioning" = true ]; then
            interval="hourly"
            formated_url="https://data.ethpandaops.io/xatu/NETWORK/databases/${database}/${table_name}/YYYY/MM/DD/HH.parquet"
            example_url="https://data.ethpandaops.io/xatu/mainnet/databases/${database}/${table_name}/${example_date}/0.parquet"
        fi
        table_description=$(curl -s "$clickhouse_host" --data "SELECT comment FROM system.tables WHERE table = '$table_name' FORMAT TabSeparated")

        table_engine=$(curl -s "$clickhouse_host" --data "SELECT engine FROM system.tables WHERE table = '${table_name}_local' FORMAT TabSeparated")
        should_use_final=false
        # check if table engine contains Replacing
        if [[ "$table_engine" =~ "Replacing" ]]; then
            should_use_final=true
        fi

        excluded_columns=$(echo "$table_config" | jq -r '.excluded_columns[]' | tr '\n' ' ')
        
        schema=$(curl -s "$clickhouse_host" --data "SELECT name, type, comment FROM system.columns WHERE table = '$table_name' FORMAT TabSeparated")

        echo "## $table_name"
        # check if hugo is set
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
        echo "$table_config" | jq -r '.networks | to_entries[] | "**" + .key + "**: `" + .value.from + "` to `" + .value.to + "`"' | while read -r network_info; do
            echo "- $network_info"
        done
        echo ""
        echo "### Example - parquet file"
        echo ""
        echo "> $formated_url"
        echo ""
        echo "\`\`\`bash"
        echo "docker run --rm -it clickhouse/clickhouse-server clickhouse local --query -q \"SELECT * FROM url('$example_url', 'Parquet') LIMIT 10\""
        echo "\`\`\`"
        echo ""
        echo "### Example - clickhouse table"
        if [ "$should_use_final" = true ]; then
            echo ""
            echo "> **Note:** [\`FINAL\`](https://clickhouse.com/docs/en/sql-reference/statements/select/from#final-modifier) should be used when querying this table"
        fi
        echo ""
        echo "\`\`\`bash"
        echo "docker run --rm -it --net host clickhouse/clickhouse-server clickhouse client -q \"SELECT * FROM ${database}.${table_name}$(if [ "$should_use_final" = true ]; then echo " FINAL"; fi) WHERE $date_partition_column >= NOW() - INTERVAL '1 HOUR' LIMIT 10\""
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
    done
}

# Generate schema markdown and store it in a temporary file
generate_schema > "$temp_schema_file"

# Generate the updated Schema TOC
schema_toc=$(yq e '.tables[]' "$config_file" -o=json | jq -r '.name' | while read -r table_name; do
    echo "- [\`$table_name\`](#${table_name// /-})"
done)

# update ToC
{
    awk '/<!-- schema_toc_start -->/{exit}1' "$schema_file"
    
    echo "<!-- schema_toc_start -->"
    echo "$schema_toc"
    echo "<!-- schema_toc_end -->"

    awk '/<!-- schema_toc_end -->/{flag=1}flag' "$schema_file" | tail -n +2
} > "$temp_toc_readme"

# update schema
{
    awk '/<!-- schema_start -->/{exit}1' "$temp_toc_readme"
    
    echo "<!-- schema_start -->"
    cat "$temp_schema_file"
    echo "<!-- schema_end -->"
    
    awk '/<!-- schema_end -->/{flag=1}flag' "$temp_toc_readme" | tail -n +2
} > "$temp_schema_readme"

# Replace the original README with the new content
mv "$temp_schema_readme" "$schema_file"

# Cleanup
rm "$temp_schema_file"
rm "$temp_toc_readme"
