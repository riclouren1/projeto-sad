# Projeto SAD 2024/2025 – Previsão de Aluguer de Bicicletas

Este projeto foi desenvolvido no âmbito da unidade curricular de Sistemas de Apoio à Decisão (UAL) e tem como objetivo prever a procura por bicicletas com base em variáveis climáticas e temporais.

##  Estrutura do Projeto


##  Scripts principais

- `02_openweather_forecast.R`: recolha de previsões horárias via OpenWeatherMap
- `03*.R`: limpeza e preparação dos dados
- `04_analise_exploratoria.R`: gráficos e estatísticas de Seul
- `05_modelagem_regressao.R`: modelos lineares de previsão
- `06_dashboard_shiny.R`: aplicação interativa com visualização por cidade

##  Como executar

1. Abrir o projeto no RStudio Cloud ou local
2. Instalar os pacotes necessários (`dplyr`, `ggplot2`, `readr`, `lubridate`, `tidymodels`, `shiny`, `DT`)
3. Correr os scripts por ordem (01 a 06)
4. Executar `06_dashboard_shiny.R` e clicar em **Run App**

## 📝 Relatório

Ver `Relatorio_SeoulBike.Rmd` para detalhes técnicos, análise e resultados.

---

Projeto desenvolvido por: Daniela Filipe, Iris da Silva, Ricardo Domingos 
Data: `r Sys.Date()`
