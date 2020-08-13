#### Map creation

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
      #geom_sf(data = occs, alpha = 1, pch = 21, size = 2.5, show.legend = FALSE) +
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

#### Map inset creation
    
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
    
    plot.with.inset <- ggdraw() +
    draw_plot(AD) +
    draw_plot(inset, x = 0.13, y = 0.6, width = .3, height = .3)
    plot.with.inset
    
    ggsave(filename = "Leptospira_clusters.jpg", plot = plot.with.inset, device = "jpeg", path = NULL, scale = 1, dpi = 600, limitsize = TRUE)  
    
    
    








