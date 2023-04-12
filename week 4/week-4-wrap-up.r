#need to use setwd() so we can run R script straight in Power BI
setwd("C:/Github Desktop/analyzing-and-visualizing-data-powerbi-davidson-college/week 4")

library(tidyverse)
library(lubridate)

confirmed_global <- read_csv("confirmed_global.csv")
deaths_global <- read_csv("deaths_global.csv")
recovered_global <- read_csv("recovered_global.csv")

#let's pivot all of them, transform the date data type, and group them by country
confirmed_global <- confirmed_global %>% pivot_longer(names_to = "date", values_to = "total_confirmed", "1/22/20":"3/9/23")

confirmed_global$date <- mdy(confirmed_global$date)

confirmed_global <- confirmed_global %>% group_by(`Country/Region`, date) %>% summarise(total_confirmed_grouped = sum(total_confirmed))

deaths_global <- deaths_global %>% pivot_longer(names_to = "date", values_to = "total_deaths", "1/22/20":"3/9/23")

deaths_global$date <- mdy(deaths_global$date)

deaths_global <- deaths_global %>% group_by(`Country/Region`, date) %>% summarise(total_deaths_grouped = sum(total_deaths))

recovered_global <- recovered_global %>% pivot_longer(names_to = "date", values_to = "total_recovered", "1/22/20":"3/9/23")

recovered_global$date <- mdy(recovered_global$date)

recovered_global <- recovered_global %>% group_by(`Country/Region`, date) %>% summarise(total_recovered_grouped = sum(total_recovered))

#let's calculate daily new count
confirmed_global$new_daily_case <- c(confirmed_global$total_confirmed_grouped[1], diff(confirmed_global$total_confirmed_grouped))

confirmed_global$new_daily_case <- ifelse(confirmed_global$new_daily_case < 0, 0, confirmed_global$new_daily_case)


deaths_global$new_daily_deaths <- c(deaths_global$total_deaths_grouped[1], diff(deaths_global$total_deaths_grouped))

deaths_global$new_daily_deaths <- ifelse(deaths_global$new_daily_deaths < 0, 0, deaths_global$new_daily_deaths)


recovered_global$new_daily_recovered <- c(recovered_global$total_recovered_grouped[1], diff(recovered_global$total_recovered_grouped))

recovered_global$new_daily_recovered <- ifelse(recovered_global$new_daily_recovered < 0, 0, recovered_global$new_daily_recovered)

#let's calculate the 7 days average
library(zoo)
confirmed_global <- confirmed_global %>% mutate(Daily_New_Cases_7_Day_Avg = rollmeanr(new_daily_case, 7, fill = NA))
deaths_global <- deaths_global %>% mutate(Daily_New_Deaths_7_Day_Avg = rollmeanr(new_daily_deaths, 7, fill = NA))
recovered_global <- recovered_global %>% mutate(Daily_New_Cases_7_Day_Avg = rollmeanr(new_daily_recovered, 7, fill = NA))
