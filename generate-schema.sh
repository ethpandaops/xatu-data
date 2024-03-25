#!/bin/bash

# Configuration
clickhouse_host=${CLICKHOUSE_HOST:-http://localhost:8123}
hugo=${HUGO:-false}
config_file=${CONFIG:-config.yaml}
readme_file=${README:-README.md}

# Temporary files
temp_schema_file=$(mktemp)
temp_toc_readme=$(mktemp)
temp_schema_readme=$(mktemp)

# Generate the schema markdown
generate_schema() {
    yq e '.tables[]' "$config_file" -o=json | jq -c '.' | while read -r table_config; do
        table_name=$(echo "$table_config" | jq -r '.name')
        quirks=$(echo "$table_config" | jq -r '.quirks')
        interval=$(echo "$table_config" | jq -r '.interval')
        table_description=$(curl -s "$clickhouse_host" --data "SELECT comment FROM system.tables WHERE table = '$table_name' FORMAT TabSeparated")

        excluded_columns=$(echo "$table_config" | jq -r '.excluded_columns[]' | tr '\n' ' ')
        
        schema=$(curl -s "$clickhouse_host" --data "SELECT name, type, comment FROM system.columns WHERE table = '$table_name' FORMAT TabSeparated")

        echo "### $table_name"
        # check if hugo is set
        if [ "$hugo" = true ]; then
            echo "{{< lead >}} $table_description {{< /lead >}}"
        else
            echo "$table_description"
        fi

        if [ ! -z "$quirks" ] && [ "$quirks" != "null" ]; then
            if [ "$hugo" = true ]; then
                echo "{{<alert >}} $quirks {{< /alert >}}"
            else
                echo "> $quirks"
            fi
        fi
        echo ""
        echo "#### Availability"
        echo "Data is available **$interval** on the following networks;"
        echo "$table_config" | jq -r '.networks | to_entries[] | "**" + .key + "**: `" + .value.from + "` to `" + .value.to + "`"' | while read -r network_info; do
            echo "- $network_info"
        done
        echo ""
        echo "#### Columns"
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

# Generate the updated Tables TOC
schema_toc=$(yq e '.tables[]' "$config_file" -o=json | jq -r '.name' | while read -r table_name; do
    echo "  - [$table_name](#${table_name// /-})"
done)

# update ToC
{
    awk '/<!-- table_toc_start -->/{exit}1' "$readme_file"
    
    echo "- [Tables](#tables)<!-- table_toc_start -->"
    echo "$schema_toc"
    echo "<!-- table_toc_end -->"

    awk '/<!-- table_toc_end -->/{flag=1}flag' "$readme_file" | tail -n +2
} > "$temp_toc_readme"

# update schema
{
    awk '/<!-- table_start -->/{exit}1' "$temp_toc_readme"
    
    echo "<!-- table_start -->"
    cat "$temp_schema_file"
    echo "<!-- table_end -->"
    
    awk '/<!-- table_end -->/{flag=1}flag' "$temp_toc_readme" | tail -n +2
} > "$temp_schema_readme"

# Replace the original README with the new content
mv "$temp_schema_readme" "$readme_file"

# Cleanup
rm "$temp_schema_file"
rm "$temp_toc_readme"
