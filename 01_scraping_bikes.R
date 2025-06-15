# --------------------------------------------
# 01_scraping_bikes.R
# --------------------------------------------
# Justificativa para não realizar scraping direto

# Este script foi reservado para realizar scraping de dados
# diretamente a partir de plataformas de partilha de bicicletas
# como:
#   - CitiBike NYC (Nova York)
#   - Vélib (Paris)
#   - Santander Cycles (Londres)
#   - etc.

# No entanto, após revisão do escopo do projeto e análise das plataformas disponíveis,
# verificou-se que a maioria destes sistemas:
#   - exige autenticação (token de acesso, registo)
#   - tem APIs fechadas ou documentação limitada
#   - ou não disponibiliza previsões horárias abertas ao público

# ✅ Por isso, optámos por utilizar:
#   - Dados históricos reais de Seul (SeoulBikeData.csv)
#   - Dados de previsão do tempo via OpenWeatherMap API
#   - Modelagem própria (regressão) para estimar procura com base no clima e hora

# Isso garantiu consistência, comparabilidade e cumprimento do ponto 12 do enunciado.

# Script mantido para manter a estrutura proposta e documentar esta decisão.
