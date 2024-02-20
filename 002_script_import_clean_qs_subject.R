# Libraries ----
library(tidyverse)
library(readxl)
library(janitor)
library(fuzzyjoin)

# Data source ----
## QS World University Rankings 
## https://www.topuniversities.com/ > 
## RANKINGS > 
## QS World University Rankings by subject >
## Social Sciences & Management >
## Business and Management Studies >
## Excel Results Table 

# Import ----
## Year: 2023
## By subject
### Business
qs_business <- read_excel(path = "000_raw_data/002_2023_qs_wur_subject.xlsx", 
                          sheet = "Business",
                          range = "A13:I593") |> 
  clean_names()

admon_triple_crown <- read_csv(file = "000_clean_data/admon_triple_crown.csv")

admon_triple_crown <- admon_triple_crown |>
  separate_wider_regex(cols = name, 
                       patterns = c(institution = ".+",
                                    "-",
                                    faculty = ".+"),
                       too_few = "align_start")

# Merge ----
admon_top_international <- admon_triple_crown |> 
  stringdist_left_join(y = qs_business,
                       # Using fuzzy join
                       ## Not perfect but the only solution
                       ## I find
                       by = c(institution = "Institution")) |> 
  clean_names() |> 
  filter(!is.na(score)) |> 
  select(institution, faculty , region, location, 
         # Score in relation to 
         # QS World University Rankings by subject
         ## Business
         score) |>
  mutate(institution = str_trim(institution, side = "both")) |> 
  slice_max(order_by = score, n = 14) 

# Adding useful observations
## This will need to be added manually
program_name <- c("Not undergraduate degrees",
                  "Barchelor in Data, Society and Organizations",
                  "Barchelor in Business Administration and Service Management",
                  "Study plan not found",
                  "Bachelor of Business Management",
                  "Barchelor in Business and Economics",
                  "Bachelor of Business – Business Management major",
                  "Bachelor of Commerce",
                  "Barchelor in Business Management (BSc Hons)",
                  "Business Administration",
                  "Already in Colombia",
                  "Not matched correctly",
                  "Bachelor of Business Administration (BBA)",
                  "Ingeniería Comercial - Licenciatura en Administración de Empresas")

# Concatenating and cleaning data
admon_top_international <- admon_top_international |> 
  mutate(program_name = program_name) |> 
  slice(-c(1, 4, 11, 12)) |> 
  mutate(institution = case_when(
    !is.na(faculty) ~ str_c(institution, faculty, sep = " -"),
    .default = institution)) |> 
  select(institution, program_name, location, region, score)


# Export ----
admon_top_international |> 
  write_csv(file = "000_clean_data/admon_top_international.csv")