#!/bin/bash

set -e

source ./scripts/date.sh

# Configuration
clickhouse_host=${CLICKHOUSE_HOST:-http://localhost:8123}
config_file=${CONFIG:-config.yaml}
metadata_file="schema/bigquery/metadata.json"

# Logging function
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}
error() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >&2
}

# Ensure schema/bigquery exists and clean files
mkdir -p schema/bigquery
rm -f schema/bigquery/*.json

# Declare ClickHouse to BigQuery types
declare -A clickhouse_to_bigquery_types=(
    ["UInt8"]="INTEGER"
    ["UInt16"]="INTEGER"
    ["UInt32"]="INTEGER"
    ["UInt64"]="INTEGER"
    ["UInt128"]="NUMERIC"
    ["UInt256"]="NUMERIC"
    ["Int8"]="INTEGER"
    ["Int16"]="INTEGER"
    ["Int32"]="INTEGER"
    ["Int64"]="INTEGER"
    ["Int128"]="NUMERIC"
    ["Int256"]="NUMERIC"
    ["Float32"]="FLOAT"
    ["Float64"]="FLOAT"
    ["String"]="STRING"
    ["FixedString"]="STRING"
    ["Date"]="DATE"
    ["DateTime"]="TIMESTAMP"
    ["DateTime64"]="TIMESTAMP"
    ["IPv4"]="STRING"
    ["IPv6"]="STRING"
    ["UUID"]="STRING"
    ["Enum"]="STRING"
    ["Array"]="REPEATED"
    ["Tuple"]="RECORD"
    ["Bool"]="BOOLEAN"
    ["Map"]="RECORD"
)

# Generate schema for a single table
generate_table_schema() {
    set -e
    local table_name=$1
    local table_config=$(yq e ".tables[] | select(.name == \"$table_name\")" "$config_file")
    local excluded_columns=$(echo "$table_config" | yq e '.excluded_columns[]' - | tr '\n' ' ')
    local schema=$(curl -s "$clickhouse_host" --data "SELECT name, type, comment FROM system.columns WHERE table = '$table_name' FORMAT TabSeparated")

    echo "$schema" | while IFS=$'\t' read -r name type comment; do
        if [[ ! " $excluded_columns " =~ " $name " ]]; then
            local mode="REQUIRED"
            [[ "$type" =~ "Nullable" ]] && { mode="NULLABLE"; type=$(echo "$type" | sed -E 's/Nullable\((.*)\)/\1/'); }
            [[ "$type" =~ "LowCardinality" ]] && type=$(echo "$type" | sed -E 's/LowCardinality\((.*)\)/\1/')

            if [[ "$type" =~ ^Array\((.*)\)$ ]]; then
                local inner_type=$(echo "$type" | sed -E 's/Array\((.*)\)/\1/')
                type="REPEATED"
                echo "$(generate_json "$name" "$inner_type" "NULLABLE" "$comment")"
                continue
            fi

            if [[ "$type" =~ ^Map\((.*)\)$ ]]; then
                local inner_types=$(echo "$type" | sed -E 's/Map\((.*)\)/\1/')
                IFS=',' read -ra types <<< "$inner_types"
                types[1]=$(echo "${types[1]}" | tr -d ' ')
                echo "$(generate_map_json "$name" "${types[0]}" "${types[1]}" "$comment")"
                continue
            fi

            if [[ "$type" == DateTime64* ]]; then
                type="DateTime64"
            elif [[ "$type" == FixedString* ]]; then
                type="FixedString"
            fi

            if [[ -z "${clickhouse_to_bigquery_types[$type]}" ]]; then
                error "Missing type mapping for ClickHouse type '$type' in column '$name'"
                exit 1
            fi

            type=${clickhouse_to_bigquery_types[$type]}
            echo "$(generate_json "$name" "$type" "$mode" "$comment")"
        fi
    done
}
generate_table_metadata() {
    local table_name=$1
    local table_description=$(curl -s "$clickhouse_host" --data "SELECT comment FROM system.tables WHERE table = '${table_name}_local' FORMAT TabSeparated" | jq -R .)
    local table_partition_key=$(curl -s "$clickhouse_host" --data "SELECT partition_key FROM system.tables WHERE table = '${table_name}_local' FORMAT TabSeparated")
    local table_partition_type=""
    local table_partition_value=""

    if [[ "$table_partition_key" =~ ^(toYYYYMM|toStartOfMonth) ]]; then
        table_partition_type="time"
        local table_partition_field="${table_partition_key#*(}"
        table_partition_field="${table_partition_field%%)*}"
        if [[ -z "$table_partition_field" ]]; then
            error "Missing partition field for table '$table_name' with partition key '$table_partition_key'"
            exit 1
        fi
        table_partition_value=$(cat <<EOF
{
            "type": "MONTH",
            "field": "$table_partition_field"
        }
EOF
        )
    elif [[ "$table_partition_key" == intDiv* ]]; then
        table_partition_type="range"
        local table_partition_field=$(echo "$table_partition_key" | sed -E 's/intDiv\(([^,]+),.*\)/\1/; s/\s//g')
        local table_partition_interval=$(echo "$table_partition_key" | sed -E 's/intDiv\([^(]*,\s*([0-9]+)\)/\1/')
        if [[ -z "$table_partition_field" ]]; then
            error "Missing partition field for table '$table_name' with partition key '$table_partition_key'"
            exit 1
        fi

        if ! [[ "$table_partition_interval" =~ ^[0-9]+$ ]]; then
            error "Invalid partition interval for table '$table_name': '$table_partition_interval' is not a number"
            exit 1
        fi
        table_partition_value=$(cat <<EOF
{
    "field": "$table_partition_field",
    "range": {
        "start": 0,
        "end": 1000000000000,
        "interval": $table_partition_interval
    }
}
EOF
        )
    fi

    # check if table_partition_value or table_partition_type is empty
    if [[ -z "$table_partition_value" || -z "$table_partition_type" ]]; then
        error "Missing partition type or value for table '$table_name' $table_partition_key"
        exit 1
    fi

    local table_sorting_keys=$(curl -s "$clickhouse_host" --data "SELECT sorting_key FROM system.tables WHERE table = '${table_name}_local' FORMAT TabSeparated")
    # bigquery can only have 4 clustering fields, also remove meta_network_name as we split by network in bigquery anyway
    local table_sorting_keys_array=$(echo "$table_sorting_keys" | jq -R -s -c 'split(",") | map(gsub("^\\s+|\\s+$"; "")) | map(select(. != "meta_network_name")) | .[0:4]')

    cat <<EOF >> "$metadata_file"
    {
        "name": "$table_name",
        "description": $table_description,
        "partition_type": "$table_partition_type",
        "partition_value": $table_partition_value,
        "clustering": $table_sorting_keys_array
    },
EOF
}

# Recursive function to handle nested types
generate_json() {
    local name=$1
    local type=$2
    local mode=$3
    local comment=$4
    if [[ "$type" =~ ^Array\((.*)\)$ ]]; then
        local inner_type=$(echo "$type" | sed -E 's/Array\((.*)\)/\1/')
        type="REPEATED"
        cat <<EOF
    {
        "name": "$name",
        "type": "$type",
        "mode": "$mode",
        "description": "$comment",
        "fields": [$(generate_json "$name" "$inner_type" "NULLABLE" "$comment")]
    },
EOF
    elif [[ "$type" =~ ^Tuple\((.*)\)$ ]]; then
        type="RECORD"
        local fields=""
        IFS=',' read -ra inner_types <<< "$(echo "$type" | sed -E 's/Tuple\((.*)\)/\1/')"
        for inner in "${inner_types[@]}"; do
            fields+=$(generate_json "$name" "$inner" "NULLABLE" "$comment")
        done
        cat <<EOF
    {
        "name": "$name",
        "type": "$type",
        "mode": "$mode",
        "description": "$comment",
        "fields": [$fields]
    },
EOF
    else
        cat <<EOF
    {
        "name": "$name",
        "type": "$type",
        "mode": "$mode",
        "description": "$comment"
    },
EOF
    fi
}

# Function to handle ClickHouse Map(String, String) to BigQuery JSON
generate_map_json() {
    local name=$1
    local key_type=$2
    local value_type=$3
    local comment=$4

    [[ -z "${clickhouse_to_bigquery_types[$key_type]}" ]] && { error "Unsupported key type '$key_type' for $name"; exit 1; }
    [[ -z "${clickhouse_to_bigquery_types[$value_type]}" ]] && { error "Unsupported value type '$value_type' for $name"; exit 1; }

    cat <<EOF
    {
        "name": "$name",
        "type": "RECORD",
        "mode": "NULLABLE",
        "description": "$comment",
        "fields": [
            {
                "name": "key_value",
                "type": "RECORD",
                "mode": "REPEATED",
                "fields": [
                    {
                        "name": "key",
                        "type": "${clickhouse_to_bigquery_types[$key_type]}",
                        "mode": "REQUIRED"
                    },
                    {
                        "name": "value",
                        "type": "${clickhouse_to_bigquery_types[$value_type]}",
                        "mode": "REQUIRED"
                    }
                ]
            }
        ]
    },
EOF
}

# Generate schema for each dataset
generate_dataset_schema() {
    local dataset_name=$1
    local dataset_config=$(yq e ".datasets[] | select(.name == \"$dataset_name\")" "$config_file")
    local table_prefix=$(echo "$dataset_config" | yq e '.tables.prefix' -)

    for table_name in $(yq e '.tables[] | select(.name | test("^'"$table_prefix"'")) | .name' "$config_file"); do
        log "Generating BigQuery schema for table: $table_name"
        echo "[" > "schema/bigquery/${table_name}.json"
        generate_table_schema "$table_name" >> "schema/bigquery/${table_name}.json"
        sed -i -e '$ s/,$//' "schema/bigquery/${table_name}.json"
        echo "]" >> "schema/bigquery/${table_name}.json"
        generate_table_metadata "$table_name" >> "$metadata_file"
    done
}

# Initialize metadata file
echo "[" > "$metadata_file"

# Generate schemas for all datasets
yq e '.datasets[].name' "$config_file" | while read -r dataset_name; do
    log "Generating schema for dataset: $dataset_name"
    generate_dataset_schema "$dataset_name"
    log "BigQuery schema generation completed for $dataset_name"
done

# Finalize metadata file
sed -i '$ s/,$//' "$metadata_file"  # Remove last comma
echo "]" >> "$metadata_file"

log "BigQuery schema update completed"