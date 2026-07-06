#!/bin/bash

# Discovers experimental (devnet) data and generates the experimental catalog.
#
# Devnets run xatu from a fork branch (release/<fork>) and write to their own
# database on the EthPandaOps ClickHouse cluster, e.g. `glamsterdam-devnet-6`.table.
# This script:
#   1. Fetches the list of active devnets from cartographoor
#   2. Determines each devnet's frontier fork (highest-epoch consensus fork) and
#      the matching xatu release/<fork> branch
#   3. Introspects each devnet's database and diffs its tables against the
#      `default` database to find fork-specific tables
#   4. Writes experimental.yaml (machine-readable) and schema/experimental.md
#
# Fork attribution for tables that have merged to xatu master lives in
# config.yaml as a per-table `fork:` field; this script only discovers tables
# that exist exclusively on devnets.

set -e
export LC_ALL=C

cartographoor_url=${CARTOGRAPHOOR_URL:-https://ethpandaops-platform-production-cartographoor.ams3.digitaloceanspaces.com/networks.json}
# The endpoint documented in generated output. Queries go to XATU_CLICKHOUSE_HOST,
# which may differ (e.g. an internal host in CI).
public_endpoint=${XATU_CLICKHOUSE_PUBLIC_ENDPOINT:-https://clickhouse.xatu.ethpandaops.io}
clickhouse_host=${XATU_CLICKHOUSE_HOST:-$public_endpoint}
clickhouse_user=${XATU_CLICKHOUSE_USER:?XATU_CLICKHOUSE_USER is required}
clickhouse_password=${XATU_CLICKHOUSE_PASSWORD:?XATU_CLICKHOUSE_PASSWORD is required}
xatu_repo_url=${XATU_REPO_URL:-https://github.com/ethpandaops/xatu}
config_file=${CONFIG:-config.yaml}
output_yaml=${EXPERIMENTAL_CONFIG:-experimental.yaml}
output_md=${EXPERIMENTAL_SCHEMA:-schema/experimental.md}

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

ch_query() {
    curl -fsS -u "${clickhouse_user}:${clickhouse_password}" "$clickhouse_host" --data "$1"
}

list_tables() {
    local database=$1
    ch_query "
        SELECT name
        FROM system.tables
        WHERE database = '$database'
          AND engine NOT LIKE '%View%'
          AND name NOT LIKE '%_local'
          AND name NOT LIKE 'admin_%'
          AND name != 'schema_migrations'
        ORDER BY name
        FORMAT TabSeparated
    " | grep -E '^[a-zA-Z_][a-zA-Z0-9_]*$' || true
}

database_exists() {
    local database=$1
    local count=$(ch_query "SELECT count() FROM system.databases WHERE name = '$database' FORMAT TabSeparated")
    [ "$count" = "1" ]
}

# Resolve the xatu branch for a fork: config override, else release/<fork>.
# Prints the branch name if it exists on the remote, empty string otherwise.
resolve_xatu_branch() {
    local fork=$1
    local branch=$(yq e ".forks.${fork}.xatu_branch // \"release/${fork}\"" "$config_file")
    local cache_file="$tmp_dir/branch_${fork}"
    if [ ! -f "$cache_file" ]; then
        if [ -n "$(git ls-remote --heads "$xatu_repo_url" "$branch" </dev/null 2>/dev/null)" ]; then
            echo "$branch" > "$cache_file"
        else
            echo "" > "$cache_file"
        fi
    fi
    cat "$cache_file"
}

markdown_anchor() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g'
}

# Wrap each element of a comma-separated list in backticks: a,b -> `a`, `b`
backtick_list() {
    echo "$1" | sed 's/[^,][^,]*/`&`/g; s/,/, /g'
}

# Find the schema page (dataset prefix) a table belongs to
schema_page_for_table() {
    local table_name=$1
    yq e '.datasets[].tables.prefix' "$config_file" | while read -r prefix; do
        if [ -n "$prefix" ] && [ "$prefix" != "null" ] && [[ "$table_name" == ${prefix}* ]]; then
            echo "$prefix"
            break
        fi
    done
}

log "Fetching cartographoor networks from $cartographoor_url"
networks_json=$(curl -fsS "$cartographoor_url")

# Devnets are active networks discovered from a github repository. Canonical
# networks (mainnet, sepolia, ...) come from the static provider with no repository.
echo "$networks_json" | jq -c '
    .networks | to_entries[]
    | select(.value.status == "active" and .value.repository != null)
    | {name: .key, repository: .value.repository}
' > "$tmp_dir/devnets.jsonl"

log "Found $(wc -l < "$tmp_dir/devnets.jsonl" | tr -d ' ') active devnet(s)"

log "Listing tables in the default database"
list_tables "default" > "$tmp_dir/tables_default"

# Introspect each devnet
> "$tmp_dir/results.jsonl"
while read -r devnet; do
    name=$(echo "$devnet" | jq -r '.name')
    repository=$(echo "$devnet" | jq -r '.repository')

    if ! database_exists "$name"; then
        log "Skipping $name: no database on $clickhouse_host"
        continue
    fi

    # Frontier fork: highest-epoch consensus fork. Ties (all-at-genesis devnets)
    # break on the fork codename, which sorts chronologically by design
    # (altair < bellatrix < ... < fulu < gloas).
    fork=$(echo "$networks_json" | jq -r --arg n "$name" '
        .networks[$n].forks.consensus // {}
        | to_entries
        | sort_by([.value.epoch, .key])
        | last
        | .key // ""
    ')

    xatu_branch=""
    if [ -n "$fork" ]; then
        xatu_branch=$(resolve_xatu_branch "$fork")
    fi

    list_tables "$name" > "$tmp_dir/tables_$name"
    comm -23 "$tmp_dir/tables_$name" "$tmp_dir/tables_default" > "$tmp_dir/new_$name"

    total_tables=$(wc -l < "$tmp_dir/tables_$name" | tr -d ' ')
    new_count=$(wc -l < "$tmp_dir/new_$name" | tr -d ' ')
    log "$name: fork=$fork branch=${xatu_branch:-none} tables=$total_tables fork-specific=$new_count"

    jq -n -c \
        --arg name "$name" \
        --arg repository "$repository" \
        --arg fork "$fork" \
        --arg xatu_branch "$xatu_branch" \
        --argjson total "$total_tables" \
        --rawfile new_tables "$tmp_dir/new_$name" \
        '{
            name: $name,
            repository: $repository,
            fork: $fork,
            xatu_branch: (if $xatu_branch == "" then null else $xatu_branch end),
            database: $name,
            tables_total: $total,
            new_tables: ($new_tables | split("\n") | map(select(. != "")))
        }' >> "$tmp_dir/results.jsonl"
done < "$tmp_dir/devnets.jsonl"

if [ ! -s "$tmp_dir/results.jsonl" ]; then
    log "No active devnets with a database found"
fi

# Fork metadata from config.yaml: display names and merged-table attribution
yq e -o=json '.forks // {}' "$config_file" > "$tmp_dir/fork_meta.json"
yq e -o=json '[.tables[] | select(.fork != null) | {"name": .name, "fork": .fork}]' "$config_file" > "$tmp_dir/merged_tables.json"

# Build the machine-readable catalog
jq -s \
    --slurpfile merged "$tmp_dir/merged_tables.json" \
    --slurpfile fork_meta "$tmp_dir/fork_meta.json" \
    --arg generated_at "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
    --arg endpoint "$public_endpoint" \
    '{
        generated_at: $generated_at,
        clickhouse_endpoint: $endpoint,
        networks: .,
        forks: (
            group_by(.fork)
            | map(select(.[0].fork != ""))
            | map(.[0].fork as $f | {
                name: $f,
                display_name: ($fork_meta[0][$f].display_name // $f),
                xatu_branch: .[0].xatu_branch,
                networks: (map(.name) | sort),
                tables: (
                    [.[] as $net | $net.new_tables[] | {table: ., network: $net.name}]
                    | group_by(.table)
                    | map({name: .[0].table, networks: (map(.network) | sort)})
                ),
                merged_tables: ([$merged[0][] | select(.fork == $f) | .name] | sort)
            })
        )
    }' "$tmp_dir/results.jsonl" > "$tmp_dir/experimental.json"

yq e -P -o=yaml '.' "$tmp_dir/experimental.json" > "$output_yaml"
log "Wrote $output_yaml"

# Render the human-readable schema page
render_table_section() {
    local table_name=$1
    local networks_csv=$2
    local ref_database=$3

    local table_comment=$(ch_query "SELECT comment FROM system.tables WHERE database = '$ref_database' AND name = '${table_name}_local' FORMAT TabSeparated")
    local sorting_key=$(ch_query "SELECT sorting_key FROM system.tables WHERE database = '$ref_database' AND name = '${table_name}_local' FORMAT TabSeparated")
    local first_sort_column=$(echo "$sorting_key" | sed 's/,.*//; s/^[[:space:]]*//; s/[[:space:]]*$//')
    local first_sort_type=""
    if [ -n "$first_sort_column" ]; then
        first_sort_type=$(ch_query "SELECT type FROM system.columns WHERE database = '$ref_database' AND table = '${table_name}_local' AND name = '$first_sort_column' FORMAT TabSeparated")
    fi

    echo "### $table_name"
    echo ""
    if [ -n "$table_comment" ]; then
        echo "$table_comment"
        echo ""
    fi
    echo "Available on: $(backtick_list "$networks_csv")"
    echo ""
    echo "<details>"
    echo "<summary>EthPandaOps Clickhouse</summary>"
    echo ""
    echo '```bash'
    echo "echo '"
    echo "    SELECT"
    echo "        *"
    echo "    FROM \`${ref_database}\`.${table_name}"
    if [[ "$first_sort_type" =~ ^DateTime || "$first_sort_type" =~ ^Date ]]; then
        echo "    WHERE"
        echo "        $first_sort_column >= NOW() - INTERVAL 1 DAY"
    fi
    echo "    LIMIT 3"
    echo "    FORMAT Pretty"
    echo "' | curl \"$public_endpoint\" -u \"\$CLICKHOUSE_USER:\$CLICKHOUSE_PASSWORD\" --data-binary @-"
    echo '```'
    echo "</details>"
    echo ""
    echo "#### Columns"
    echo "| Name | Type | Description |"
    echo "|--------|------|-------------|"
    ch_query "SELECT name, type, comment FROM system.columns WHERE database = '$ref_database' AND table = '$table_name' FORMAT TabSeparated" \
        | while IFS=$'\t' read -r col_name col_type col_comment; do
            echo "| **$col_name** | \`$col_type\` | *$col_comment* |"
        done
    echo ""
}

render_markdown() {
    echo "# Experimental data"
    echo ""
    echo "<!-- This file is generated by generate-experimental.sh. Do not edit manually. -->"
    echo ""
    echo "Xatu also collects data from short-lived devnets that test upcoming network upgrades. Devnets run xatu from a fork branch, so their schema is ahead of the main catalog: they carry tables for the upgrade being tested that don't exist on production networks yet."
    echo ""
    echo "Devnet data lives on the same ClickHouse endpoint as production networks: \`$public_endpoint\`."
    echo ""
    echo "Each devnet gets its **own database**, named after the network. Unlike production tables in the \`default\` database, you don't filter on \`meta_network_name\` — the database *is* the network:"
    echo ""
    echo '```sql'
    echo 'SELECT * FROM `glamsterdam-devnet-6`.beacon_api_eth_v1_events_block LIMIT 3'
    echo '```'
    echo ""
    echo "> Devnets are ephemeral. Databases disappear when a devnet is deprovisioned, and schemas drift between devnets — always check what a devnet actually has before relying on it."
    echo ""
    echo "## Active devnets"
    echo ""
    echo "| Network | Fork | Xatu branch | Fork-specific tables | Source |"
    echo "|---------|------|-------------|----------------------|--------|"
    jq -r '
        .networks[]
        | [
            "`" + .name + "`",
            (if .fork == "" then "-" else "`" + .fork + "`" end),
            (if .xatu_branch == null then "-" else "[`" + .xatu_branch + "`](https://github.com/ethpandaops/xatu/tree/" + .xatu_branch + ")" end),
            (.new_tables | length | tostring),
            "[" + .repository + "](https://github.com/" + .repository + ")"
        ]
        | "| " + join(" | ") + " |"
    ' "$tmp_dir/experimental.json"
    echo ""

    jq -c '.forks[]' "$tmp_dir/experimental.json" | while read -r fork_json; do
        local fork=$(echo "$fork_json" | jq -r '.name')
        local display=$(echo "$fork_json" | jq -r '.display_name')
        local branch=$(echo "$fork_json" | jq -r '.xatu_branch // ""')
        local fork_networks=$(echo "$fork_json" | jq -r '.networks | join(",")')

        echo "## ${display} (\`${fork}\`)"
        echo ""
        if [ -n "$branch" ]; then
            echo "Collected by xatu's [\`$branch\`](https://github.com/ethpandaops/xatu/tree/$branch) branch on: $(backtick_list "$fork_networks")"
        else
            echo "Active on: $(backtick_list "$fork_networks")"
        fi
        echo ""

        local merged_count=$(echo "$fork_json" | jq -r '.merged_tables | length')
        if [ "$merged_count" -gt 0 ]; then
            echo "### Tables in the main catalog"
            echo ""
            echo "These tables were introduced for ${display} and have since merged to xatu master — they are part of the main catalog and available on production networks:"
            echo ""
            echo "$fork_json" | jq -r '.merged_tables[]' | while read -r merged_table; do
                local page=$(schema_page_for_table "$merged_table")
                if [ -n "$page" ]; then
                    echo "- [\`$merged_table\`](./${page}.md#$(markdown_anchor "$merged_table"))"
                else
                    echo "- \`$merged_table\`"
                fi
            done
            echo ""
        fi

        local new_count=$(echo "$fork_json" | jq -r '.tables | length')
        if [ "$new_count" -gt 0 ]; then
            echo "### Devnet-only tables"
            echo ""
            echo "These tables only exist on ${display} devnets and have not merged to xatu master yet:"
            echo ""
            echo "$fork_json" | jq -r '.tables[] | .name' | while read -r t; do
                echo "- [\`$t\`](#$(markdown_anchor "$t"))"
            done
            echo ""
            echo "$fork_json" | jq -c '.tables[]' | while read -r table_json; do
                local t=$(echo "$table_json" | jq -r '.name')
                local t_networks=$(echo "$table_json" | jq -r '.networks | join(",")')
                local ref_db=$(echo "$table_json" | jq -r '.networks[0]')
                render_table_section "$t" "$t_networks" "$ref_db"
            done
        else
            echo "No devnet-only tables — these devnets run the standard xatu schema."
            echo ""
        fi
    done
}

log "Rendering $output_md"
mkdir -p "$(dirname "$output_md")"
render_markdown > "$output_md"

log "Experimental catalog generation completed"
