#' Process and Impute Data Unemployment Rate
#'
#' This function processes the unemployment and inflation rates dataframes, for the 
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

#### processing files obtained on OECD 
process_oecd_files <- function(df,var_name) {
  df_processed <- df |>
    dplyr::filter(FREQUENCY == "A") |>
    dplyr::filter(TIME >= 2003 & TIME < 2023) |> 
    dplyr::select(LOCATION,TIME,Value) |>
    dplyr::rename(code = LOCATION, year = TIME) |>
    dplyr::mutate(country = countrycode::countrycode(code, origin = "iso3c", destination = "country.name")) |>
    dplyr::rename_all(tolower) |>
    dplyr::select(country,code,year,value) |>
    dplyr::rename(!!var_name := value) |>
    tidyr::drop_na(country) |>
    dplyr::mutate(across(c( "country", "code","year"), as.factor))

  return(df_processed)
  
} 


folder <- './databases/OECD_files'
csv_files <- list.files(folder,pattern = "\\.csv$", full.names = TRUE)


for (i in 1:length(csv_files)) {
  file <- csv_files[i]
  df <- readr::read_csv(file)
  var_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(file))
  print(var_name)
  df_processed <-  process_oecd_files(df,var_name)
  #saving the xlsx file
  writexl::write_xlsx(df_processed, paste0(".\\treated_databases\\xlsx_files\\", var_name, ".xlsx"))
  
  # saving the .RData file
  saveRDS(df_processed,paste0(".\\treated_databases\\.rdata_files\\",var_name,".RData"))
  
  # saving the csv file
  write.csv(df_processed, paste0(".\\treated_databases\\csv_files\\",var_name,".csv"))
}
