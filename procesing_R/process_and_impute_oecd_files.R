#' Process and Impute Data Unemployment Rate
#'
#' This function processes the unemployment rate dataframe, for the 
#' data obtained in (falta a informação). Processing takes place by renaming columns, converting 
#' data types, adding IOS coding of countries and imputing missing values 
#' using the KNN method.
#'
#' @param df A dataframe containing the data to be processed and imputed.
#' @return A dataframe that has been processed and imputed.
#' @importFrom dplyr slice rename mutate select
#' @importFrom countrycode countrycode
#' @importFrom recipes recipe step_impute_knn prep bake
#' @export
#' 

#### para tratar arquivos provinientes da OECD
pasta_arquivos <- 'D:/2022/Esp/TCC_ANDRESSA_IDH/HDI_Modeling/databases/OECD_files'
arquivos_csv <- list.files(pasta_arquivos,pattern = "\\.csv$", full.names = TRUE)

lista_dados <- list()


for (i in 1:length(arquivos_csv)) {
  arquivo <- arquivos_csv[i]
  df <- readr::read_csv(arquivo)
  var_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(arquivo))
  print(var_name)
  df_processed <-  process_and_impute(df)
  writexl::write_xlsx(df_processed, paste0(".\\treated_databases\\", var_name, "_treated.xlsx"))
}


process_and_impute <- function(df) {
  df_processed <- df |>
    dplyr::filter(FREQUENCY == "A") |>
    dplyr::select(LOCATION,TIME,Value) |>
    dplyr::rename(code = LOCATION, year = TIME) |>
    dplyr::mutate(country = countrycode::countrycode(code, origin = "iso3c", destination = "country.name")) |>
    dplyr::rename_all(tolower) |>
    dplyr::select(country,code,year,value) |>
    dplyr::rename(!!var_name := value) |>
    tidyr::drop_na(country) |>
    dplyr::mutate(across(c( "country", "code"), as.factor))
  
## falta processo de imputação
  
  return(df_processed)
  
  } 


