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
#   4. Writes experimental.json (full catalog including column schemas, consumed
#      by the ethpandaops.io experimental pages), experimental.yaml (skimmable
#      variant without columns), and schema/experimental.md (overview index)
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
output_json=${EXPERIMENTAL_JSON:-experimental.json}
output_md=${EXPERIMENTAL_SCHEMA:-schema/experimental.md}
# Site paths on ethpandaops.io, used for links in generated output
fork_page_base=${FORK_PAGE_BASE:-/data/xatu/forks}

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

log "Fetching cartographoor networks from $cartographoor_url"
networks_json=$(curl -fsS "$cartographoor_url")

# Devnets are active networks discovered from a github repository. Canonical
# networks (mainnet, sepolia, ...) come from the static provider with no repository.
echo "$networks_json" | jq -c '
    .networks | to_entries[]
    | select(.value.status == "active" and .value.repository != null)
    | {name: .key, repository: .value.repository, dora: (.value.serviceUrls.dora // "")}
' > "$tmp_dir/devnets.jsonl"

log "Found $(wc -l < "$tmp_dir/devnets.jsonl" | tr -d ' ') active devnet(s)"

log "Listing tables in the default database"
list_tables "default" > "$tmp_dir/tables_default"

# Introspect each devnet
> "$tmp_dir/results.jsonl"
while read -r devnet; do
    name=$(echo "$devnet" | jq -r '.name')
    repository=$(echo "$devnet" | jq -r '.repository')
    dora=$(echo "$devnet" | jq -r '.dora')

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
        --arg dora "$dora" \
        --arg fork "$fork" \
        --arg xatu_branch "$xatu_branch" \
        --argjson total "$total_tables" \
        --rawfile new_tables "$tmp_dir/new_$name" \
        '{
            name: $name,
            repository: $repository,
            dora: (if $dora == "" then null else $dora end),
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
                slug: (($fork_meta[0][$f].display_name // $f) | ascii_downcase | gsub("[^a-z0-9]+"; "-")),
                xatu_branch: .[0].xatu_branch,
                networks: (map({name, repository, dora, new_table_count: (.new_tables | length)}) | sort_by(.name)),
                tables: (
                    [.[] as $net | $net.new_tables[] | {table: ., network: $net.name}]
                    | group_by(.table)
                    | map({name: .[0].table, networks: (map(.network) | sort)})
                ),
                merged_tables: ([$merged[0][] | select(.fork == $f) | .name] | sort)
            })
        )
    }' "$tmp_dir/results.jsonl" > "$tmp_dir/experimental.json.raw"

# Enrich devnet-only tables with their descriptions, sorting key, and full
# column schemas so downstream consumers (generate-schema.sh, the homepage)
# don't need ClickHouse access to the devnet databases
> "$tmp_dir/details.jsonl"
jq -c '.forks[].tables[] | {name: .name, db: .networks[0]}' "$tmp_dir/experimental.json.raw" | sort -u | while read -r entry; do
    t=$(echo "$entry" | jq -r '.name')
    db=$(echo "$entry" | jq -r '.db')
    comment=$(ch_query "SELECT comment FROM system.tables WHERE database = '$db' AND name = '${t}_local' FORMAT TabSeparated")
    sorting_key=$(ch_query "SELECT sorting_key FROM system.tables WHERE database = '$db' AND name = '${t}_local' FORMAT TabSeparated")
    columns_tsv=$(ch_query "SELECT name, type, comment FROM system.columns WHERE database = '$db' AND table = '$t' FORMAT TabSeparated")
    jq -n -c \
        --arg name "$t" \
        --arg description "$comment" \
        --arg sorting_key "$sorting_key" \
        --arg columns "$columns_tsv" \
        '{
            name: $name,
            description: $description,
            sorting_key: $sorting_key,
            columns: ($columns | split("\n") | map(select(. != "") | split("\t") | {name: .[0], type: .[1], description: (.[2] // "")}))
        }' >> "$tmp_dir/details.jsonl"
done

if [ -s "$tmp_dir/details.jsonl" ]; then
    jq -s 'INDEX(.name)' "$tmp_dir/details.jsonl" > "$tmp_dir/details.json"
else
    echo '{}' > "$tmp_dir/details.json"
fi
jq --slurpfile details "$tmp_dir/details.json" '
    .forks[].tables[] |= (. + {
        description: ($details[0][.name].description // ""),
        sorting_key: ($details[0][.name].sorting_key // ""),
        columns: ($details[0][.name].columns // [])
    })
' "$tmp_dir/experimental.json.raw" > "$tmp_dir/experimental.json"

jq '.' "$tmp_dir/experimental.json" > "$output_json"
log "Wrote $output_json"
# The yaml variant carries everything except column schemas, to stay skimmable
jq 'del(.forks[].tables[].columns)' "$tmp_dir/experimental.json" | yq e -P -o=yaml '.' - > "$output_yaml"
log "Wrote $output_yaml"

# The overview page: a scannable index of upgrades and devnets. Full table
# detail lives on the per-fork pages.
render_overview() {
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
    echo "## Network upgrades"
    echo ""
    echo "Each upgrade has a dedicated page with the full table schemas and query examples:"
    echo ""
    echo "| Upgrade | CL fork | Xatu branch | Devnet-only tables | In main catalog | Active devnets |"
    echo "|---------|---------|-------------|--------------------|-----------------|----------------|"
    jq -r --arg base "$fork_page_base" '
        .forks[]
        | [
            "**[" + .display_name + "](" + $base + "/" + .slug + ")**",
            "`" + .name + "`",
            (if .xatu_branch == null then "-" else "[`" + .xatu_branch + "`](https://github.com/ethpandaops/xatu/tree/" + .xatu_branch + ")" end),
            (.tables | length | tostring),
            (.merged_tables | length | tostring),
            (.networks | map("`" + .name + "`") | join(", "))
        ]
        | "| " + join(" | ") + " |"
    ' "$tmp_dir/experimental.json"
    echo ""
    echo "## Active devnets"
    echo ""
    echo "| Network | Upgrade | Fork-specific tables | Source |"
    echo "|---------|---------|----------------------|--------|"
    jq -r --arg base "$fork_page_base" '
        . as $root
        | .networks[]
        | .fork as $f
        | ([$root.forks[] | select(.name == $f)] | first) as $fork_info
        | [
            "`" + .name + "`",
            (if $fork_info == null then "-" else "[" + $fork_info.display_name + "](" + $base + "/" + $fork_info.slug + ") (`" + $f + "`)" end),
            (.new_tables | length | tostring),
            "[" + .repository + "](https://github.com/" + .repository + ")"
        ]
        | "| " + join(" | ") + " |"
    ' "$tmp_dir/experimental.json"
    echo ""
}

log "Rendering $output_md"
mkdir -p "$(dirname "$output_md")"
render_overview > "$output_md"

log "Experimental catalog generation completed"
