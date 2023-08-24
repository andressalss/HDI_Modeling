#' Process Mental Gender Wage Gap Data
#'
#' This function processes the mental health dataframe by renaming columns, 
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
    dplyr::rename(!!var_name := value) |>
    dplyr::mutate(across(c( "country", "code"), as.factor))
  
  indicators_processed <- df |>
    dplyr::select(2,8:12) |>
    dplyr::rename_with(snakecase::to_snake_case) |>
    dplyr::rename_with(~ paste0("lib_moral_", .), c(-1)) |>
    dplyr::mutate(code = countrycode::countrycode(country, origin ="country.name" , destination ="iso3c" )) |>
    dplyr::mutate(across(c( "country", "code"), as.factor)) |>
    dplyr::mutate(year = "2022") |>
    dplyr::relocate(c(code,year), .after = country)
  
  
  ## falta processo de imputação
  
  return(list(moral_processed = moral_processed, indicators_processed = indicators_processed))
} 








file_path <- ("./databases/31_liberdade_moral.csv")
generate_file(file_path)

generate_file <- function(file_path) {
  df <- read.csv(file_path, encoding =  "UTF-8")
  var_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(file_path))
  processed_data <- process_and_impute_moral(df)  # Use a função process_and_impute_moral
  
  moral_processed <- processed_data$moral_processed
  indicators_processed <- processed_data$indicators_processed
  
  writexl::write_xlsx(moral_processed, paste0(".\\treated_databases\\", var_name, "_moral.xlsx"))
  writexl::write_xlsx(indicators_processed, paste0(".\\treated_databases\\", var_name, "_indicators.xlsx"))
}
