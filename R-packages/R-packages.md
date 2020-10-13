### Instalación de paquetes y librerías necesarias

> In this work, the following R packages were used: 

pkgs <- c("sf","ggplot2","ggspatial","magrittr","tidyverse","rgdal","cowplot","raster","sp")

sapply(pkgs, function(x) library(x, character.only = TRUE))

