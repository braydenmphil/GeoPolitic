library(tidyverse)
spending<-read.csv("ThailandSpending.csv")

spending<- spending %>% 
  slice(1) %>% 
  mutate(across(-Series.Name, as.double)) %>%
  pivot_longer(
    cols = -Series.Name,
    names_to = "year",
    values_to = "value"
  ) %>%
  mutate(year = as.integer(str_extract(year, "\\d{4}"))) %>% 
  filter(!is.na(year) & !is.na(value)) %>% 
  rename(govt_spending = value) %>% 
  select(-Series.Name) %>% 
  write_csv("ThailandSpendingClean.csv")
