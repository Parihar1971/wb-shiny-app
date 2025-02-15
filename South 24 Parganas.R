# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (replace with your actual file path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for South 24 Parganas District (ensure 'district_name' matches your shapefile's district name column)
south_24_parganas <- wb_shapefile[wb_shapefile$NAME == "South 24 Parganas", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile,
              fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = south_24_parganas,
              fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%  # Highlight South 24 Parganas
  setView(lng = 88.4, lat = 22.3, zoom = 9)  # Adjust the map view to focus on South 24 Parganas

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile,
              fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = south_24_parganas,
              fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%  # Highlight South 24 Parganas
  setView(lng = 88.4, lat = 22.3, zoom = 9)  # Adjust the map view to focus on South 24 Parganas

# Save the map as an HTML file
saveWidget(map, "south_24_parganas_map.html")

# Overlay a 6.6 kms x 6.6 kms grid on the map of South 24 Parganas District

# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (replace with actual path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for South 24 Parganas District
south_24_parganas <- wb_shapefile[wb_shapefile$NAME == "South 24 Parganas", ]

# Define the grid size in km
grid_size_km <- 6.6

# Latitude and longitude conversion: 1 degree ≈ 111 km
# Convert km to degrees (approximate conversion)
grid_size_deg <- grid_size_km / 111

# Create the bounding box from the South 24 Parganas shapefile
bbox <- st_bbox(south_24_parganas)

# Convert bbox to simple feature (geometry) using st_as_sfc
bbox_sf <- st_as_sfc(bbox)

# Create the grid over the bounding box of South 24 Parganas
grid <- st_make_grid(bbox_sf, cellsize = c(grid_size_deg, grid_size_deg), what = "polygons")

# Clip the grid to South 24 Parganas boundary using st_intersection
grid_clipped <- st_intersection(grid, south_24_parganas)

# Ensure grid_clipped contains only polygons (remove non-polygon geometries if any)
grid_clipped <- grid_clipped[st_geometry_type(grid_clipped) == "POLYGON", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = south_24_parganas, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 88.5, lat = 22.3, zoom = 10)  # Adjust the map view to focus on South 24 Parganas

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = south_24_parganas, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 88.5, lat = 22.3, zoom = 10)  # Adjust the map view to focus on South 24 Parganas

# Save the map as an HTML file
saveWidget(map, "south_24_parganas_map_with_clipped_grid.html")
