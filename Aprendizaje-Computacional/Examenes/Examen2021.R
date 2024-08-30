library(rpart)
set.seed(100)
############# EJERCICIO 1 ######################
# c) A partir de los datos del dataset anterior entrena un árbol de decisión RPART para que prediga
# el atributo Salida. Compara usando validación cruzada (80% para entrenamiento; 20% test) la 
# predicción del árbol obtenido con la de un árbol podado con un CP tal que sea un árbol raíz (1 punto)
x <- c(0,0,0,0,1,1,1) 
y <- c(0,0,1,1,0,0,1) 
z <- c(0,1,0,1,0,1,1) 
Salida <- c(0,1,1,0,1,0,0) 

data<- data.frame(x,y,z, Salida) 
names(data)<- c("x", "y", "z", "Salida") 

# Creo el conjunto de datos. Validacion cruzada.
data_size <- 5 # Escojo 5 dato,s ya que es el 80% de 7 mas o menos 
test_size <- 2 
samples <- sample(data_size, data_size, replace=FALSE) 
indexes <- samples[1:test_size] 
train <- data[-indexes,] 
test <- data[indexes,] 

# Rpart 
#Entrenamiento 
arbol <- rpart(formula=Salida~., data=train, method="class") 
print(arbol) 
#Predicción 
prediccion <- predict(arbol, newdata = test, type = "class") 
print(prediccion) 


# Poda 
opt <- which.min(arbol$cptable[,"xerror"]) 
cp1 <- arbol$cptable[opt, "CP"] 
arbolpodado<-prune (arbol, cp=cp1) 
print(arbolpodado) 


############### EJERCICIO 2 #####################
# A partir del conjunto de datos que podemos encontrar en el campus virtual (denominado ejercicio2SVM.csv):
# Determina si es separable linealmente e indica cual seria la función Kernel mas adecuada 
# (indica tipo de función y sus parámetros ) (0,5 puntos). 
# Calcula los siguientes parámetros de la Maquina de Soporte Vectorial que podemos obtener con el dataset anteriores y el Kernel elegido:
# I. Vectores Soporte. (0.25 puntos) 
# II. Ancho del canal (0.5 puntos) 
# III. Vector de Pesos normal al Hiperplano (W) (0.25 puntos) 
# IV. Vector B (0.25 puntos) 
# V. La ecuación del Hiperplano y de los planos de soporte positivo y negativo. (0.75 puntos) 
# VI. Pinta el conjuntos de puntos y el Hiperplano. (0.75 puntos)
# VII. Clasifica los puntos (0.5, 0,8) y (0.6,0,2). (0.25 puntos)

library(e1071) 
Datos <- read.csv("C:/Users/juane/Documents/ejercicio2SVM.csv", stringsAsFactors = TRUE) 
set.seed(100) 
Datos$y <- as.factor(Datos$y) 
# He usado otra librería que conozco para ver mejor si son separables linealmente 
library(ggplot2) 
ggplot(data = Datos, aes(x = X2, y = X1, color = as.factor(y))) + geom_point(size = 3) 
# RESPUESTA: 
# Vemos claramente que no son separables linealmente 
# Por lo tanto el kernel será Polinomial o radial. 

# He probado ambos, y más o menos son iguales, aunque creo que el mejor es el polinomial 
svm <- svm(y~., Datos, kernel="polynomial") 
# I. Vectores de soporte 
vs <- Datos[svm$index,1:2] 
# II. Calcular ancho del canal 
width = 2/(sqrt(sum((w)^2))) 
width 
# III. Vector de pesos normal al hiperplano (W) 
w <- crossprod(as.matrix(vs), svm$coefs) 
w 
# IV. Calcular vector B
b <- -svm$rho 
b 
# V. Calcular la ecuación del hiperplano y de los planos de soporte positivo 
# y negativo 
paste(c("[",w,"]' * x + [",b,"] = 0"), collapse=" ") 
paste(c("[",w,"]' * x + [",b,"] = 1"), collapse=" ") 
paste(c("[",w,"]' * x + [",b,"] = -1"), collapse=" ") 
# VI. Dibujar los puntos y el hiperplano 
plot(svm, Datos) 
# VII. Clasificamos los puntos 
x = c(0.5, 0.8) 
if ((t(w) %*% x + b) >= 0){ 
  print("1") 
}else if((t(w) %*% x + b) < 0){ 
  print("-1") 
} 
x = c(0.6, 0.2) 
if ((t(w) %*% x + b) >= 0){ 
  print("1") 
}else if((t(w) %*% x + b) < 0){ 
  print("-1") 
}

################ EJERCICIO 3 ####################
# La URL maliciosa, también conocido como sitio web malicioso, es una amenaza común y grave para la ciberseguridad. 
# La URL maliciosa atraaen a los usuarios confiados a ser víctimas de estafas (monetarias pérdida, robo de información privada e instalación de malware),
# y causan pérdidas de miles de millones de euros cada año. Por tanto, es necesario detectar y actuar sobre tales amenazas de manera oportuna.
# Tradicionalmente, esta detección se realiza principalmente mediante el uso de listas negras. Sin embargo, las listas negras no pueden ser exhaustivas, y carecen de la
# capacidad para detectar nuevas URL maliciosas generadas. Otra técnica que se esta usando es machine lerarning para clasificar las url entre maliciosas o no. 
# a) Elige el clasificador que mejor predicción produzca (usa el accuracy y validación cruzada para
# entrenamiento y predicción) entre SVM y Perceptron Multicapa. El dataset detect-maliciusus-URL.csv se
# encuentra en el campus virtual. (3 puntos).

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

######### RANDOMFOREST ################## (no haria falta randomforest)
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


