#' Process Moral Freedom Data
#'
#' This function processes the Moral Freedom dataframe by renaming columns, 
#' converting data types, and filtering out rows with NA in the 'code' column.
#'
#' @param data A dataframe containing the data to be processed.
#' @return A dataframe that has been processed.
#' @importFrom dplyr rename mutate filter
#' @export


process_and_impute_moral <- function(df) {
  moral_processed <- df |>
    dplyr::select(2,3,4) |>
    dplyr::rename_with(snakecase::to_snake_case) |>
    dplyr::rename("2022" = 2, "2020" = 3) |>
    dplyr::mutate(code = countrycode::countrycode(country, origin ="country.name" , destination ="iso3c" )) |>
    dplyr::select(1,4,2,3) |>
    tidyr::pivot_longer(c(3,4), names_to = "year",values_to = "value") |>
    dplyr::mutate(across("value", ~gsub(",", ".", .))) |>
    dplyr::rename(!!var_name := value) |>
    dplyr::mutate(across(c( "country", "code","year"), as.factor)) |> 
    dplyr::mutate_at(4, as.numeric)
  
  indicators_processed <- df |>
    dplyr::select(2,8:12) |>
    dplyr::rename_with(snakecase::to_snake_case) |>
    dplyr::rename_with(~ paste0("lib_moral_", .), c(-1)) |>
    dplyr::mutate(code = countrycode::countrycode(country, origin ="country.name" , destination ="iso3c" )) |>
    dplyr::mutate(year = "2022") |>
    dplyr::relocate(c(code,year), .after = country) |> 
    dplyr::mutate(across(c( "country", "code","year"), as.factor)) |> 
    dplyr::mutate(across(4:8, ~gsub(",", ".", .))) |> 
    dplyr::mutate(across(c(4:8), as.numeric))
  

  return(list(moral_processed = moral_processed, indicators_processed = indicators_processed))
} 

generate_file <- function(file_path) {
  df <- read.csv(file_path, encoding =  "UTF-8")
  var_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(file_path))
  processed_data <- process_and_impute_moral(df)  # Use a função process_and_impute_moral
  
  moral_processed <- processed_data$moral_processed
  indicators_processed <- processed_data$indicators_processed
  # saving the xlsx file
  writexl::write_xlsx(moral_processed, paste0(".\\treated_databases\\xlsx_files\\", var_name, ".xlsx"))
  writexl::write_xlsx(indicators_processed, paste0(".\\treated_databases\\xlsx_files\\", var_name, "_indicators.xlsx"))
  
  # saving the .RData file
  saveRDS(moral_processed,paste0(".\\treated_databases\\.rdata_files\\",var_name,".RData"))
  saveRDS(indicators_processed,paste0(".\\treated_databases\\.rdata_files\\",var_name,"_indicators.RData"))
  
  # saving the csv file
  write.csv(moral_processed, paste0(".\\treated_databases\\csv_files\\",var_name,".csv"))
  write.csv(indicators_processed, paste0(".\\treated_databases\\csv_files\\",var_name,"_indicators.csv"))

}


file_path <- ("./databases/31_moral_freedom.csv")
generate_file(file_path)
