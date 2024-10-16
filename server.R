# Definir servidor
server <- shinyServer(function(input, output, session) {
  
  archivo_cargado <- reactive({
    req(input$archivo)
    read_csv(input$archivo$datapath, locale = locale(encoding = "UTF-8"), show_col_types = FALSE)
  })
  
  output$columnaReseñasUI <- renderUI({
    req(archivo_cargado())
    selectInput("columna_reseñas", "Columna con reseñas", 
                choices = names(archivo_cargado()), 
                selected = NULL)
  })
  
  output$columnaPuntuacionesUI <- renderUI({
    req(archivo_cargado())
    selectInput("puntuaciones", "Columna de puntuaciones", 
                choices = names(archivo_cargado()), 
                selected = NULL)
  })
  
  output$resultadoDisponible <- reactive({
    return(!is.null(input$ejecutar_analisis) && input$ejecutar_analisis > 0)
  })
  outputOptions(output, "resultadoDisponible", suspendWhenHidden = FALSE)
  
  observeEvent(input$ejecutar_analisis, {
    tipo_analisis <- input$tipo_analisis
    archivo <- archivo_cargado()
    
    if (is.null(input$columna_reseñas) || input$columna_reseñas == "") {
      showNotification("Por favor, selecciona una columna de reseñas.", type = "error")
      return()
    }
    
    archivo$texto <- sapply(archivo[[input$columna_reseñas]], function(x) {
      x <- tolower(x)
      x <- gsub("[[:punct:]]", "", x)
      x <- gsub("[^a-zA-Z\\s]", "", x)
      x <- gsub("^\\s+|\\s+$", "", x)
      words <- strsplit(x, "\\s+")[[1]]
      words <- words[!words %in% stop_words$word]
      paste(words, collapse = " ")
    })
    
    if (tipo_analisis == "Frecuencia de palabras") {
      word_freq <- archivo %>%
        unnest_tokens(word, texto) %>%
        count(word, sort = TRUE) %>%
        filter(!word %in% stop_words$word)
      
      output$grafica <- renderPlot({
        wordcloud(words = word_freq$word, freq = word_freq$n, 
                  max.words = 100, min.freq = 1, 
                  random.order = FALSE, rot.per = 0.35,
                  colors = brewer.pal(8, "Dark2"))
      })
      
    } else if (tipo_analisis == "Distribución de puntuaciones") {
      if (is.null(input$puntuaciones) || input$puntuaciones == "") {
        showNotification("Por favor, selecciona una columna de puntuaciones.", type = "error")
        return()
      }
      
      score_counts <- archivo %>% count(!!sym(input$puntuaciones))
      
      output$grafica <- renderPlot({
        ggplot(score_counts, aes(x = !!sym(input$puntuaciones), y = n)) + 
          geom_bar(stat = "identity", fill = "steelblue") + 
          labs(x = "Puntuación", y = "Frecuencia", 
               title = "Distribución de puntuaciones") + 
          theme_minimal()
      })
      
    } else if (tipo_analisis == "Análisis de sentimiento") {
      sentiment_counts <- archivo %>%
        mutate(sentimiento = sentimentr::sentiment(archivo[[input$columna_reseñas]]) %>% 
                 group_by(element_id) %>%
                 summarise(sentiment = mean(sentiment, na.rm = TRUE)) %>%
                 pull(sentiment)) %>%
        mutate(sentimiento = ifelse(sentimiento > 0, "positivo", 
                                    ifelse(sentimiento < 0, "negativo", "neutro"))) %>%
        count(sentimiento)
      
      output$grafica <- renderPlot({
        ggplot(sentiment_counts, aes(x = sentimiento, y = n, fill = sentimiento)) + 
          geom_bar(stat = "identity") + 
          scale_fill_manual(values = c("positivo" = "green", "negativo" = "red", "neutro" = "gray")) + 
          labs(x = "Sentimiento", y = "Frecuencia", 
               title = "Análisis de sentimiento") + 
          theme_minimal()
      })
    }
  })
})
