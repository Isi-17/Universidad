library(nnet)
# Import DataSet, NO HEADER. Importamos el data y el trainingData

vote.data <- read.csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Examen2018Congresistas/vote.data.txt", header = FALSE)
voteTraining.test <- read.csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Examen2018Congresistas/voteTraining.test.txt", header = FALSE)

# size -> numero de capas ocultas
# decay -> parametros para actualizacion de neuronas (incremento)

# V17 porque la columna V17 es la decision: Votacion
#perceptron <- nnet (V17~., data = vote.data, size=2)

#prediccion <- predict(perceptron, voteTraining.test)
sizeMejor=0;
mejoraccuracy=0;
perceptronMejor=NULL;
for (sizeN in 1:20){
  perceptron<- nnet (V17 ~. , data=vote.data,size=sizeN )
  matrizconfusion<-table( predict(perceptron ,voteTraining.test,  type="class" ),  voteTraining.test$V17)
  accuracy<-sum(diag(matrizconfusion))/sum(matrizconfusion)
  if (accuracy> mejoraccuracy){
    sizeMejor=sizeN;
    perceptronMejor=perceptron
    mejoraccuracy=accuracy;
  }
}
sizeMejor
perceptronMejor

V1<-c("n","n")
V2<-c("y","y")
V3<-c("n","n")
V4<-c("n","y")
V5<-c("y","y")
V6<-c("n","y")
V7<-c("y","u")
V8<-c("y","u")
V9<-c("y","n")
V10<-c("n","n")
V11<-c("y","y")
V12<-c("n","y")
V13<-c("u","u")
V14<-c("n","y")
V15<-c("y","n")
V16<-c("y","u")
V17<-c("republican.", "democrat.")


datosApredecir<-data.frame(V1, V2, V3,V4, V5,V6, V7, V8, V9, V10, V12, V13,V14, V15,V16, V17)

matrizconfusion<-table( predict(perceptronMejor ,datosApredecir,  type="class" ),  datosApredecir$V17)

matrizconfusion2<-table( predict(perceptronMejor ,voteTraining.test,  type="class" ),  voteTraining.test$V17)

matrizconfusion
matrizconfusion2
