#need to use setwd() so we can run R script straight in Power BI
setwd("C:/Github Desktop/analyzing-and-visualizing-data-powerbi-davidson-college/week 3")

library(tidyverse)
library(readxl)

budgets <- read_excel("week_3_wrap_up.xlsx")

#let's check the highest actual expenditures vs. original budgets among departments (fund type descr)
expenditure_comparison <- budgets %>% filter(`Revenue or Expenditure` == "Expenditures") %>% group_by(`Fund Type Descr`) %>% summarise(original_budget = sum(`Original Budget`), actual_expenditure = sum(`Actuals`))

#now let's check revenue numbers
revenue_comparison <- budgets %>% filter(`Revenue or Expenditure` == "Revenues") %>% group_by(`Fund Type Descr`) %>% summarise(original_budget = sum(`Original Budget`), actual_expenditure = sum(`Actuals`))

#let's calculate the differences
expenditure_comparison <- expenditure_comparison %>% mutate(actual_vs_budget = original_budget - actual_expenditure)
revenue_comparison <- revenue_comparison %>% mutate(actual_vs_budget = original_budget - actual_expenditure)
