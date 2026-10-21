
# Bertie Time Trial Route mapping
# load zipped shapefile, add extras and export as html file with leaflet
# Gary, 26 March 2026 - 22 October 2026

############################################################################## #
# Load libraries ####
############################################################################## #
library(sf)
library(leaflet)
library(leaflet.extras)
library(leaflet.extras2)
library(htmlwidgets)
library(htmltools)



############################################################################## #
# 1. Import the zipped shapefile ####
############################################################################## #

# If the zip contains multiple files, st_read usually finds the .shp automatically
line_data <- st_read("/vsizip/C:/Garys_Laptop_Files/Allsorts/Bertie_Route/Bertie_Route_2026_shapefile.zip")

# Ensure it is in the correct Coordinate Reference System for Leaflet (WGS84)
line_data <- st_transform(line_data, 4326)



############################################################################## #
# 2. Create the leaflet map ####
############################################################################## #

map <- leaflet() %>%
  
  # set map centre and zoom level
  setView(lng = -2.694, lat = 56.227, zoom = 16) %>%
  
  # add text attribution to map
  # addTiles(attribution = "Bertie Time Trial Route") %>%  # Adds a default OpenStreetMap background?

  # add map tile from providers
  addProviderTiles(providers$Esri.WorldStreetMap) %>%
  # addProviderTiles(providers$CartoDB.Positron) %>%
  # addProviderTiles(providers$OpenStreetMap) %>%
  
  # Use JavaScript to style and centre text at the top of the map window
  htmlwidgets::onRender("
    function(el, x) {
      // Create the title element
      var titleDiv = document.createElement('div');
      titleDiv.innerHTML = 'Allsorts Bertie Time Trial Route';
      // Style it to be centered at the top, transparent, and modern
      titleDiv.style.position = 'absolute';
      titleDiv.style.top = '12px';
      titleDiv.style.left = '50%';
      titleDiv.style.transform = 'translateX(-50%)';
      titleDiv.style.zIndex = '1000'; // Ensures it stays on top of the map tiles
      titleDiv.style.fontSize = '20px';
      titleDiv.style.fontWeight = 'bold';
      titleDiv.style.color = '#333333';
      titleDiv.style.backgroundColor = 'transparent';
      titleDiv.style.pointerEvents = 'none'; // Allows clicks to pass through the title to the map
      titleDiv.style.whiteSpace = 'nowrap';
      // Append it directly to the map container
      el.appendChild(titleDiv);
    }
  ") %>%

  # add additional text to the layout
  addControl(html = "Bertie Time Trial Route<br>
             Start at the start and finish at the finish<br>
             Follow the moving line<br>",
             position = "bottomleft") %>%

  
  # # Add the Line with custom thickness and color
  # addPolylines(
  #   data = line_data,
  #   color = "royalblue",
  #   weight = 5,               # thickness
  #   opacity = 0.8,
  #   label = "My Route") %>%   # Hover text
  
  
  # Add text at a coordinate with no marker pin
  addLabelOnlyMarkers(
    lng = -2.7030179, lat = 56.226950, 
    label = "Start and Finish",
    labelOptions = labelOptions(
      noHide = TRUE,          # Keeps the text permanently visible
      direction = "center",   # Centers the text over the coordinates
      textOnly = TRUE,        # Removes the white background card/bubble
      style = list(
        "font-weight" = "bold",
        "font-size" = "16px",
        "color" = "black"))) %>%     # Optional: gives the text a custom color
      
  # Add Marker with text for Fire Station
  addMarkers(
    lng = -2.6963861, lat = 56.225198,
    label = "Fire Station", 
    labelOptions = labelOptions(
      direction = "right",        # Appears above the pin ('top', 'bottom', 'left', 'right')
      textOnly = FALSE),        # FALSE = white popup box; TRUE = plain text floating on screen
    popup = "Fire Station") %>%
  
    # Add Marker with text for Corner Shop
  addMarkers(
    lng = -2.6919905, lat = 56.224882, 
    label = "Corner Shop", 
    labelOptions = labelOptions(
      direction = "bottom",       
      textOnly = FALSE),
    popup = "Corner Shop") %>%
  
  # Add Marker with text for Toll Road
  addMarkers(
    lng = -2.6927522, lat = 56.227348,
    label = "Toll Road", 
    labelOptions = labelOptions(
      direction = "right",       
      textOnly = FALSE),       
    popup = "Toll Road") %>%
  
  # Add Marker with text for Cellardyke Church
  addMarkers(
    lng = -2.6901022, lat = 56.224259, 
    label = "Cellardyke Church", 
    labelOptions = labelOptions(
      direction = "right",        
      textOnly = FALSE),       
    popup = "Cellardyke Church") %>%
  
  # Add Marker with text for Windmill Road Corner
  addMarkers(
    lng = -2.6898522, lat = 56.230912, 
    label = "Windmill Road Corner", 
    labelOptions = labelOptions(
      direction = "top",        
      textOnly = FALSE),       
    popup = "Windmill Road Corner") %>%
  
  
    # "Marching Ants" line effect
  leaflet.extras2::addAntpath(
    data = line_data,
    # Styling the line
    color = "blue",       # Dark blue/grey main line
    weight = 5,              # Thickness
    opacity = 0.9,
    label = "This is the Bertie Route",

    options = antpathOptions(
      delay = 2000,          # INCREASE this number to SLOW DOWN (e.g., 3000 or 4000)
      reverse = TRUE,       # Change to TRUE if direction is wrong
      dashArray = c(10, 20)  # 10px dash, 15px gap
    )
  ) %>%

  # A "Pulsing marker" effect for the marker
  addPulseMarkers(lng = -2.7030179, lat = 56.226950,
                  label = "This is where the Bertie route starts and finishes",
                  icon = makePulseIcon(
                    color = "#00FF00",      # Green dot
                    heartbeat = 0.8,        # Faster pulse
                    iconSize = c(22,22))     # Small, discrete size
  ) %>%
  
  # Add a map view reset button
  leaflet.extras::addResetMapButton() %>%
  
  # Add a button to go fullscreen
  leaflet.extras::addFullscreenControl() %>%
  
  # Add a scale bar
  addScaleBar(position = "bottomleft")



############################################################################## #
# 3. Preview the map in RStudio Viewer ####
############################################################################## #

map



############################################################################## #
# 4. Export the leaflet map as a standalone HTML file ####
############################################################################## #

htmlwidgets::saveWidget(widget = map,
                        file = "bertie_time_trial_map.html",
                        title = "Bertie Time Trial Route",
                        selfcontained = TRUE)



# push to GitHub here as index.html?

############################################################################## #
# Key Customization Tips ####
############################################################################## #
#
# Line Thickness (weight)
# The weight argument in addPolylines is measured in pixels.
# A value of 1 is very thin, while 10 is quite bold.
#
# Popups vs. Labels ,,,
# label: Appears instantly when you hover over the line/marker.
# popup: Appears only when you click on the feature (supports HTML tags like <b> for bolding).
#
# selfcontained = TRUE ...
# In the saveWidget function, this is crucial.
# It bundles all the JavaScript and CSS into one single .html file
# so you can email it to someone else and it will work perfectly without needing extra folders.

# 1. The Elevation Profile (Altitude)
# If your shapefile contains Z-coordinates (altitude), you can display an interactive height profile at the bottom of the map. As the user moves their mouse over the chart, a marker moves along the line on the map.
# package: leaflet.extras2
# Feature: addElevation()

# 2. Animated Markers (The "Moving" Effect)
# Instead of a static line, you can have a pulse or a moving icon that travels along the path to show directionality.
# Package: leaflet.extras
# Feature: addPulseMarkers() or addAntPath().

# Why use it: addAntPath creates a "marching ants" effect on your line, which intuitively shows the user which way the route flows.

# 3. Labels and Hover Effects
# Standard markers can feel cluttered. Use Labels for a cleaner look.
# Static Labels: Text that is always visible.
# Tooltip Labels: Text that pops up only when hovering over the line.

# 5. Mini-Maps and Scale Bars
# Crucial for orientation when users zoom in deep.
# MiniMap: A small inset map in the corner showing the "big picture."
# Measure Tool: Allows users to click two points and see the distance between them.

# 6. Dynamic Titles and Images in Popups
# You can use standard HTML inside the popup argument to embed images or formatted text.
# Example of an image in a popup
# popup_content <- paste0(
#  "<b>Summit View</b><br>",
#  "<img src='https://link-to-your-image.jpg' width='200'>",
#  "<p>This is the highest point of the trail.</p>")
# addMarkers(lng, lat, popup = popup_content)

# 7. Fullscreen and Reset View
# Sometimes users get "lost" panning around.
# Fullscreen: addFullscreenControl()
# Reset: addResetMapButton() returns the zoom level to the original extent of your shapefile.

# 8. GitHub Pages
# Map is now shared publicly at garsco.github.io
# But not really sure how GitHub us working
# Good idea just to keep practicing with it though



############################################################################## #
# End.
############################################################################## #


# Create a dummy line (London to Paris-ish)
# test_line <- matrix(c(-0.12, 51.50, 2.35, 48.85), ncol = 2, byrow = TRUE)

# leaflet() %>%
#   addTiles() %>%
#   leaflet.extras2::addAntpath(data = test_line, color = "blue", weight = 5)
# 
# leaflet() %>%
#   addTiles() %>%
#   leaflet.extras2::addAntpath(
#     data = test_line,
#     color = "blue",       # Dark blue/grey main line
#     weight = 5,              # Thickness
#     opacity = 0.9,
# 
# # Controlling the animation
# #delay = 800,             # Speed of movement
#     dashArray = c(10, 15),   # 10px dash, 15px gap
# 
# # Interaction
#     label = "Recommended Route",
#     popup = "This path takes approximately 2 hours.")
#   
