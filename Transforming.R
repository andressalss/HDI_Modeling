library(tidyr)
library(dplyr)
library(purrr)

file <- "./Reading_Data.R"
source(file)

arquivos_com_anos <- list()
arquivos_sem_anos <- list()

for (nome_objeto in names(loaded_objects)) {
  objeto <- loaded_objects[[nome_objeto]]
  print(nome_objeto)
  df <- objeto
  colunas_fixas <- c("country", "code", "year")
  colunas_variaveis <- ""
  if ("year" %in% colnames(objeto)) {
    colunas_variaveis <- setdiff(names(df), colunas_fixas)
    print(colunas_variaveis)
    
    # Verifique se há mais de um ano na coluna "year"
    if (n_distinct(df$year) > 1) {
      df_mean <- df |> 
        group_by(country, code) |> 
        summarise(across(all_of(colunas_variaveis), ~mean(., na.rm = TRUE), .names = "mean_{.col}"))
      
      print(df_mean)
      # Crie um novo nome para o objeto média
      nome_objeto_media <- paste0(unlist(strsplit(nome_objeto, "\\."))[1], "_mean")
      print(nome_objeto_media)
      # Crie um novo objeto que contenha o dataframe df_medias
      assign(nome_objeto_media, df_mean, envir = .GlobalEnv)
      
      # Salve o objeto de média como .RData
      nome_arquivo_rdata <- paste0(".\\treated_databases\\.rdata_files\\", nome_objeto_media, ".RData")
      saveRDS(df_mean, file = nome_arquivo_rdata)
      
      # Adicione apenas o nome do arquivo à lista de arquivos com anos (sem caminho)
      arquivos_com_anos <- c(arquivos_com_anos, basename(nome_arquivo_rdata))
    } else {
      cat("Arquivo com apenas 1 ano ou sem ano na coluna 'year':", nome_objeto, "\n")
      print("Ignorando cálculo de média devido a apenas um ano presente.")
      
      # Adicione o nome do arquivo à lista de arquivos sem anos
      arquivos_sem_anos <- c(arquivos_sem_anos, nome_objeto)
    }
  }
}

# Imprima as listas de arquivos separadas
cat("Arquivos com anos na coluna 'year':\n")
print(arquivos_com_anos)

cat("Arquivos sem anos ou com apenas 1 ano na coluna 'year':\n")
print(arquivos_sem_anos)

# Criar uma lista de data frames com os nomes dos arquivos com anos
lista_df_com_anos <- lapply(arquivos_com_anos, function(nome_arquivo) {
  nome_arquivo_completo <- paste0(".\\treated_databases\\.rdata_files\\", nome_arquivo)
  readRDS(nome_arquivo_completo)
})

# Mesclar (merge) todos os data frames da lista em um único data frame
df_com_anos <- lista_df_com_anos %>%
  reduce(full_join, by = c("country", "code"))

df_sem_anos <- data.frame()

# Crie uma lista de data frames com os nomes das data frames sem anos
for (nome_objeto in arquivos_sem_anos) {
  objeto <- loaded_objects[[nome_objeto]]
  
  # Remova a coluna 'year' dos data frames que não têm anos na coluna 'year'
  df_sem_anos_temp <- objeto %>%
    select(-year)
  
  # Concatene o data frame temporário ao data frame df_sem_anos
  df_sem_anos <- bind_rows(df_sem_anos, df_sem_anos_temp)
}

# Mesclar (merge) df_com_anos e df_sem_anos em um único data frame
df_final <- full_join(df_com_anos, df_sem_anos, by = c("country", "code"))


# Para visualizar as primeiras linhas de df_final
head(df_final)
