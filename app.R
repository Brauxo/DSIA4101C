library(shiny)

# Charger les données
df <- read.csv("Data.csv", sep = ",")

# Lancer l'application
shinyApp(ui = ui, server = server)
