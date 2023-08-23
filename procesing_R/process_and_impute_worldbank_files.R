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
pasta_arquivos <- 'D:/2022/Esp/TCC_ANDRESSA_IDH/HDI_Modeling/databases/worldbank_files'
arquivos_csv <- list.files(pasta_arquivos,pattern = "\\.csv$", full.names = TRUE)

lista_dados <- list()


for (i in 1:length(arquivos_csv)) {
  arquivo <- arquivos_csv[i]
  df <- readr::read_csv(arquivo,skip  = 4)
  file_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(arquivo))
  indicator_name <-  df$`Indicator Name`[1]
  indicator_code <-  df$`Indicator Code`[1]
  cat(paste("File name: ", file_name, "\n",
          "Indicator Name: ", indicator_name, "\n",
          "Indicator Code: ", indicator_code))
  df_processed <-  process_and_impute(df)
  writexl::write_xlsx(df_processed, paste0("..\\treated_databases\\", file_name, "_treated.xlsx"))
}


file_name <- "pib"
df <- readr::read_csv('D:/2022/Esp/TCC_ANDRESSA_IDH/HDI_Modeling/databases/worldbank_files/4_pib.csv', skip  = 4)

process_and_impute <- function(df) {
  df_processed <- df |>
    #precisamos definiar a partir de qual ano
    dplyr::select(-c(3:34,68)) |>
    dplyr::rename(code = `Country Code`, country = `Country Name`) |>
    dplyr::mutate(name = countrycode::countrycode(code, origin = "iso3c", destination = "country.name")) |>
    dplyr::relocate(name, .before = country) |>
    tidyr::pivot_longer(c(4:35), names_to = "year",
                        values_to = "value") |>
    dplyr::select(name,country,code,year,value) |>
    dplyr::rename(!!file_name := value) |>
    #o que faremos com codigos sem correspond?
    tidyr::drop_na(name) |>
    dplyr::mutate(across(c( "country", "code"), as.factor)) |>
    dplyr::mutate(across(c(4,5), as.numeric)) 
  
  ## falta processo de imputação
  
  return(df_processed)
  
} 


