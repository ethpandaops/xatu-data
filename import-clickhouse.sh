#!/bin/bash

# Import dep scripts
source ./scripts/clickhouse.sh
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
if [[ -z "$DATABASE" ]]; then
    echo "Error: DATABASE parameter not provided."
    usage
fi

if [[ -z "$NETWORK" ]]; then
    echo "Error: NETWORK parameter not provided."
    usage
fi

if [[ -z "$TABLE" ]]; then
    echo "Error: TABLE parameter not provided."
    usage
fi

if [[ -z "$START_DATE" ]]; then
    echo "Error: START_DATE parameter not provided."
    usage
fi

# Validate date format (YYYY-MM-DD)
if ! [[ "$START_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Error: START_DATE must be in format YYYY-MM-DD."
    usage
fi

if ! [[ "$END_DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Error: END_DATE must be in format YYYY-MM-DD."
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

# Loop through each day from START_DATE to END_DATE
CURRENT_DATE="$START_DATE"
while [[ "$CURRENT_DATE" != $(date -d "$END_DATE + 1 day" '+%Y-%m-%d') ]]; do
    # Log start of process for CURRENT_DATE
    log "Starting to import $CURRENT_DATE for $DATABASE.$TABLE on $NETWORK."

    # Define base URL for data and adjust based on partitioning
    BASE_URL="https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE"
    YEAR=$(date -d "$CURRENT_DATE" '+%Y')
    MONTH=$(date -d "$CURRENT_DATE" '+%-m')
    DAY=$(date -d "$CURRENT_DATE" '+%-d')
    URL="$BASE_URL/$YEAR/$MONTH/$DAY"
    URL+=$([[ "$HOURLY_PARTITIONING" == "true" ]] && echo "/{0..23}" || echo "")
    URL+=".parquet"

    # Construct and execute the INSERT query
    QUERY="INSERT INTO $DATABASE.$TABLE SELECT * FROM url('$URL', 'Parquet')"
    log "Inserting data from $URL into $TABLE."
    log "Query: $QUERY"
    clickhouse_query "$QUERY"

    # Move to the next date
    CURRENT_DATE=$(date -d "$CURRENT_DATE + 1 day" '+%Y-%m-%d')
done

log "Completed processing from $START_DATE to $END_DATE for $DATABASE.$TABLE on $NETWORK"
