# =================================================================================
# Gapminder_Analysis.R
#
# A comprehensive analysis of the Gapminder dataset, exploring global trends in
# life expectancy, GDP per capita, and population from 1952 to 2007.
#
# This script:
#  1. Installs & loads required packages
#  2. Loads the Gapminder data
#  3. Cleans & prepares key variables
#  4. Generates 12 visualizations, printing and saving each as gap-1.png ... gap-12.png:
#     - Global average life expectancy over time
#     - Global average GDP per capita over time
#     - Global total population over time
#     - Scatter: GDP vs. life expectancy
#     - Regression: life expectancy ~ log(GDP per capita)
#     - Top 10 countries by life expectancy (latest)
#     - Boxplot: life expectancy by continent
#     - Violin: GDP per capita by continent
#     - Time-series: life expectancy by continent
#     - Density: distribution of life expectancy
#     - Heatmap: life expectancy by year & continent
#     - Population bubble plot: GDP vs. life expectancy sized by population
#
# Usage:
#   Rscript Gapminder_Analysis.R
# =================================================================================

# 0. Install & load packages
pkgs <- c("ggplot2","dplyr","gapminder","scales","viridis","tidyr","forcats","zoo")
for(pkg in pkgs){
  if (!requireNamespace(pkg, quietly=TRUE)) install.packages(pkg)
}
lapply(pkgs, library, character.only=TRUE)

# 1. Load Gapminder data
data("gapminder")
gm <- gapminder

# 2. Prepare summary data
## 2.1 Latest snapshot (2007)
latest <- gm %>% filter(year == max(year))

## 2.2 Global aggregates by year
global_trends <- gm %>%
  group_by(year) %>%
  summarize(
    avg_lifeExp    = mean(lifeExp),
    avg_gdpPercap  = mean(gdpPercap),
    total_pop      = sum(pop),
    .groups = "drop"
  )

# 3. Plots

# 3.1 Global average life expectancy over time
p1 <- ggplot(global_trends, aes(year, avg_lifeExp)) +
  geom_line(color="steelblue", size=1) +
  labs(title="Global Average Life Expectancy Over Time",
       x="Year", y="Life Expectancy (years)") +
  theme_minimal()
print(p1)
ggsave("gap-1.png", p1, width=8, height=5)

# 3.2 Global average GDP per capita over time
p2 <- ggplot(global_trends, aes(year, avg_gdpPercap)) +
  geom_line(color="darkgreen", size=1) +
  scale_y_continuous(labels=dollar_format()) +
  labs(title="Global Average GDP per Capita Over Time",
       x="Year", y="GDP per Capita (USD)") +
  theme_minimal()
print(p2)
ggsave("gap-2.png", p2, width=8, height=5)

# 3.3 Global total population over time
p3 <- ggplot(global_trends, aes(year, total_pop/1e9)) +
  geom_line(color="purple", size=1) +
  labs(title="Global Total Population Over Time",
       x="Year", y="Population (billions)") +
  theme_minimal()
print(p3)
ggsave("gap-3.png", p3, width=8, height=5)

# 3.4 Scatter: GDP per Capita vs. Life Expectancy (latest)
p4 <- ggplot(latest, aes(gdpPercap, lifeExp)) +
  geom_point(alpha=0.7) +
  scale_x_log10(labels=dollar_format()) +
  labs(title="Life Expectancy vs. GDP per Capita (2007)",
       x="GDP per Capita (log scale)", y="Life Expectancy (years)") +
  theme_minimal()
print(p4)
ggsave("gap-4.png", p4, width=8, height=5)

# 3.5 Regression: lifeExp ~ log(gdpPercap)
model <- lm(lifeExp ~ log(gdpPercap), data=latest)
cat("\n===== Regression Summary: lifeExp ~ log(gdpPercap) =====\n")
print(summary(model))
p5 <- ggplot(latest, aes(log(gdpPercap), lifeExp)) +
  geom_point(alpha=0.5) +
  geom_smooth(method="lm", se=TRUE, color="darkred") +
  labs(title="Linear Regression: Life Expectancy ~ log(GDP per Capita)",
       x="log(GDP per Capita)", y="Life Expectancy") +
  theme_minimal()
