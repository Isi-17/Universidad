# Grupo:
# Isidro Javier Garcia Fernandez
# Alvaro Sanchez Hernandez

# Doble Grado Matematicas e Ingenieria Informatica

# Enunciado: 
# En esta práctica vamos a encontrar el mejor clasificador para los datos del Titanic publicados en Kaggle 
# (https://www.kaggle.com/c/titanic), que también podemos encontrarlos en el Campus Virtual. 

library(e1071)
library(nnet)
library(rpart)
library(RColorBrewer)
library(rpart.plot)
library(rattle)

# Configurar path.
data_titanic <- read.csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Practica_Titanic/train.csv", header = T, stringsAsFactors = T)

# data_titanic -> 891 obs
#eliminar datos faltantes
data_titanic<-na.omit(data_titanic)

#eliminar columnas no necesarias
data_titanic$Name=NULL
data_titanic$PassengerId=NULL
data_titanic$Ticket=NULL
data_titanic$Cabin=NULL
data_titanic$Embarked=NULL


data_titanic<-data_titanic[1:300,]


#cuenta el numero de na por columna
#sampply(data_titanic, funcion(x) sum(is.na(x)))


#validacion cruzada
set.seed(200)
d_size<-dim(data_titanic)[1]
dtest_size <- ceiling(0.2*d_size) # me quedo con un 20% para test
samples<-sample(d_size, d_size, replace=FALSE)
indexes<-samples[1:dtest_size]
dtrain<-data_titanic[-indexes,]
dtest<-data_titanic[indexes,]


############### Perceptron ###############################

perceptronTitanic <- nnet(Survived~., data = dtrain, size = 2) # podmos modificar size
matrizconfusion<-table( predict(perceptronTitanic ,dtest ),  dtest$Survived)
accuracy<-sum(diag(matrizconfusion))/sum(matrizconfusion)
accuracy # 0.53


################ Rpart ###################################

rpartTitanic <- rpart(Survived~., data=dtrain, control = rpart.control(minbucket = 5))
# minsplit mnimo numero de observaciones para que un nodo pueda dividirse.
# minbucket: nº min. observacioens que indicas que tiene que tener un nodo hoja. Normalmente es 1/3 * minsplit
# Como tenemos 714 observaciones y 143 test podemos poner minbucket = 30 por ejemplo.
matrizconfusion<- table(predict(rpartTitanic, dtest), dtest$Survived)
accuracy<-sum(diag(matrizconfusion))/sum(matrizconfusion)
accuracy # 0.2


fancyRpartPlot(rpartTitanic)

barplot(rpartTitanic$variable.importance) ## Importancia el sexo.


rpartTitanic$cptable
opt <- which.min(rpartTitanic$cptable[,"xerror"]) # devuelve el indice de la tabla que es el menor
cpmin <- rpartTitanic$cptable[opt, "CP"] 

#ArbolTitanic podado con cpminimo
rpartTitanicconCPPodado<-rpart(Survived~., data = dtrain, control = rpart.control(cp = cpmin))
matrizconfusion<- table(predict(rpartTitanicconCPPodado, dtest), dtest$Survived)
accuracy<-sum(diag(matrizconfusion))/sum(matrizconfusion)
accuracy # 0.7

# ArbolTitanic con tune. Arbol optimo.
rpartTitanic$cptable # tengo 7
rpart.tune <- tune.rpart(Survived~., data = dtrain, cp=c(rpartTitanic$cptable[1], rpartTitanic$cptable[2], rpartTitanic$cptable[3], rpartTitanic$cptable[4], rpartTitanic$cptable[5], rpartTitanic$cptable[6], rpartTitanic$cptable[7])) # mejor modelo
matrizconfusion.tune<- table(predict(rpart.tune$best.model, dtest, type = "vector"), dtest$Survived, dnn = c("Prediction", "Actual")) # class -> vector
accuracytune<-sum(diag(matrizconfusion.tune))/sum(matrizconfusion.tune)
accuracytune # 0.7

fancyRpartPlot(rpart.tune$best.model)

barplot(rpart.tune$best.model$variable.importance) ## Importancia el sexo.


# Hacer poda.Con cpminimo
opt <- which.min(rpartTitanic$cptable[,"xerror"]) # devuelve el indice de la tabla que es el menor
cpmin <- rpartTitanic$cptable[opt, "CP"] 
rpart.poda <- prune(rpartTitanic, cp = cpmin)
matrizconfusion.tunepoda<- table(predict(rpart.poda, newdata = dtest, type = "vector"), dtest$Survived) # class -> vector
accuracytunepod<-sum(diag(matrizconfusion.tunepoda))/sum(matrizconfusion.tunepoda)
accuracytunepod # 0.1.


###################### SVM RADIAL #############################
svp <- svm(Survived~.,data=dtrain,C = 100, kernel='radial',scaled=c(),cost=1000, cross=2,scale=FALSE, Probabilistic=FALSE)

matrizconfusionSVM<-table(predict(svp,dtest), dtest$Survived , dnn=c("Prediction", "Actual"))
accuracySVMrad<- sum(diag(matrizconfusionSVM))/sum(matrizconfusionSVM)
accuracySVMrad # 0.01


svp <- svm(Survived~.,data=dtrain,C = 100, kernel='linear',scaled=c(),cost=1000, cross=2,scale=FALSE, Probabilistic=FALSE)

matrizconfusionSVM<-table(predict(svp,dtest), dtest$Survived , dnn=c("Prediction", "Actual"))
accuracySVM<- sum(diag(matrizconfusionSVM))/sum(matrizconfusionSVM)
accuracySVM # 0.01

#USAMOS TUNE
svm_cvpolinomial <- tune("svm", Survived ~., data = dtrain, kernel = 'polynomial',
                         ranges = list(cost = c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100),
                                       degree = c( 1, 2, 3, 4)), gamma=1, coef0=1)

#MOSTRAMOS LOS RESULTADOS 
svm_cvpolinomial$best.parameters
mejorSVM<-svm_cvpolinomial$best.model
matrizconfusionSVMBetter<-table(predict(mejorSVM,dtest), dtest$Survived, dnn=c("Prediction", "Actual"))
accuracySVMBetter<- sum(diag(matrizconfusionSVMBetter))/sum(matrizconfusionSVMBetter)
matrizconfusionSVM
matrizconfusionSVMBetter
accuracySVMBetter # 0.016
accuracySVM # 0.016

