library(shiny)
library(bslib)
library(leaflet)
library(jsonlite)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(plotly)

# Load UI and Server components
source("server.R")
source("ui.R")

# Run the application
shinyApp(ui = ui, server = server)
