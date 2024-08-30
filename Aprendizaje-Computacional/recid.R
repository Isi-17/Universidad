library(rpart)
library(mboost)

set.seed(123)

find <- sample(150, 150)

itest <- find[1:20]

datos_icb <- read.csv('C:/Users/isidr/Desktop/Aprendizaje_Computacional/datos_icb.txt', sep="")

dataTest <- datos_icb[itest,] 
dataFit <- datos_icb[-itest, ]

# Atributo de decisión: recid
recidArbol<-rpart(recid~., data = dataFit, control = rpart.control(minsplit = 1))

print(recidArbol)
plot(recidArbol)
text(recidArbol, use.n=TRUE)

prediccion <- predict(recidArbol, dataTest, type = "class") 
# minsplit: como minimo '1' solo valor para poder dividir el arbol en ramas.

matrizconfusion <- table(prediccion, dataTest$recid) # Matriz de confusion
#prediccion NO SI
# NO        16 4
# SI        0  0

sum(diag(matrizconfusion)) # 16

# Accuracy = Traza / sum(matrizconfusion)
accuracy <- sum(diag(matrizconfusion))/sum(matrizconfusion) # 0.8


opt <- which.min(recidArbol$cptable[,"xerror"]) # devuelve el indice de la tabla que es el menor
cpmin <- recidArbol$cptable[opt, "CP"] 

arbolPodado<-rpart(recid~., data = dataFit, control = rpart.control(cp = cpmin))
# Acaba de decir el profesor que para el arbol podado se use prune, no rpart
# arbolPodado <- prune(recidArbol, cp=cpmin)

prediccionPodado <- predict(arbolPodado, dataTest, type="class")

matrizconfusionPodado <- table(prediccionPodado, dataTest$Species)

accuracyPodado <- sum(diag(matrizconfusion))/sum(matrizconfusion) # 0.95

print(arbolPodado)
plot(arbolPodado)
text(arbolPodado, use.n=TRUE)






