# Map creation

arg <- st_read("C:/Users/User/Documents/Analyses/Wild boar diseases/Shapefiles/ARG_adm/ARG_adm2.shp")
studyarea = arg %>% filter(NAME_2 == "Patagones" | NAME_1 == "R?o Negro" & NAME_2 == "Adolfo Alsina" | NAME_2 == "Conesa")

studyarea1 <- cbind(studyarea, st_coordinates(st_centroid(studyarea)))

occs <- read.csv("C:/Users/User/Documents/Analyses/Wild boar diseases/Leptospira/Output/Leptospira.csv", sep = ",", dec = ".") %>%
  st_as_sf(coords = c("Long", "Lat"), crs = 4326) %>%
  st_join(arg)

occs <- st_as_sf(occs, coords = c("Long","Lat"), crs = 4326)

clusters <- st_read("C:/Users/User/Documents/Analyses/Wild boar diseases/Leptospira/Output/Leptospira.col.shp")

AD <- ggplot() +
  geom_sf(data = studyarea, color = "black", alpha = 1, aes(fill = NAME_2), show.legend = FALSE) +
  geom_sf(data = clusters, alpha = 1, color = "red", size = 1) +
  geom_sf(data = occs, alpha = 1, pch = 21, size = 3, show.legend = FALSE, aes(fill = factor(Number))) +
  scale_fill_manual(values = c("#FFFFFF","#2ECC71","#F73505","#F5CD60","#ABB2B9","#F0B27A")) +
  annotation_scale(width_hint = 0.2, height = unit(0.2, "cm"),
                   pad_x = unit(0.25, "cm"),
                   pad_y = unit(0.3, "cm")) +
  geom_text(data = studyarea1, aes(X, Y, label = NAME_2), size = 4, family = "sans") +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  coord_sf(xlim = c(-65.5, -62), ylim = c(-41.25, -38.5)) +
  annotate("text", x = -62.9, y = -39.8, label = "RR = 5,4", color = "black", size = 3.5, fontface = 2)

AD

##################################################################
### Distance analysis
##################################################################

rm(list=ls(all=TRUE))

library(rgeos)
library(rgdal)
library(leaflet)
library(magrittr)
library(readxl)

Leptospira <- read_excel("~/Analyses/Wild boar diseases/Leptospira/Leptospira.xlsx", sheet = "Hoja2")

View(Leptospira)

class(Leptospira)
head(Leptospira)

# Load all points

points <- read.csv("C:/Users/User/Documents/Analyses/Wild boar diseases/Leptospira/Output/Leptospira_distance.csv", sep = ",")
head(points)

posits <- points[with(points, Resultado == 1),]
length(posits$Resultado)

negats <- points[with(points, Resultado == 0),]
length(negats$Resultado)

### Get long and lat from your data.frame. Make sure that the order is in lon/lat.

xy <- points[,c(3,2)]
head(xy)

spdf <- SpatialPointsDataFrame(coords = xy, data = points,
                               proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))

head(spdf)

# Project into something - Decimal degrees are no fun to work with when measuring distance!

wgs84 <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")

utm20S <- CRS("+proj=utm +zone=20 +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0") # Opcion 1

utm20S <- CRS("+init=epsg:32720") # Opcion 2

points_proj <- spTransform(spdf, utm20S)
points_proj
class(points_proj)

# Load farms data

farms <- readOGR("C:/Users/User/Documents/Analyses/Wild boar ENM/Spatial data/Capas SENASA/Farm distribution.shp")
farms@coords

area_estudio <- readOGR("C:/Users/User/Documents/Analyses/Wild boar diseases/Shapefiles/Study_area/Study_area.shp")

fall.within.poly <- farms[area_estudio,]
head(fall.within.poly)
length(fall.within.poly$Latitud)

farm_coords <- as.data.frame(fall.within.poly@coords)
head(farm_coords)

colnames(farm_coords) <- c("Long", "Lat")
head(farm_coords)
length(farm_coords$Long)

farm_spdf <- SpatialPointsDataFrame(coords = farm_coords, data = farm_coords,
                                    proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))

farm_spdf
head(farm_spdf)

# Project into something - Decimal degrees are no fun to work with when measuring distance!

utm20S <- CRS("+proj=utm +zone=20 +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0") # Opcion 1

utm20S <- CRS("+init=epsg:32720") # Opcion 2

farms_proj <- spTransform(farm_spdf, utm20S)
farms_proj
class(farms_proj)

farms_proj@data

writeOGR(farms_proj, layer = "Farms_proj", "C:/Users/User/Documents/Analyses/Wild boar diseases/Shapefiles/Study_area/Farms_proj.shp", driver="ESRI Shapefile")

farms_proj = readOGR("C:/Users/User/Documents/Analyses/Wild boar diseases/Shapefiles/Study_area/Farms_proj.shp")

farms_proj <- spTransform(farms_proj, utm20S)

dist <- gDistance(points_proj, farms_proj, byid = T)  # Distance between geometries. 
# Matriz de distancias entre cada jabali (posit y negat)
# y todas las granjas.  
dist

min_Distance <- apply(dist, 2, min)  
min_Distance

# Make a new column in the WGS84 data, set it to the distance
# The distance vector will stay in order, so just stick it on!

points_proj@data$Nearest_farm <- min_Distance  # Creates column with km to nearest farm

points_proj@data$Near_ID <- as.vector(apply(dist, 2, function(x) which(x == min(x))))
points_proj

# Comparison between positives and negatives

df <- as.data.frame(points_proj)
df
is.data.frame(df)

# Normality check negative farms

dist_neg <- subset(df, Resultado == 0) 
is.data.frame(dist_neg)
mean_dist_neg <- mean(dist_neg$Nearest_farm) 
mean_dist_neg

# Test normality: 
# H0 = La distribuci?n es normal
# H1 = La distribuci?n no es normal
# Si p > 0.05 no rechazamos la hipotesis nula

normality = shapiro.test(dist_neg$Nearest_farm)
normality

# P < 0.01, por lo que rechazamos H0 (datos no normales)

plot.new()

p <- ggplot(dist_neg, aes(sample = Nearest_farm)) + stat_qq()
p


###########################################################

# Normality check positive farms

dist_pos <- subset(df, Resultado == 1) 
mean_dist_pos <- mean(dist_pos$Nearest_farm) 
mean_dist_pos

normality.pos = shapiro.test(dist_pos$Nearest_farm)
normality.pos

# P < 0.01, por lo que rechazamos H0 (datos no normales)

plot.new()

p <- ggplot(dist_pos, aes(sample = Nearest_farm)) + stat_qq()
p


###################################################################               

# Compute summary statistics by groups:

library(dplyr)

group_by(df, Resultado) %>%
  summarise(
    count = n(),
    mean = mean(Nearest_farm, na.rm = TRUE),
    sd = sd(Nearest_farm, na.rm = TRUE)
  )

# Compute Mann-Whitney-Wilcoxon

wilcoxon = wilcox.test(x = df$Nearest_farm, y = df$Resultado, alternative = "two.sided", mu = 0,
                       paired = FALSE, conf.int = 0.95) 

wilcoxon

# Prevalence estimation

points <- read.csv("C:/Users/User/Documents/Analyses/Wild boar diseases/Leptospira/Output/Leptospira_distance.csv", sep = ",")
head(points)

prev <- (round((sum((points$Resultado == 1)/length(points$Plot))*100), digits = 1))
prev

