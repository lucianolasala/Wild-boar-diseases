### Introducción
Los datos analizados provienen de análisis diagnósticos de muestras biomédicas obtenidas de ejemplares de jabalí cazados en los partidos de Patagones, Adolfo Alsina y Conesa en la provincia de Buenos Aires. Se realizó el diagnóstico para diversos patógenos.
Se analizó la distribición espacial de animales positivos y negativos para cada patógeno mediante análisis de conglomerados (*cluster analysis*) locales, los cuales tinen la capacidad de detectar no solo la presencia sino la localización exacta de conglomerados de casos. 
Se utilizó el Spatial Scan Statistic (Kulldorff y Nargawalla, 1995) utilizando modelos de Bernoulli, donde los casos y controles fueron definidos por resultados positivos y negativos a cada patógeno, respectivamente.   
En este análisis se realiza un escaneo del área de estudio mediante la creación de ventanas circulares móviles, de diámetro y localización variables. 
    El método puramente espacial coloca una ventana circular sobre el área de estudio, la cual se centra secuencialmente sobre cada una de las observaciones. En cada localización, la ventana varía su radio entre cero y un valor especificado por el usuario. Así, el método crea un número muy grande de ventanas con sets diferentes de observaciones (casos y controles) dentro y fuera de cada una.  Cada ventana constituye un posible conglomerado. 

Para cada sitio y tamaño de ventana,  la hipótesis alternativa consiste en un riesgo mayor dentro de la ventana respecto del exterior. 
The likelihood function is maximized over all window locations and sizes, and the one with the maximum
likelihood constitutes the most likely cluster. This is the cluster that is least likely to have occurred by
chance. The likelihood ratio for this window constitutes the maximum likelihood ratio test statistic.
Its
distribution under the null-hypothesis is obtained by repeating the same analytic exercise on a large
number of random replications of the data set generated under the null hypothesis. The p-value is
obtained through Monte Carlo hypothesis testing14, by comparing the rank of the maximum likelihood
from the real data set with the maximum likelihoods from the random data sets.
