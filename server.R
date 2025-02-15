library(shiny)
library(leaflet)
library(dplyr)
library(htmlwidgets)
library(RColorBrewer)

# Server code
server <- function(input, output) {

  # Render the map based on the selected district
  output$map <- renderLeaflet({
    selected_district <- input$district
    map_list[[selected_district]]  # Render the corresponding map
  })
}
