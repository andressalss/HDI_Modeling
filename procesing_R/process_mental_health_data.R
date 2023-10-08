#' Process Mental Health Data
#'
#' This function processes the mental health dataframe by renaming columns, 
#' converting data types, and filtering out rows with NA in the 'code' column.
#'
#' @param data A dataframe containing the data to be processed.
#' @return A dataframe that has been processed.
#' @importFrom dplyr rename mutate filter
#' @export


process_mental_health_data <- function(df) {
  data_processed <- df |> 
    dplyr::rename(
      country = 1,
      code = 2,
      year = 3,
      depressive_dalys = 4,
      schizophrenia_dalys = 5,
      bipolar_dalys = 6,
      eating_disorder_dalys = 7,
      anxiety_dalys = 8
    ) |> 
    dplyr::mutate(code = ifelse(code == "", NA, code)) |> 
    dplyr::filter(year > 1999) |> 
    dplyr::filter(!is.na(code)) |> 
    dplyr::mutate(across(c("country","code","year"), as.factor))
  return(data_processed)
}

generate_file <- function(file_path) {
  df <- readr::read_csv(file_path)
  var_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(file_path))
  df <- process_mental_health_data(df)
  # saving the .RData file
  saveRDS(df,paste0(".\\treated_databases\\.rdata_files\\",var_name,".RData"))
  # saving the csv file
  write.csv(df, paste0(".\\treated_databases\\csv_files\\",var_name,".csv"))
  return(writexl::write_xlsx(df,paste0(".\\treated_databases\\xlsx_files\\",var_name,".xlsx")))
}


file_path <- (".\\databases\\23_mental_health_indi.csv")
generate_file(file_path)
