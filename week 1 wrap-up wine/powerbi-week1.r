#need to use setwd() so we can run R script straight in Power BI
setwd("C:/Github Desktop/analyzing-and-visualizing-data-powerbi-davidson-college/week 1 wrap-up wine")

library(tidyverse)

winemag <- read_csv("winemag-data-130k-v2.csv")

sum_points_country <- winemag %>% group_by(country) %>% summarize(total_points = sum(points))
sum_points_winery <- winemag %>% group_by(winery) %>% summarize(total_points = sum(points))
sum_points_region_1 <- winemag %>% group_by(region_1) %>% summarize(total_points = sum(points))
sum_points_region_2 <- winemag %>% group_by(region_2) %>% summarize(total_points = sum(points))

sum_price_variety <- winemag %>% group_by(variety) %>% summarize(cost = sum(price))

average_points_country <- winemag %>% group_by(country) %>% summarize(average_points = mean(points))

min_points_country <- winemag %>% group_by(country) %>% summarize(min_points = min(points))
max_points_country <- winemag %>% group_by(country) %>% summarize(max_points = max(points))

dfs <- list(sum_points_country,average_points_country,min_points_country,max_points_country)

points <- dfs %>% reduce(inner_join, by = "country")