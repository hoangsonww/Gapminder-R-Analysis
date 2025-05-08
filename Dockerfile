# Use an R base image
FROM r-base:4.3.2

# System dependencies (if needed)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev libssl-dev libxml2-dev

# Install R packages
RUN R -e "install.packages(c('ggplot2','dplyr','gapminder','scales','viridis','tidyr','forcats','rmarkdown'), repos='https://cloud.r-project.org/')"

WORKDIR /app
COPY . .

# Default command: run analysis then render report
CMD ["bash", "-lc", "bash scripts/run_gapminder.sh && bash scripts/render_report.sh"]
