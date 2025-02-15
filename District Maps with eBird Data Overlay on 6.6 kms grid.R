# Generating Interactive Maps

library(leaflet)
library(sf)
library(htmlwidgets)
library(dplyr)
library(RColorBrewer)

# Step 1: Load the shapefile for West Bengal
shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Ensure the shapefile has the correct CRS (WGS 84, EPSG:4326)
shapefile <- st_transform(shapefile, crs = 4326)

# Step 2: Check for invalid geometries
invalid_geometries <- st_is_valid(shapefile)
if (any(!invalid_geometries)) {
  shapefile <- st_make_valid(shapefile)  # Fix invalid geometries
}

# Step 3: Load the latitude and longitude data from latlong.csv
latlong_data <- read.csv("latlong.csv")

# Step 4: Convert latlong_data to an sf object
latlong_sf <- st_as_sf(latlong_data, coords = c("LONGITUDE", "LATITUDE"), crs = 4326)

# Step 5: Loop through each district and create a map

districts <- unique(shapefile$NAME)  # List of unique districts in West Bengal

# Create an empty list to store maps for all districts
map_list <- list()

for(district_name in districts) {
  # Step 6: Filter the shapefile for the current district
  district <- shapefile[shapefile$NAME == district_name, ]

  # Step 7: Create a grid for the current district (6.6 km x 6.6 km grid)
  grid_size <- 0.0595  # Approximate 6.6 km in degrees at this latitude
  grid <- st_make_grid(district, cellsize = c(grid_size, grid_size), what = "polygons")

  # Convert the grid to an `sf` object for easier manipulation
  grid_sf <- st_sf(geometry = grid)

  # Step 8: Clip the grid to the current district boundary
  grid_clipped <- st_intersection(grid_sf, district)

  # Step 9: Ensure no invalid geometries in the clipped grid
  grid_clipped <- st_make_valid(grid_clipped)

  # Step 10: Calculate the density by counting how many points fall in each grid cell
  grid_density <- st_join(grid_clipped, latlong_sf, join = st_intersects)

  # Count how many points are within each grid cell
  density_counts <- grid_density %>%
    group_by(geometry) %>%
    summarise(count = n(), .groups = "drop")

  # Step 11: Normalize density values with a logarithmic scale
  density_counts <- density_counts %>%
    mutate(log_density = log1p(count))  # Apply log transformation (log(1 + count))

  # Step 12: Define a color palette (from white → green → orange → maroon)
  color_palette <- colorRampPalette(c("white", "green", "orange", "maroon"))(100)

  # Step 13: Assign colors to the grid cells based on logarithmic density
  density_counts <- density_counts %>%
    mutate(color = ifelse(is.na(log_density), "transparent", color_palette[round(log_density / max(log_density, na.rm = TRUE) * 99) + 1]))

  # Step 14: Create the Leaflet map for the current district
  map <- leaflet() %>%
    setView(lng = mean(st_coordinates(district)[,1]), lat = mean(st_coordinates(district)[,2]), zoom = 8) %>%

    # Add a standard OpenStreetMap base layer
    addTiles(urlTemplate = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
             attribution = '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors') %>%

    # Add the full West Bengal boundary as context (whole state shapefile)
    addPolygons(data = shapefile,
                color = "black",  # Black boundary for West Bengal
                weight = 2,       # Bold boundary for West Bengal (weight 2)
                opacity = 0.5,    # Transparent boundary for the state
                fillOpacity = 0,  # No fill for state boundary
                dashArray = NULL) %>%  # Solid line for West Bengal boundary

    # Add the district boundary with blue color (solid lines)
    addPolygons(data = district,
                color = "blue",  # Blue boundary for district (contrast with state boundary)
                weight = 2,      # Bold boundary (weight 2)
                opacity = 1,     # Full opacity for the boundary
                fillOpacity = 0, # No fill inside the district polygons
                dashArray = NULL) %>%  # Solid line for district boundary

    # Add the grid overlay with improved gray grid lines
    addPolygons(data = grid_clipped,
                color = "#222222",  # Darker gray grid lines
                weight = 1,         # Reduced weight for thinner grid lines
                opacity = 0.8,      # Increased opacity for gridline visibility
                fillOpacity = 0)    # No fill inside the grid cells

  # Step 15: Add the density heatmap overlay for the current district
  density_counts_sf <- st_as_sf(density_counts, wkt = "geometry")

  # Adjust the color palette for higher contrast
  color_palette <- colorRampPalette(c("white", "darkgreen", "orange", "red", "darkred"))(100)

  # Assign colors to the grid cells based on the new color palette
  density_counts_sf <- density_counts_sf %>%
    mutate(color = ifelse(is.na(log_density), "transparent", color_palette[round(log_density / max(log_density, na.rm = TRUE) * 99) + 1]))

  # Add the density heatmap with higher contrast inside the grid cells
  map <- map %>%
    addPolygons(data = density_counts_sf,
                color = density_counts_sf$color,  # Use color from density_counts
                weight = 1,      # Thin gridlines for better contrast
                opacity = 0.6,   # Adjust opacity for better grid line visibility
                fillOpacity = 0.4)  # Lower opacity for the grid fill, allowing map details to show through

  # Step 16: Store the map for the current district in the map_list
  map_list[[district_name]] <- map

  # Step 17: Optionally, save the map to an HTML file for each district
  saveWidget(map, paste0("west_bengal_", district_name, "_map.html"))
}

# If you want to view all maps as separate widgets, you can open the saved HTML files or
# combine them in a Shiny app to display them interactively on a single webpage.

library(shiny)
library(leaflet)
library(sf)
library(dplyr)
library(htmlwidgets)
library(RColorBrewer)

# Step 2: Create the Shiny UI
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

# Step 3: Create the Shiny server
server <- function(input, output) {

  # Render the map based on the selected district
  output$map <- renderLeaflet({
    selected_district <- input$district
    map_list[[selected_district]]  # Render the corresponding map
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
