install.packages("leaflet")
install.packages("sf")

library(leaflet)
library(sf)


# Load the shapefile
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

koch_bihar <- wb_shapefile[wb_shapefile$NAME == "Koch Bihar", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = koch_bihar, fillColor = "gray", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.6) %>%
  setView(lng = 89.433, lat = 26.030, zoom = 9)  # Center the map on West Bengal and Koch Bihar

install.packages("htmlwidgets")

library(htmlwidgets)

# Create the leaflet map
map <- leaflet() %>%
  addTiles() %>%
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = koch_bihar, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%
  setView(lng = 89.433, lat = 26.030, zoom = 9)

# Save the map as an HTML file
saveWidget(map, "koch_bihar_map.html")

# Overlay a grid of 6.6 km x 6.6 km over Cooch Behar District

# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (make sure to replace the path with your actual file path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Koch Bihar District
koch_bihar <- wb_shapefile[wb_shapefile$NAME == "Koch Bihar", ]

# Define the grid size in km
grid_size_km <- 6.6

# Latitude and longitude conversion: 1 degree ≈ 111 km
# Convert km to degrees (approximate conversion)
grid_size_deg <- grid_size_km / 111

# Create the bounding box from the Koch Bihar shapefile
bbox <- st_bbox(koch_bihar)

# Convert bbox to simple feature (geometry) using st_as_sfc
bbox_sf <- st_as_sfc(bbox)

# Create the grid over the bounding box of Koch Bihar
grid <- st_make_grid(bbox_sf, cellsize = c(grid_size_deg, grid_size_deg), what = "polygons")

# Clip the grid to Koch Bihar boundary using st_intersection
grid_clipped <- st_intersection(grid, koch_bihar)

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = koch_bihar, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 89.447, lat = 26.032, zoom = 8)  # Adjust the map view to focus on Koch Bihar

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = koch_bihar, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 89.447, lat = 26.032, zoom = 8)  # Adjust the map view to focus on Koch Bihar

# Save the map as an HTML file
saveWidget(map, "koch_bihar_map_with_clipped_grid.html")
