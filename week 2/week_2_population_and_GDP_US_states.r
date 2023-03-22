#need to use setwd() so we can run R script straight in Power BI
setwd("C:/Github Desktop/analyzing-and-visualizing-data-powerbi-davidson-college/week 2")

library(tidyverse)
library(readxl)

#load all the needed datasets
population <- read_excel("Week_2_US_States_Population_by_Year.xlsx")
gdp <- read_excel("Week_2_US_States_GDP_by_Year.xlsx")
states_info <- read_csv("Week_2_US_States_2_fixed.csv")

#pivot longer to make it readable later in Power BI
gdp_pivot <- gdp %>% pivot_longer(names_to = "state", values_to = "gdp_value", "Alabama":"Wyoming") %>% arrange(state, Year)

#let's multiply each value by 1,000,000 as instructed
gdp_pivot <- gdp_pivot %>% mutate(gdp_actual_value = gdp_value*1000000) %>% select(-gdp_value)

#let's use pivot_longer but for population this time
population_pivot <- population %>% pivot_longer(names_to = "state", values_to = "population_number", "AL":"DC") %>% arrange(state, Year)

#let's use left_join to get the state code for gdp_pivot
gdp_pivot_updated <- left_join(gdp_pivot, states_info, by = c("state"="name")) %>% select(Year, state, gdp_actual_value, abbreviation)

#let's create GDP per capita
gdp_and_population <- inner_join(gdp_pivot_updated, population_pivot, by = c("abbreviation"="state", "Year"="Year")) %>% mutate(gdp_per_capita = gdp_actual_value/population_number) %>% arrange(abbreviation, Year)

#now, let's calculate Population Growth
first_year <- min(gdp_and_population$Year)
latest_year <- max(gdp_and_population$Year)

first_year_pop <- gdp_and_population %>% filter(Year == first_year) %>% pull(population_number)
latest_year_pop <- gdp_and_population %>% filter(Year == latest_year) %>% pull(population_number)

population_growth <- (latest_year_pop - first_year_pop) / first_year_pop

population_growth_df <- states_info %>% select(name, abbreviation) %>% arrange(abbreviation)

#states_info list DC as a state and WA as another state, which is wrong. We need to fix this before we put population_growth into the data frame
row_to_remove <- 8
population_growth_df <- population_growth_df[-row_to_remove, ]

population_growth_df <- population_growth_df %>% mutate(pop_growth = population_growth)