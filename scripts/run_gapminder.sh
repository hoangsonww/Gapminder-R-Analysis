#!/usr/bin/env bash
# Executes the main analysis script

set -euo pipefail

echo "[$(date)] Running Gapminder analysis..."
Rscript Gapminder_Analysis.R
echo "[$(date)] Analysis complete."
