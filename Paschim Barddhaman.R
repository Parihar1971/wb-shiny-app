# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (make sure to replace the path with your actual file path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Paschim Barddhaman District
paschim_barddhaman <- wb_shapefile[wb_shapefile$NAME == "Paschim Barddhaman", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile,
              fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = paschim_barddhaman,
              fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%  # Adjust fillOpacity
  setView(lng = 87.7, lat = 23.25, zoom = 8)  # Adjust the map view to focus on Paschim Barddhaman

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile,
              fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = paschim_barddhaman,
              fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%  # Adjust fillOpacity
  setView(lng = 87.7, lat = 23.25, zoom = 8)  # Adjust the map view to focus on Paschim Barddhaman

# Save the map as an HTML file
saveWidget(map, "paschim_barddhaman_map.html")

# Overlay a 6.6 kms x 6.6 kms grid on the map of Pashchim Barddhaman

# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (replace with actual path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Pashchim Barddhaman District
pashchim_barddhaman <- wb_shapefile[wb_shapefile$NAME == "Paschim Barddhaman", ]

# Define the grid size in km
grid_size_km <- 6.6

# Latitude and longitude conversion: 1 degree ≈ 111 km
# Convert km to degrees (approximate conversion)
grid_size_deg <- grid_size_km / 111

# Create the bounding box from the Pashchim Barddhaman shapefile
bbox <- st_bbox(pashchim_barddhaman)

# Convert bbox to simple feature (geometry) using st_as_sfc
bbox_sf <- st_as_sfc(bbox)

# Create the grid over the bounding box of Pashchim Barddhaman
grid <- st_make_grid(bbox_sf, cellsize = c(grid_size_deg, grid_size_deg), what = "polygons")

# Clip the grid to Pashchim Barddhaman boundary using st_intersection
grid_clipped <- st_intersection(grid, pashchim_barddhaman)

# Ensure grid_clipped contains only polygons (remove non-polygon geometries if any)
grid_clipped <- grid_clipped[st_geometry_type(grid_clipped) == "POLYGON", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = pashchim_barddhaman, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 87.25, lat = 23.15, zoom = 10)  # Adjust the map view to focus on Pashchim Barddhaman

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = pashchim_barddhaman, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 87.25, lat = 23.15, zoom = 10)  # Adjust the map view to focus on Pashchim Barddhaman

# Save the map as an HTML file
saveWidget(map, "pashchim_barddhaman_map_with_clipped_grid.html")
