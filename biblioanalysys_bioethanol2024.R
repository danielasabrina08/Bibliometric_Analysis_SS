#### Flujo de trabajo para generar información de bibliometría y figuras 
## Elaborado por: Reyes Rivera Daniela Sabrina

# Cargar la paquetería a emplear:
install.packages("bibliometrix")
library(bibliometrix)

# Cargar el archivo con información de los artículos en la consulta:
file <- "savedrecs_2024.bib"
#Ubicar ruta de trabajo
setwd("C:/Users/danni/Desktop/ServicioSocial/data2024")

#Generar un DataFrame
M <- convert2df(file = file, dbsource = "isi", format = "bibtex")
write.csv(M,"databe_2024.csv")

#Calcular las principales medidas bbliométricas a través de la funcion biblioAnalysis
results <- biblioAnalysis(M, sep = ";")
options(width=100)

#Objeto de resumen de las características de los 10 primeros artículos
S <- summary(object = results, k = 10, pause = FALSE)

#Generar gráficos de resultados
plot(x = results, k = 10, pause = FALSE) #k = numero de articulos a mostrar
#sort(Matrix::colSums(A), decreasing = TRUE)[1:5]

#Siguiendo el enfoque, calcular distintas redes bipartitas
A <- cocMatrix(M, Field = "CR", sep = ".  ") #Red de citas
A <- cocMatrix(M, Field = "CR", sep = ";") #Red de autores
A <- cocMatrix(M, Field = "DE", sep = ";") #Red de palabras clave del autor

### Redes de acoplamiento bibliográfico:

#Funcion biblioNetwork: Calcula las redes de acoplamiento principales: autor, fuentes y paises
NetMatrix <- biblioNetwork(M, analysis = "coupling", network = "references", sep = ".  ")
NetMatrix <- biblioNetwork(M, analysis = "coupling", network = "authors", sep = ";")

#Funcion networkStat: devuelve diversos parámetros estadisticos resumidos
NetMatrix <- biblioNetwork(M, analysis = "co-occurrences", network = "keywords", sep = ";")
netstat <- networkStat(NetMatrix)
names(netstat$network)
summary(netstat, k=10)


#### Usando la función networkPlot, trazar redes 

#Red de asociacion por colaboracion entre paises
M <- metaTagExtraction(M, Field = "AU_CO", sep = ";") #Uso de la funcion metaTagExtraction 
NetMatrix_Country <- biblioNetwork(M, analysis = "collaboration", network = "countries", sep = ";")
# Generar el grafico - PAISES
net=networkPlot(NetMatrix_Country, n = dim(NetMatrix_Country)[1], 
                Title = "Country Collaboration", type = "circle", size=TRUE, 
                remove.multiple=FALSE,labelsize=0.7,cluster="none")

# Red de co-ocurrencias
NetMatrix <- biblioNetwork(M, analysis="collaboration",network="countries",sep=";")
#Generar grafico:
net=networkPlot(NetMatrix, n = dim(NetMatrix)[1], Title = "Country Collaboration", 
                type = "circle", size=TRUE, remove.multiple=FALSE,labelsize=0.7,
                cluster="none")
net=networkPlot(NetMatrix_COC, normalize="association", weighted = T,
                n=30, Title = "Co-occurrences", type="circle", size=T,
                edgesize=5,labelsize=0.7)
NetMatrix <- biblioNetwork(M, analysis = "co-occurrences", network = "keywords", sep = ";")
# Plot the network
net=networkPlot(NetMatrix, normalize="association", weighted=T, n = 30, Title = "Keyword Co-occurrences", type = "fruchterman", size=T,edgesize = 5,labelsize=0.7)

#Grafico de palabras compartidas: Estructura conceptual de un campo; distintos métodos 
#de reduccion y agrupacion por K-medias para generar agrupaciones de documentos con expresion de ideas comunes
CS <- conceptualStructure(M,field="ID", method="CA", 
                          minDegree=4, clust=5, stemming=FALSE, 
                          labelsize=10, documents=10)

#Mapa historiográfico de citas:
#Representa un mapa de redes cronológico con las citas mas importantes de una coleccion bibliográfica
options(width=130)
histResults <- histNetwork(M, min.citations = 1, sep = ";")
net <- histPlot(histResults, n=15, size = 10, labelsize=5) #Gráfico
topAU <- authorProdOverTime(M, k = 10, graph = TRUE) #Genera grafico de actividad de los 10 autores mas productivos
head(topAU$dfAU) #Productividad de los autores por año

# Conceptual structure - thematic evolution
tmap <- thematicEvolution(M, field = "ID", years)
plotThematicEvolution(tmap$Nodes, tmap$Edges)
# Agrupar periodos de tiempo

#Generar thematic evolution maps en la interfaz gráfica biblioshiny
biblioshiny()