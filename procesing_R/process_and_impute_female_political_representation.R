#' Process and Impute Data Female Political Representation
#'
#' This function processes the female political participation dataframe, for the 
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


process_and_impute_female_political_representation <- function(df) {
  df_processed <- df |> 
    dplyr::slice(-c(1,2)) |> 
    dplyr::rename(
      rank = `...1`,
      country = `...2`,
      lower_house_elections = `...3`,
      lower_house_seats = `...4`,
      lower_house_women = `...5`,
      lower_house_percentage_w = `...6`,
      upper_chamber_elections = `...7`,
      upper_chamber_seats = `...8`,
      upper_chamber_women = `...9`,
      upper_chamber_percentage_w = `...10`
    ) |>
    dplyr::select(-rank) |> 
    dplyr::mutate(across(everything(), ~dplyr::na_if(., "-"))) |> 
    dplyr::mutate(across(c("lower_house_seats",
                           "lower_house_women",
                           "lower_house_percentage_w",
                           "upper_chamber_seats", 
                           "upper_chamber_women",
                           "upper_chamber_percentage_w"), as.numeric)) |> 
    dplyr::mutate(code = countrycode::countrycode(country, origin = "country.name", destination = "iso3c")) |> 
    dplyr::mutate(across(c("country", "code", "lower_house_elections", "upper_chamber_elections"), as.factor)) |> 
   
    dplyr::relocate(code, .after = country)
  
  rec_prepped <- recipes::recipe(~ ., data = df_processed) |>
    recipes::step_impute_knn(recipes::all_predictors(), neighbors = 5) |>
    recipes::prep()
  
  df_imputed <- recipes::bake(rec_prepped, new_data = df_processed)
  
  return(df_imputed)
}



df <- readr::read_csv("..\\databases\\repres_polit_fem.csv", skip = 3) 

female_political_representation_process_and_impute <-  process_and_impute_female_political_representation(df)

writexl::write_xlsx(female_political_representation_process_and_impute, "..\\treated databases\\female_political_representation_process_and_imputed.xlsx")
