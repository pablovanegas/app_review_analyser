# Definir servidor
server <- shinyServer(function(input, output) {
  # Crear una variable reactiva para almacenar el archivo cargado
  archivo_cargado <- reactive({
    req(input$archivo)
    read_csv(input$archivo$datapath)
  })
  
  
  
  # Evento de ejecución del análisis
  observeEvent(input$ejecutar_analisis, {
    # Obtener tipo de análisis seleccionado
    tipo_analisis <- input$tipo_analisis
    
    # Obtener el archivo cargado
    archivo <- archivo_cargado()
    
    # Preprocesar texto
    archivo$texto <- sapply(archivo$texto, function(x) {
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
      wordcloud <- wordcloud(words = word_freq$word, freq = word_freq$n, 
                             max.words = 100, min.freq = 1, 
                             random.order = FALSE, rot.per.char = TRUE, 
                             colors = brewer.pal(8, "Dark2"))
      
      # Mostrar la nube de palabras
      output$grafica <- renderPlot({
        wordcloud
      })
    } else if (tipo_analisis == "Distribución de puntuaciones") {
      # Crear contador de puntuaciones
      score_counts <- archivo %>% count(puntuacion)
      
      # Mostrar la distribución de puntuaciones
      output$grafica <- renderPlot({
        ggplot(score_counts, aes(x = puntuacion, y = n)) + 
          geom_bar(stat = "identity") + 
          labs(x = "Puntuación", y = "Frecuencia") + 
          ggtitle("Distribución de puntuaciones")
      })
    } else if (tipo_analisis == "Análisis de sentimiento") {
      # Crear contador de sentimientos
      sentiment_counts <- archivo %>%
        mutate(sentimiento = ifelse(sentimiento > 0, "positivo", ifelse(sentimiento < 0, "negativo", "neutro"))) %>%
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
