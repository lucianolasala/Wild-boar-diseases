### Leptospirosis

> La prevalencia de infección fue de 20,2% (*n* = 104). Se detectó un agrupamiento de casos significativo (*p* = 0,017) con un radio de 24 km dentro del cual el riesgo relativo fue de 5,4. 
La comparación de distancias entre jabalíes positivos/negativos y la granja de cerdos más cercana fue estadísticamente significativa (*W* = 10816, *p* < 2.2e-16). La distancia mediana entre casos (*n* = 21) y la granja más cercana fue de 3.299 m, mientras que la distancia entre no-casos (*n* = 83) y la granja más cercana fue de 4.276 m. 

El código utilizado para producir el mapa se presenta [aquí](./Leptospira.R).

<img src="https://user-images.githubusercontent.com/20196847/92311237-bf779800-ef8b-11ea-9991-cdb5914ea133.jpg" width="400" img align="center">

> Legenda: Distribución de casos de Leptospira sp. en jabalíes del sudoeste de la provincia de Buenos Aires. Los círculos representan sitios con uno (blando), dos (verde) y cuatro casos (rojo).        

### Análisis de distancia
> Distance data between cases-controls and nearest farm were not normally distributed.   
>Test for normality:    
- H0 = dist. is normal  
- H1 = dist. is not normal   
- If p > 0.05 cannot reject H0    
>In our case, p-value = 1.75e-11 means that we need to reject H0 and accept H1. 

#### Mann-Whitney-Wilcoxon test
