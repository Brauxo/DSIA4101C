library(shiny)
library(bslib)
library(leaflet)
library(jsonlite)
library(shinydashboard)
# Lire les données à partir du fichier CSV
df <- read.csv('Data.csv')
# Fonction pour créer la carte en fonction de l'option de filtrage
create_map <- function(data, filter_option = "both") {
  map_object <- leaflet() %>%
    addTiles(urlTemplate = "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png") %>%
    setView(lng = 1.888334, lat = 46.603354, zoom = 6)
  
  line_count <- 3347
  filtered_data <- head(data, line_count)
  for (i in 1:nrow(filtered_data)) {
    row <- filtered_data[i, ]
    coordinates <- row$coordinates
    if (!is.null(coordinates) && length(coordinates) > 0) {
      filtered_coordinates <- lapply(coordinates, function(coord) {
        if (is.list(coord) && length(coord) == 2) {
          return(c(coord[2], coord[1]))  # lat, lon order
        }
      })
      filtered_coordinates <- Filter(Negate(is.null), filtered_coordinates)
      
      if (length(filtered_coordinates) >= 2) {
        if (!is.null(row$vitesses) && length(row$vitesses) > 0) {
          vitesses_detail <- sapply(row$vitesses, function(v) v$detail)
          max_vitesse <- ifelse(length(vitesses_detail) > 0, max(vitesses_detail), 0)
        } else {
          max_vitesse <- 0
        }
        if (!is.null(row$code_ligne)) {
          code_ligne <- row$code_ligne
        } else {
          code_ligne <- 0
        }
        color <- ifelse(max_vitesse >= 250, "green", "royalblue")
        if (filter_option == "LGV" && max_vitesse < 250) next
        if (filter_option == "classique" && max_vitesse >= 250) next
        if (filter_option == "LGVC" && max_vitesse < 250 && !(code_ligne %in% c(14000, 5000))) next
        if (filter_option == "LGVC") color <- "green"
        
        map_object <- addPolylines(map_object, 
                                   lng = sapply(filtered_coordinates, `[[`, 2), 
                                   lat = sapply(filtered_coordinates, `[[`, 1), 
                                   color = color, weight = 1, opacity = 1)
      }
    }
  }
  
  return(map_object)
}



# Définir l'interface utilisateur (UI) du dashboard
ui <- dashboardPage(
  dashboardHeader(
    title = tags$div(
      style = "width: 100%; text-align: center;",
      "Le réseau de chemin de fer en France"
    ),
    titleWidth = "100%"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Histogramme", tabName = "histogram", icon = icon("chart-simple")),
      menuItem("Cartographie", tabName = "map", icon = icon("map-location")),
      menuItem("Pie Chart", tabName = "piechart", icon = icon("chart-pie")),
      menuItem("Distribution", tabName = "distribution", icon = icon("th"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        body {
          min-width: 800px;
          min-height: 600px;
        }
      "))
    ),
    
    tabItems(
      tabItem(tabName = "histogram",
              fluidRow(
                box(
                  title = "Sélectionnez les paramètres pour l'histogramme",
                  solidHeader = TRUE,
                  status = "primary"
                )
              )
      ),
      
      tabItem(tabName = "map",
              fluidRow(
                selectInput(
                  inputId = "lgv_option",
                  label = "Choisissez une option:",
                  choices = list("Toutes les lignes" = "both", "LGV" = "LGV", "Lignes classiques" = "classique", "LGV complété" = "LGVC"),
                  selected = "both"
                ),
                box(
                  width = 9,
                  status = "primary",
                  solidHeader = TRUE,
                  leafletOutput("map", height = "600px", width = "100%"),
                  id = "map-box"
                )
              )
      )
    )
  )
)

# Server logic
server <- function(input, output, session) {
  
  # Render a blank map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(urlTemplate = "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png") %>%
      setView(lng = 1.888334, lat = 46.603354, zoom = 6)  # Center on France
  })
}

# Lancer l'application Shiny
shinyApp(ui = ui, server = server)
