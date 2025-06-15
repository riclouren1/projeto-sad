# --------------------------------------------
# União dos dados de Seul + outras 4 cidades
# --------------------------------------------

library(dplyr)
library(readr)
library(lubridate)
library(stringr)

# Caminhos dos ficheiros
seoul_path <- "Datasets/clean_seoul_bike_sharing.csv"
clima_path <- "Datasets/clean_cities_weather_forecast.csv"
saida_path <- "Datasets/clean_all_weather.csv"

# Verificar se os ficheiros existem
if (!file.exists(seoul_path)) stop("Ficheiro de Seul não encontrado.")
if (!file.exists(clima_path)) stop("Ficheiro climático não encontrado.")

# Carregar dados de Seul com nomes reais
seoul <- read_csv(seoul_path, show_col_types = FALSE) %>%
  transmute(
    cidade = "Seul",
    data = as.Date(date),
    hora = as.integer(as.character(hour)),
    temperatura = temperature_c_,
    sensacao = temperature_c_,
    humidade = humidity_,
    vento = wind_speed_m_s_,
    chuva = rainfall_mm_
  )

# Carregar dados das outras cidades
outras <- read_csv(clima_path, show_col_types = FALSE)

# Juntar tudo
todos <- bind_rows(seoul, outras) %>%
  arrange(cidade, data, hora)

# Guardar no ficheiro final
write_csv(todos, saida_path)
message("✅ Ficheiro final criado: ", saida_path)
