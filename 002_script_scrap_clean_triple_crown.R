# Libraries ----
library(tidyverse)
library(rvest)

# Data source ----
## MBA Today
## https://www.mba.today/ > 
## Accreditation > 
## Focus on the Triple Accreditation: Standing out from the Crowd
### Direct link: https://www.mba.today/guide/triple-accreditation-business-schools

# Scrap ----
url <- "https://www.mba.today/guide/triple-accreditation-business-schools"
html <- read_html(x = url)

## Regions
regions <- html |> 
  html_elements(css = "#myTab") |> 
  html_elements(css = "a") |> 
  html_text()

## Business Schools
class_tab_content <- html |> 
  html_elements(css = ".tab-content")

## Define ids
ids <- class_tab_content |> 
  html_elements(css = "div") |> 
  html_attr(name = "id")

## Apply a loop
tibble_ls <- vector(mode = "list", 
                    length = length(seq_along(ids)))

for (i in seq_along(tibble_ls)) {
  tbl <- class_tab_content |> 
    html_elements(css = str_glue("#{ids[i]}")) |> 
    html_elements(css = "li") |> 
    html_text() |> 
    tibble(name = _,
           region = regions[i])
  tibble_ls[[i]] <- tbl
    print(str_glue("{regions[i]}: {nrow(tbl)}"))
}

# Final data ----
## See last update in: https://www.mba.today/guide/triple-accreditation-business-schools
## 2024-01-28
triple_crown <- bind_rows(tibble_ls)

# Export ----
triple_crown |> 
  write_csv(file = "000_clean_data/admon_triple_crown.csv")
