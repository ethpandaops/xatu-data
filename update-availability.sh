#!/bin/bash

# Import dep scripts
source ./scripts/log.sh
source ./scripts/date.sh

set -e

# Path to config file
CONFIG_FILE="./config.yaml"

# Ensure yq is installed
if ! command -v yq &> /dev/null; then
    log "Required command 'yq' is not installed. Please install it to proceed."
    exit 1
fi

# Accept dataset as a parameter
DATASET=$1

if [ -z "$DATASET" ]; then
    log "No dataset specified. Please provide a dataset name."
    exit 1
fi

# Check if the dataset has availability == "public"
IS_PUBLIC=$(yq e ".datasets[] | select(.name == \"$DATASET\").availability | contains([\"public\"])" "$CONFIG_FILE")

if [ "$IS_PUBLIC" != "true" ]; then
    log "Dataset '$DATASET' does not have public availability."
    exit 0
fi

# Read table prefixes from the specified dataset in config.yaml
TABLE_PREFIXES=$(yq e ".datasets[] | select(.name == \"$DATASET\").tables.prefix" "$CONFIG_FILE")

if [ -z "$TABLE_PREFIXES" ]; then
    log "No tables found for dataset '$DATASET'."
    exit 1
fi

log "Checking tables with prefixes: $TABLE_PREFIXES"

# Read tables from config.yaml that match the prefixes
TABLES=$(yq e ".tables[].name" "$CONFIG_FILE" | grep -E "^($TABLE_PREFIXES)")

if [ -z "$TABLES" ]; then
    log "No tables found matching the prefixes: $TABLE_PREFIXES"
    exit 1
fi

log "Tables to be checked: $TABLES"

# Function to check if data is available for a given date
data_is_available() {
    local TABLE=$1
    local NETWORK=$2
    local HOURLY_PARTITIONING=$3
    local DATABASE=$4
    local DATE=$5

    YEAR=$(date -u -d "$DATE" '+%Y')
    MONTH=$(date -u -d "$DATE" '+%-m')
    DAY=$(date -u -d "$DATE" '+%-d')
    BASE_URL="https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE"
    if [[ "$HOURLY_PARTITIONING" == "true" ]]; then
        URL="$BASE_URL/$YEAR/$MONTH/$DAY/0.parquet"
    else
        URL="$BASE_URL/$YEAR/$MONTH/$DAY.parquet"
    fi

    HTTP_STATUS=$(curl --head --connect-timeout 5 --max-time 10 --silent --write-out "%{http_code}" --output /dev/null "$URL")
    if [[ "$HTTP_STATUS" == "200" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to determine the start date
determine_start_date() {
    local TABLE=$1
    local NETWORK=$2
    local HOURLY_PARTITIONING=$3
    local DATABASE=$4


    while : ; do
        CURRENT_DATE=$(yq e ".tables[] | select(.name == \"$TABLE\").networks.$NETWORK.from" "$CONFIG_FILE")
        if [[ "$CURRENT_DATE" == "null" || -z "$CURRENT_DATE" ]]; then
            CURRENT_DATE=$(date -u '+%Y-%m-%d')
        fi

        NEXT_DATE=$(date -u -d "$CURRENT_DATE - 1 day" '+%Y-%m-%d')

        if [[ "$NEXT_DATE" < "2020-01-01" ]]; then
            log "No data available before 2020-01-01 for $DATABASE.$TABLE on $NETWORK"
            yq e ".tables |= map(select(.name == \"$TABLE\").networks.$NETWORK.from = null)" -i "$CONFIG_FILE"
            log "No start date found for $DATABASE.$TABLE on $NETWORK, setting it to null"
            break
        fi

        if data_is_available "$TABLE" "$NETWORK" "$HOURLY_PARTITIONING" "$DATABASE" "$NEXT_DATE"; then
            yq e ".tables |= map(select(.name == \"$TABLE\").networks.$NETWORK.from = \"$NEXT_DATE\")" -i "$CONFIG_FILE"
            log "Start date for $DATABASE.$TABLE on $NETWORK is now $NEXT_DATE"
            CURRENT_DATE="$NEXT_DATE"
            continue
        fi

        yq e ".tables |= map(select(.name == \"$TABLE\").networks.$NETWORK.from = \"$CURRENT_DATE\")" -i "$CONFIG_FILE"
        log "Start date for $DATABASE.$TABLE on $NETWORK is still $CURRENT_DATE"
        break
    done
}

# Function to determine the end date
determine_end_date() {
    local TABLE=$1
    local NETWORK=$2
    local HOURLY_PARTITIONING=$3
    local DATABASE=$4


    while : ; do
        CURRENT_DATE=$(yq e ".tables[] | select(.name == \"$TABLE\").networks.$NETWORK.to" "$CONFIG_FILE")
        if [[ "$CURRENT_DATE" == "null" || -z "$CURRENT_DATE" ]]; then
            CURRENT_DATE=$(date -u '+%Y-%m-%d')
        fi

        NEXT_DATE=$(date -u -d "$CURRENT_DATE + 1 day" '+%Y-%m-%d')
        if [[ "$NEXT_DATE" > "$(date -u '+%Y-%m-%d')" ]]; then
            log "No data available after $(date -u '+%Y-%m-%d') for $DATABASE.$TABLE on $NETWORK"
            yq e ".tables |= map(select(.name == \"$TABLE\").networks.$NETWORK.to = \"$CURRENT_DATE\")" -i "$CONFIG_FILE"
            log "End date for $DATABASE.$TABLE on $NETWORK is now $CURRENT_DATE"
            break
        fi

        if data_is_available "$TABLE" "$NETWORK" "$HOURLY_PARTITIONING" "$DATABASE" "$NEXT_DATE"; then
            yq e ".tables |= map(select(.name == \"$TABLE\").networks.$NETWORK.to = \"$NEXT_DATE\")" -i "$CONFIG_FILE"
            log "End date for $DATABASE.$TABLE on $NETWORK is now $NEXT_DATE"
            CURRENT_DATE="$NEXT_DATE"
            continue
        fi

        yq e ".tables |= map(select(.name == \"$TABLE\").networks.$NETWORK.to = \"$CURRENT_DATE\")" -i "$CONFIG_FILE"
        log "End date for $DATABASE.$TABLE on $NETWORK is still $CURRENT_DATE"
        break
    done
}

# Define the start date for the search
START_DATE=$(date -u '+%Y-%m-%d') # Set start date to today in UTC

for TABLE in $TABLES; do
    DATABASE=$(yq e ".tables[] | select(.name == \"$TABLE\").database" "$CONFIG_FILE")
    HOURLY_PARTITIONING=$(yq e ".tables[] | select(.name == \"$TABLE\").hourly_partitioning" "$CONFIG_FILE")
    NETWORKS=$(yq e ".tables[] | select(.name == \"$TABLE\").networks | keys" "$CONFIG_FILE" | yq e '.[]')
    for NETWORK in $NETWORKS; do
        log "Checking availability for $DATABASE.$TABLE on $NETWORK"

        determine_start_date "$TABLE" "$NETWORK" "$HOURLY_PARTITIONING" "$DATABASE"
        determine_end_date "$TABLE" "$NETWORK" "$HOURLY_PARTITIONING" "$DATABASE"
    done
done
