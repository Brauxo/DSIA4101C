library(shiny)
library(leaflet)
library(jsonlite)
library(shinydashboard)

# Lire les données à partir du fichier JSON
df <- fromJSON('data.json')  # Assurez-vous que le chemin vers le JSON est correct

# Fonction pour extraire la vitesse maximale
extract_max_speed <- function(row) {
  if (!is.null(row$vitesses) && length(row$vitesses) > 0) {
    speeds <- sapply(row$vitesses, function(v) v$detail)
    return(max(speeds, na.rm = TRUE))  # Ignorer les NA ici
  }
  return(0)
}

# Fonction pour déterminer la couleur de la ligne
determine_color <- function(max_speed, filter_option, code_line) {
  if (is.na(max_speed)) {
    return(NULL)
  }
  
  if (filter_option == "LGV" && max_speed < 250) {
    return(NULL)
  }
  if (filter_option == "classique" && max_speed >= 250) {
    return(NULL)
  }
  if (filter_option == "LGVC" && max_speed < 250 && !(code_line %in% c(14000, 5000))) {
    return(NULL)
  }
  return(ifelse(max_speed >= 250, "green", "royalblue"))
}

# Fonction pour créer la carte en fonction de l'option de filtrage
create_map <- function(data, filter_option = "both") {
  map_object <- leaflet() %>%
    addTiles(urlTemplate = "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png") %>%
    setView(lng = 1.888334, lat = 46.603354, zoom = 6)
  
  line_count <- 3347
  filtered_data <- head(data, line_count)
  
  for (i in 1:nrow(filtered_data)) {
    row <- filtered_data[i, , drop = FALSE]
    coordinates <- row$coordinates
    
    # Vérifiez que les coordonnées ne sont pas nulles
    if (!is.null(coordinates) && length(coordinates) > 0) {
      # Si les coordonnées sont au format JSON, les convertir
      if (is.character(coordinates)) {
        coordinates <- fromJSON(coordinates)
      }
      
      filtered_coordinates <- lapply(coordinates, function(coord) {
        if (is.list(coord) && length(coord) == 2) {
          return(c(coord[[2]], coord[[1]]))  # lat, lon order
        }
      })
      filtered_coordinates <- Filter(Negate(is.null), filtered_coordinates)
      
      if (length(filtered_coordinates) >= 2) {
        max_speed <- extract_max_speed(row)  # Extraire la vitesse maximale
        color <- determine_color(max_speed, filter_option, row$code_ligne)
        
        if (!is.null(color)) {
          map_object <- addPolylines(map_object, 
                                     lng = sapply(filtered_coordinates, `[[`, 2), 
                                     lat = sapply(filtered_coordinates, `[[`, 1), 
                                     color = color, weight = 1, opacity = 1)
        }
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

# Définir la logique du serveur
server <- function(input, output) {
  output$map <- renderLeaflet({
    # Filtrer les données pour enlever les lignes sans coordonnées ou vitesses valides
    valid_data <- df[!is.na(df$coordinates) & sapply(df$vitesses, function(v) length(v) > 0), ]
    
    # Vérifiez que nous avons des données valides après le filtrage
    if (nrow(valid_data) == 0) {
      stop("Aucune donnée valide pour afficher la carte.")
    }
    
    create_map(valid_data, filter_option = input$lgv_option)
  })
}

# Lancer l'application Shiny
shinyApp(ui = ui, server = server)
