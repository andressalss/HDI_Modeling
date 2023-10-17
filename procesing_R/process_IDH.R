#' Process Mental Health Data
#'
#' This function processes the mental health dataframe by renaming columns, 
#' converting data types, and filtering out rows with NA in the 'code' column.
#'
#' @param data A dataframe containing the data to be processed.
#' @return A dataframe that has been processed.
#' @importFrom dplyr rename mutate filter
#' @export

### paises que não correspondem ao código

process_hdi <- function(df,var_name) {
  df_processed <- df |>
    dplyr::filter(!is.na(`HDI rank`)) |> 
    dplyr::select(2:3) |> 
    dplyr::rename_with(snakecase::to_snake_case) |>
    dplyr::mutate(code = countrycode::countrycode(country, origin = "country.name", destination = "iso3c")) |>
    dplyr::select(country,code,value) |> 
    dplyr::mutate(across(value,as.numeric)) |> 
    dplyr::rename(!!var_name := value) |>
    dplyr::mutate(across(c( "country", "code"), as.factor))
  
  return(df_processed)
  
}

generate_file <- function(file_path) {
  df <- readxl::read_excel(file_path, skip = 5)
  var_name <- gsub("^\\d+_(.*?)\\.xlsx$", "\\1", basename(file_path))
  df <- process_hdi(df, var_name)
  # saving the .RData file
  saveRDS(df,paste0(".\\treated_databases\\.rdata_files\\",var_name,".RData"))
  # saving the csv file
  write.csv(df, paste0(".\\treated_databases\\csv_files\\",var_name,".csv"))
  return(writexl::write_xlsx(df,paste0(".\\treated_databases\\xlsx_files\\",var_name,".xlsx")))
}


file_path <- (".\\databases\\0_hdi_2021.xlsx")
generate_file(file_path)
