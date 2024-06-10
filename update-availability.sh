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
        return 1
    else
        return 0
    fi
}

# Define the start date for the search
START_DATE=$(date -u '+%Y-%m-%d') # Set start date to today in UTC

for TABLE in $TABLES; do
    DATABASE=$(yq e ".tables[] | select(.name == \"$TABLE\").database" "$CONFIG_FILE")
    HOURLY_PARTITIONING=$(yq e ".tables[] | select(.name == \"$TABLE\").hourly_partitioning" "$CONFIG_FILE")
    NETWORKS=$(yq e ".tables[] | select(.name == \"$TABLE\").networks | keys" "$CONFIG_FILE" | yq e '.[]')
    for NETWORK in $NETWORKS; do
        log "Checking availability for $DATABASE.$TABLE on $NETWORK"

        # Determine the start date
        EXISTING_START_DATE=$(yq e ".tables[] | select(.name == \"$TABLE\").networks.$NETWORK.from" "$CONFIG_FILE")
        if [[ "$EXISTING_START_DATE" == "null" ]]; then
            log "No existing start date found for $DATABASE.$TABLE on $NETWORK, using $START_DATE as the start date"
            EXISTING_START_DATE="$START_DATE"
        else
            log "Existing start date for $DATABASE.$TABLE on $NETWORK is $EXISTING_START_DATE"
        fi

        START_DATE_FOUND=""
        CURRENT_DATE="$EXISTING_START_DATE"
        while : ; do
            if [[ "$CURRENT_DATE" < "2020-01-01" ]]; then
                log "No data available before 2020-01-01 for $DATABASE.$TABLE on $NETWORK"
                break
            fi

            if data_is_available "$TABLE" "$NETWORK" "$HOURLY_PARTITIONING" "$DATABASE" "$CURRENT_DATE"; then
                START_DATE_FOUND=$(date -u -d "$CURRENT_DATE + 1 day" '+%Y-%m-%d')
                break
            fi

            CURRENT_DATE=$(date -u -d "$CURRENT_DATE - 1 day" '+%Y-%m-%d')
        done

        # Determine the end date
        EXISTING_END_DATE=$(yq e ".tables[] | select(.name == \"$TABLE\").networks.$NETWORK.to" "$CONFIG_FILE")
        if [[ "$EXISTING_END_DATE" == "null" ]]; then
            log "No existing end date found for $DATABASE.$TABLE on $NETWORK, using $START_DATE as the end date"
            EXISTING_END_DATE="$START_DATE"
        else
            log "Existing end date for $DATABASE.$TABLE on $NETWORK is $EXISTING_END_DATE"
        fi

        END_DATE_FOUND=""
        CURRENT_DATE="$EXISTING_END_DATE"
        while : ; do
            if [[ "$CURRENT_DATE" > "$(date -u '+%Y-%m-%d')" ]]; then
                log "No data available after $(date -u '+%Y-%m-%d') for $DATABASE.$TABLE on $NETWORK"
                break
            fi

            if data_is_available "$TABLE" "$NETWORK" "$HOURLY_PARTITIONING" "$DATABASE" "$CURRENT_DATE"; then
                END_DATE_FOUND=$(date -u -d "$CURRENT_DATE - 1 day" '+%Y-%m-%d')
                break
            fi

            CURRENT_DATE=$(date -u -d "$CURRENT_DATE + 1 day" '+%Y-%m-%d')
        done

        if [ -n "$START_DATE_FOUND" ] && [ -n "$END_DATE_FOUND" ]; then
            log "Data exists in $DATABASE.$TABLE on $NETWORK from $START_DATE_FOUND to $END_DATE_FOUND"
            yq e ".tables |= map(select(.name == \"$TABLE\").networks.$NETWORK.from = \"$START_DATE_FOUND\")" -i "$CONFIG_FILE"
            yq e ".tables |= map(select(.name == \"$TABLE\").networks.$NETWORK.to = \"$END_DATE_FOUND\")" -i "$CONFIG_FILE"
            
            # Log if the start date has changed
            if [[ "$EXISTING_START_DATE" != "$START_DATE_FOUND" ]]; then
                log "Start date for $DATABASE.$TABLE on $NETWORK has changed from $EXISTING_START_DATE to $START_DATE_FOUND"
            fi

            # Log if the end date has changed
            if [[ "$EXISTING_END_DATE" != "$END_DATE_FOUND" ]]; then
                log "End date for $DATABASE.$TABLE on $NETWORK has changed from $EXISTING_END_DATE to $END_DATE_FOUND"
            fi
        fi
    done
done
