# --------------------------------------------
# DASHBOARD SHINY – 5 CIDADES
# --------------------------------------------

library(shiny)
library(readr)
library(dplyr)
library(ggplot2)

# Caminho do ficheiro unificado
dados <- read_csv("Datasets/clean_all_weather.csv")



# Carregar dados
dados <- read_csv(data_path, show_col_types = FALSE)

# UI
ui <- fluidPage(
  titlePanel("Previsão de Tempo e Aluguer de Bicicletas – 5 Cidades"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("cidade", "Escolhe a cidade:",
                  choices = unique(dados$cidade),
                  selected = "Seul")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Tabela de Dados",
                 DT::dataTableOutput("tabela")
        ),
        
        tabPanel("Gráficos por Hora",
                 fluidRow(
                   column(6, plotOutput("graf_temp")),
                   column(6, plotOutput("graf_chuva"))
                 ),
                 fluidRow(
                   column(6, plotOutput("graf_vento")),
                   column(6, plotOutput("graf_humidade"))
                 )
        )
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  dados_filtrados <- reactive({
    dados %>%
      filter(cidade == input$cidade)
  })
  
  output$tabela <- DT::renderDataTable({
    DT::datatable(dados_filtrados())
  })
  
  output$graf_temp <- renderPlot({
    ggplot(dados_filtrados(), aes(x = hora, y = temperatura)) +
      geom_line(group = 1, color = "firebrick") +
      labs(title = "Temperatura por Hora", x = "Hora", y = "Temperatura (°C)")
  })
  
  output$graf_chuva <- renderPlot({
    ggplot(dados_filtrados(), aes(x = hora, y = chuva)) +
      geom_col(fill = "steelblue") +
      labs(title = "Chuva por Hora", x = "Hora", y = "mm")
  })
  
  output$graf_vento <- renderPlot({
    ggplot(dados_filtrados(), aes(x = hora, y = vento)) +
      geom_line(group = 1, color = "darkorange") +
      labs(title = "Velocidade do Vento por Hora", x = "Hora", y = "m/s")
  })
  
  output$graf_humidade <- renderPlot({
    ggplot(dados_filtrados(), aes(x = hora, y = humidade)) +
      geom_line(group = 1, color = "darkgreen") +
      labs(title = "Humidade Relativa por Hora", x = "Hora", y = "%")
  })
}

# Lançar App
shinyApp(ui, server)

