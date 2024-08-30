library(randomForest)
ind <- sample(2, nrow(iris), replace= TRUE, prob=c(0.7, 0.3))

trainData <- iris[ind==1,]
testData <- iris[ind==2,]

rf <- randomForest(Species~., data = trainData, ntree=100, proximity=TRUE)

matrizconfusion<- table(predict(rf, newdata = testData), testData$Species)
accuracy <- sum(diag(matrizconfusion)) / sum(matrizconfusion)
accuracy # 0.958333

importance(rf)
varImpPlot(rf)
#                   MeanDecreaseGini
#Sepal.Length         6.073006
#Sepal.Width          1.972201
#Petal.Length        35.339372
#Petal.Width         27.264013



