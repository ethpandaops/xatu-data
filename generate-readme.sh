#!/bin/bash

source ./scripts/date.sh

# Configuration
mode=${MODE:-}
config_file=${CONFIG:-config.yaml}
readme_file=${README:-README.md}

# Temporary files
temp_datasets_readme=$(mktemp)
temp_datasets_file=$(mktemp)

# Availability overrides
availability_overrides_keys=("public" "ethpandaops-clickhouse")
availability_overrides_values=("Public Parquet Files" "EthPandaOps Clickhouse")

if [ "$mode" != "" ]; then
    echo "Running in $mode mode"
else
    echo "Running in default mode"
fi

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
    echo "| Dataset Name | Schema | Description | Prefix | $header_columns |"
    echo "|--------------|--------|-------------|--------|$(echo "$dataset_availability_options" | sed 's/.*/---/g' | tr '\n' '|' | sed 's/|$//')|"

    # Print each dataset's availability
    yq e '.datasets[]' "$config_file" -o=json | jq -c '.' | while read -r dataset_config; do
        dataset_name=$(echo "$dataset_config" | jq -r '.name')
        dataset_description=$(echo "$dataset_config" | jq -r '.description')
        dataset_prefix=$(echo "$dataset_config" | jq -r '.tables.prefix')
        if [ "${mode}" = "hugo" ]; then
            dataset_link="./schema/${dataset_prefix}"
        fi
        if [ "${mode}" = "docusaurus" ]; then
            dataset_link="./schema/${dataset_prefix}"
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

# Generate datasets table markdown and store it in a temporary file
generate_datasets_table > "$temp_datasets_file"

# update  datasets
{
    awk '/<!-- datasets_start -->/{exit}1' "$readme_file"
    
    echo "<!-- datasets_start -->"
    cat "$temp_datasets_file"
    echo "<!-- datasets_end -->"
    
    awk '/<!-- datasets_end -->/{flag=1}flag' "$readme_file" | tail -n +2
} > "$temp_datasets_readme"

mv "$temp_datasets_readme" "$readme_file"

# Cleanup
rm "$temp_datasets_file"
