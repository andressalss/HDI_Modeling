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

taxa_desemp <- read.csv("./databases/1_unemp_rate.csv")
# numero de paises
length(unique(taxa_desemp$LOCATION))
# intervalo dos anos
range(taxa_desemp$TIME)
length(unique(taxa_desemp$LOCATION))



# 2 - TAXA DE INFLAÇÃO --------------------------------------------------------
taxa_infl <- read.csv("./databases/2_inflation_rate.csv")
range(taxa_infl$TIME)
length(unique(taxa_infl$LOCATION))


# numero de paises
length(unique(taxa_infl$LOCATION))
# intervalo dos anos
range(taxa_infl$TIME)

# 3 - INDICADOR DE GINI ---------------------------------------------------
ind_gini <- read.csv("./databases/3_gini_index.csv")
ind_gini <-  ind_gini[1:1837,]

range(ind_gini$Year)
length(unique(ind_gini$Country.or.Area))


# 4 - PIB -----------------------------------------------------------------
#ano está como coluna
pib <- read.csv("./databases/4_gpd.csv",skip = 4)
length(unique(pib$Country.Code))

# 5 - Participação Feminina na Força de Trabalho --------------------------
## Thiago
taxa_part_fem_ft <- read.csv("./databases/5_female_labor_force.csv",skip = 4)
length(unique(taxa_part_fem_ft$Country.Code))



# 6 - Disparidade de Renda entre Gêneros ----------------------------------
dispar_renda_gen <- read.csv("./databases/6_gender_inequality.csv")
range(dispar_renda_gen$Year)
length(unique(dispar_renda_gen$Code))


# 7- Representação Política Feminina --------------------------------------
## Thiago

# Os dados aqui são de janeiro de 2021

repres_polit_fem <- read.csv("./databases/7_female_political_represent.csv",skip=4)
length(unique(repres_polit_fem$Country))



# 8 - Leis de Igualdade de Gênero -----------------------------------------
lei_igual_gen <- read.csv("./databases/8_legal_framework_eq_gender.csv")
range(lei_igual_gen$Year)
length(unique(lei_igual_gen$Code))



# 16 - Taxa de Domicílios com Acesso à Internet ---------------------------
taxa_dom_inter <- read.csv("./databases/16_people_using_internet.csv",skip=4)
length(unique(taxa_dom_inter$Country.Code))



# 18 - Taxas de Emissão de CO2 --------------------------------------------
## Thiago
taxa_emis_CO2 <- read.csv("./databases/18_co2_emission.csv")
range(taxa_emis_CO2$Year)
length(unique(taxa_emis_CO2$Code))



# 19 - Taxa de Consumo de Energias Renováveis -----------------------------
taxa_cons_energ_renov <- read.csv("./databases/19_renewable_energy_consum.csv",  skip = 4)
length(unique(taxa_cons_energ_renov$Country.Name))


# 21 - Consumo de Água ----------------------------------------------------
cons_agua_per_cap <- read.csv("./databases/21_water_consum.csv",sep = ";")
length(unique(cons_agua_per_cap$Country))


# 23 - Saúde Mental -------------------------------------------------------
## Thiago
saude_mental <- read.csv("./databases/23_mental_health_indi.csv")
range(saude_mental$Year)
length(unique(saude_mental$Code))


# 28 - População Encarcerada ----------------------------------------------
pop_encarcerada <- read.csv("./databases/28_prison_pop_rate.csv")
range(pop_encarcerada$Year)
length(unique(pop_encarcerada$Code))


# 31 - Liberdade Moral  ---------------------------------------------------
liberdade_moral <- read.csv("./databases/31_moral_freedom.csv")
length(unique(liberdade_moral$COUNTRY))

