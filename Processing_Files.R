folder <- "./procesing_R"

# Lista todos os arquivos na pasta com extensão .R
r_files <- list.files(path = folder, pattern = "\\.R$", full.names = TRUE)

# Loop para executar cada arquivo R
for (file in r_files) {
  cat("Executando:", basename(file), "\n")
  source(file, local = TRUE)  # Use local = TRUE para evitar a sobreposição de variáveis
}
