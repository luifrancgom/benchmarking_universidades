# Benchmarking universidades

Repositorio que contiene la información necesaria sobre comparación de programas académicos relacionados con Administración de Empresas a nivel nacional e internacional

## Datos

Los datos se encuentran en la carpeta `000_raw_data`:

-   000_admon_alta_calidad_colombia_pregrado.xlsx

    -   Fecha de corte: 2024-02-19
    -   Fuente: Sistema Nacional de Información para la Educación superior en Colombia - SNIES
    -   Programas académicos cuyo nombre contiene **Administración de Empresas**, activos en la fecha de corte, con acreditación de alta calidad, nivel académico de pregrado y nivel de formación universitario donde se incluyen todas las posibles modalidades que cumplan los anteriores filtros

-   001_saberpro_genericas_2022-1.zip

    -   Fecha corte: 2023-04-20
    -   Fuente: DataIcfes
    -   Contiene los resultados de Saber Pro para las competencias genéricas correspondientes al primer semestre del 2022 dado que para la fecha de corte no se tiene información de las competencias específicas

-   001_saberpro_genericas_2022-2.zip

    -   Fecha corte: 2023-04-13
    -   Fuente: DataIcfes
    -   Contiene los resultados de Saber Pro para las competencias genéricas correspondientes al segundo semestre del 2022 dado que para la fecha de corte no se tiene información de las competencias específicas

-   002_2023_qs_wur_subject.xlsx

    -   Fecha corte: 2024-02-20
    -   Fuente: QS World University Rankings
    -   Contiene la clasificación del QS World University Rankings por área (subject) y subáreas. En la hoja `Main` se pueden consultar las áreas y las subáreas. Para los objetivos del análisis se tomaron los datos correspondiente al área `Social Sciences & Management` en relación a la subárea `Business & Management Studies` respecto a la columna `Score`

## Diccionarios de variables

Los diccionarios de datos en el caso que estén disponibles se encuentran en la carpeta `000_data_dictionaries`:

-   001_saberpro_genericas.pdf: descripción de variables para entender los archivos 001_saberpro_genericas_2022-1.zip y 001_saberpro_genericas_2022-2.zip

## Datos finales

La versión final de la información filtrada se encuentra en la carpeta `000_clean_data`:

-   `admon_top_col.csv`: 10 mejores programas académicos filtrados con acreditación de alta calidad en Colombia y mejor puntaje de saber pro en competencias genéricas. 

    -   En base a la fecha de corte solo existen 3 programas académicos que tienen acreditación en alta calidad diferentes a modalidad `presencial` o `presencial dual`. En ese sentido se incluyeron dichos programas dado que se requería un análisis de una modalidad similar a `distancia`

-   `admon_triple_crown.csv`: listado final de las escuelas de negocios con triple corona (acreditación escuelas de negocios) como resultado del web scrapping realizado utilizando la información disponible en [MBA Today](https://www.mba.today/guide/triple-accreditation-business-schools)

-   `admon_top_international.csv`: 10 mejores escuelas de negocios filtradas con triple corona y mejor puntaje QS World University Rankings en la subárea `Business & Management Studies` respecto a las instituciones de educación superior asociadas con las escuelas de negocios.

    -   Debido a que a nivel mundial no se cuentan con códigos de instituciones de educación superior y programas académicos en el proceso existío pérdida de información al combinar los registros obtenidos de [MBA Today](https://www.mba.today/guide/triple-accreditation-business-schools) y de 
002_2023_qs_wur_subject.xlsx

        -   Se busco minimizar la pérdida de información utilizando el paquete [`fuzzyjoin`](https://cran.r-project.org/web/packages/fuzzyjoin/index.html) donde no es necesario combinar registros a través de una coincidencia exacta.

## Literatura

La revisión de la literatura en cuanto al tema de `benchmarking` respecto a la comparación de programas académicos se pueden encontrar en la caperta `000_clean_data`

## Planes de estudio en Colombia

En las siguientes carpetas se encuentra la información de los planes de estudios de los programa académicos como resultado final del filtro realizado:

-   `001_study_plans_col`: planes de estudio
-   `001_electives_col`: electivas asociados a los planes de estudio

## Planes de estudio a nivel internacional

En las siguientes carpetas se encuentra la información de los planes de estudios de los programa académicos como resultado final del filtro realizado:

-   `002_study_plans_international`: planes de estudio

## Scripts

Scripts utilizados para generar los **Datos Finales**

-   `001_script_import_clean_col.R`: Importación y limpieza de datos relacionados con programas académicos en Colombia
-   `002_script_scrap_clean_triple_crown.R`: Web scrapping para obtener resultados finales relacionados con triple corona (acreditación escuelas de negocios)
-   `002_script_import_clean_qs_subject.R`: Importación, limpieza y combinación de registros en base a la información relacionada respecto a triple corona (acreditación escuelas de negocios) y QS World University Rankings en la subárea `Business & Management Studies`

## Descripción de metodología
