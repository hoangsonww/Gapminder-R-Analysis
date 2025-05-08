#!/usr/bin/env bash
# Renders the RMarkdown report from the analysis

set -euo pipefail

echo "[$(date)] Rendering Gapminder report..."
Rscript -e "rmarkdown::render('Gapminder_Analysis.Rmd', output_file='Gapminder_report.html')"
echo "[$(date)] Report ready: Gapminder_report.html"
