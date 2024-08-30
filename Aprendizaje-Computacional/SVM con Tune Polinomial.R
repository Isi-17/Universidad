library(e1071)
set.seed(100)
ind <- sample(150,150)
idt <- ind[1:10]
dtrain <- iris[-idt,]
dtest <- iris[idt,]

m1 <- svm(Species ~ ., data = dtrain)
matrizconfusionSVM<-table(predict(m1,dtest), dtest$Species, dnn=c("Prediction", "Actual"))
accuracySVM<- sum(diag(matrizconfusionSVM))/sum(matrizconfusionSVM)

# Tune
svm_cv <- tune("svm", Species ~., data = dtrain, kernel = 'radial',
               ranges = list(cost = c(0.001, 0.01, 0.1, 1, 5, 10, 20),
                             gamma = c(0.5, 1, 2, 3, 4, 5, 10)))
# cost: no es necesario.
svm_cvpolinomial <- tune("svm", Species ~., data = dtrain, kernel = 'polynomial',
                         ranges = list(cost = c(1, 5, 10, 20),
                                       degree = c( 1, 2, 3, 4)), gamma=1, coef0=1)
# Polinomial tiene 3 argumentos: grado, coeficientes y gamma (lo que multiplica)
# Devolvera una máquina con uno de los 4 costes y uno de los 4 grados.

# Representación del modelo para saber cuál es la mejor.
svm_cv$best.parameters
svm_cvpolinomial$best.parameters

mejorSVM<-svm_cv$best.model # guardo el mejor SVM y con ese hago la predicción
matrizconfusionSVMBetter<-table(predict(mejorSVM,dtest), dtest$Species, dnn=c("Prediction", "Actual"))
accuracySVMBetter<- sum(diag(matrizconfusionSVMBetter))/sum(matrizconfusionSVMBetter)

# Imprimir Resultados
matrizconfusionSVM
matrizconfusionSVMBetter
accuracySVMBetter
accuracySVM

