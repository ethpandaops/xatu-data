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
            # If the date is before December 2022, break the loop
            if [[ "$CURRENT_DATE" < "2022-12-01" ]]; then
                log "❌❌❌ Data not available for $DATABASE.$TABLE on $NETWORK"
                break
            fi
            
            YEAR=$(date -d "$CURRENT_DATE" '+%Y')
            MONTH=$(date -d "$CURRENT_DATE" '+%-m')
            DAY=$(date -d "$CURRENT_DATE" '+%-d')
            BASE_URL="https://data.ethpandaops.io/xatu/$NETWORK/databases/$DATABASE/$TABLE"
            if [[ "$HOURLY_PARTITIONING" == "true" ]]; then
                URL="$BASE_URL/$YEAR/$MONTH/$DAY/0.parquet"
            else
                URL="$BASE_URL/$YEAR/$MONTH/$DAY.parquet"
            fi

            # Initialize retry counter
            RETRY_COUNT=0

            # Loop to retry the curl command
            while : ; do
                if ! HTTP_STATUS=$(curl --head --connect-timeout 5 --max-time 10 --silent --write-out "%{http_code}" --output /dev/null "$URL"); then
                    log "Error executing curl command for $URL. Retrying..."
                    RETRY_COUNT=$((RETRY_COUNT+1))
                    if [ "$RETRY_COUNT" -ge 20 ]; then
                        log "❌ Failed to execute curl command after 20 retries for $URL"
                        break 2
                    fi
                    sleep 1
                    continue
                fi

                if [[ "$HTTP_STATUS" == "200" ]]; then
                    if [ -z "$FROM_DATE" ]; then
                        log "✅ Data available for $CURRENT_DATE for $TABLE on $NETWORK"
                        FROM_DATE="$CURRENT_DATE"
                    fi
                    DATA_FOUND=true
                    break
                elif [[ "$HTTP_STATUS" == "404" ]]; then
                    if [ "$DATA_FOUND" = true ]; then
                        log "❌ Data not available for $CURRENT_DATE for $TABLE on $NETWORK"
                        TO_DATE=$(date -d "$CURRENT_DATE + 1 day" '+%Y-%m-%d')
                        break 2
                    fi
                    break
                else
                    log "Received HTTP status $HTTP_STATUS for $URL. Retrying..."
                    RETRY_COUNT=$((RETRY_COUNT+1))
                    if [ "$RETRY_COUNT" -ge 20 ]; then
                        log "❌ Failed to get a valid response after 20 retries for $URL"
                        break 2
                    fi
                    sleep 1
                fi
            done

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
