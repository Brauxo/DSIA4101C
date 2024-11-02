library(shiny)
library(shinydashboard)
library(leaflet)  # Ensure leaflet is loaded
ui <- dashboardPage(
  dashboardHeader(
    title = tags$div(
      style = "width: 100%; text-align: center;",
      "Chemin de fer en France"
    ),
    titleWidth = "100%"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Histogramme", tabName = "histogram", 
               icon = icon("chart-simple")),
      menuItem("Cartographie", tabName = "map", 
               icon = icon("map-location")),
      menuItem("Pie Chart", tabName = "piechart", 
               icon = icon("chart-pie")),
      menuItem("Distribution", tabName = "distribution", 
               icon = icon("th"))
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
      
      # Cartographie tab where the map is displayed
      tabItem(tabName = "map",
              fluidRow(
                selectInput(
                  inputId = "lgv_option",
                  label = "Choisissez une option:",
                  choices = list("Toutes les lignes" = "both", "LGV" = "LGV", "Lignes classiques" = "classique", "LGV complété" = "LGVC"),
                  selected = "both"
                ),
                box(
                  width = 9,  # Adjust width as needed
                  status = "primary",
                  solidHeader = TRUE,
                  leafletOutput("map", height = "600px", width = "100%"),  # Full width map with padding
                  id = "map-box"
                )
              )
      )
    )
  )
)
