# Análisis de Reseñas con Shiny

Este proyecto es una aplicación web en R que utiliza **Shiny** para analizar reseñas de un archivo CSV. Permite explorar y visualizar datos de texto mediante análisis de frecuencia de palabras, análisis de sentimiento y visualización de distribución de puntuaciones, facilitando la interpretación de opiniones y la obtención de información útil de los comentarios de los usuarios.

## Descripción General
### ¿Qué Hace Esta Aplicación?
La aplicación permite:

- **Carga de Datos de Reseñas**: Cargar un archivo CSV con reseñas y puntuaciones opcionales.
- **Selección del Tipo de Análisis**: Elige entre análisis de frecuencia de palabras, análisis de sentimiento, distribución de puntuaciones, o los tres análisis combinados.
- **Visualización de Resultados**: Ver los resultados directamente en la aplicación, incluyendo gráficos como nubes de palabras, gráficos de barras y distribuciones de sentimientos.

## Análisis Principales
1. **Análisis de Frecuencia de Palabras**:
   - Genera una nube de palabras para resaltar los términos más comunes en las reseñas.
   - Excluye palabras comunes (stop words) para un análisis más significativo.

2. **Distribución de Puntuaciones**:
   - Crea un gráfico de barras para visualizar la frecuencia de las puntuaciones.
   - Útil para evaluar la satisfacción general de los usuarios.

3. **Análisis de Sentimiento**:
   - Clasifica las reseñas como positivas, negativas o neutras utilizando técnicas de análisis de sentimiento.
   - Facilita una evaluación rápida del tono general de las opiniones.

## Instrucciones de Uso
1. **Carga de Datos**: Carga un archivo CSV que contenga una columna con texto de reseñas. Opcionalmente, incluye una columna de puntuación numérica.
2. **Selecciona Columnas**: Escoge la columna de reseñas y, si procede, la columna de puntuaciones.
3. **Selecciona el Tipo de Análisis**:
   - **Frecuencia de Palabras**: Muestra una nube de palabras basada en las reseñas.
   - **Distribución de Puntuaciones**: Visualiza las puntuaciones en un gráfico de barras.
   - **Análisis de Sentimiento**: Clasifica las reseñas como positivas, negativas o neutras.
   - **Todos**: Ejecuta y muestra los tres análisis simultáneamente.
4. **Ejecutar Análisis**: Haz clic en el botón “Ejecutar análisis” para generar las visualizaciones elegidas.

