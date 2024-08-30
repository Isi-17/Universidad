library(rpart)
library(mboost)
set.seed(123)
# Establece una semilla para la generación de números aleatorios. 
# La misma semilla producirá los mismos resultados cada vez que se ejecute el código.

# Muestra aleatoria de números del 1 al 150. Se seleccionan con reemplazo (un mismo numero puede aparecer varias veces en la muestra)
find <- sample(150, 150)

# Contiene los primeros 20 elementos de la muestra aleatoria generada anteriormente. 
# Esto se utiliza para dividir los datos en un conjunto de prueba más pequeño.
itest <- find[1:20]

dataTest <- iris[itest,] # tengo 20 observaciones de 5 variables
# Filas de la base de datos iris correspondientes a los índices especificados en el vector itest. 

# -itest -> me coge todos los datos menos los de itest
dataFit <- iris[-itest, ] # tengo 130 observaciones de 5 variables
# Filas de la base de datos iris que no están en el conjunto de prueba. Excluye las filas correspondientes a los índices en itest.

arbolRpart<-rpart(Species~., iris, control = rpart.control(minbucket = 2))

print(arbolRpart)
plot(arbolRpart)
text(arbolRpart, use.n=TRUE)

prediccion <- predict(arbolRpart, dataTest) # Predecir con el arbol de decision por probabilidad.
# Sin embargo, crea una tabla que divide por probabilidades. Quiero dividirlo por clases.

prediccion <- predict(arbolRpart, dataTest, type="class") # Predecir con el arbol de decision por clase.
#14         50        118         43        150        148         90         91        143 
#setosa     setosa  virginica     setosa  virginica  virginica versicolor versicolor  virginica 
#92        137         99         72         26          7         78         81        147 
#versicolor  virginica versicolor versicolor     setosa     setosa  virginica versicolor  virginica 
#103        117 
#virginica  virginica 
# Predice que el nº 14 es setosa. Si abro "dataTest", efectivamente es setosa.
# Predice por clases, pues es la que mas probabilidad tiene de ser.

matrizconfusion <- table(prediccion, dataTest$Species) # Matriz de confusion
#prediccion   setosa versicolor virginica
#setosa          5          0         0
#versicolor      0          6         0
#virginica       0          1         8
# Acierto 5 setosa, 6 versicolor y 8 virginica. Fallo con una versicolor que digo que es virginica.

# Traza
sum(diag(matrizconfusion)) # 19

# Accuracy = Traza / sum(matrizconfusion)
accuracy <- sum(diag(matrizconfusion))/sum(matrizconfusion) # 0.95


opt <- which.min(arbolRpart$cptable[,"xerror"]) # devuelve el indice de la tabla que es el menor
cpmin <- arbolRpart$cptable[opt, "CP"] 

arbolPodado<-rpart(Species~., data = dataFit, control = rpart.control(cp = cpmin))

prediccionPodado <- predict(arbolPodado, dataTest, type="class")

matrizconfusionPodado <- table(prediccionPodado, dataTest$Species)

accuracyPodado <- sum(diag(matrizconfusion))/sum(matrizconfusion) # 0.95

print(arbolPodado)
plot(arbolPodado)
text(arbolPodado, use.n=TRUE)






