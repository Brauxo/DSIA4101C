library(shinydashboard)
library(leaflet)
# Home page function
create_home <- function() {
  fluidPage(
    
    # Titre de la page
    h1("Bienvenue sur le Dashboard des Chemins de Fer", style = "text-align: center; margin-top: 30px;"),
    
    # Paragraphe expliquant l'objectif du site
    p(
      "Ce dashboard a pour objectif de fournir une vue d'ensemble sur l'infrastructure des chemins de fer en France. 
      Grâce aux données publiques, nous explorons la répartition géographique des lignes de train et analysons plusieurs 
      aspects des chemins de fer français, tels que la densité des lignes par région, la longueur moyenne des lignes, 
      ainsi que leur évolution historique.",
      "L'importance des chemins de fer en France ne se limite pas à la simple infrastructure de transport, mais joue un rôle clé dans le développement économique, 
      l’aménagement territorial et la réduction de l'empreinte carbone. Ce dashboard permet à ses utilisateurs d'explorer visuellement ces aspects à l'aide de cartes et 
      de graphiques interactifs qui fournissent des perspectives précieuses sur l'état et l'évolution du réseau ferroviaire.",
      style = "text-align: justify; padding: 0 10%; margin-top: 20px;"
    ),
    
    # Première section : Texte à gauche et carte (image) à droite
    fluidRow(
      column(6, 
             h3("Les Chemins de Fer en France"),
             p(
               "La carte ci-contre illustre le réseau des chemins de fer en France, permettant une vue d'ensemble des 
               lignes ferroviaires à travers le pays. Ce réseau est un élément essentiel du transport national, reliant 
               les régions entre elles et facilitant le transport de personnes et de marchandises.",
               "Vous pourrez explorer ici les principales lignes à grande vitesse (LGV), les lignes régionales ainsi que les 
               trajets internationaux. Cette carte met en lumière les zones les plus denses du réseau, telles que la région 
               Île-de-France, ainsi que les zones plus rurales où le réseau est moins développé. Ce tableau interactif permet 
               d’explorer la répartition géographique des lignes ferroviaires.",
               style = "text-align: justify;"
             )
      ),
      column(6, 
             tags$img(src = "map_example.PNG", style = "width: 100%; border-radius: 10px;")
      )
    ),
    
    # Deuxième section : Image (histogramme) à gauche et texte à droite
    fluidRow(
      column(6, 
             tags$img(src = "data_example.PNG", style = "width: 100%; border-radius: 10px;")
      ),
      column(6, 
             h3("Analyse Statistique des Lignes de Chemins de Fer"),
             p(
               "Les graphiques interactifs de cette section montrent diverses statistiques liées au réseau ferroviaire français. 
               Vous pourrez découvrir la répartition des lignes selon leur longueur, la densité des chemins de fer dans chaque 
               région, et analyser l'évolution de la construction du réseau au fil du temps.",
               "Les histogrammes illustrent également les différences entre les zones urbaines et rurales, mettant en lumière 
               les disparités en termes d'infrastructures de transport. De plus, les données montrent les tendances dans 
               l’extension du réseau ferroviaire, en lien avec les politiques publiques récentes visant à promouvoir des 
               modes de transport plus durables et écologiques.",
               style = "text-align: justify;"
             )
      )
    ),
  )
}

