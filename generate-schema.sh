#!/bin/bash

# Configuration
config_file="config.yaml"
clickhouse_host="http://localhost:8123"
readme_file="README.md"

# Temporary files
temp_schema_file=$(mktemp)
temp_readme=$(mktemp)

# Generate the schema markdown
generate_schema() {
    echo "## Schema"
    yq e '.tables[]' "$config_file" -o=json | jq -c '.' | while read -r table_config; do
        table_name=$(echo "$table_config" | jq -r '.name')
        table_description=$(curl -s "$clickhouse_host" --data "SELECT comment FROM system.tables WHERE table = '$table_name' FORMAT TabSeparated")

        excluded_columns=$(echo "$table_config" | jq -r '.excluded_columns[]' | tr '\n' ' ')
        
        schema=$(curl -s "$clickhouse_host" --data "SELECT name, type, comment FROM system.columns WHERE table = '$table_name' FORMAT TabSeparated")

        networks=$(echo "$table_config" | jq -r '.networks[]')

        echo "### $table_name"
        echo ""
        echo "{{< keywordList >}}"
        if [ ! -z "$networks" ]; then
            for network in $networks; do
                echo -n "{{< keyword >}} $network {{< /keyword >}}"
            done
        fi
        echo ""
        echo "{{< /keywordList >}}"
        echo ""
        echo "{{< lead >}} $table_description {{< /lead >}}"
        echo ""
        echo "| Column | Type | Description |"
        echo "|--------|------|-------------|"
        
        echo "$schema" | while IFS=$'\t' read -r name type comment; do
            if [[ ! " $excluded_columns " =~ " $name " ]]; then
                echo "| **$name** | \`$type\` | *$comment* |"
            fi
        done
        
        echo
    done
}

# Generate schema markdown
generate_schema > "$temp_schema_file"

# Rebuild the README to properly place the ToC and Schema
{
    # Preserve content before the existing ToC
    awk '/## Table of contents/{exit}1' "$readme_file"
    
    # Generate the updated ToC
    echo "## Table of contents"
    echo "- [How to use](#how-to-use)"
    echo "- [Schema](#schema)"
    yq e '.tables[]' "$config_file" -o=json | jq -r '.name' | while read -r table_name; do
        echo "  - [$table_name](#${table_name// /-})"
    done
    echo "- [Credits](#credits)"
    echo

    # Preserve the "How to use" section or any content up to "## Schema"
    awk '/## How to use/,/## Schema/{if(!/## Schema/)print}' "$readme_file"
    echo

    # Insert the Schema Section
    cat "$temp_schema_file"

    # Preserve content after "## Schema"
    awk '/## Schema/{flag=1;next}/##/{flag=0}flag' "$readme_file" | tail -n +2
    
    # Ensure "Credits" and any content afterwards are preserved
    awk '/## Credits/{flag=1}flag' "$readme_file"
} > "$temp_readme"

# Replace the original README with the new content
mv "$temp_readme" "$readme_file"

# Cleanup
rm "$temp_schema_file"
