# --------------------------------------------
# Limpeza dos dados de previsão climática (API)
# --------------------------------------------

library(dplyr)
library(readr)
library(lubridate)
library(stringr)

# Caminho
input_path <- "Datasets/raw_cities_weather_forecast.csv"
output_path <- "Datasets/clean_cities_weather_forecast.csv"

# Verifica se o ficheiro existe
if (!file.exists(input_path)) {
  stop("Ficheiro de dados brutos não encontrado em ", input_path)
}

# Carrega os dados
dados_raw <- read_csv(input_path, show_col_types = FALSE)

# Limpeza e transformação
dados_clean <- dados_raw %>%
  mutate(
    cidade = str_trim(cidade),
    data = as.Date(datetime),
    hora = hour(datetime),
    hora = factor(hora, levels = 0:23, ordered = TRUE)
  ) %>%
  select(cidade, data, hora, temperatura, sensacao, humidade, vento, chuva) %>%
  arrange(cidade, data, hora)

# Guardar limpo
write_csv(dados_clean, output_path)
message("Ficheiro limpo criado em: ", output_path)
