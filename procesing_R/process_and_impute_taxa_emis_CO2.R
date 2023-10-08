#' Process CO2 Emission Rate Date
#'
#' This function processes the CO2 emission rate dataframe by renaming columns, 
#' filtering out rows with NA in the 'code' column, and imputing missing values 
#' in the 'Share of global annual CO₂ emissions' column using the KNN method.
#'
#' @param data A dataframe containing the data to be processed.
#' @return A dataframe that has been processed and imputed.
#' @importFrom dplyr rename mutate filter
#' @importFrom recipes recipe step_impute_knn prep bake
#' @export

process_impute_tax_emis_CO2 <- function(df,var_name) {
  data_processed <- df |> 
    dplyr::rename(
      country = 1,
      code = 2,
      year = 3,
      !!var_name := 4) |>
    dplyr::filter(year > (max(year) - 20)) |>
    dplyr::mutate(across(c( "country","code","year"), as.factor)) |> 
    dplyr::filter(!is.na(code))
  

  rec_prepped <- recipes::recipe(~ ., data = data_processed) |>
    recipes::step_impute_knn(4, neighbors = 10) |>
    recipes::prep()
  
  data_imputed <- recipes::bake(rec_prepped, new_data = data_processed)
  
  return(data_imputed)
}


generate_file <- function(file_path) {
  df <- readr::read_csv(file_path)
  var_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(file_path))
  df <- process_impute_tax_emis_CO2(df,var_name)
  # saving the .RData file
  saveRDS(df,paste0(".\\treated_databases\\.rdata_files\\",var_name,".RData"))
  # saving the csv file
  write.csv(df, paste0(".\\treated_databases\\csv_files\\",var_name,".csv"))
  return(writexl::write_xlsx(df,paste0(".\\treated_databases\\xlsx_files\\",var_name,".xlsx")))
}

file_path <- (".\\databases\\18_co2_emission.csv")
generate_file(file_path)
