#!/bin/bash

# This script generates both llms.txt and llms-full.txt files

set -e

# Run the generation script
./generate-llmstxt.sh

echo "Both llms.txt and llms-full.txt have been generated successfully."