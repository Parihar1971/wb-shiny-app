# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (make sure to replace the path with your actual file path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Kalimpong District
kalimpong <- wb_shapefile[wb_shapefile$NAME == "Kalimpong", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = kalimpong, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%
  setView(lng = 88.5, lat = 27.05, zoom = 8)  # Adjust the map view to focus on Kalimpong

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = kalimpong, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%
  setView(lng = 88.5, lat = 27.05, zoom = 8)  # Adjust the map view to focus on Kalimpong

# Save the map as an HTML file
saveWidget(map, "kalimpong_map.html")

# Overlay 6.6 kms x 6.6 kms grid over the map of Kalimpong District

# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (make sure to replace the path with your actual file path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Kalimpong District
kalimpong <- wb_shapefile[wb_shapefile$NAME == "Kalimpong", ]

# Define the grid size in km
grid_size_km <- 6.6

# Latitude and longitude conversion: 1 degree ≈ 111 km
# Convert km to degrees (approximate conversion)
grid_size_deg <- grid_size_km / 111

# Create the bounding box from the Kalimpong shapefile
bbox <- st_bbox(kalimpong)

# Convert bbox to simple feature (geometry) using st_as_sfc
bbox_sf <- st_as_sfc(bbox)

# Create the grid over the bounding box of Kalimpong
grid <- st_make_grid(bbox_sf, cellsize = c(grid_size_deg, grid_size_deg), what = "polygons")

# Clip the grid to Kalimpong boundary using st_intersection
grid_clipped <- st_intersection(grid, kalimpong)

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = kalimpong, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 88.434, lat = 27.033, zoom = 8)  # Adjust the map view to focus on Kalimpong

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = kalimpong, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 88.434, lat = 27.033, zoom = 8)  # Adjust the map view to focus on Kalimpong

# Save the map as an HTML file
saveWidget(map, "kalimpong_map_with_clipped_grid.html")
