library(shiny)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(wordcloud)
library(sentimentr)
# Definir interfaz de usuario
library(shiny)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(wordcloud)
library(sentimentr)

# Definir interfaz de usuario
ui <- shinyUI(fluidPage(
  
  # Título de la aplicación con un estilo más atractivo
  titlePanel(h2("Análisis de Reseñas", align = "center")),
  
  # Descripción breve de la aplicación
  fluidRow(
    column(12, 
           p("Sube un archivo CSV que contenga reseñas de productos, selecciona el tipo de análisis que deseas realizar y la columna correspondiente. La aplicación generará automáticamente gráficos que te ayudarán a interpretar los datos.")
    )
  ),
  
  # Panel de carga de archivo
  sidebarLayout(
    sidebarPanel(
      # Botón para cargar archivo CSV
      fileInput("archivo", "Cargar archivo CSV", 
                accept = c(".csv"),
                buttonLabel = "Buscar...",
                placeholder = "No se ha cargado ningún archivo"),
      
      # Mensaje de ayuda para el archivo CSV
      helpText("El archivo debe contener una columna con las reseñas y otra con las puntuaciones."),
      
      # Seleccionar tipo de análisis
      selectInput("tipo_analisis", "Tipo de análisis", 
                  choices = c("Frecuencia de palabras", 
                              "Distribución de puntuaciones", 
                              "Análisis de sentimiento", 
                              "Todos"),
                  selected = "Frecuencia de palabras"),
      
      # Selector de la columna que contiene las reseñas (se actualiza dinámicamente)
      uiOutput("columnaReseñasUI"),
      
      # Selector de la columna que contiene las puntuaciones (se actualiza dinámicamente)
      uiOutput("columnaPuntuacionesUI"),
      
      # Selector de la columna de productos (se actualiza dinámicamente)
      uiOutput("columnaProductosUI"),
      
      # Botón para ejecutar el análisis
      actionButton("ejecutar_analisis", "Ejecutar análisis", 
                   icon = icon("chart-bar")),
      
      # Mensaje de ayuda para guiar al usuario
      helpText("Haz clic en 'Ejecutar análisis' para visualizar los resultados.")
    ),
    
    # Panel principal para mostrar los resultados
    mainPanel(
      # Mostrar un mensaje de bienvenida cuando no hay resultados
      conditionalPanel(
        condition = "output.resultadoDisponible == false",
        h4("Resultados", align = "center"),
        p("Cargue un archivo CSV y seleccione un tipo de análisis para visualizar los resultados aquí.", 
          align = "center")
      ),
      
      # Mostrar la gráfica de resultados cuando esté disponible
      conditionalPanel(
        condition = "output.resultadoDisponible == true",
        h4("Resultados del análisis", align = "center"),
        plotOutput("grafica", height = "600px")
      )
    )
  )
))

shinyApp(ui = ui, server = server)
