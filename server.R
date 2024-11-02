library(shiny)
library(leaflet)

# Server logic
server <- function(input, output) {
  # Charger les données
  data <- read.csv('Data.csv')  # Assurez-vous que le CSV est formaté correctement
  
  # Rendre la carte Leaflet en fonction de l'option sélectionnée
  output$map <- renderLeaflet({
    create_map(data, filter_option = input$lgv_option)
  })
}