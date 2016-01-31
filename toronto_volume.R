library(magrittr)
library(leaflet)
library(gsub)

setwd("~/GitHub/toronto_ped_traffic_volume")

# Get the files names
files = list.files(pattern = "*.csv")


file.list <- lapply(files, function(x) read.csv(x, header = TRUE, stringsAsFactors = FALSE))

names(file.list) <- c("vol_2011","vol_2012","vol_2013")
 
#note the invisible function keeps lapply from spitting out the data.frames to the console

invisible(lapply(names(file.list), 
                 function(x) assign(x,file.list[[x]],envir=.GlobalEnv)))


# Create Intersection
vol_2011$Intersection <- paste(vol_2011$Main, "&", vol_2011$Side.1.Route)

vol_2011 <- as.data.frame(lapply(vol_2011, function(x) gsub(",", "", x)))

#AUtomate this
vol_2011$X8HrPedVol <- as.numeric(as.character(vol_2011$X8HrPedVol))
vol_2011$Longitude <- as.numeric(as.character(vol_2011$Longitude))
vol_2011$Latitude <- as.numeric(as.character(vol_2011$Latitude))


vol_2011$size <- ((vol_2011$X8HrPedVol - min(vol_2011$X8HrPedVol)) /
  (max(vol_2011$X8HrPedVol) - min(vol_2011$X8HrPedVol))) * 15


# Create a continuous palette function
pal <- colorNumeric(
  palette = "Blues",
  domain = vol_2011$X8HrPedVol
)



# http://rstudio.github.io/leaflet/colors.html

df = vol_2011
m = leaflet(df) %>%   
  setView(lng = -79.381, lat = 43.656, zoom = 14) %>% 
  addTiles() %>% 
  addProviderTiles("Stamen.Toner") %>%  
  addCircleMarkers(radius = ~size, 
                   color = ~pal(X8HrPedVol), 
                   popup= ~Intersection, 
                   fill = TRUE, 
                   opacity = .8,
                   fillOpacity = .8)
m

?addCircleMarkers


