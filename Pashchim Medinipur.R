# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (replace with your actual file path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Paschim Medinipur District (correct spelling)
paschim_medinipur <- wb_shapefile[wb_shapefile$NAME == "Pashchim Medinipur", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile,
              fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = paschim_medinipur,
              fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%  # Highlight Paschim Medinipur
  setView(lng = 87.8, lat = 22.5, zoom = 8)  # Adjust the map view to focus on Pashchim Medinipur

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile,
              fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = paschim_medinipur,
              fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%  # Highlight Paschim Medinipur
  setView(lng = 87.8, lat = 22.5, zoom = 8)  # Adjust the map view to focus on Pashchim Medinipur

# Save the map as an HTML file
saveWidget(map, "paschim_medinipur_map.html")

# Overlay a 6.6 kms x 6.6 kms grid on the map of Pashchim Medinipur District

# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (replace with actual path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Pashchim Medinipur District
pashchim_medinipur <- wb_shapefile[wb_shapefile$NAME == "Pashchim Medinipur", ]

# Define the grid size in km
grid_size_km <- 6.6

# Latitude and longitude conversion: 1 degree ≈ 111 km
# Convert km to degrees (approximate conversion)
grid_size_deg <- grid_size_km / 111

# Create the bounding box from the Pashchim Medinipur shapefile
bbox <- st_bbox(pashchim_medinipur)

# Convert bbox to simple feature (geometry) using st_as_sfc
bbox_sf <- st_as_sfc(bbox)

# Create the grid over the bounding box of Pashchim Medinipur
grid <- st_make_grid(bbox_sf, cellsize = c(grid_size_deg, grid_size_deg), what = "polygons")

# Clip the grid to Pashchim Medinipur boundary using st_intersection
grid_clipped <- st_intersection(grid, pashchim_medinipur)

# Ensure grid_clipped contains only polygons (remove non-polygon geometries if any)
grid_clipped <- grid_clipped[st_geometry_type(grid_clipped) == "POLYGON", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = pashchim_medinipur, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 87.33, lat = 22.58, zoom = 10)  # Adjust the map view to focus on Pashchim Medinipur

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = pashchim_medinipur, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 87.33, lat = 22.58, zoom = 10)  # Adjust the map view to focus on Pashchim Medinipur

# Save the map as an HTML file
saveWidget(map, "pashchim_medinipur_map_with_clipped_grid.html")
