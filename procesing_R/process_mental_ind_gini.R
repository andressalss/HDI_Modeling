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

file_path <- "D:/2022/Esp/TCC_ANDRESSA_IDH/HDI_Modeling/databases/ind_gini.csv"
df <- read.csv(file_path, encoding =  "UTF-8")


R.utils::getRelativePath("D:/2022/Esp/TCC_ANDRESSA_IDH/HDI_Modeling/databases/ind_gini.csv")

process_and_impute <- function(df) {
  df_processed <- df |>
    dplyr::select(1:3) |>
    dplyr::slice(1:1837) |>
    dplyr::rename(country = Country.or.Area ,year = Year,
                  gini = Value) |>
    dplyr::mutate(code = countrycode::countrycode(country, origin = "country.name", destination = "iso3c")) |>
    dplyr::select(country,code,year,gini) |>
#    dplyr::rename(!!var_name := value) |>
    tidyr::drop_na(code) |>
    dplyr::mutate(across(c( "country", "code"), as.factor))
  
  ## falta processo de imputação
  
  return(df_processed)
  
} 

gini_processed <- process_and_impute(df)

writexl::write_xlsx(gini_processed, "..\\treated_databases\\gini_processed.xlsx")
