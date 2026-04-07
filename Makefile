.PHONY: install test lint format export-local export-all-local export-dev clean help

# Default target
.DEFAULT_GOAL := help

# Python interpreter
PYTHON := python3

# Install dependencies
install:  ## Install dependencies
	$(PYTHON) -m pip install -e ".[dev]"

# Run tests
test:  ## Run tests
	pytest tests/ -v

# Lint code
lint:  ## Run linting
	ruff check src/ scripts/ tests/
	mypy src/ scripts/ --ignore-missing-imports

# Format code
format:  ## Format code
	black src/ scripts/ tests/
	ruff check src/ scripts/ tests/ --fix

# Export single table locally (example)
export-local:  ## Export single table locally (dry-run)
	$(PYTHON) scripts/export_table.py \
		-e staging \
		-t beacon_api_eth_v1_events_block \
		-n mainnet \
		-d 2024-05-30 \
		--dry-run

# Test export all for yesterday
export-all-local:  ## Export all daily tables locally (dry-run)
	$(PYTHON) scripts/export_all.py \
		-e staging \
		-g daily \
		--dry-run

# Run with local config override
export-dev:  ## Export with dev config (TABLE=table_name NETWORK=network)
	XATU_CONFIG_PATH=config/dev-override.yaml \
	$(PYTHON) scripts/export_table.py -e staging -t $(TABLE) -n $(NETWORK)

# Clean up
clean:  ## Clean up temporary files
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf .pytest_cache
	rm -rf .mypy_cache
	rm -rf .ruff_cache

# Development setup
dev-setup:  ## Set up development environment
	$(PYTHON) -m venv venv
	. venv/bin/activate && $(PYTHON) -m pip install --upgrade pip
	. venv/bin/activate && $(PYTHON) -m pip install -e ".[dev]"
	@echo "Run 'source venv/bin/activate' to activate the virtual environment"

# Help
help:  ## Show this help message
	@echo 'Usage:'
	@echo '  make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)