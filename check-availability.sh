#!/bin/bash

# Import dep scripts
source ./scripts/log.sh
source ./scripts/date.sh

set -e

# Script parameters
NETWORK="$1"
DATABASE="$2"
TABLE="$3"
START_DATE="$4"
END_DATE="${5:-$START_DATE}"

usage() {
    echo "Usage: $0 DATABASE TABLE NETWORK START_DATE [END_DATE]"
    echo "NETWORK: Name of the network."
    echo "DATABASE: Name of the database."
    echo "TABLE: Name of the table."
    echo "START_DATE: Start date in format YYYY-MM-DD."
    echo "END_DATE: (Optional) End date in format YYYY-MM-DD. Defaults to START_DATE if not provided."
    exit 1
}

# Validate parameters
if [[ -z "$DATABASE" || -z "$NETWORK" || -z "$TABLE" || -z "$START_DATE" ]]; then
    usage
fi

# Validate date format (YYYY-MM-DD)
if ! [[ "$START_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || ! [[ "$END_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Error: START_DATE and END_DATE must be in format YYYY-MM-DD."
    usage
fi

# Path to config file
CONFIG_FILE="./config.yaml"

# Ensure yq is installed
if ! command -v yq &> /dev/null; then
    log "Required command 'yq' is not installed. Please install it to proceed."
    exit 1
fi

# Read table configuration from config.yaml
HOURLY_PARTITIONING=$(yq e ".tables[] | select(.name == \"$TABLE\").hourly_partitioning" "$CONFIG_FILE")

# Initialize counters
available_days=0
unavailable_days=0

# Loop through each day from START_DATE to END_DATE
CURRENT_DATE="$START_DATE"
while [[ "$CURRENT_DATE" != $(date -d "$END_DATE + 1 day" '+%Y-%m-%d') ]]; do
    # Define base URL for data and adjust based on interval
    BASE_URL="https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE"
    YEAR=$(date -d "$CURRENT_DATE" '+%Y')
    MONTH=$(date -d "$CURRENT_DATE" '+%-m')
    DAY=$(date -d "$CURRENT_DATE" '+%-d')

    if [[ "$HOURLY_PARTITIONING" == "true" ]]; then
        for HOUR in {0..23}; do
            URL="$BASE_URL/$YEAR/$MONTH/$DAY/$HOUR.parquet"
            # Fire a HTTP HEAD request to check availability for each hour
            if curl --head --silent --fail "$URL" > /dev/null; then
                log "✅ Data available for $CURRENT_DATE at hour $HOUR"
                ((available_days++))
            else
                log "❌ Data not available for $CURRENT_DATE at hour $HOUR"
                ((unavailable_days++))
            fi
        done
    else
        URL="$BASE_URL/$YEAR/$MONTH/$DAY.parquet"
        # Fire a HTTP HEAD request to check availability for the day
        if curl --head --silent --fail "$URL" > /dev/null; then
            log "✅ Data available for $CURRENT_DATE"
            ((available_days++))
        else
            log "❌ Data not available for $CURRENT_DATE"
            ((unavailable_days++))
        fi
    fi

    # Move to the next date
    CURRENT_DATE=$(date -d "$CURRENT_DATE + 1 day" '+%Y-%m-%d')
done

log "Summary: $available_days available, $unavailable_days not available from $START_DATE to $END_DATE for $DATABASE.$TABLE on $NETWORK"
