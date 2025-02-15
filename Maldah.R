# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (make sure to replace the path with your actual file path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Maldah District
maldah <- wb_shapefile[wb_shapefile$NAME == "Maldah", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile,
              fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = maldah,
              fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%  # Adjust fillOpacity
  setView(lng = 88.14, lat = 25.02, zoom = 8)  # Adjust the map view to focus on Maldah

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile,
              fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = maldah,
              fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%  # Adjust fillOpacity
  setView(lng = 88.14, lat = 25.02, zoom = 8)  # Adjust the map view to focus on Maldah

# Save the map as an HTML file
saveWidget(map, "maldah_map.html")

# Overlay a 6.6 kms x 6.6 kms grid on the map of Maldah District

# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (make sure to replace the path with your actual file path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Maldah District
maldah <- wb_shapefile[wb_shapefile$NAME == "Maldah", ]

# Define the grid size in km
grid_size_km <- 6.6

# Latitude and longitude conversion: 1 degree ≈ 111 km
# Convert km to degrees (approximate conversion)
grid_size_deg <- grid_size_km / 111

# Create the bounding box from the Maldah shapefile
bbox <- st_bbox(maldah)

# Convert bbox to simple feature (geometry) using st_as_sfc
bbox_sf <- st_as_sfc(bbox)

# Create the grid over the bounding box of Maldah
grid <- st_make_grid(bbox_sf, cellsize = c(grid_size_deg, grid_size_deg), what = "polygons")

# Clip the grid to Maldah boundary using st_intersection
grid_clipped <- st_intersection(grid, maldah)

# Ensure grid_clipped contains only polygons (remove non-polygon geometries if any)
grid_clipped <- grid_clipped[st_geometry_type(grid_clipped) == "POLYGON", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = maldah, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 88.106, lat = 25.014, zoom = 8)  # Adjust the map view to focus on Maldah

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = maldah, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 88.106, lat = 25.014, zoom = 8)  # Adjust the map view to focus on Maldah

# Save the map as an HTML file
saveWidget(map, "maldah_map_with_clipped_grid.html")
