# Cargar librerías
library(tidyverse)
library(tm)
library(e1071)
library(caret)

# Cargar el archivo CSV con las reseñas
df <- read.csv("C:/Users/pajua/Desktop/Programacion/review_analyser/netflix_reviews.csv")

# Preprocesamiento de texto
library(tm)

# Cargar el archivo CSV con las reseñas
df <- read.csv("C:/Users/pajua/Desktop/Programacion/review_analyser/netflix_reviews.csv")

# Preprocesamiento de texto
library(tm)

clean_text <- function(text) {
  if (is.na(text) | text == "") {
    return("")
  } else {
    text <- tolower(text)
    text <- gsub("[[:punct:]]", "", text)  # Utiliza gsub para eliminar puntuaciones
    text <- gsub("[[:digit:]]", "", text)  # Utiliza gsub para eliminar números
    text <- removeWords(text, stopwords("en"))
    text <- gsub("\\s+", " ", text)  # Utiliza gsub para eliminar espacios en blanco adicionales
    return(text)
  }
}

# Aplicar limpieza de texto a la columna de reseñas
df$cleaned_review <- sapply(df$content, clean_text)

# Aplicar limpieza de texto a la columna de reseñas
df$cleaned_review <- sapply(df$content, clean_text)
# Aplicar limpieza de texto a la columna de reseñas
df$cleaned_review <- sapply(df$content, clean_text)

# Crear un Corpus
corpus <- Corpus(VectorSource(df$cleaned_review))

# Crear una matriz de términos (Term-Document Matrix)
dtm <- DocumentTermMatrix(corpus)

# Convertir a un data frame
dtm_df <- as.data.frame(as.matrix(dtm))

# Añadir la variable de sentimiento al dataset
dtm_df$sentiment <- df$sentiment

# Dividir los datos en entrenamiento y prueba
set.seed(123)
trainIndex <- createDataPartition(dtm_df$sentiment, p = .8, 
                                  list = FALSE, 
                                  times = 1)
train_data <- dtm_df[trainIndex,]
test_data <- dtm_df[-trainIndex,]

# Entrenar el modelo Naive Bayes
modelo <- naiveBayes(sentiment ~ ., data = train_data)

# Realizar predicciones
predicciones <- predict(modelo, newdata = test_data)

# Evaluación del modelo
confusionMatrix(predicciones, test_data$sentiment)

# Visualización de los resultados
sentiment_counts <- table(test_data$sentiment)
barplot(sentiment_counts, main = "Sentiment Analysis", col = "blue")

