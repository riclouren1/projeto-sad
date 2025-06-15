# --------------------------------------------
# LIMPEZA: Dados de previsão do tempo (OpenWeather)
# Ficheiro original: raw_cities_weather_forecast.csv
# Saída: clean_cities_weather_forecast.csv
#
# --------------------------------------------

#  Carregar pacotes necessários
library(readr)     # para ler e escrever ficheiros CSV
library(dplyr)     # para manipulação de dados
library(stringr)   # para limpeza de nomes de colunas

#  Ler o dataset bruto
dados_raw <- read_csv("Datasets/raw_cities_weather_forecast.csv")

#  Ver estrutura inicial
glimpse(dados_raw)

#  1. Normalizar nomes das colunas (snake_case)
dados_limpos <- dados_raw %>%
  rename_with(~ str_to_lower(.) %>% str_replace_all(" ", "_"))

#  2. Selecionar apenas as colunas úteis
dados_limpos <- dados_limpos %>%
  select(
    datetime,
    city,
    temp,
    humidity,
    pressure,
    wind_speed,
    weather_main,
    weather_desc
  )

# 3. Remover linhas com valores ausentes
dados_limpos <- dados_limpos %>%
  filter(across(c(temp, humidity, pressure, wind_speed), ~ !is.na(.)))

# ️ 4. Converter colunas de texto em fatores
dados_limpos <- dados_limpos %>%
  mutate(
    city = as.factor(city),
    weather_main = as.factor(weather_main),
    weather_desc = as.factor(weather_desc)
  )

# ️ 5. Ordenar cronologicamente
dados_limpos <- dados_limpos %>%
  arrange(city, datetime)

# 6. Guardar versão limpa
write_csv(dados_limpos, "Datasets/clean_cities_weather_forecast.csv")

# Mensagem final
cat("Dados limpos guardados em: Datasets/clean_cities_weather_forecast.csv\n")
