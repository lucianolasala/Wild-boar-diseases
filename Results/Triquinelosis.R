#-----------------------------------------------------------------
# Trichinella spiralis
#-----------------------------------------------------------------

rm(list=ls(all=TRUE))

arg <- st_read("C:/Users/User/Documents/Analyses/Wild boar diseases/Shapefiles/ARG_adm/ARG_adm2.shp")

studyarea = arg %>% filter(NAME_2 == "Patagones" | NAME_1 == "Río Negro" & NAME_2 == "Adolfo Alsina" | NAME_2 == "Conesa")

studyarea1 <- cbind(studyarea, st_coordinates(st_centroid(studyarea)))


occs <- read.csv("C:/Users/User/Documents/Analyses/Wild boar diseases/Triquinelosis/Trichinella.csv", sep = ",", dec = ".") %>%
  st_as_sf(coords = c("Long", "Lat"), crs = 4326) %>%
  st_join(arg)

occs1 <- st_as_sf(occs, coords = c("Long","Lat"), crs = 4326)

AD <- ggplot() +
  geom_sf(data = studyarea, color = "black", alpha = 1, aes(fill = NAME_2), show.legend = FALSE) +
  geom_sf(data = occs, alpha = 1, pch = 21, size = 3, show.legend = FALSE, aes(fill = factor(Number))) +
  scale_fill_manual(values = c("#FFFFFF","#F5CD60","#ABB2B9","#F0B27A")) +
  annotation_scale(width_hint = 0.2, height = unit(0.2, "cm"),
                   pad_x = unit(0.25, "cm"),
                   pad_y = unit(0.3, "cm")) +
  geom_text(data = studyarea1, aes(X, Y, label = NAME_2), size = 4,
            family = "sans") +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  coord_sf(xlim = c(-65.5, -62), ylim = c(-41.25, -38.5))

AD

#-----------------------------------------------------------------
# Inset creation
#-----------------------------------------------------------------

arginset <- st_read("C:/Users/User/Documents/Analyses/Wild boar diseases/Shapefiles/ARG_adm/ARG_adm0.shp")

poly <- st_read("C:/Users/User/Documents/Analyses/Wild boar diseases/Shapefiles/Polygon/Polygon.shp") 

inset <- ggplot() +
  geom_sf(data = arginset, color = "black", alpha = 1) +
  geom_sf(data = poly, color = "red", alpha = 0, size = 1) +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) + 
  theme(panel.background = element_blank()) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        plot.background = element_rect(fill = "lightblue", colour = "black"))

plot.with.inset <-
  ggdraw() +
  draw_plot(AD) +
  draw_plot(inset, x = 0.2, y = 0.6, width = .3, height = .3)

plot.with.inset

ggsave(filename = "C:/Users/User/Documents/Analyses/Wild boar diseases/R_project/Wild-boar-diseases/Maps/Triquinelosis.jpg", plot = plot.with.inset, device = "jpeg", path = NULL,
       scale = 1, dpi = 300, limitsize = TRUE)


#-----------------------------------------------------------------
# Analisis de distancias
#-----------------------------------------------------------------

rm(list=ls(all=TRUE))

install.packages("rgeos","rgdal","magrittr","readxl")

library(rgeos)
library(rgdal)
library(magrittr)
library(readxl)

Triquinelosis <- read_excel("~/Analyses/Wild boar diseases/Triquinelosis/Trichinella.xlsx", sheet = "Trichinella_distance")

View(Triquinelosis)

# Load all points

points <- read.csv("C:/Users/User/Documents/Analyses/Wild boar diseases/Triquinelosis/Trichinella_distance.csv", sep = ",")
head(points)

posits <- points[with(points, Resultado == 1),]
length(posits$Resultado)

negats <- points[with(points, Resultado == 0),]
length(negats$Resultado)

# Get longitude and latitude from the data.frame. Make sure that the order is in lon/lat.

xy <- points[,c(3,2)]  # Extract Long and Lat
head(xy)

# Transform data.frame to SpatialPointsDataframe

