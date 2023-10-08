#' Process and Impute Data Unemployment Rate
#'
#' This function processes the unemployment rate dataframe, for the 
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

#### para tratar arquivos provinientes do worldbank


process_worldbank_files <- function(df) {
  df <- df |> 
    dplyr::select(1:3, (ncol(df) - 21):(ncol(df) - 2))
  
  df_processed <- df |>
    dplyr::rename(code = `Country Code`, country = `Country Name`) |>
    dplyr::mutate(name = countrycode::countrycode(code, origin = "iso3c", destination = "country.name")) |>
    dplyr::relocate(name, .before = country) |>
    tidyr::pivot_longer(c(5:(ncol(df)+1)), names_to = "year",
                        values_to = "value") |>
    dplyr::select(name,country,code,year,value) |>
    tidyr::drop_na(name,value) |>
    dplyr::rename(!!file_name := value) |>
    dplyr::mutate(across(c( "country", "code","year"), as.factor)) |>
    dplyr::mutate(across(c(5), as.numeric)) |> 
    dplyr::select(-name)
    
  
  ## exclui o país Kosovo
  
  return(df_processed)
  
}

folder <- './databases/worldbank_files'
csv_files <- list.files(folder,pattern = "\\.csv$", full.names = TRUE)

for (i in 1:length(csv_files)) {
  file <- csv_files[i]
  df <- readr::read_csv(file,skip  = 4)
  file_name <- gsub("^\\d+_(.*?)\\.csv$", "\\1", basename(file))
  indicator_name <-  df$`Indicator Name`[1]
  indicator_code <-  df$`Indicator Code`[1]
  cat(paste("File name: ", file_name, "\n",
            "Indicator Name: ", indicator_name, "\n",
            "Indicator Code: ", indicator_code))
  df <-  process_worldbank_files(df)
  writexl::write_xlsx(df, paste0(".\\treated_databases\\xlsx_files\\", file_name, ".xlsx"))
  # saving the .RData file
  saveRDS(df,paste0(".\\treated_databases\\.rdata_files\\",file_name,".RData"))
  # saving the csv file
  write.csv(df, paste0(".\\treated_databases\\csv_files\\",file_name,".csv"))
}
