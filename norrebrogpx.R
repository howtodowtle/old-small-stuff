##############################
##  Authors: AJD
##  Date: 18.01.2017
##  Project: Plot Norrebro Lobet 2013 from GPX file
##  Script: norrebrogpx.R
##  WD: ~/norrebrogpx
##  Input Data: 20130518-090027-Run.R
##############################

# Workspace and Working Directory -----------------------------------------

rm(list = ls())
getwd()

folder.wd = "~/norrebrogpx"
setwd(folder.wd)
getwd()

# Function Definitions ----------------------------------------------------

IPak = function(pkg){
  # Function will install new packages and require already installed ones
  #
  # Args:
  #  pkg: A character string containing the packages to be used in the
  #       project.
  #
  # Returns:
  #  None, apart from the function calls for install.packages() and/or
  #  require(). 
  new.pkg = pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}


# Install and Load Packages -----------------------------------------------

packages = c("plotKML", "leaflet", "ggmap", "maps")
IPak(packages)


# Data --------------------------------------------------------------------

# Function readGPX: http://plotkml.r-forge.r-project.org/readGPX.html

run = "20130518-090027-Run.gpx"

track = readGPX(run)
str(track)
tracks = track$tracks
str(tracks)
tracks = data.frame(Reduce(rbind, tracks))
colnames(tracks)<- c("lon", "lat", "ele", "time")
str(tracks)
data.class(tracks)
head(tracks)

# lon, lat already numeric. ele, tim characters


# leaflet -----------------------------------------------------------------

myleaflet = leaflet(tracks) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolylines(lng = ~ lon, lat = ~ lat, 
               # stroke options; weight: width in pixels
               stroke = TRUE, weight = 2, color = "red", opacity = 0.5,
               # fill options (optional)
               fill = FALSE, fillColor = "black", fillOpacity = 1,
               # rest
               dashArray = NULL, smoothFactor = 1, noClip = FALSE, 
               popup = NULL, options = pathOptions(), data = tracks)
  
# If points ("circles") are preferred:
  # addCircles(lng = ~ lon, lat = ~ lat, radius = 0.5, fillColor = "red", 
  #            fillOpacity = 0.5, stroke = TRUE)

myleaflet

# myleaflet <- myleaflet %>% 
#   addPolylines(lng = ~ lon, lat = ~ lat, 
#                # stroke options; weight: width in pixels
#                stroke = TRUE, weight = 1, color = "red", opacity = 0.5,
#                # fill options (optional)
#                fill = TRUE, fillColor = "black", fillOpacity = 1,
#                # rest
#                dashArray = NULL, smoothFactor = 1, noClip = FALSE, 
#                popup = NULL, options = pathOptions(), data = tracks)

# ggmap -------------------------------------------------------------------

# map <- get_map(location = "Berlin", zoom = 6)
# 
# # location = c(12.55787, 55.68615)
# 
# mapPoints <- ggmap(map) +
#   geom_point(x = tracks$lon, y = tracks$lat, 
#              size = 1, data = tracks, alpha = .5)
# 
# mapPoints
# 
# kort <- map()
# map(kort)
# points(tracks$lon, tracks$lat)

