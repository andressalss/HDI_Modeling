pasta_arquivos <- 'D:/2022/Esp/TCC_ANDRESSA_IDH/databases'
arquivos_csv <- list.files(pasta_arquivos,pattern = "\\.csv$", full.names = TRUE)

lista_dados <- list()

for (i in 1:length(arquivos_csv)) {
  arquivo <- arquivos_csv[i]
  dados <- read.csv(arquivo)
  lista_dados[[i]] <- dados
}



setwd("D:/2022/Esp/TCC_ANDRESSA_IDH/HDI_Modeling/databases")

# 1 - TAXA DE DESEMPREGO --------------------------------------------------

taxa_desemp <- read.csv("1_taxa_desemp.csv")
# numero de paises
length(unique(taxa_desemp$LOCATION))
# intervalo dos anos
range(taxa_desemp$TIME)


# 2 - TAXA DE INFLAÇÃO --------------------------------------------------------
taxa_infl <- read.csv("2_taxa_infl.csv")

# numero de paises
length(unique(taxa_infl$LOCATION))
# intervalo dos anos
range(taxa_infl$TIME)

# 3 - INDICADOR DE GINI ---------------------------------------------------
ind_gini <- read.csv("3_ind_gini.csv")
ind_gini <-  ind_gini[1:1837,]

range(ind_gini$Year)

# 4 - PIB -----------------------------------------------------------------
#ano está como coluna
pib <- read.csv("4_pib.csv",skip = 4)
range(pib$)

# 5 - Participação Feminina na Força de Trabalho --------------------------
## Thiago

taxa_part_fem_ft <- read.csv("5_taxa_part_fem_ft.csv",skip = 4)
# os anos estão em colunas
range(taxa_part_fem_ft$)

# 6 - Disparidade de Renda entre Gêneros ----------------------------------
dispar_renda_gen <- read.csv("6_dispar_renda_gen.csv")
range(dispar_renda_gen$Year)

# 7- Representação Política Feminina --------------------------------------
## Thiago
repres_polit_fem <- read.csv("7_repres_polit_fem.csv",skip=4)
range(repres_polit_fem$)

# 8 - Leis de Igualdade de Gênero -----------------------------------------
lei_igual_gen <- read.csv("8_lei_igual_gen.csv")


# 16 - Taxa de Domicílios com Acesso à Internet ---------------------------
taxa_dom_inter <- read.csv("16_taxa_dom_inter.csv",skip=4)


# 18 - Taxas de Emissão de CO2 --------------------------------------------
## Thiago
taxa_emis_CO2 <- read.csv("18_taxa_emis_CO2.csv")


# 19 - Taxa de Consumo de Energias Renováveis -----------------------------
taxa_cons_energ_renov <- read.csv("19_taxa_cons_energ_renov.csv",  skip = 4)


# 21 - Consumo de Água ----------------------------------------------------
cons_agua_per_cap <- read.csv("21_cons_agua_per_cap.csv")


# 23 - Saúde Mental -------------------------------------------------------
## Thiago
saude_mental <- read.csv("23_saude_mental.csv")


# 28 - População Encarcerada ----------------------------------------------
pop_encarcerada <- read.csv("28_pop_encarcerada.csv")


# 31 - Liberdade Moral  ---------------------------------------------------
liberdade_moral <- read.csv("31_liberdade_moral.csv")


