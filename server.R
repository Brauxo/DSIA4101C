library(shiny)
library(leaflet)
# Server logic
server <- function(input, output, session) {
  
  # Render a blank map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(urlTemplate = "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png") %>%
      setView(lng = 1.888334, lat = 46.603354, zoom = 6)  # Center on France
  })
}