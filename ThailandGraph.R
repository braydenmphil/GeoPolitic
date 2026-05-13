library(tidyverse)
library(plotly)



# Ok so I am thinking of making some sort of plot showin govt spending
# and adding markers when theres a regime change

democracy_data <- readr::read_csv(
  'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2024/2024-11-05/democracy_data.csv'
)
masterSet <- read.csv("masterSet.csv")
spending<- read.csv("ThailandSpendingClean.csv")

thailand<- masterSet %>% 
  filter(country_name == "Thailand") %>% 
  left_join(spending, by = "year")

# years w/ regime change
regime_changes <- thailand %>% 
  arrange(year) %>% 
  mutate(prev_regime = lag(regime_category)) %>% 
  filter(regime_category != prev_regime, !is.na(prev_regime))

# Below is the code for the graph. Probably just copy and paste it into
# the dashboard.

thailand %>% plot_ly(
  x = ~year,
  y = ~govt_spending,
  type = "scatter",
  mode = "lines+markers",
  line = list(color = "#2A9D8F", width = 2),
  marker = list(color = "#2A9D8F", size = 5),
  hovertemplate = paste(
    "<b>Year:</b> %{x}<br>",
    "<b>Govt Spending:</b> %{y:.1f}% of GDP<br>",
    "<extra></extra>"
  )) %>% 
  add_segments(
    data = regime_changes,
    x = ~year, xend = ~year,
    y = min(thailand$govt_spending, na.rm = TRUE),
    yend = max(thailand$govt_spending, na.rm = TRUE),
    line = list(color = "#E63946", dash = "dot", width = 2),
    hovertemplate = paste("<b>Regime change:</b> %{x}<br><extra></extra>"),
    name = "Regime Change") %>% 
  layout(
    title = list(
      text = "Thailand Government Spending & Regime Changes Over Time",
      font = list(size = 16)),
    xaxis = list(title = "Year"),
    yaxis = list(title = "Government Spending (% of GDP)"),
    showlegend = TRUE
  )
