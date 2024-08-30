library(rpart)
data_titanic <- read.csv("C:/Users/Usuario_UMA/Downloads/train.csv", stringsAsFactors=TRUE)
data_titanic<-na.omit(data_titanic)
data_titanic_find_var<-data_titanic

#eliminar columnas no necesarias
data_titanic_find_var$Name=NULL
data_titanic_find_var$PassengerId=NULL
data_titanic_find_var$Ticket=NULL
data_titanic_find_var$Cabin=NULL
data_titanic_find_var$Embarked=NULL
data_titanic_find_var$Survived=NULL

atributos<-names(data_titanic_find_var)
numerovariables<-round(sqrt(length(atributos)))
set.seed(44664575)
numeroArboles<-10
accuracy<-c()
for (i in  1:numeroArboles){
  data_titanic$Name=NULL
  data_titanic$PassengerId=NULL
  data_titanic$Ticket=NULL
  data_titanic$Cabin=NULL
  data_titanic$Embarked=NULL
  atributosparaentrenar<-sample(1:length(atributos), size = numerovariables, replace = FALSE) # Vector de 20 elementos
  formula<-paste("Survived~ ", atributos[atributosparaentrenar[1]] , "+", atributos[atributosparaentrenar[2]])
  print(i)
  print(formula)
  #eliminar columnas no necesarias
  
  
  data_titanic$Survived<-as.factor(data_titanic$Survived)
  d_size<-dim(data_titanic)[1]
  dtest_size <- ceiling(0.2*d_size)
  samples<-sample(d_size, d_size, replace=FALSE)
  indexes<-samples[1:dtest_size]
  dtrain<-data_titanic[-indexes,]
  dtest<-data_titanic[indexes,]
  
  
  arbolrpart<-rpart(formula, data=dtrain )
  prediccion <-predict(arbolrpart, dtest, type="class")
  matrizconfusion<-table(prediccion,dtest$Survived)
  accuracy[i]<-sum(diag(matrizconfusion)/sum(matrizconfusion))
}
max (accuracy)
min(accuracy)
mean(accuracy)
