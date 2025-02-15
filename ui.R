library(shiny)
library(leaflet)

# UI code
ui <- fluidPage(
  titlePanel("Interactive Maps of West Bengal Districts"),

  sidebarLayout(
    sidebarPanel(
      selectInput("district", "Choose a District", choices = districts)
    ),

    mainPanel(
      leafletOutput("map")
    )
  )
)
