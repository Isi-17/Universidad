library(randomForest)
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

rf <- randomForest(Survived~., data = dtrain, ntree=100, proximity=TRUE)

matrizconfusion<- table(predict(rf, newdata = dtest), dtest$Survived)
accuracy <- sum(diag(matrizconfusion)) / sum(matrizconfusion)
accuracy # 1

importance(rf)
varImpPlot(rf)
#          IncNodePurity
#Pclass    0.05776190
#Sex       0.53928571   --> si eres hombre o mujer permite decidir mejor
#Age       0.22773810
#SibSp     0.09033333
#Parch     0.05659524
#Fare      0.16216667



