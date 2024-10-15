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
FROM="$4"
TO="${5:-$FROM}"

usage() {
    echo "Usage: $0 NETWORK DATABASE TABLE FROM [TO]"
    echo "NETWORK: Name of the network."
    echo "DATABASE: Name of the database."
    echo "TABLE: Name of the table."
    echo "FROM: date (in format YYYY-MM-DD) or integer."
    echo "TO: (Optional) date (in format YYYY-MM-DD) or integer. Defaults to FROM if not provided."
    exit 1
}

# Validate parameters
if [[ -z "$DATABASE" || -z "$NETWORK" || -z "$TABLE" || -z "$FROM" ]]; then
    usage
fi

# Path to config file
CONFIG_FILE="./config.yaml"

PARTITIONING_COLUMN=$(yq e ".tables[] | select(.name == \"$TABLE\").partitioning.column" "$CONFIG_FILE")
PARTITIONING_TYPE=$(yq e ".tables[] | select(.name == \"$TABLE\").partitioning.type" "$CONFIG_FILE")
PARTITIONING_INTERVAL=$(yq e ".tables[] | select(.name == \"$TABLE\").partitioning.interval" "$CONFIG_FILE")

if [[ "$PARTITIONING_TYPE" == "integer" ]]; then
    # Validate integer format (0-999999999)
    if ! [[ "$FROM" =~ ^[0-9]+$ ]] || ! [[ "$TO" =~ ^[0-9]+$ ]]; then
        echo "Error: FROM and TO must be integers."
        usage
    fi
elif [[ "$PARTITIONING_TYPE" == "datetime" ]]; then
    # Validate date format (YYYY-MM-DD)
    if ! [[ "$FROM" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || ! [[ "$TO" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "Error: FROM and TO must be in format YYYY-MM-DD."
        usage
    fi
fi

# Ensure yq is installed
if ! command -v yq &> /dev/null; then
    log "Required command 'yq' is not installed. Please install it to proceed."
    exit 1
fi

# Check if table exists
log "Checking if table '$TABLE' exists in the configuration..."

if [[ -z $(yq e ".tables[] | select(.name == \"$TABLE\")" "$CONFIG_FILE") ]]; then
    log "Table '$TABLE' does not exist in the configuration."
    exit 1
fi

log "Extracting prefixes of datasets available for public access..."

# Use yq to extract prefixes of datasets that have 'public' in their availability
PREFIXES=$(yq e '
  .datasets[]
  | select(.availability[] == "public")
  | .tables.prefix
' "$CONFIG_FILE")

if [[ -z "$PREFIXES" ]]; then
    log "❌ No datasets are marked as public in the configuration."
    exit 1
fi

log "Checking if table '$TABLE' matches any public dataset prefixes..."

MATCH_FOUND=false
MATCHED_DATASET=""

# Iterate over each prefix to find a match
while IFS= read -r prefix; do
    if [[ "$TABLE" == "$prefix"* ]]; then
        MATCH_FOUND=true
        # Retrieve the dataset name corresponding to the matched prefix
        MATCHED_DATASET=$(yq e "
          .datasets[]
          | select(.tables.prefix == \"$prefix\")
          | .name
        " "$CONFIG_FILE")
        break  # Stop after the first match
    fi
done <<< "$PREFIXES"

log "Matched dataset: $MATCHED_DATASET"
log "Matched found: $MATCH_FOUND"

if $MATCH_FOUND; then
    log "✅ Table '$TABLE' is available for public access in dataset: '$MATCHED_DATASET'."
else
    log "❌ Table '$TABLE' is not available for public access."
    exit 1
fi

echo "We will use the following configuration:"
echo "----"
echo "Network: $NETWORK"
echo "Database: $DATABASE"
echo "Table: $TABLE"
echo "From: $FROM"
echo "To: $TO"
echo "----"
echo "You are about to insert data into the ClickHouse cluster that the 'clickhouse client' will connect to."
echo "You can edit the following CLICKHOUSE_ environment variables to change to a different cluster:"
echo "CLICKHOUSE_HOST, CLICKHOUSE_PORT, CLICKHOUSE_USER, CLICKHOUSE_PASSWORD"
read -p "Do you want to proceed? (y/n): " proceed

if [[ "$proceed" != "y" ]]; then
    echo "Operation cancelled by the user."
    exit 1
fi

if [[ "$PARTITIONING_TYPE" == "datetime" ]]; then
    # Loop through each day from FROM to TO
    CURRENT_DATE="$FROM"
    while [[ "$CURRENT_DATE" != $(date -d "$TO + 1 day" '+%Y-%m-%d') ]]; do
        # Log start of process for CURRENT_DATE
        log "Starting to import $CURRENT_DATE for $DATABASE.$TABLE on $NETWORK."

        # Define base URL for data and adjust based on interval
        BASE_URL="https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE"
        YEAR=$(date -d "$CURRENT_DATE" '+%Y')
        MONTH=$(date -d "$CURRENT_DATE" '+%-m')
        DAY=$(date -d "$CURRENT_DATE" '+%-d')

        if [[ "$PARTITIONING_INTERVAL" == "hourly" ]]; then
            for HOUR in {0..23}; do
                URL="$BASE_URL/$YEAR/$MONTH/$DAY/$HOUR.parquet"
                # Construct and execute the INSERT query
                QUERY="INSERT INTO $DATABASE.$TABLE SELECT * FROM url('$URL', 'Parquet')"
                log "Inserting data from $URL into $TABLE."
                log "Query: $QUERY"
                clickhouse_query "$QUERY"
            done
        else
            URL="$BASE_URL/$YEAR/$MONTH/$DAY.parquet"
            # Construct and execute the INSERT query
            QUERY="INSERT INTO $DATABASE.$TABLE SELECT * FROM url('$URL', 'Parquet')"
            log "Inserting data from $URL into $TABLE."
            log "Query: $QUERY"
            clickhouse_query "$QUERY"
        fi

        # Move to the next date
        CURRENT_DATE=$(date -d "$CURRENT_DATE + 1 day" '+%Y-%m-%d')
    done
elif [[ "$PARTITIONING_TYPE" == "integer" ]]; then
    FROM_INTEGER=$(( (FROM / PARTITIONING_INTERVAL) * PARTITIONING_INTERVAL ))
    TO_INTEGER=$(( (TO / PARTITIONING_INTERVAL) * PARTITIONING_INTERVAL ))

    # Loop through each partition from FROM_INTEGER to TO_INTEGER
    CURRENT_PARTITION=$FROM_INTEGER
    while [[ $CURRENT_PARTITION -le $TO_INTEGER ]]; do
        URL="https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE/$PARTITIONING_INTERVAL/$CURRENT_PARTITION.parquet"
        
        # Construct and execute the INSERT query
        QUERY="INSERT INTO $DATABASE.$TABLE SELECT * FROM url('$URL', 'Parquet')"
        log "Inserting data from $URL into $TABLE."
        log "Query: $QUERY"
        clickhouse_query "$QUERY"

        # Move to the next partition
        CURRENT_PARTITION=$((CURRENT_PARTITION + PARTITIONING_INTERVAL))
    done
fi

log "Completed processing from $FROM to $TO for $DATABASE.$TABLE on $NETWORK"
