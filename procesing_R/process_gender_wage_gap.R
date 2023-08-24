#' Process Mental Gender Wage Gap Data
#'
#' This function processes the mental health dataframe by renaming columns, 
#' converting data types, and filtering out rows with NA in the 'code' column.
#'
#' @param data A dataframe containing the data to be processed.
#' @return A dataframe that has been processed.
#' @importFrom dplyr rename mutate filter
#' @export


process_and_impute <- function(df) {
  df_processed <- df |>
    dplyr::rename_with(snakecase::to_snake_case) |>
    dplyr::rename(country = entity) |>
    dplyr::mutate(across(c( "country", "code"), as.factor))
  
  ## falta processo de imputação
  
  return(df_processed)
  
} 


file_path <- ("./databases/6_dispar_renda_gen.csv")
generate_file(file_path)
generate_file <- function(file_path) {
  df <- read.csv(file_path, encoding =  "UTF-8")
  var_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(file_path))
  df <- process_and_impute(df)
  return(writexl::write_xlsx(df,paste0(".\\treated_databases\\",var_name,".xlsx")))
}


