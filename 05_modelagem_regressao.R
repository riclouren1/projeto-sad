# --------------------------------------------
# MODELAGEM PREDITIVA: REGRESSÃO LINEAR
# --------------------------------------------

setwd("/cloud/project")

library(readr)
library(dplyr)
library(stringr)
library(tidymodels)

# Caminho do dataset limpo
data_path <- "Datasets/clean_seoul_bike_sharing.csv"

# 1) Verificar existência do ficheiro
if (!file.exists(data_path)) {
  stop("Ficheiro limpo não encontrado em ", data_path)
} else {
  message("Dataset encontrado em: ", data_path)
}

# 2) Ler dados
dados <- read_csv(data_path, show_col_types = FALSE)
message("Dados carregados: ", nrow(dados), " registos e ", ncol(dados), " colunas.")

# 3) Normalizar nomes de colunas
names(dados) <- names(dados) %>%
  tolower() %>%
  str_replace_all("[^a-z0-9]+", "_") %>%
  str_replace_all("_+$", "")

# 4) Garantir fatores
dados <- dados %>%
  mutate(
    hour = as.factor(hour),
    seasons = as.factor(seasons),
    holiday = as.factor(holiday),
    functioning_day = as.factor(functioning_day)
  )

# 5) Separar treino/teste (80/20)
set.seed(123)
split <- initial_split(dados, prop = 0.8)
treino <- training(split)
teste  <- testing(split)
message("Divisão treino/teste: ", nrow(treino), " treino e ", nrow(teste), " teste.")

# 6) Receita climática (numéricas normalizadas)
receita_clima <- recipe(rented_bike_count ~ temperature_c + humidity + wind_speed_m_s +
                          rainfall_mm + snowfall_cm + solar_radiation_mj_m2,
                        data = treino) %>%
  step_normalize(all_numeric_predictors())

# 7) Remover categóricas com apenas um nível
categoricas <- treino %>% select(where(is.factor))
variaveis_validas <- names(Filter(function(x) nlevels(x) > 1, categoricas))
message("Variáveis categóricas com mais de 1 nível: ", paste(variaveis_validas, collapse = ", "))

# 8) Receita temporal com variáveis categóricas válidas
formula_tempo <- as.formula(paste("rented_bike_count ~", paste(variaveis_validas, collapse = " + ")))

receita_tempo <- recipe(formula_tempo, data = treino) %>%
  step_dummy(all_nominal_predictors())

# 9) Definir modelo
modelo_lm <- linear_reg() %>% set_engine("lm")

# 10) Treinar modelos
wf_clima <- workflow() %>%
  add_recipe(receita_clima) %>%
  add_model(modelo_lm) %>%
  fit(data = treino)
message("Modelo climático treinado.")

wf_tempo <- workflow() %>%
  add_recipe(receita_tempo) %>%
  add_model(modelo_lm) %>%
  fit(data = treino)
message("Modelo temporal treinado.")

# 11) Avaliar desempenho
metricas <- metric_set(rmse, rsq)

pred_clima <- predict(wf_clima, teste) %>% bind_cols(teste)
res_clima  <- metricas(pred_clima, truth = rented_bike_count, estimate = .pred)

pred_tempo <- predict(wf_tempo, teste) %>% bind_cols(teste)
res_tempo  <- metricas(pred_tempo, truth = rented_bike_count, estimate = .pred)

# 12) Mostrar resultados
cat("\nDesempenho do modelo climático:\n")
print(res_clima)

cat("\nDesempenho do modelo temporal:\n")
print(res_tempo)

