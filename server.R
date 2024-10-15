# Definir servidor
server <- shinyServer(function(input, output, session) {
  
  # Crear una variable reactiva para almacenar el archivo cargado
  archivo_cargado <- reactive({
    req(input$archivo)  # Asegurarse de que se ha cargado un archivo
    # Leer el archivo con codificación UTF-8
    read_csv(input$archivo$datapath, locale = locale(encoding = "UTF-8"))
  })
  
  # Renderizar selectInput dinámico para seleccionar la columna de reseñas
  output$columnaReseñasUI <- renderUI({
    req(archivo_cargado())
    selectInput("columna_reseñas", "Columna con reseñas", 
                choices = names(archivo_cargado()), 
                selected = NULL)
  })
  
  # Renderizar selectInput dinámico para seleccionar la columna de puntuaciones
  output$columnaPuntuacionesUI <- renderUI({
    req(archivo_cargado())
    selectInput("puntuaciones", "Columna de puntuaciones", 
                choices = names(archivo_cargado()), 
                selected = NULL)
  })
  
  
  # Variable de control para el conditionalPanel de la UI
  output$resultadoDisponible <- reactive({
    # Retorna TRUE si se ha realizado un análisis, para mostrar la gráfica
    return(!is.null(input$ejecutar_analisis) && input$ejecutar_analisis > 0)
  })
  outputOptions(output, "resultadoDisponible", suspendWhenHidden = FALSE)
  
  # Evento de ejecución del análisis
  observeEvent(input$ejecutar_analisis, {
    # Obtener tipo de análisis seleccionado
    tipo_analisis <- input$tipo_analisis
    
    # Obtener el archivo cargado
    archivo <- archivo_cargado()
    
    # Verificar si la columna de reseñas está seleccionada
    if (is.null(input$columna_reseñas) || input$columna_reseñas == "") {
      showNotification("Por favor, selecciona una columna de reseñas.", type = "error")
      return()
    }
    
    # Preprocesar texto
    archivo$texto <- sapply(archivo[[input$columna_reseñas]], function(x) {
      x <- tolower(x)
      x <- gsub("[[:punct:]]", "", x)
      x <- gsub("[^a-zA-Z\\s]", "", x)
      x <- gsub("^\\s+|\\s+$", "", x)
      words <- strsplit(x, "\\s+")[[1]]
      words <- words[!words %in% stop_words$word]
      paste(words, collapse = " ")
    })
    
    # Ejecutar análisis según el tipo seleccionado
    if (tipo_analisis == "Frecuencia de palabras") {
      # Crear contador de frecuencia de palabras
      word_freq <- archivo %>%
        unnest_tokens(word, texto) %>%
        count(word, sort = TRUE) %>%
        filter(!word %in% stop_words$word)
      
      # Crear nube de palabras
      output$grafica <- renderPlot({
        wordcloud(words = word_freq$word, freq = word_freq$n, 
                  max.words = 100, min.freq = 1, 
                  random.order = FALSE, rot.per.char = TRUE, 
                  colors = brewer.pal(8, "Dark2"))
      })
      
    } else if (tipo_analisis == "Distribución de puntuaciones") {
      # Verificar si la columna de puntuaciones está seleccionada
      if (is.null(input$puntuaciones) || input$puntuaciones == "") {
        showNotification("Por favor, selecciona una columna de puntuaciones.", type = "error")
        return()
      }
      
      # Crear contador de puntuaciones
      score_counts <- archivo %>% count(!!sym(input$puntuaciones))
      
      # Mostrar la distribución de puntuaciones
      output$grafica <- renderPlot({
        ggplot(score_counts, aes(x = !!sym(input$puntuaciones), y = n)) + 
          geom_bar(stat = "identity") + 
          labs(x = "Puntuación", y = "Frecuencia") + 
          ggtitle("Distribución de puntuaciones")
      })
      
    } else if (tipo_analisis == "Análisis de sentimiento") {
      # Realizar el análisis de sentimiento
      sentiment_counts <- archivo %>%
        mutate(sentimiento = sentimentr::sentiment(archivo[[input$columna_reseñas]])) %>%
        mutate(sentimiento = ifelse(sentimiento$sentiment > 0, "positivo", 
                                    ifelse(sentimiento$sentiment < 0, "negativo", "neutro"))) %>%
        count(sentimiento)
      
      # Mostrar el análisis de sentimiento
      output$grafica <- renderPlot({
        ggplot(sentiment_counts, aes(x = sentimiento, y = n)) + 
          geom_bar(stat = "identity") + 
          labs(x = "Sentimiento", y = "Frecuencia") + 
          ggtitle("Análisis de sentimiento")
      })
    }
  })
})
