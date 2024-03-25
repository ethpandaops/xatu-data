#!/bin/bash

CLICKHOUSE_HOST="${CLICKHOUSE_HOST:-}"
CLICKHOUSE_PORT="${CLICKHOUSE_PORT:-}"
CLICKHOUSE_USER="${CLICKHOUSE_USER:-}"
CLICKHOUSE_PASSWORD="${CLICKHOUSE_PASSWORD:-}"

function clickhouse_query() {
    local args=()
    [[ -n "$CLICKHOUSE_HOST" ]] && args+=(--host="$CLICKHOUSE_HOST")
    [[ -n "$CLICKHOUSE_USER" ]] && args+=(--user="$CLICKHOUSE_USER")
    [[ -n "$CLICKHOUSE_PASSWORD" ]] && args+=(--password="$CLICKHOUSE_PASSWORD")
    [[ -n "$CLICKHOUSE_PORT" ]] && args+=(--port="$CLICKHOUSE_PORT")
    args+=(--query="$1")

    echo $(clickhouse client "${args[@]}")
}
