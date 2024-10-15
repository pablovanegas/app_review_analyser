# Definir interfaz de usuario
ui <- shinyUI(fluidPage(
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
      
      # Este es el caso de que solo sea un producto
      
      selectInput("reviews", "Columna con reseñas", choices = NULL),
      
      selectInput("puntuaciones", "Columna de puntuaciones", choices = NULL),
      
      # Para el caso de que sean varios productos 
      
      selectInput('productos', 'Columna lista de Productos', choices = NULL),
      
      
      
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

shinyApp(ui = ui, server = server)
