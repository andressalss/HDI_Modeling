#' Process Mental Gender Wage Gap Data
#'
#' This function processes the mental health dataframe by renaming columns, 
#' converting data types, and filtering out rows with NA in the 'code' column.
#'
#' @param data A dataframe containing the data to be processed.
#' @return A dataframe that has been processed.
#' @importFrom dplyr rename mutate filter
#' @export


process_gender_wage_gap <- function(df) {
  df_processed <- df |>
    dplyr::rename_with(snakecase::to_snake_case) |>
    dplyr::rename(country = entity) |>
    dplyr::filter(year > 1996) |> 
    dplyr::mutate(across(c( "country", "code","year"), as.factor))
  
  ## falta processo de imputação
  
  return(df_processed)
  
} 

generate_file <- function(file_path) {
  df <- read.csv(file_path, encoding =  "UTF-8")
  var_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(file_path))
  df <- process_gender_wage_gap(df)
  # saving the .RData file
  saveRDS(df,paste0(".\\treated_databases\\.rdata_files\\",var_name,".RData"))
  # saving the csv file
  write.csv(df, paste0(".\\treated_databases\\csv_files\\",var_name,".csv"))
  return(writexl::write_xlsx(df,paste0(".\\treated_databases\\xlsx_files\\",var_name,".xlsx")))
}

file_path <- ("./databases/6_gender_inequality.csv")
generate_file(file_path)
