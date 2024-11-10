# server.R
library(shiny)
library(leaflet)
library(jsonlite)
library(dplyr)
library(purrr)
library(tidyr)
library(geosphere)
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

# Prepare processed_data for map rendering, using the variable `df` consistently
processed_data <- df %>%
  mutate(
    coordinates = map(coordinates, ~{
      if (is.matrix(.x) && ncol(.x) == 2) {
        as.data.frame(.x) %>% setNames(c("lng", "lat"))
      } else if (is.data.frame(.x) && ncol(.x) == 2) {
        .x %>% setNames(c("lng", "lat"))
      } else {
        NULL
      }
    })
  ) %>%
  filter(!sapply(coordinates, is.null)) %>%
  unnest(coordinates) %>%
  filter(lng >= -5.0 & lng <= 9.5 & lat >= 41.0 & lat <= 51.2) %>%
  mutate(segment_id = paste(code_ligne, troncon, sep = "_"))

# Define a function to plot the map with distance-based line breaking
plot_map <- function(data, max_distance_km = 5) {
  map <- leaflet() %>%
    addTiles() %>%
    setView(lng = 2.2137, lat = 46.2276, zoom = 6)
  
  # Add each segment independently and break lines based on distance
  data %>%
    group_by(segment_id) %>%
    group_walk(~{
      segment <- .x
      polyline_points <- list()  # Store consecutive points for each polyline segment
      
      for (i in 2:nrow(segment)) {
        # Calculate distance between consecutive points
        prev_point <- c(segment$lng[i - 1], segment$lat[i - 1])
        current_point <- c(segment$lng[i], segment$lat[i])
        distance <- distHaversine(prev_point, current_point) / 1000  # Convert to km
        
        # Check if the distance is within the threshold
        if (distance <= max_distance_km) {
          # If within threshold, add point to current polyline
          polyline_points <- append(polyline_points, list(current_point))
        } else {
          # If distance is too large, draw the current polyline and start a new one
          if (length(polyline_points) >= 2) {
            polyline_df <- do.call(rbind, polyline_points) %>% as.data.frame() %>%
              setNames(c("lng", "lat"))
            map <<- map %>%
              addPolylines(data = polyline_df, lng = ~lng, lat = ~lat, color = "blue", weight = 1, opacity = 1)
          }
          # Start a new polyline
          polyline_points <- list(current_point)
        }
      }
      
      # Add the last polyline segment if it has more than one point
      if (length(polyline_points) >= 2) {
        polyline_df <- do.call(rbind, polyline_points) %>% as.data.frame() %>%
          setNames(c("lng", "lat"))
        map <<- map %>%
          addPolylines(data = polyline_df, lng = ~lng, lat = ~lat, color = "blue", weight = 1, opacity = 1)
      }
    })
  
  map
}

# Define server logic
server <- function(input, output, session) {
  # Filtered data for histogram based on user selection
  filtered_data_histogram <- reactive({
    if (input$line_type_histogram == "LGV") {
      vitesses_df %>% filter(detail >= 250)
    } else if (input$line_type_histogram == "classique") {
      vitesses_df %>% filter(detail < 250)
    } else {
      vitesses_df
    }
  })
  
  # Render the map
  output$map <- renderLeaflet({
    plot_map(processed_data, max_distance_km = 5)  # Using a 5 km distance threshold
  })
  
  # Histogram of Speeds
  output$histogram_vitesses <- renderPlotly({
    filtered_data_histogram() %>%
      plot_ly(
        x = ~detail,
        type = 'histogram',
        nbinsx = 30
      ) %>%
      layout(title = "Histogramme des Vitesses", 
             xaxis = list(title = "Vitesses"),
             yaxis = list(title = "Fréquence"))
  })
  
  # Pie Chart of Speeds
  output$pie_vitesses <- renderPlotly({
    plot_ly(
      data = vitesses_df,
      labels = ~detail,
      type = 'pie',
      textinfo = 'none'
    ) %>%
      layout(title = "Répartition des Vitesses")
  })
  
  # Scatterplot of Speeds by Start Position
  output$scatter_vitesses <- renderPlotly({
    plot_ly(
      data = vitesses_df,
      x = ~pk_debut,
      y = ~detail,
      type = 'scatter',
      mode = 'markers'
    ) %>%
      layout(title = "Position de Début vs Vitesses", 
             xaxis = list(title = "Position de Début (pk_debut)"), 
             yaxis = list(title = "Vitesse (km/h)"))
  })
}