# About Us page function
create_about_us <- function() {
  # Profils des membres de l'équipe
  profiles <- list(
    list(name = "Elliot CAMBIER", img = "elliot.jpg", text = "Étudiant en 4ème année d'ingénierie à l'ESIEE Paris, spécialisé en Data Science et Intelligence Artificielle (DSIA). Les projets liés à la Data Science m'intéressent particulièrement, notamment après avoir choisi l'année dernière des électives en Data Science, IA et Deep Learning."),
    list(name = "Owen BRAUX", img = "owen.jpg", text = "Actuellement étudiant, en 4ème année à l'ESIEE Paris. Je suis passionné par l'analyse de données et l'intelligence artificielle, j'ai choisi de suivre la filière DSIA pour approfondir mes connaissances et compétences dans ces domaines en plein essor.")
  )
  
  profile_cards <- lapply(profiles, function(p) {
    div(
      style = "display: flex; align-items: center; margin-bottom: 20px;", # Style pour aligner les éléments horizontalement
      div(
        img(src = p$img, class = "profile-img", alt = paste("Photo de", p$name), style = "height: 200px; width: auto; object-fit: cover; margin-right: 20px; border-radius: 10px;"),
        style = "flex-shrink: 0;" # Assure que l'image garde sa taille
      ),
      div(
        h3(p$name, class = "name-title"),
        div(
          p(p$text, class = "profile-text"),
          style = "border: 2px solid #ccc; padding: 15px; border-radius: 10px; background-color: #f9f9f9; width: 300px; height: 200px; overflow-y: auto;" # Limiter la taille du texte
        ),
        style = "flex-grow: 1;" # Permet à la div contenant le texte de prendre l'espace restant
      )
    )
  })
  
  # Section de contact
  contact_section <- p(
    tags$a("elliot.cambier@edu.esiee.fr", href = "mailto:elliot.cambier@edu.esiee.fr"),
    " et ",
    tags$a("owen.braux@edu.esiee.fr", href = "mailto:owen.braux@edu.esiee.fr"),
    class = "contact-info",
    style = "border: 1px solid #ccc; padding: 8px; margin-top: 10px; border-radius: 8px; background-color: #f9f9f9; font-size: 16px; text-align: center; width: 400px; height: 30px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"
  )
  
  
  # Logiciels utilisés
  software_images <- c("R_logo.png","logo_shiny.png","R_studio.png","python_logo.png", "github_logo.png", "css_logo.png")
  software_section <- lapply(software_images, function(img) {
    div(
      img(src = img, class = "software-logo", alt = paste("Logo", gsub("_", " ", sub(".png", "", img))), style = "width: 100px; height: 100px; object-fit: contain; margin-right: 10px;"),
      class = "software-item"
    )
  })
  
  # Retourner la structure
  div(
    h1("À propos de nous", class = "page-title"),
    div(profile_cards, class = "profile-section"),
    h1("Contact", class = "page-title"),
    contact_section,
    h1("Logiciels utilisés", class = "page-title"),
    div(software_section, class = "software-section", style = "display: flex; flex-wrap: wrap; align-items: center; justify-content: flex-start;")
  )
}

# Define the UI layout
ui <- dashboardPage(
  dashboardHeader(
    title = tagList(
      img(src = "rails.png", height = "40px", style = "margin-right: 10px;"),
      "RAILSFRANCE"
    )
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Accueil", tabName = "home", icon = icon("home")),
      menuItem("À propos de nous", tabName = "about", icon = icon("info-circle")),
      menuItem("Histogramme", tabName = "histogram", icon = icon("chart-simple")),
      menuItem("Cartographie", tabName = "map", icon = icon("map-location")),
      menuItem("Pie Chart", tabName = "piechart_vitesses", icon = icon("chart-pie")),
      menuItem("Distribution", tabName = "scatterplot_vitesses", icon = icon("th")),
      selectInput("line_type", "Sélectionner le type de ligne:", 
                  choices = c("Toutes les lignes" = "both", "Lignes classiques" = "classique", "Lignes grande vitesse (LGV)" = "LGV"),
                  selected = "both")
    )
  ),
  dashboardBody(
    tags$head(
      tags$style(HTML("
        /* Set minimum width for the entire application */
        body {
          min-width: 1200px;
        }
      "))
    ),
    tabItems(
      # Page d'accueil
      tabItem(tabName = "home", create_home()),
      
      # Page About Us
      tabItem(tabName = "about", create_about_us()),
      
      # Histogramme
      tabItem(tabName = "histogram",
              fluidRow(
                box(
                  title = "Histogramme des Vitesses",
                  solidHeader = TRUE,
                  status = "primary",
                  width = 12,
                  plotlyOutput("histogram_vitesses", height = "400px")
                )
              )
      ),
      
      # Cartographie
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
      ),
      
      # Onglet Camembert des Vitesses
      tabItem(tabName = "piechart_vitesses",
              fluidRow(
                box(
                  title = "Camembert des Vitesses",
                  solidHeader = TRUE,
                  status = "primary",
                  width = 12,           # Utiliser toute la largeur disponible
                  plotlyOutput("pie_vitesses", height = "600px") # Augmenter la hauteur
                )
              )
      ),
      
      # Onglet Scatterplot des Vitesses
      tabItem(tabName = "scatterplot_vitesses",
              fluidRow(
                box(
                  title = "Scatterplot des Vitesses",
                  solidHeader = TRUE,
                  status = "primary",
                  width = 12,
                  plotlyOutput("scatter_vitesses", height = "400px")
                )
              )
      )
    )
  )
)
