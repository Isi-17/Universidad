library(e1071)
library(caret)
# instalar caret
# instalar timeDate
# instalar lubridate
set.seed(12345)

#Create simulation data
topxdata = matrix(rnorm(200, mean=0, sd=1), nrow = 20, ncol = 10)
botxdata = matrix(rnorm(200, mean=1, sd=1), nrow = 20, ncol = 10)
xdata = rbind(topxdata, botxdata)
colnames(xdata) = 1:10

ydata = c(rep("Top", 20), rep("Bottom", 20) )
ydata = as.factor(ydata)


# Setup for cross validation
ctrl <- trainControl(method="repeatedcv",   # 10fold cross validation
                     repeats=5,         # do 5 repetitions of cv
                     summaryFunction=twoClassSummary,   # Use AUC to pick the best model
                     classProbs=TRUE)


#Train and Tune the SVM
svm.tune <- train(x=xdata,
                  y= ydata,
                  method = "svmRadial",   # Radial kernel
                  tuneLength = 5,                   # 5 values of the cost function
                  preProc = c("center","scale"),  # Center and scale data
                  metric="ROC",
                  trControl=ctrl)

svm.tune

