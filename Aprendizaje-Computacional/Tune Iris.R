library("e1071")
head(iris,5)
attach(iris)

x <- subset(iris, select=-Species) #excluding Species
y <- Species

#Create SVM Model and show summary
svm_model <- svm(Species ~ ., data=iris)
summary(svm_model)

pred <- predict(svm_model,x)
system.time(pred <- predict(svm_model,x)
            
            svm_model_after_tune <- svm(Species ~ ., data=iris, kernel="radial", cost=10, gamma=0.5)
            summary(svm_model_after_tune)
            
            system.time(pred_after <- predict(svm_model_after_tune,x))
            table(pred_after,y)
            
            
            svm_tune <- tune(svm, train.x=x, train.y=y, 
                             kernel="radial", ranges=list(cost=10^(-1:2), gamma=c(.5,1,2)))
            print(svm_tune)
            
            #After you find the best cost and gamma, you can create svm model again and try to run again
            svm_model_after_tune <- svm(Species ~ ., data=iris, kernel="radial", cost=10, gamma=0.5)
            summary(svm_model_after_tune)
            
            