# La URL maliciosa, también conocido como sitio web malicioso, es una amenaza común y grave para la ciberseguridad. 
# La URL maliciosa atraaen a los usuarios confiados a ser víctimas de estafas (monetarias pérdida, robo de información privada e instalación de malware),
# y causan pérdidas de miles de millones de euros cada año. Por tanto, es necesario detectar y actuar sobre tales amenazas de manera oportuna.
# Tradicionalmente, esta detección se realiza principalmente mediante el uso de listas negras. Sin embargo, las listas negras no pueden ser exhaustivas, y carecen de la
# capacidad para detectar nuevas URL maliciosas generadas. Otra técnica que se esta usando es machine lerarning para clasificar las url entre maliciosas o no. 

set.seed(100) 

# Configurar path del fichero: 
Datos <- read.csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Ejercicio Sitio Web Malicioso/detect-malicious-URL.csv", header = T, stringsAsFactors = TRUE)

# Validacion Cruzada
d_size<-dim(Datos)[1]
dtest_size <- ceiling(0.2*d_size) # me quedo con un 20% para test
samples<-sample(d_size, d_size, replace=FALSE)
indexes<-samples[1:dtest_size]
train<-Datos[-indexes,]
test<-Datos[indexes,]

########## PERCEPTRON MULTICAPA ####################
library(nnet)

# Entrenamiento
training <- nnet(label~., data=train, size=5, maxit=1000, decay=1, trace=FALSE) 

# Prediccion
prediccion <- predict(training,test,type="raw")

# Matriz de confusión
matrizconfusionPM <- table(prediccion, test$label, dnn=c("Prediction", "Actual"))
# Acuracy
accuracyPM <- sum(diag(matrizconfusionPM))/sum(matrizconfusionPM)

######### RANDOMFOREST ##################
library(randomForest)

# Creamos el randomforest con 10 arboles
rf <- randomForest(label~., data = train, ntree=10, proximity=TRUE)

# Prediccion y accuracy
matrizconfusionRF<- table(predict(rf, newdata = test), test$label)
accuracyRF <- sum(diag(matrizconfusionRF)) / sum(matrizconfusionRF)

########## SVM #########################
library(e1071)
svm <- svm(label~ ., data = train)

# Prediccion y accuracy
matrizconfusionSVM<-table(predict(svm,test), test$label, dnn=c("Prediction", "Actual"))
accuracySVM<- sum(diag(matrizconfusionSVM))/sum(matrizconfusionSVM)


# Ahora la comparación entre ambos
accuracyPM # 0.1
accuracyRF # 0.8
accuracySVM # 0.9

# Si decidimos ampliar la cantidad de arboles del randomforest podremos tener un accuracy de 1.


