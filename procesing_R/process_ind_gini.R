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

process_ind_gini <- function(df,var_name) {
  df_processed <- df |>
    dplyr::select(1:3) |>
    dplyr::slice(1:1837) |>
    dplyr::rename(country = `Country.or.Area` ,year = Year,
                  value = Value) |>
    dplyr::filter(year > 2000) |> 
    dplyr::mutate(country = stringr::str_replace(country, "SÃ£o TomÃ© and Principe" , "São Tomé and Príncipe")) |> 
    dplyr::mutate(country = stringr::str_replace(country, "TÃ¼rkiye" , "Turkey")) |>
    dplyr::mutate(code = countrycode::countrycode(country, origin = "country.name", destination = "iso3c")) |>
    dplyr::select(country,code,year,value) |>
    dplyr::rename(!!var_name := value) |>
    tidyr::drop_na(code) |>
    dplyr::mutate(across(c( "country", "code","year"), as.factor))

  return(df_processed)
  
}

generate_file <- function(file_path) {
  df <- read.csv(file_path, encoding =  "UTF-8")
  var_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(file_path))
  df <- process_ind_gini(df, var_name)
  # saving the .RData file
  saveRDS(df,paste0(".\\treated_databases\\.rdata_files\\",var_name,".RData"))
  # saving the csv file
  write.csv(df, paste0(".\\treated_databases\\csv_files\\",var_name,".csv"))
  return(writexl::write_xlsx(df,paste0(".\\treated_databases\\xlsx_files\\",var_name,".xlsx")))
}


file_path <- (".\\databases\\3_gini_index.csv")
generate_file(file_path)
