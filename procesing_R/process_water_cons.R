#' Process Mental Gender Wage Gap Data
#'
#' This function processes the mental health dataframe by renaming columns, 
#' converting data types, and filtering out rows with NA in the 'code' column.
#'
#' @param data A dataframe containing the data to be processed.
#' @return A dataframe that has been processed.
#' @importFrom dplyr rename mutate filter
#' @export


process_water_cons <- function(df) {
  df_processed <- df |>
    dplyr::mutate(Country = stringr::str_replace(Country, "C�te d'Ivoire", "Côte d'Ivoire")) |> 
    dplyr::rename_with(snakecase::to_snake_case) |>
    dplyr::select(1,2) |>
    dplyr::mutate(code = countrycode::countrycode(country, origin = "country.name" , destination = "iso3c")) |>
    dplyr::mutate(year = 2023) |>
    dplyr::select(1,3,4,2) |>
    dplyr::mutate(across(c( "country", "code","year"), as.factor)) |>
    dplyr::mutate(annual_water_use = as.numeric(annual_water_use))
  return(df_processed)
  
} 

generate_file <- function(file_path) {
  df <- read.csv(file_path, sep = ";",encoding =  "UTF-8")
  var_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(file_path))
  df <- process_water_cons(df)
  # saving the .RData file
  saveRDS(df,paste0(".\\treated_databases\\.rdata_files\\",var_name,".RData"))
  # saving the csv file
  write.csv(df, paste0(".\\treated_databases\\csv_files\\",var_name,".csv"))
  #return(writexl::write_xlsx(df,paste0(".\\treated_databases\\xlsx_files\\",var_name,".xlsx")))
}

file_path <- ("./databases/21_water_consum.csv")
generate_file(file_path)
