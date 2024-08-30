library(adabag);
datos <- read.csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Bagging Titanic/train.csv", header=T, quote="\"")
adadata<- datos
adadata$Survived  <- factor(adadata$Survived)
adadata$Embarked <- factor(adadata$Embarked)

d_size <- dim(adadata)[1]
dtest_size <- ceiling(0.2*d_size)

set.seed(200)
samples <- sample(d_size, d_size, replace=FALSE)
indexes <- samples[1:dtest_size]
dtrain <- adadata[-indexes,]
dtest <- adadata[indexes,]

adaboost <- boosting(Survived~PassengerId+Pclass+Sex+Age+SibSp+Ticket+Fare+Cabin+Embarked, data=dtrain, boos=TRUE, mfinal=10,coeflearn='Breiman')
summary(adaboost)
adaboost$trees
adaboost$weights ##calcula los pesos
adaboost$importance ## calcula la importancia de las variables
errorevol(adaboost,adadata)
predict(adaboost,adadata)
tree1 <- adaboost$trees[[1]]

library(rattle)
library(rpart.plot)
library(RColorBrewer)
fancyRpartPlot(tree1)

prediction <- predict (object = tree1, newdata = dtest, type="class")
prediction

MC <-table(dtest[, "Survived"],prediction);MC
TruePos <-MC[1,2]/(MC[1,1]+MC[1,2]);TruePos
Scores <- sum(diag(MC))
Accuracy <- Scores/(sum(MC));Accuracy
