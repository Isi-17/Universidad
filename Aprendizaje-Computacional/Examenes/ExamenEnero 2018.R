# 1| Un ensemble consiste en entrenar una serie de clasificadores pobres (por ejemplo,
# arboles de decisión o perceptron multicapa) con un subconjunto escogido
#aleatoriamente del dataset. Se realiza una predicción con cada uno de los
#clasificadores y se obtiene como salida del ensemble la clase más votada 
#(es decir, la clase con mayor número de ocurrencias).
#   a) Realiza un programa en R que implemente el algoritmo descrito usando
#     perceptron multicapa (busca el número más adecuado de neuronas en la capa
#      oculta). Usa el dataset de la recidiva.
#   b) Modifica el programa anterior usando arboles de decisión como el clasificador
#     pobre. Usa el mismo dataset que en el apartado anterior.
#   c) Compara ambos algoritmos. ¿Por cuál de ellos te decidirías?
##Sugerencia:
##  Para poder manjar una lista de clasificadores puedes usar el código siguiente:
library(rpart)
df<-data.frame(x=c(1,2,3,3,3), y=factor(c("a", "a", "b", "a",
                                          "b")),z=c(5,4,4,2,5))
mytree1<-rpart(y ~ x+z , data = df, minbucket = 1, minsplit=1)
mytree2<-rpart(y ~ x+z , data = df, minbucket = 1, minsplit=2)
mytree3<-rpart(y ~ x+z , data = df, minbucket = 1, minsplit=3)
lista1<- list(mytree1, mytree2)
lista2<- list(mytree3)
w <- c(lista1,lista2)
w[[1]]
plot(w[[3]])
##################
library(nnet)
datos_icb <- read.csv('C:/Users/isidr/Desktop/Aprendizaje_Computacional/datos_icb.txt', sep="")

ind <- sample(2, nrow(iris), replace = TRUE, prob = c(0.7, 0.3))
trainData <- datos_icb[ind==1,]
testData <- datos_icb[ind==2,]
ListaPerceptron=c()
nPerceptrones <- 10
for (i in 1:nPerceptrones){
  lr.fit <- nnet(recid~., data = trainData, size=5, maxit =500, decay=1, trace=FALSE)
  ListaPerceptron<- c(ListaPerceptron, list(lr.fit))
}


# Ej 3
# a)  Explica el siguiente programa:
x1=rnorm(1000) 
x2=rnorm(1000)
y=2*x1+.7*x2+rnorm(1000) # 7% de x2 y multiplico por 2 la x1
df=data.frame(y,x1,x2,x3=rnorm(1000),x4=rnorm(1000),x5=rnorm(1000)
)
# run the randomForest implementation
library(randomForest)
# Se crea un randomforest
rf1 <- randomForest(y~., data=df, mtry=2, ntree=50,
                    importance=TRUE)
importance(rf1,type=1)

#     %IncMSE
#x1 52.48946431
#x2 20.21594925
#x3  0.09493892
#x4  1.23762024
#x5 -0.89935097
# Vemos que da mas importancia a la variable x1.

# b) Modifica el programa de forma que la importancia de las variables sea
#equiprobable (es decir, que cambie dependiendo de la ejecución). 

x1=rnorm(1000) 
x2=rnorm(1000)
y=x1+x2+rnorm(1000) # QUITAMOS LOS ESCALARES de manera que ahora no le damos importancia a una variable en concreto
df=data.frame(y,x1,x2,x3=rnorm(1000),x4=rnorm(1000),x5=rnorm(1000)
)
# run the randomForest implementation
library(randomForest)
# Se crea un randomforest
rf1 <- randomForest(y~., data=df, mtry=2, ntree=50,
                    importance=TRUE)
importance(rf1,type=1)
