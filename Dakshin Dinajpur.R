# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (make sure to replace the path with your actual file path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Dakshin Dinajpur District
dakshin_dinajpur <- wb_shapefile[wb_shapefile$NAME == "Dakshin Dinajpur", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile,
              fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = dakshin_dinajpur,
              fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%  # Adjust fillOpacity
  setView(lng = 88.63, lat = 25.51, zoom = 8)  # Adjust the map view to focus on Dakshin Dinajpur

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile,
              fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = dakshin_dinajpur,
              fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.6) %>%  # Adjust fillOpacity
  setView(lng = 88.63, lat = 25.51, zoom = 8)  # Adjust the map view to focus on Dakshin Dinajpur

# Save the map as an HTML file
saveWidget(map, "dakshin_dinajpur_map.html")

# Overlay a 6.6 kms x 6.6 kms grid on the map of Dakshin Dinajpur

# Load necessary libraries
library(leaflet)
library(sf)
library(htmlwidgets)

# Load the shapefile of West Bengal (make sure to replace the path with your actual file path)
wb_shapefile <- st_read("aee65/West Bengal/District_shape_West_Bengal.shp")

# Filter for Dakshin Dinajpur District
dakshin_dinajpur <- wb_shapefile[wb_shapefile$NAME == "Dakshin Dinajpur", ]

# Define the grid size in km
grid_size_km <- 6.6

# Latitude and longitude conversion: 1 degree ≈ 111 km
# Convert km to degrees (approximate conversion)
grid_size_deg <- grid_size_km / 111

# Create the bounding box from the Dakshin Dinajpur shapefile
bbox <- st_bbox(dakshin_dinajpur)

# Convert bbox to simple feature (geometry) using st_as_sfc
bbox_sf <- st_as_sfc(bbox)

# Create the grid over the bounding box of Dakshin Dinajpur
grid <- st_make_grid(bbox_sf, cellsize = c(grid_size_deg, grid_size_deg), what = "polygons")

# Clip the grid to Dakshin Dinajpur boundary using st_intersection
grid_clipped <- st_intersection(grid, dakshin_dinajpur)

# Ensure grid_clipped contains only polygons (remove non-polygon geometries if any)
grid_clipped <- grid_clipped[st_geometry_type(grid_clipped) == "POLYGON", ]

# Create the map
leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = dakshin_dinajpur, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 88.726, lat = 25.422, zoom = 8)  # Adjust the map view to focus on Dakshin Dinajpur

# Create the map
map <- leaflet() %>%
  addTiles() %>%  # Add OpenStreetMap base tiles
  addPolygons(data = wb_shapefile, fillColor = "lightgrey", weight = 2, color = "black", opacity = 0.5, fillOpacity = 0.3) %>%
  addPolygons(data = dakshin_dinajpur, fillColor = "gray", weight = 2, color = "black", opacity = 1, fillOpacity = 0.1) %>%
  addPolygons(data = grid_clipped, color = "black", weight = 1, fillOpacity = 0) %>%  # Black gridlines
  setView(lng = 88.726, lat = 25.422, zoom = 8)  # Adjust the map view to focus on Dakshin Dinajpur

# Save the map as an HTML file
saveWidget(map, "dakshin_dinajpur_map_with_clipped_grid.html")
