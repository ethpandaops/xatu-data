#!/bin/bash

# Exports the table catalog as JSON for programmatic consumers — primarily the
# ethpandaops.io schema pages, which render these files directly.
#
# Outputs:
#   catalog/index.json     - datasets summary with table names
#   catalog/<prefix>.json  - full per-dataset catalog including column schemas
#   catalog/cbt.json       - CBT tables (auto-discovered from ClickHouse)
#
# Runs against the same ClickHouse instances as generate-schema.sh and is
# expected to run in the same CI job.

set -e
export LC_ALL=C

clickhouse_host=${CLICKHOUSE_HOST:-http://localhost:8125}
cbt_clickhouse_host=${CBT_CLICKHOUSE_HOST:-http://localhost:8123}
clickhouse_user=${CLICKHOUSE_USER:-default}
clickhouse_password=${CLICKHOUSE_PASSWORD:-supersecret}
config_file=${CONFIG:-config.yaml}
output_dir=${CATALOG_DIR:-catalog}

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

ch_query() {
    local host=$1
    local query=$2
    curl -fsS -u "${clickhouse_user}:${clickhouse_password}" "$host" --data "$query"
}

# Emit a full table entry as JSON: config metadata + introspected schema
build_table_json() {
    local table_name=$1
    local table_config=$2
    local host=$3
    local schema_database=$4

    local description=$(ch_query "$host" "SELECT comment FROM system.tables WHERE database = '$schema_database' AND name = '${table_name}_local' FORMAT TabSeparated")
    local engine=$(ch_query "$host" "SELECT engine FROM system.tables WHERE database = '$schema_database' AND name = '${table_name}_local' FORMAT TabSeparated")
    local columns_tsv=$(ch_query "$host" "SELECT name, type, comment FROM system.columns WHERE database = '$schema_database' AND table = '$table_name' FORMAT TabSeparated")

    local should_use_final=false
    if [[ "$engine" =~ "Replacing" ]]; then
        should_use_final=true
    fi

    echo "$table_config" | yq e -o=json '.' - | jq -c \
        --arg description "$description" \
        --arg engine "$engine" \
        --argjson should_use_final "$should_use_final" \
        --arg columns "$columns_tsv" \
        '. + {
            description: (if $description == "" then (.description // "") else $description end),
            engine: $engine,
            should_use_final: $should_use_final,
            columns: (
                (.excluded_columns // []) as $excluded
                | $columns | split("\n")
                | map(select(. != "") | split("\t") | {name: .[0], type: .[1], description: (.[2] // "")})
                | map(select(.name as $n | $excluded | index($n) | not))
            )
        }'
}

# CBT tables are not in config.yaml; discover them from ClickHouse
discover_cbt_tables() {
    ch_query "$cbt_clickhouse_host" "
        SELECT name
        FROM system.tables
        WHERE database = 'mainnet'
          AND engine NOT LIKE '%View%'
          AND name NOT LIKE 'admin_%'
          AND name NOT IN ('schema_migrations', 'schema_migrations_local')
          AND name NOT LIKE '%_local'
        ORDER BY name
        FORMAT TabSeparated
    " | grep -E '^[a-zA-Z_][a-zA-Z0-9_]*$' || true
}

build_cbt_table_config() {
    local table_name=$1
    local sorting_key=$(ch_query "$cbt_clickhouse_host" "SELECT sorting_key FROM system.tables WHERE database = 'mainnet' AND name = '${table_name}_local' FORMAT TabSeparated")
    local partition_column=$(echo "$sorting_key" | sed 's/,.*//; s/^[[:space:]]*//; s/[[:space:]]*$//')
    local column_type=$(ch_query "$cbt_clickhouse_host" "SELECT type FROM system.columns WHERE database = 'mainnet' AND table = '${table_name}_local' AND name = '$partition_column' FORMAT TabSeparated")

    local partition_type="none"
    local partition_interval=""
    if [[ "$column_type" =~ ^DateTime || "$column_type" =~ ^Date ]]; then
        partition_type="datetime"
        partition_interval="daily"
    elif [[ "$column_type" =~ ^UInt || "$column_type" =~ ^Int ]]; then
        partition_type="integer"
        partition_interval="1000"
    fi

    cat <<EOF
name: "$table_name"
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
EOF
}

mkdir -p "$output_dir"
generated_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

> "$tmp_dir/index_datasets.jsonl"

yq e -o=json '.datasets' "$config_file" | jq -c '.[]' | while read -r dataset_json; do
    dataset_name=$(echo "$dataset_json" | jq -r '.name')
    table_prefix=$(echo "$dataset_json" | jq -r '.tables.prefix // ""')

    if [ -z "$table_prefix" ]; then
        output_file="$output_dir/cbt.json"
        dataset_key="cbt"
    else
        output_file="$output_dir/${table_prefix}.json"
        dataset_key="$table_prefix"
    fi

    log "Building catalog for dataset: $dataset_name ($dataset_key)"
    > "$tmp_dir/tables.jsonl"

    if [ -z "$table_prefix" ]; then
        for table_name in $(discover_cbt_tables); do
            if [[ "$table_name" =~ [/:] ]] || [[ -z "$table_name" ]]; then
                continue
            fi
            table_config=$(build_cbt_table_config "$table_name")
            build_table_json "$table_name" "$table_config" "$cbt_clickhouse_host" "mainnet" >> "$tmp_dir/tables.jsonl"
        done
    else
        for table_name in $(yq e '.tables[] | select(.name | test("^'"$table_prefix"'")) | .name' "$config_file"); do
            table_config=$(yq e '.tables[] | select(.name == "'"$table_name"'")' "$config_file")
            database=$(echo "$table_config" | yq e '.database' -)
            build_table_json "$table_name" "$table_config" "$clickhouse_host" "$database" >> "$tmp_dir/tables.jsonl"
        done
    fi

    jq -s \
        --argjson dataset "$(echo "$dataset_json" | jq 'del(.additional_info)')" \
        --arg additional_info "$(echo "$dataset_json" | jq -r '.additional_info // ""')" \
        --argjson fork_meta "$(yq e -o=json '.forks // {}' "$config_file")" \
        --arg generated_at "$generated_at" \
        '{
            generated_at: $generated_at,
            dataset: ($dataset + {additional_info: $additional_info}),
            tables: (. | map(
                if .fork then . + {fork_display_name: ($fork_meta[.fork].display_name // .fork)} else . end
            ))
        }' "$tmp_dir/tables.jsonl" > "$output_file"
    log "Wrote $output_file ($(jq '.tables | length' "$output_file") tables)"

    jq -c '{
        name: .dataset.name,
        prefix: (.dataset.tables.prefix // ""),
        key: "'"$dataset_key"'",
        description: .dataset.description,
        availability: .dataset.availability,
        tables: [.tables[].name]
    }' "$output_file" >> "$tmp_dir/index_datasets.jsonl"
done

jq -s --arg generated_at "$generated_at" '{generated_at: $generated_at, datasets: .}' \
    "$tmp_dir/index_datasets.jsonl" > "$output_dir/index.json"
log "Wrote $output_dir/index.json"

log "Catalog generation completed"
