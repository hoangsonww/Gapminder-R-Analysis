.PHONY: all analysis report clean

# Default target
all: report

# Run the R script to generate and save all plots
analysis:
	bash scripts/run_gapminder.sh

# Render the RMarkdown report (depends on analysis)
report: analysis Gapminder_Analysis.Rmd
	Rscript -e "rmarkdown::render('Gapminder_Analysis.Rmd', output_file='Gapminder_report.html')"

# Remove generated files
clean:
	rm -f gap-*.png Gapminder_report.html
