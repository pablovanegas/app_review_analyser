library(shiny)
library(shinydashboard)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(wordcloud)
library(sentimentr)
library(tidytext)

# Definir interfaz de usuario
ui <- dashboardPage(
  dashboardHeader(title = "Análisis de Reseñas"),
  
  dashboardSidebar(
    width = 300,  # Aumenta el ancho de la barra lateral
    sidebarMenu(
      menuItem("Cargar Datos", tabName = "cargar", icon = icon("upload"))
    ),
    fileInput("archivo", "Cargar archivo CSV", 
              accept = c(".csv"),
              buttonLabel = "Buscar...",
              placeholder = "No se ha cargado ningún archivo"),
    helpText("El archivo debe contener una columna con las reseñas y otra con las puntuaciones."),
    selectInput("tipo_analisis", "Tipo de análisis", 
                choices = c("Frecuencia de palabras", 
                            "Distribución de puntuaciones", 
                            "Análisis de sentimiento", 
                            "Todos"),
                selected = "Frecuencia de palabras"),
    uiOutput("columnaReseñasUI"),
    conditionalPanel(
      condition = "input.tipo_analisis == 'Distribución de puntuaciones' || input.tipo_analisis == 'Todos'",
      uiOutput("columnaPuntuacionesUI")
    ),
    actionButton("ejecutar_analisis", "Ejecutar análisis", 
                 icon = icon("chart-bar")),
    helpText("Haz clic en 'Ejecutar análisis' para visualizar los resultados.")
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper {
          margin-left: 300px; /* Alinea el contenido con la barra lateral más ancha */
        }
        .box {
          width: 100%; /* Aumenta el ancho de las cajas */
        }
      "))
    ),
    fluidRow(
      box(
        title = "Resultados del análisis",
        status = "primary",
        solidHeader = TRUE,
        width = 12,
        plotOutput("grafica_frecuencia", height = "400px"),
        plotOutput("grafica_puntuaciones", height = "400px"),
        plotOutput("grafica_sentimiento", height = "400px")
      )
    )
  )
)
