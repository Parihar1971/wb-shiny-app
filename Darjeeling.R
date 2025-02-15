# Install necessary packages if not already installed
install.packages("leaflet")
install.packages("sf")

# Load the libraries
library(leaflet)
library(sf)

# Load the shapefile of West Bengal
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Darjeeling District
darjeeling <- wb_shapefile[wb_shapefile$NAME == "Darjiling", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = darjeeling, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%
  setView(lng = 88.265, lat = 27.042, zoom = 8)  # Center on Darjeeling, adjust coordinates if necessary

map <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = darjeeling, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%
  setView(lng = 88.265, lat = 27.042, zoom = 8)  # Center on Darjeeling, adjust coordinates if necessary

saveWidget(map, "darjeeling_map.html")

# Overlay a 6.6 kms x 6.6 kms grid on the map of Darjiling

# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (make sure to replace the path with your actual file path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Darjiling District
darjiling <- wb_shapefile[wb_shapefile$NAME == "Darjiling", ]

# Define the grid size in km
grid_size_km <- 6.6

# Latitude and longitude conversion: 1 degree ≈ 111 km
# Convert km to degrees (approximate conversion)
grid_size_deg <- grid_size_km / 111

# Create the bounding box from the Darjiling shapefile
bbox <- st_bbox(darjiling)

# Convert bbox to simple feature (geometry) using st_as_sfc
bbox_sf <- st_as_sfc(bbox)

# Create the grid over the bounding box of Darjiling
grid <- st_make_grid(bbox_sf, cellsize = c(grid_size_deg, grid_size_deg), what = "polygons")

# Clip the grid to Darjiling boundary using st_intersection
grid_clipped <- st_intersection(grid, darjiling)

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = darjiling, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 88.263, lat = 27.035, zoom = 8)  # Adjust the map view to focus on Darjiling

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = darjiling, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 88.263, lat = 27.035, zoom = 8)  # Adjust the map view to focus on Darjiling

# Save the map as an HTML file
saveWidget(map, "darjiling_map_with_clipped_grid.html")
