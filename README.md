-   [Introduction](#introduction)
-   [Getting started](#getting-started)


Introduction
------------

**kuenm** is an R package designed to make the process of model calibration and final model creation easier and more reproducible, and at the same time more robust. The aim of this package is to design suites of candidate models to create diverse calibrations of Maxent models to allow selection of optimal parameterizations for each study. Other objectives of this program are to make the task of creating final models and their transfers easier, as well to permit assessing extrapolation risks when model transfers are needed.

  rm(list=ls(all=TRUE))
  arg <- st_read("C:/Users/User/Documents/Analyses/Wild boar       
  diseases/Shapefiles/ARG_adm/ARG_adm2.shp")

  studyarea = arg %>% filter(NAME_2 == "Patagones" | NAME_1 == "R?o Negro" & NAME_2 == "Adolfo   Alsina" | NAME_2 == "Conesa")

  studyarea1 <- cbind(studyarea, st_coordinates(st_centroid(studyarea)))