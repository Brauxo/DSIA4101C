library(leaflet)
library(jsonlite)
library(dplyr)
library(tidyr)
library(plotly)

# Load and preprocess data
df <- fromJSON('data.json')
vitesses_df <- df %>%
  select(vitesses) %>%
  tidyr::unnest(vitesses) %>%
  mutate(pk_debut = from, pk_fin = to)
electrifications_df <- df %>%
  select(electrifications) %>%
  tidyr::unnest_wider(electrifications)
df <- df %>% mutate(distance_troncon = pk_fin - pk_debut)

# Define server logic
server <- function(input, output, session) {
  # Données filtrées en fonction de la sélection de l'utilisateur (pour l'histogramme)
  filtered_data_histogram <- reactive({
    if (input$line_type_histogram == "LGV") {
      vitesses_df %>% filter(detail >= 250)
    } else if (input$line_type_histogram == "classique") {
      vitesses_df %>% filter(detail < 250)
    } else {
      vitesses_df
    }
  })
 
 
  # Render the map with all lines using coordinates
  output$map <- renderLeaflet({
    # Create a Leaflet map centered on France
    map <- leaflet() %>%
      addTiles() %>%
      setView(lng = 2.2137, lat = 46.2276, zoom = 6)
    
    # Loop through each row in df to add polylines
    for (i in 1:nrow(df)) {
      ligne <- df[i, ]
      coords <- ligne$coordinates
      
      # Check if coordinates are available and contain at least two points
      if (!is.null(coords) && length(coords) >= 2) {
        # Transform the list of coordinates into a dataframe
        lat_lon <- do.call(rbind, lapply(coords, function(x) {
          if (is.numeric(x) && length(x) == 2) {
            return(data.frame(lat = x[2], lng = x[1]))
          } else {
            NULL  # Ignore non-numeric or incorrectly structured coordinates
          }
        }))
        
        # Remove any NULL rows from lat_lon
        lat_lon <- lat_lon[!is.na(lat_lon$lat) & !is.na(lat_lon$lng), ]
        
        # Add the polyline to the map if there are valid coordinates
        if (nrow(lat_lon) >= 2) {
          map <- addPolylines(
            map,
            data = lat_lon,
            lng = ~lng,
            lat = ~lat,
            color = "blue",
            weight = 1,
            opacity = 1
          )
        }
      }
    }
    map
  })
  
  
  # Histogramme des Vitesses
  output$histogram_vitesses <- renderPlotly({
    filtered_data_histogram() %>%
      plot_ly(
        x = ~detail,
        type = 'histogram',
        nbinsx = 30  # Ajustez le nombre de bacs pour l'histogramme
      ) %>%
      layout(title = "Histogramme des Vitesses", 
             xaxis = list(title = "Vitesses"),
             yaxis = list(title = "Fréquence"))
  })
  
  # Camembert des Vitesses
  output$pie_vitesses <- renderPlotly({
    plot_ly(
      data = vitesses_df,
      labels = ~detail,
      type = 'pie',
      textinfo = 'none'  # Hide all text labels, including percentages
    ) %>%
      layout(title = "Répartition des Vitesses")
  })
  
  # Scatterplot des Vitesses par Position de Début
  output$scatter_vitesses <- renderPlotly({
    plot_ly(
      data = vitesses_df,
      x = ~pk_debut,
      y = ~detail,
      type = 'scatter',
      mode = 'markers'
    ) %>%
      layout(title = "Position de Début vs Vitesses", xaxis = list(title = "Position de Début (pk_debut)"), yaxis = list(title = "Vitesse (km/h)"))
  })
}
