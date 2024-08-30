library(rpart)
library(readr)
vote.data <- read.csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Examen2018Congresistas/vote.data.txt", header = FALSE)

names (vote.data)<-c("handicappedinfants",
                     "waterprojectcostsharing",
                     "adoptionofthebudgetresolution",
                     "physicianfeefreeze",
                     "elsalvadoraid",
                     "religiousgroupsinschools",
                     "antisatellitetestban",
                     "aidtonicaraguancontra",
                     "mxmissile",
                     "immigration",
                     "synfuelscorporationcutback",
                     "educationspending",
                     "superfundrighttosue",
                     "crime",
                     "dutyfreeexports",
                     "exportadministrationactsouthafrica", "votation")

vote.test <- read.csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Examen2018Congresistas/vote.data.txt", header=FALSE)

names (vote.test)<-c("handicappedinfants",
                     "waterprojectcostsharing",
                     "adoptionofthebudgetresolution",
                     "physicianfeefreeze",
                     "elsalvadoraid",
                     "religiousgroupsinschools",
                     "antisatellitetestban",
                     "aidtonicaraguancontra",
                     "mxmissile",
                     "immigration",
                     "synfuelscorporationcutback",
                     "educationspending",
                     "superfundrighttosue",
                     "crime",
                     "dutyfreeexports",
                     "exportadministrationactsouthafrica", "votation")
vote.data1<-vote.data
vote.test1<-vote.test

vote.data1$physicianfeefreeze<-NULL
vote.test1$physicianfeefreeze<-NULL

modelorpart<- rpart (votation ~ ., data=vote.data1)
modelorpart
plot(modelorpart)
text(modelorpart, use.n = TRUE)
printcp(modelorpart)

opt <- which.min(modelorpart$cptable[,"xerror"])
cp1 <- modelorpart$cptable[opt,"CP"]

modelorpart.podado <- prune(modelorpart, cp=cp1)
plot(modelorpart.podado)
text(modelorpart.podado, use.n = TRUE)

modelorpart.podado

predicion.vote.original <- predict(modelorpart, newdata = vote.test1, type="class")
predicion.vote.podado <- predict(modelorpart.podado, newdata = vote.test1, type="class")

#Calculamos la matriz de confusi�n
matrizConfusion.original <- table(predicion.vote.original, vote.test1$votation)
matrizConfusion.podado <- table(predicion.vote.podado, vote.test1$votation)



accuracy.original <- sum(diag(matrizConfusion.original))/sum(matrizConfusion.original)
accuracy.podado <- sum(diag(matrizConfusion.podado))/sum(matrizConfusion.podado)
accuracy.original
accuracy.podado





modelorpart<- rpart (votation ~ ., data=vote.data)
modelorpart
plot(modelorpart)
text(modelorpart, use.n = TRUE)
printcp(modelorpart)

opt <- which.min(modelorpart$cptable[,"xerror"])
cp1 <- modelorpart$cptable[opt,"CP"]

modelorpart.podado <- prune(modelorpart, cp=cp1)
plot(modelorpart.podado)
text(modelorpart.podado, use.n = TRUE)

modelorpart.podado

predicion.vote.original <- predict(modelorpart, newdata = vote.test, type="class")
predicion.vote.podado <- predict(modelorpart.podado, newdata = vote.test, type="class")

#Calculamos la matriz de confusi�n
matrizConfusion.original <- table(predicion.vote.original, vote.test$votation)
matrizConfusion.podado <- table(predicion.vote.podado, vote.test$votation)



accuracy.original <- sum(diag(matrizConfusion.original))/sum(matrizConfusion.original)
accuracy.podado <- sum(diag(matrizConfusion.podado))/sum(matrizConfusion.podado)
accuracy.original
accuracy.podado

