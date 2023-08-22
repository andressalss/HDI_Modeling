#' Process Mental Health Data
#'
#' This function processes the mental health dataframe by renaming columns, 
#' converting data types, and filtering out rows with NA in the 'code' column.
#'
#' @param data A dataframe containing the data to be processed.
#' @return A dataframe that has been processed.
#' @importFrom dplyr rename mutate filter
#' @export


process_mental_health_data <- function(data) {
  data_processed <- data |> 
    dplyr::rename(
      country = Entity,
      code = Code,
      year = Year,
      depressive_dalys = "DALYs from depressive disorders per 100,000 people in, both sexes aged age-standardized",
      schizophrenia_dalys = "DALYs from schizophrenia per 100,000 people in, both sexes aged age-standardized",
      bipolar_dalys = "DALYs from bipolar disorder per 100,000 people in, both sexes aged age-standardized",
      eating_disorder_dalys = "DALYs from eating disorders per 100,000 people in, both sexes aged age-standardized",
      anxiety_dalys = "DALYs from anxiety disorders per 100,000 people in, both sexes aged age-standardized"
    ) |> 
    dplyr::mutate(code = ifelse(code == "", NA, code)) |> 
    dplyr::filter(!is.na(code))
  
  return(data_processed)
}


df <- readr::read_csv("..\\databases\\saude_mental.csv")
mental_health_processed <- process_mental_health_data(df)

writexl::write_xlsx(mental_health_processed, "..\\treated databases\\mental_health_processed.xlsx")