spdf <- SpatialPointsDataFrame(coords = xy, data = points, proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
spdf@proj4string

# Define a projection - Decimal degrees are no fun to work with when measuring distance

utm20S <- CRS("+proj=utm +zone=20 +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0") # Opcion 1

utm20S <- CRS("+init=epsg:32720") # Opcion 2

points_proj <- spTransform(spdf, utm20S)

# Load farms data

farms <- readOGR("C:/Users/User/Documents/Analyses/Wild boar ENM/Spatial data/Capas SENASA/Farm distribution.shp")
farms@coords

area_estudio <- readOGR("C:/Users/User/Documents/Analyses/Wild boar diseases/Shapefiles/Study_area/Study_area.shp")

fall.within.poly <- farms[area_estudio,]  # 460 farms

farm_coords <- as.data.frame(fall.within.poly@coords)

colnames(farm_coords) <- c("Long", "Lat")

farm_spdf <- SpatialPointsDataFrame(coords = farm_coords, data = farm_coords,
                                    proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))

# Project into something - Decimal degrees are no fun to work with when measuring distance!

utm20S <- CRS("+proj=utm +zone=20 +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0") # Opcion 1

utm20S <- CRS("+init=epsg:32720") # Opcion 2

farms_proj <- spTransform(farm_spdf, utm20S)
class(farms_proj)
farms_proj@data

writeOGR(farms_proj, layer = "Farms_proj", "C:/Users/User/Documents/Analyses/Wild boar diseases/Shapefiles/Study_area/Farms_proj.shp", driver="ESRI Shapefile")

# Read in projected farm data

farms_proj = readOGR("C:/Users/User/Documents/Analyses/Wild boar diseases/Shapefiles/Study_area/Farms_proj.shp")
class(farms_proj)
farms_proj@proj4string

farms_proj <- spTransform(farms_proj, utm20S)

dist <- gDistance(points_proj, farms_proj, byid = T)  # Distance between geometries. 
# Matriz de distancias entre cada jabali (posit y negat) y todas las granjas.  
dist

min_Distance <- apply(dist, 2, min)  
min_Distance  # 106 values for minimum distance

# Make a new column in the WGS84 data, set it to the distance.
# The distance vector will stay in order, so just stick it on!

points_proj@data$Nearest_farm <- min_Distance  # Creates column with km to nearest farm
head(points_proj@data)

points_proj@data$Near_ID <- as.vector(apply(dist, 2, function(x) which(x == min(x))))
head(points_proj@data)
points_proj@data$Near_ID

# Comparison between positives and negatives

class(points_proj)
df <- as.data.frame(points_proj)
head(df)

# Next we check normality assumptions for both groups

normality1 = shapiro.test(df$Nearest_farm)
normality1

# Test normality: 
# H0 = dist. is normal
# H1 = dist. is not normal 
# If p > 0.05 cannot reject H0

# In our case, p-value = 2.699e-09, then reject H0 and accept H1

plot.new()

p <- ggplot(df) +
  stat_qq(aes(sample = Nearest_farm, colour = "red"), shape=21) +
  theme(legend.position = "none") +
  labs(x = "Theoretical", y = "Observed") +
  theme(axis.title.x = element_text(size = 10, face = "bold.italic"),
        axis.title.y = element_text(size = 10, face = "bold.italic")) +
  theme(plot.margin = unit(c(1,1,1,1), "cm")) +
  theme(axis.title.x = element_text(margin = margin(t = 15)),
        axis.title.y = element_text(margin = margin(r = 15)))
p

ggsave(filename = "Figure_1.jpg", plot = p, device = "jpeg", path = NULL,
       scale = 1, dpi = 300, limitsize = TRUE)

###################################################################               

# Compute summary statistics by groups:

group_by(df, Resultado) %>%
  summarise(
    count = n(),
    mean = mean(Nearest_farm, na.rm = TRUE),
    sd = sd(Nearest_farm, na.rm = TRUE),
    median = median(Nearest_farm, na.rm = TRUE)
  )

# Compute Mann-Whitney-Wilcoxon

wilcoxon = wilcox.test(x = df$Nearest_farm, y = df$Resultado, alternative = "two.sided", mu = 0,
                       paired = FALSE, conf.int = 0.95) 

wilcoxon

# Prevalence estimation

points <- read.csv("C:/Users/User/Documents/Analyses/Wild boar diseases/Aujeszky/Output/Aujeszky_distance.csv", sep = ",")
head(points)

prev <- (round((sum((points$Resultado == 1)/length(points$Resultado))*100), digits = 1))
prev
