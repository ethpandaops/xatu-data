#!/bin/bash

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