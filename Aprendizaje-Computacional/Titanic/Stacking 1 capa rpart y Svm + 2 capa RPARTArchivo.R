library(e1071)
library (rpart)

data_titanic <- read.csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Titanic/train.csv", header = T) # StringAsFactor = T
data_titanic<-data_titanic[1:10,]
#eliminar datos faltantes
data_titanic<-na.omit(data_titanic)

#eliminar columnas no necesarias
data_titanic$Name=NULL
data_titanic$PassengerId=NULL
data_titanic$Ticket=NULL
data_titanic$Cabin=NULL
data_titanic$Embarked=NULL


#validacion cruzada
set.seed(200)
d_size<-dim(data_titanic)[1]
dtest_size <- ceiling(0.2*d_size)
samples<-sample(d_size, d_size, replace=FALSE)
indexes<-samples[1:dtest_size]
dtrain<-data_titanic[-indexes,]
dtest<-data_titanic[indexes,]

#entreno RPART
rpartTitanic<-rpart(Survived ~. , data=dtrain, control = rpart.control(minbucket  = 5))
prediccionRpart<-predict(rpartTitanic ,dtest, type="vector" )
#entreno SVM
svmTitanic <- svm(Survived ~. , data=dtrain)
prediccionSVM<-predict(svmTitanic,dtest, type="class")

#entreno RPART (2 capa)
dtest$Survived<-NULL

entrada2Capa<-rbind(dtest,dtest)
# Ahora voy a concatenar las predicciones de rpart y de svm.
entrada2Capa<-data.frame(entrada2Capa,Survived=c(prediccionRpart ,prediccionSVM) )

# Este es el rpart que quiero
rpartTitanic2Capa<-rpart(Survived ~. , data=entrada2Capa, control = rpart.control(minbucket  = 5))
prediccionRpart<-predict(rpartTitanic2Capa ,entrada2Capa, type="vector" )

# Predecimos un viajero con nuestro arbol rpart de la segunda capa.
d_t <- read.csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Titanic/train.csv", header = T) # StringAsFactor = T
predecirviajero25 <- d_t[25,]

prediccionRpart<- predict(rpartTitanic2Capa, predecirviajero25, type = "vector")
prediccionRpart

#matrizconfusion<- table(predict(rpartTitanic2Capa, entrada2Capa), entrada2Capa$Survived)
#accuracy<-sum(diag(matrizconfusion))/sum(matrizconfusion)
#accuracy

