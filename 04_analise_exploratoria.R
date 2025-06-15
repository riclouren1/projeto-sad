# --------------------------------------------
# ANÁLISE EXPLORATÓRIA - SEUL
# --------------------------------------------

setwd("/cloud/project")

library(readr)
library(dplyr)
library(stringr)
library(lubridate)
library(ggplot2)

# Caminhos
input_path <- "Datasets/SeoulBikeData.csv"
output_path <- "Datasets/clean_seoul_bike_sharing.csv"

if (!file.exists(input_path)) {
  stop("❌ Ficheiro 'SeoulBikeData.csv' não encontrado.")
}

# Leitura com readr (UTF-8 robusto)
seoul_raw <- read_csv(input_path, locale = locale(encoding = "UTF-8"))

# Corrigir nomes das colunas
names(seoul_raw) <- str_trim(names(seoul_raw))
names(seoul_raw) <- make.names(names(seoul_raw))

# Limpeza e transformação
seoul_clean <- seoul_raw %>%
  rename_with(~ str_to_lower(.) %>% str_replace_all("[^a-z0-9]+", "_")) %>%
  mutate(
    date = dmy(date),
    hour = as.factor(hour),
    seasons = as.factor(seasons),
    holiday = as.factor(holiday),
    functioning_day = as.factor(functioning_day),
    rented_bike_count = as.numeric(gsub(",", "", rented_bike_count)),
    temperature_c_ = as.numeric(gsub(",", "", temperature_c_))
  ) %>%
  filter(functioning_day == "Yes") %>%
  arrange(date, hour)

# Guardar ficheiro limpo
write_csv(seoul_clean, output_path)
message("✅ Dados limpos guardados em: ", output_path)

# Estatísticas descritivas
message("📊 Total de registos:", nrow(seoul_clean))
message("📅 Dias únicos:", length(unique(seoul_clean$date)))
print(seoul_clean %>% count(seasons))
print(seoul_clean %>% count(holiday))

# Gráfico 1 – Aluguer ao longo do tempo
print(
  ggplot(seoul_clean, aes(x = date, y = rented_bike_count)) +
    geom_line(color = "steelblue") +
    labs(title = "Aluguer de Bicicletas ao Longo do Tempo", x = "Data", y = "N.º de Bicicletas")
)

# Gráfico 2 – Boxplot por hora e estação
print(
  ggplot(seoul_clean, aes(x = hour, y = rented_bike_count, fill = seasons)) +
    geom_boxplot(outlier.size = 0.5) +
    labs(title = "Distribuição por Hora e Estação", x = "Hora", y = "Bicicletas Alugadas") +
    theme(axis.text.x = element_text(angle = 90))
)

# Gráfico 3 – Temperatura vs Aluguer
print(
  ggplot(seoul_clean, aes(x = temperature_c_, y = rented_bike_count, color = seasons)) +
    geom_point(alpha = 0.4) +
    geom_smooth(method = "lm", se = FALSE) +
    labs(title = "Temperatura vs Aluguer", x = "Temperatura (°C)", y = "Aluguer de Bicicletas")
)

# Correlação entre todas as colunas numéricas
message("\n🔍 Correlação entre variáveis numéricas:")
numeric_df <- seoul_clean %>% select(where(is.numeric))
corr_matrix <- cor(numeric_df, use = "complete.obs")
print(corr_matrix)

# Gráfico – Aluguer por dia da semana
seoul_clean <- seoul_clean %>%
  mutate(weekday = weekdays(date))

print(
  ggplot(seoul_clean, aes(x = weekday, y = rented_bike_count)) +
    geom_boxplot() +
    labs(title = "Aluguer por Dia da Semana", x = "Dia", y = "N.º de Bicicletas") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
)
