library(tidyr)
library(dplyr)
library(purrr)

file <- "./Reading_Data.R"
source(file)

for (nome_objeto in names(loaded_objects)) {
  objeto <- loaded_objects[[nome_objeto]]
  print(nome_objeto)
  df <- objeto
  colunas_fixas <- c("country", "code", "year")
  colunas_variaveis <- ""
  if ("year" %in% colnames(objeto) && n_distinct(df$year) > 1) {
    colunas_variaveis <- setdiff(names(df), colunas_fixas)
    # Verifique se há mais de um ano na coluna "year"
      df_mean <- df |> 
        group_by(code) |> 
        summarise(across(all_of(colunas_variaveis), ~mean(., na.rm = TRUE), .names = "mean_{.col}"))
      
      print(df_mean)
      # Crie um novo nome para o objeto média
      nome_objeto_media <- paste0(unlist(strsplit(nome_objeto, "\\."))[1], "_mean")
      print(nome_objeto_media)
      # Crie um novo objeto que contenha o dataframe df_medias
      assign(nome_objeto_media, df_mean, envir = .GlobalEnv)
      
      # Salve o objeto de média como .RData
      nome_arquivo_rdata <- paste0(".\\treated_databases\\.rdata_files\\mean_data\\", nome_objeto_media, ".RData")
      saveRDS(df_mean, file = nome_arquivo_rdata)}
      
      else{
        if("year" %in% colnames(objeto)){
          df <- df |> dplyr::select(-year)
        }
      df <- df |> dplyr::select(-country)
      nome_arquivo_rdata <- paste0(".\\treated_databases\\.rdata_files\\mean_data\\", nome_objeto)
      saveRDS(df, file = nome_arquivo_rdata)

      
    }
  }