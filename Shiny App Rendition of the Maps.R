# Install and load necessary libraries
library(shiny)
library(leaflet)
library(sf)
library(htmlwidgets)
library(dplyr)
library(RColorBrewer)

# Step 1: Load the shapefile for West Bengal
shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Ensure the shapefile has the correct CRS (WGS 84, EPSG:4326)
shapefile <- st_transform(shapefile, crs = 4326)

# Step 2: Load the latitude and longitude data from latlong.csv
latlong_data <- read.csv("latlong.csv")

# Step 3: Convert latlong_data to an sf object
latlong_sf <- st_as_sf(latlong_data, coords = c("LONGITUDE", "LATITUDE"), crs = 4326)

# Step 4: Create a list to store maps for each district
districts <- unique(shapefile$NAME)  # List of unique districts in West Bengal

# Step 5: Define a function to create the map for each district
create_district_map <- function(district_name) {

  # Filter the shapefile for the current district
  district <- shapefile[shapefile$NAME == district_name, ]

  # Create a grid for the current district (6.6 km x 6.6 km grid)
  grid_size <- 0.0595  # Approximate 6.6 km in degrees at this latitude
  grid <- st_make_grid(district, cellsize = c(grid_size, grid_size), what = "polygons")

  # Convert the grid to an `sf` object for easier manipulation
  grid_sf <- st_sf(geometry = grid)

  # Clip the grid to the current district boundary
  grid_clipped <- st_intersection(grid_sf, district)

  # Ensure no invalid geometries in the clipped grid
  grid_clipped <- st_make_valid(grid_clipped)

  # Calculate the density by counting how many points fall in each grid cell
  grid_density <- st_join(grid_clipped, latlong_sf, join = st_intersects)

  # Count how many points are within each grid cell
  density_counts <- grid_density %>%
    group_by(geometry) %>%
    summarise(count = n(), .groups = "drop")

  # Normalize density values with a logarithmic scale
  density_counts <- density_counts %>%
    mutate(log_density = log1p(count))  # Apply log transformation (log(1 + count))

  # Define a color palette (from white → green → orange → maroon)
  color_palette <- colorRampPalette(c("white", "green", "orange", "maroon"))(100)

  # Assign colors to the grid cells based on logarithmic density
  density_counts <- density_counts %>%
    mutate(color = color_palette[round(log_density / max(log_density) * 99) + 1])

  # Create the Leaflet map for the current district
  map <- leaflet() %>%
    setView(lng = mean(st_coordinates(district)[,1]), lat = mean(st_coordinates(district)[,2]), zoom = 8) %>%

    # Add a standard OpenStreetMap base layer
    addTiles(urlTemplate = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
             attribution = '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors') %>%

    # Add the full West Bengal boundary as context (whole state shapefile)
    addPolygons(data = shapefile,
                color = "black",  # Black boundary for West Bengal
                weight = 1,       # Light border for West Bengal
                opacity = 0.5,    # Transparent boundary for the state
                fillOpacity = 0,  # No fill for state boundary
                dashArray = "5,5") %>%  # Optional dashed lines for a different effect

    # Add the district boundary with blue color
    addPolygons(data = district,
                color = "blue",  # Blue boundary for district (contrast with state boundary)
                weight = 2,      # Increased weight for better contrast
                opacity = 1,     # Full opacity for the boundary
                fillOpacity = 0, # No fill inside the district polygons
                dashArray = "5,5") %>%  # Optional dashed lines for a different effect

    # Add the grid overlay with improved gray grid lines
    addPolygons(data = grid_clipped,
                color = "#222222",  # Darker gray grid lines
                weight = 1,         # Reduced weight for thinner grid lines
                opacity = 0.8,      # Increased opacity for gridline visibility
                fillOpacity = 0)    # No fill inside the grid cells

  # Add the density heatmap overlay for the current district
  density_counts_sf <- st_as_sf(density_counts, wkt = "geometry")

  # Assign colors to the grid cells based on the new color palette
  density_counts_sf <- density_counts_sf %>%
    mutate(color = color_palette[round(log_density / max(log_density) * 99) + 1])

  # Add the density heatmap with higher contrast inside the grid cells
  map <- map %>%
    addPolygons(data = density_counts_sf,
                color = density_counts_sf$color,  # Use color from density_counts
                weight = 1,      # Thin gridlines for better contrast
                opacity = 0.6,   # Adjust opacity for better grid line visibility
                fillOpacity = 0.4)  # Lower opacity for the grid fill, allowing map details to show through

  return(map)
}

# Step 6: Create a Shiny UI to display the maps
# Shiny Server
server <- function(input, output, session) {

  # Render the dynamic tabs with a map for each district
  output$district_tabs <- renderUI({
    # Generate a tabPanel for each district
    lapply(districts, function(district_name) {
      tabPanel(district_name, leafletOutput(paste0("map_", district_name)))
    })
  })

  # Render a map for each district
  lapply(districts, function(district_name) {
    output[[paste0("map_", district_name)]] <- renderLeaflet({
      create_district_map(district_name)
    })
  })

  # Optionally, display the map for the selected district by switching tabs
  observeEvent(input$district, {
    updateTabsetPanel(session, "tabs", selected = input$district)
  })
}

# Step 8: Run the Shiny app
shinyApp(ui = ui, server = server)
