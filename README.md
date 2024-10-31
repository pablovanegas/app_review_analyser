# Análisis de Reseñas con Shiny

Esta aplicación Shiny permite realizar análisis de texto y puntuaciones a partir de un archivo CSV con reseñas y puntuaciones de productos, servicios o experiencias. La aplicación ofrece tres tipos de análisis: frecuencia de palabras, distribución de puntuaciones y análisis de sentimiento.

## Requisitos

Esta aplicación requiere los siguientes paquetes en R:

- `shiny`
- `shinydashboard`
- `readr`
- `dplyr`
- `tidyr`
- `ggplot2`
- `wordcloud`
- `sentimentr`
- `tidytext`

Asegúrate de tenerlos instalados antes de ejecutar la aplicación.

## Uso de la Aplicación

### Carga de Archivo

1. **Archivo CSV**: Carga un archivo CSV que contenga al menos dos columnas: una con las reseñas (texto) y otra con las puntuaciones (números).
2. **Formato UTF-8**: Asegúrate de que el archivo esté en formato UTF-8.

### Selección de Parámetros de Análisis

1. **Tipo de Análisis**: Selecciona el tipo de análisis deseado:
   - **Frecuencia de Palabras**: Muestra las palabras más frecuentes en las reseñas.
   - **Distribución de Puntuaciones**: Analiza la distribución de las puntuaciones (requiere seleccionar la columna de puntuaciones).
   - **Análisis de Sentimiento**: Analiza la polaridad de los sentimientos en las reseñas.
   - **Todos**: Ejecuta los tres tipos de análisis.
2. **Selección de Columnas**: Selecciona la columna de reseñas y, en caso de realizar un análisis de distribución de puntuaciones, selecciona también la columna de puntuaciones.

### Ejecución del Análisis

Haz clic en **"Ejecutar análisis"** para visualizar los resultados en la sección de resultados.

---

## Funcionalidades del Análisis

### Frecuencia de Palabras

- Limpia y tokeniza el texto de las reseñas, eliminando signos de puntuación y palabras comunes sin relevancia (stop words).
- Genera una nube de palabras con las palabras más frecuentes.

### Distribución de Puntuaciones

- Muestra un gráfico de barras de la frecuencia de las puntuaciones seleccionadas en el archivo.

### Análisis de Sentimiento

- Clasifica el sentimiento de cada reseña como positivo, negativo o neutro, y muestra un gráfico de barras con la distribución de estos sentimientos.

---

## Ejecución

Para ejecutar la aplicación, utiliza el siguiente código en tu consola de R:

```r
library(shiny)
shiny::runApp("path/to/your/app")