print(p5)
ggsave("gap-5.png", p5, width=8, height=5)

# 3.6 Top 10 countries by life expectancy (2007)
top10_le <- latest %>%
  arrange(desc(lifeExp)) %>%
  slice_head(n=10)
p6 <- ggplot(top10_le, aes(fct_reorder(country, lifeExp), lifeExp)) +
  geom_col(fill="darkslateblue") +
  coord_flip() +
  labs(title="Top 10 Countries by Life Expectancy (2007)",
       x=NULL, y="Life Expectancy (years)") +
  theme_minimal()
print(p6)
ggsave("gap-6.png", p6, width=8, height=5)

# 3.7 Boxplot: life expectancy by continent (2007)
p7 <- ggplot(latest, aes(continent, lifeExp, fill=continent)) +
  geom_boxplot() +
  labs(title="Life Expectancy by Continent (2007)",
       x="Continent", y="Life Expectancy (years)") +
  theme_minimal() + theme(legend.position="none")
print(p7)
ggsave("gap-7.png", p7, width=8, height=5)

# 3.8 Violin: GDP per capita by continent (2007)
p8 <- ggplot(latest, aes(continent, gdpPercap, fill=continent)) +
  geom_violin() +
  scale_y_log10(labels=dollar_format()) +
  labs(title="GDP per Capita Distribution by Continent (2007)",
       x="Continent", y="GDP per Capita (log scale)") +
  theme_minimal() + theme(legend.position="none")
print(p8)
ggsave("gap-8.png", p8, width=8, height=5)

# 3.9 Life expectancy time-series by continent
p9 <- ggplot(gm, aes(year, lifeExp, color=continent)) +
  geom_line(stat="summary", fun="mean", size=1) +
  labs(title="Average Life Expectancy Over Time by Continent",
       x="Year", y="Life Expectancy (years)", color="Continent") +
  theme_minimal()
print(p9)
ggsave("gap-9.png", p9, width=8, height=5)

# 3.10 Density: distribution of life expectancy (2007)
p10 <- ggplot(latest, aes(lifeExp, fill=continent)) +
  geom_density(alpha=0.6) +
  labs(title="Density of Life Expectancy by Continent (2007)",
       x="Life Expectancy (years)", y="Density") +
  theme_minimal()
print(p10)
ggsave("gap-10.png", p10, width=8, height=5)

# 3.11 Heatmap: life expectancy by year & continent
heat_data <- gm %>%
  group_by(continent, year) %>%
  summarize(avg_le = mean(lifeExp), .groups="drop")
p11 <- ggplot(heat_data, aes(year, continent, fill=avg_le)) +
  geom_tile(color="white") +
  scale_fill_viridis(name="Avg Life Exp") +
  labs(title="Average Life Expectancy by Year & Continent",
       x="Year", y="Continent") +
  theme_minimal()
print(p11)
ggsave("gap-11.png", p11, width=8, height=5)

# 3.12 Bubble plot: GDP vs Life Expectancy sized by population (2007)
p12 <- ggplot(latest, aes(gdpPercap, lifeExp, size=pop, color=continent)) +
  geom_point(alpha=0.6) +
  scale_x_log10(labels=dollar_format()) +
  scale_size_continuous(labels=scales::comma_format(scale=1e-6),
                        name="Population\n(millions)") +
  labs(title="Life Expectancy vs GDP per Capita (2007) Sized by Population",
       x="GDP per Capita (log scale)", y="Life Expectancy") +
  theme_minimal()
print(p12)
ggsave("gap-12.png", p12, width=8, height=5)

# End of Gapminder_Analysis.R
