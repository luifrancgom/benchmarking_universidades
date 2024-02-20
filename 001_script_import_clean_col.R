# Libraries ----
library(tidyverse)
library(janitor)
library(readxl)
library(stringi)

# Import ----
## Data from SNIES undergradute programs
## Business Administration
col_admon <- read_xlsx(path = "000_raw_data/000_admon_alta_calidad_colombia_pregrado.xlsx", 
                       sheet = 1, 
                       range = "A1:AM88") |> 
  clean_names()

col_admon |> glimpse()
## Score Saber-pro 2022
## Generic competencies
### There are no information about specific competencies
### for 2022
saberpro_2022_1_genericas <- read_csv(file = "000_raw_data/001_saberpro_genericas_2022-1.zip") |> 
  clean_names()
saberpro_2022_2_genericas <- read_csv(file = "000_raw_data/001_saberpro_genericas_2022-2.zip") |> 
  clean_names()

# Clean ----
## Saberpro 2022 generic competencies
saberpro_2022_1_genericas <- saberpro_2022_1_genericas |>
         # Id estudiante
  select(estu_consecutivo,
         # Información IES: nombre y código IES
         inst_cod_institucion, inst_nombre_institucion,
         # Información programa académico: nombre y código SNIES 
         estu_prgm_academico, estu_snies_prgmacademico,
         # Puntaje global competencias genéricas
         punt_global)

saberpro_2022_2_genericas <- saberpro_2022_2_genericas |>
  # Id estudiante
  select(estu_consecutivo,
         # Información IES: nombre y código IES
         inst_cod_institucion, inst_nombre_institucion,
         # Información programa académico: nombre y código SNIES 
         estu_prgm_academico, estu_snies_prgmacademico,
         # Puntaje global competencias genéricas
         punt_global)

saberpro_2022_genericas <- saberpro_2022_1_genericas |> 
  bind_rows(saberpro_2022_2_genericas) |> 
         # Students belonging to the SNIES programs
         # 111213 and 103473 doesn't appear in Saberpro
  filter(estu_snies_prgmacademico %in% col_admon$codigo_snies_del_programa) |> 
  group_by(estu_snies_prgmacademico) |> 
  summarise(mean_punt_global = mean(punt_global))

saberpro_2022_genericas |> glimpse()

## Undergraduate business administration
### High quality
col_admon <- col_admon |> 
         # Código IES institución padre
  select(codigo_institucion_padre,
         # Código IES institución
         codigo_institucion,
         # Nombre institución
         nombre_institucion,
         # Código SNIES del programa
         codigo_snies_del_programa,
         # Nombre del programa,
         nombre_del_programa,
         # Modalidad
         modalidad,
         # Número de créditos,
         numero_creditos,
         # Periodos de duración
         numero_periodos_de_duracion,
         # Costo matrícula estudiantes nuevos
         costo_matricula_estud_nuevos,
         # Municipio de oferta del programa
         municipio_oferta_programa,
         # Costo matrícula estudiantes nuevos
         costo_matricula_estud_nuevos) |> 
  # Clean accents
  mutate(nombre_del_programa = stri_trans_general(str = nombre_del_programa,
                                                  id = "Latin-ASCII")) |> 
  filter(nombre_del_programa == "ADMINISTRACION DE EMPRESAS")

col_admon |> glimpse()

## Final data
virtual_admon <- col_admon |> 
  filter(modalidad == "Virtual") |> 
  left_join(y = saberpro_2022_genericas,
            by = join_by(codigo_snies_del_programa == estu_snies_prgmacademico))

presencial_admon <- col_admon |> 
  filter(modalidad != "Virtual") |> 
  left_join(y = saberpro_2022_genericas,
            by = join_by(codigo_snies_del_programa == estu_snies_prgmacademico)) |> 
  slice_max(order_by = mean_punt_global, 
            n = 10 - nrow(virtual_admon))

admon_top_col <- virtual_admon |> 
  bind_rows(presencial_admon) |> 
  select(nombre_institucion, 
         codigo_snies_del_programa,
         modalidad,
         municipio_oferta_programa,
         numero_creditos,
         numero_periodos_de_duracion,
         costo_matricula_estud_nuevos,
         mean_punt_global) |> 
  arrange(desc(mean_punt_global))
  
# Export ----
admon_top_col |> 
  write_csv(file = "000_clean_data/admon_top_col.csv")


