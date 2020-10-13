### Instalación de paquetes y librerías necesarias

> En este trabajo se utilizó una serie de paquetes de R y funciones necesarias para realizar los análisis presentados.

pkgs <- c("sf","ggplot2","ggspatial","magrittr","tidyverse","rgdal","cowplot","raster","sp")

sapply(pkgs, function(x) library(x, character.only = TRUE))

