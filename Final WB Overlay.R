R Studio Code for plotting of eBird data density on the map of West Bengal with a 6.6km x 6.6km grid overlay

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

# Step 3: Create a grid for density calculation (6.6 km x 6.6 km grid)
grid_size <- 0.0595  # Approximate 6.6 km in degrees at this latitude
grid <- st_make_grid(shapefile, cellsize = c(grid_size, grid_size), what = "polygons")

# Convert the grid to an `sf` object for easier manipulation
grid_sf <- st_sf(geometry = grid)

# Step 4: Clip the grid to the West Bengal boundary
grid_clipped <- st_intersection(grid_sf, shapefile)

# Step 5: Assign each point to a grid cell
latlong_sf <- st_as_sf(latlong_data, coords = c("LONGITUDE", "LATITUDE"), crs = 4326)

# Step 6: Calculate the density by counting how many points fall in each grid cell
grid_density <- st_join(grid_clipped, latlong_sf, join = st_intersects)

# Count how many points are within each grid cell
density_counts <- grid_density %>%
  group_by(geometry) %>%
  summarise(count = n(), .groups = "drop")

# Step 7: Normalize density values with a logarithmic scale
density_counts <- density_counts %>%
  mutate(log_density = log1p(count))  # Apply log transformation (log(1 + count))

# Step 8: Define a color palette (from white → green → orange → maroon)
# Use more colors to help represent the range of densities better
color_palette <- colorRampPalette(c("white", "green", "orange", "maroon"))(100)

# Step 9: Assign colors to the grid cells based on logarithmic density
density_counts <- density_counts %>%
  mutate(color = color_palette[round(log_density / max(log_density) * 99) + 1])

# Step 10: Create the Leaflet map with a high-contrast base layer
map <- leaflet() %>%
  setView(lng = 87.5, lat = 22.5, zoom = 7) %>%

  # Add a standard OpenStreetMap base layer with full opacity
  addTiles(urlTemplate = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
           attribution = '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors') %>%

  # Add the shapefile with more contrast in black for district boundaries
  addPolygons(data = shapefile,
              color = "black",  # Black boundary for districts
              weight = 2,       # Increased weight for better contrast
              opacity = 1,      # Full opacity for the boundary
              fillOpacity = 0,  # No fill inside the district polygons
              dashArray = "5,5") %>%  # Optional: Add dashed lines for a different effect

  # Add the grid overlay with improved gray grid lines (weight set to 1)
  addPolygons(data = grid_clipped,
              color = "#222222",  # Darker gray grid lines
              weight = 1,         # Reduced weight for thinner grid lines
              opacity = 0.8,      # Increased opacity for gridline visibility
              fillOpacity = 0)    # No fill inside the grid cells

# Step 11: Add the density heatmap overlay within grid boxes (with more contrast in color)
# Convert density_counts to sf object with geometry if not already
density_counts_sf <- st_as_sf(density_counts, wkt = "geometry")

# Adjust the color palette for higher contrast
color_palette <- colorRampPalette(c("white", "darkgreen", "orange", "red", "darkred"))(100)

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

# Step 12: Plot the map
map

# Step 13: Save the map to an HTML file
saveWidget(map, "west_bengal_map_with_eBird_Data_Overlay_on_6.6_Kms_Grid.html")
