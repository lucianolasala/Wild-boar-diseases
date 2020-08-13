# Spatial Epidemiology of Wild Boar (*Sus scrofa*) diseases in Argentina

<img src="https://user-images.githubusercontent.com/20196847/82152923-d78ba600-983a-11ea-9bfc-2a9115a029f5.jpg" height="100" width="100" img align="right">

-   [Introduction](#introduction)
-   [Methodological approach](#methodological-approach)
    -   [R packages](#r-packages)             
    -   [Data processing](#data-processing)    
    -   [Environmental data processing](#environmental-data-processing)     
    -   [Model calibration](#model-calibration)      
    -   [Model validation](#model-validation)
    -   [Plots](#plots)


Introduction
------------

**kuenm** is an R package designed to make the process of model calibration and final model creation easier and more reproducible, and at the same time more robust. The aim of this package is to design suites of candidate models to create diverse calibrations of Maxent models to allow selection of optimal parameterizations for each study. Other objectives of this program are to make the task of creating final models and their transfers easier, as well to permit assessing extrapolation risks when model transfers are needed.

    rm(list=ls(all=TRUE))
    arg <- st_read("C:/Users/User/Documents/Analyses/Wild boar       
    diseases/Shapefiles/ARG_adm/ARG_adm2.shp")
    studyarea = arg %>% filter(NAME_2 == "Patagones" | NAME_1 == "R?o Negro" & NAME_2 ==          "Adolfo   Alsina" | NAME_2 == "Conesa")
    studyarea1 <- cbind(studyarea, st_coordinates(st_centroid(studyarea)))
    studyarea = arg %>% filter(NAME_2 == "Patagones" | NAME_1 == "R?o Negro" & NAME_2 ==          "Adolfo   Alsina" | NAME_2 == "Conesa")
    studyarea1 <- cbind(studyarea, st_coordinates(st_centroid(studyarea)))


Methodological approach
----------

[1. R packages](./R_packages/README.md)

[2. Occurrence data processing](./Occurrences/README.md)

[3. Environmental data processing](./Variables/README.md)

[4. Model calibration](./calibration/calibration.md)

[5. Model validation](./Validation/README.md)

[6. Plots](./plots)
