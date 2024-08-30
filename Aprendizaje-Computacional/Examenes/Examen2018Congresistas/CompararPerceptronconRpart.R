library(rpart)
library(nnet)
vote.data <- read.csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Examen2018Congresistas/vote.data.txt", header = FALSE)
voteTraining.test <- read.csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Examen2018Congresistas/voteTraining.test.txt", header = FALSE)
arbolvote<-rpart (V17~., vote.data)
opt <- which.min(arbolvote$cptable[,"xerror"])
cp1 <- arbolvote$cptable[opt, "CP"]
arbolpodadovote<-prune (arbolvote, cp=cp1)
matrizconfusion<-table( predict(arbolvote ,voteTraining.test,  type="class" ),  voteTraining.test$V17)
accuracyArbolVote<-sum(diag(matrizconfusion))/sum(matrizconfusion)
perceptron<- nnet (V17 ~. , data=vote.data,size=500 )
matrizconfusion<-table( predict(perceptron ,voteTraining.test,  type="class" ),  voteTraining.test$V17)
accuracyPerceptron<-sum(diag(matrizconfusion))/sum(matrizconfusion)
accuracyArbolVote
accuracyPerceptron
