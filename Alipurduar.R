# Install the necessary packages if not already installed
install.packages("sf")
install.packages("leaflet")
install.packages("dplyr")

# Load the libraries
library(sf)
library(leaflet)
library(dplyr)

# Load the shapefile
shapefile_path <- "aee65/West Bengal/District_shape_West_Bengal.shp"
wb_districts <- st_read(shapefile_path)

# Check the column names to identify the district name column
names(wb_districts)

# View the first few rows to see the data structure
head(wb_districts)

# Filter out the Alipurduar district
alipurduar_boundary <- wb_districts %>%
  filter(NAME == "Alipurduar")  # Replace 'DISTRICT_NAME' with the actual column name for district names

# Plot the entire West Bengal districts and highlight only Alipurduar in gray
leaflet() %>%
  addTiles() %>%
  addPolygons(data = wb_districts,
              fillColor = "white",
              fillOpacity = 0.3,
              color = "black",
              weight = 1) %>%  # Show all districts with white fill and black border
  addPolygons(data = alipurduar_boundary,
              fillColor = "white",
              fillOpacity = 0.7,
              color = "black",
              weight = 2,
              popup = ~NAME)  # Highlight Alipurduar in gray with a popup showing the district name

# Install the necessary packages if not already installed
install.packages("sf")
install.packages("leaflet")
install.packages("dplyr")

# Load the libraries
library(sf)
library(leaflet)
library(dplyr)

# Load the shapefile
shapefile_path <- "aee65/West Bengal/District_shape_West_Bengal.shp"
wb_districts <- st_read(shapefile_path)

# Check the column names to identify the district name column
names(wb_districts)

alipurduar_boundary <- wb_districts %>%
  filter(NAME == "Alipurduar")  # Replace 'DISTRICT_NAME' with the actual column name for the district name

# Define a custom color palette using the colorBin function
pal <- colorBin(
  palette = c("white", "yellow", "green", "orange", "red", "maroon"),
  domain = grid_points_count$count,
  bins = 5,  # Adjust the number of bins to match the desired color scale
  na.color = "transparent"  # Make grids with no data appear transparent
)

# Create the Leaflet map with transparent grids for no data
leaflet() %>%
  addTiles() %>%  # Base map layer
  addPolygons(data = alipurduar_boundary_wgs84,
              fillColor = "lightgray",
              fillOpacity = 0.025,  # Lower opacity for boundary fill
              color = "black",   # Black border for the boundary
              weight = 2,        # Set the border weight
              popup = ~NAME) %>%  # Boundary layer with popup
  addPolygons(data = grid_points_count_wgs84,
              color = "gray",  # Gray border for the gridlines
              weight = 1,       # Set the border weight to make gridlines visible
              fillColor = ~ifelse(is.na(count), "transparent", pal(count)),  # Make grids with no data transparent
              fillOpacity = 0.5)  # Lower opacity for grid cells with data

# Install and load the htmlwidgets package if not already installed
# install.packages("htmlwidgets")
library(htmlwidgets)

# Define the map with the necessary layers
map <- leaflet() %>%
  addTiles() %>%  # Base map layer
  addPolygons(data = alipurduar_boundary_wgs84,
              fillColor = "white",
              fillOpacity = 0.3,  # Lower opacity for boundary fill
              color = "black",   # Black border for the boundary
              weight = 2,        # Set the border weight
              popup = ~NAME) %>%  # Boundary layer with popup
  addPolygons(data = grid_points_count_wgs84,
              color = "gray",  # Gray border for the gridlines
              weight = 1,       # Set the border weight to make gridlines visible
              fillColor = ~ifelse(is.na(count), "transparent", pal(count)),  # Make grids with no data transparent
              fillOpacity = 0.5)  # Lower opacity for grid cells with data

# Save the map as an interactive HTML file
saveWidget(map, "eBird_Data_Density_6.6x6.6_Km_Alipurduar.html")
