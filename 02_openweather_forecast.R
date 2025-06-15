# --------------------------------------------
# Recolha de Dados Climáticos – OpenWeatherMap
# --------------------------------------------

library(httr)
library(jsonlite)
library(dplyr)
library(lubridate)

# API Key
api_key <- "c58abecd625451cfe85737e0ec34e57f"

# Cidades e coordenadas (latitude e longitude)
cidades <- data.frame(
  cidade = c("Nova York", "Paris", "Suzhou", "Londres"),
  lat = c(40.7128, 48.8566, 31.2989, 51.5072),
  lon = c(-74.0060, 2.3522, 120.5853, -0.1276)
)

# Lista para guardar resultados
previsoes <- list()

# Loop pelas cidades
for (i in 1:nrow(cidades)) {
  url <- paste0(
    "https://api.openweathermap.org/data/2.5/forecast?",
    "lat=", cidades$lat[i],
    "&lon=", cidades$lon[i],
    "&units=metric&appid=", api_key
  )
  
  resposta <- tryCatch({
    fromJSON(content(GET(url), "text", encoding = "UTF-8"))
  }, error = function(e) NULL)
  
  if (!is.null(resposta$list)) {
    dados <- resposta$list %>%
      transmute(
        datetime = as.POSIXct(dt, origin = "1970-01-01", tz = "UTC"),
        temperatura = main$temp,
        sensacao = main$feels_like,
        humidade = main$humidity,
        vento = wind$speed,
        chuva = ifelse(is.null(rain$`3h`), 0, rain$`3h`),
        cidade = cidades$cidade[i]
      )
    
    previsoes[[i]] <- dados
  } else {
    message("Erro ao obter dados de ", cidades$cidade[i])
  }
}

# Concatenar e guardar
dados_final <- bind_rows(previsoes)
write.csv(dados_final, "Datasets/raw_cities_weather_forecast.csv", row.names = FALSE)
message("Ficheiro salvo em: Datasets/raw_cities_weather_forecast.csv")
