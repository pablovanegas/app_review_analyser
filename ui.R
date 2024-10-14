# Definir interfaz de usuario
shinyUI(fluidPage(
  # Título de la aplicación
  titlePanel("Análisis de reseñas"),
  
  # Panel de carga de archivo
  sidebarLayout(
    sidebarPanel(
      # Botón para cargar archivo CSV
      fileInput("archivo", "Cargar archivo CSV"),
      
      # Seleccionar tipo de análisis
      selectInput("tipo_analisis", "Tipo de análisis", 
                  choices = c("Frecuencia de palabras", "Distribución de puntuaciones", "Análisis de sentimiento", "Todos")),
      
      # Seleccionar columna de texto
      selectInput("reviews", "Columna con reseñas", choices = NULL),
      
      selectInput("puntuaciones", "Columna de puntuaciones", choices = NULL),
      
      
      
      # Botón para ejecutar análisis
      actionButton("ejecutar_analisis", "Ejecutar análisis")
    ),
    
    # Panel de resultados
    mainPanel(
      # Gráfica de resultados
      plotOutput("grafica")
    )
  )
))