#!/bin/bash

# Import dep scripts
source ./scripts/log.sh

set -e

# Path to config file
CONFIG_FILE="./config.yaml"

# Ensure yq is installed
if ! command -v yq &> /dev/null; then
    log "Required command 'yq' is not installed. Please install it to proceed."
    exit 1
fi

# Check if running on macOS and use gdate if available
if [[ "$(uname)" == "Darwin" ]]; then
    if command -v gdate &> /dev/null; then
        date() {
            gdate "$@"
        }
    else
        log "GNU date (gdate) is not installed. Please install it using 'brew install coreutils' to ensure compatibility."
        exit 1
    fi
fi

# Read tables from config.yaml
TABLES=$(yq e '.tables[].name' "$CONFIG_FILE")

# Define the start date for the search
START_DATE=$(date '+%Y-%m-%d') # Set start date to today

for TABLE in $TABLES; do
    DATABASE=$(yq e ".tables[] | select(.name == \"$TABLE\").database" "$CONFIG_FILE")
    HOURLY_PARTITIONING=$(yq e ".tables[] | select(.name == \"$TABLE\").hourly_partitioning" "$CONFIG_FILE")
    NETWORKS=$(yq e ".tables[] | select(.name == \"$TABLE\").networks | keys" "$CONFIG_FILE" | yq e '.[]')
    for NETWORK in $NETWORKS; do
        CURRENT_DATE="$START_DATE"
        DATA_FOUND=false
        FROM_DATE=""
        TO_DATE=""
        log "Checking availability for $DATABASE.$TABLE on $NETWORK"
        while : ; do
            YEAR=$(date -d "$CURRENT_DATE" '+%Y')
            MONTH=$(date -d "$CURRENT_DATE" '+%-m')
            DAY=$(date -d "$CURRENT_DATE" '+%-d')
            BASE_URL="https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE"
            if [[ "$HOURLY_PARTITIONING" == "true" ]]; then
                URL="$BASE_URL/$YEAR/$MONTH/$DAY/0.parquet"
            else
                URL="$BASE_URL/$YEAR/$MONTH/$DAY.parquet"
            fi

            # Fire a HTTP HEAD request to check availability for the day
            if curl --head --silent --fail "$URL" > /dev/null; then
                if [ -z "$FROM_DATE" ]; then
                    log "✅ Data available for $CURRENT_DATE for $TABLE on $NETWORK"
                    FROM_DATE="$CURRENT_DATE"
                fi
                DATA_FOUND=true
            else
                if [ "$DATA_FOUND" = true ]; then
                    log "❌ Data not available for $CURRENT_DATE for $TABLE on $NETWORK"
                    TO_DATE=$(date -d "$CURRENT_DATE + 1 day" '+%Y-%m-%d')
                    break
                fi
            fi
            # Move to the next date
            CURRENT_DATE=$(date -d "$CURRENT_DATE - 1 day" '+%Y-%m-%d')
        done
        if [ -n "$FROM_DATE" ] && [ -n "$TO_DATE" ]; then
            log "Data exists in $DATABASE.$TABLE on $NETWORK from $FROM_DATE to $TO_DATE"
            # Swap FROM and TO dates so they're more human readable
            
            FROM_CMD="yq e \".tables |= map(select(.name == \\\"$TABLE\\\").networks.$NETWORK.to = \\\"$FROM_DATE\\\")\" -i \"$CONFIG_FILE\""
            TO_CMD="yq e \".tables |= map(select(.name == \\\"$TABLE\\\").networks.$NETWORK.from = \\\"$TO_DATE\\\")\" -i \"$CONFIG_FILE\""
            eval $FROM_CMD
            eval $TO_CMD
        fi
    done
done
