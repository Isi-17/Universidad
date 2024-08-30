library(randomForest) # Random Forest
library(caret)
library(e1071) # SVM
library(adabag) # bagging
library(rpart.plot)
library(kernlab)
library(rattle)
library(RColorBrewer)

# Componentes del grupo:
# Isidro Javier García Fernández
# Álvaro Sánchez Hernández
# José Antonio Luque Salguero
# Jesús Escudero Moreno

# En esta práctica de reconocimiento de dígitos, se han utilizado varios modelos de machine learning para abordar el problema. 
# Se han aplicado diferentes enfoques, como árboles de decisión, bosques aleatorios, SVM, bagging y boosting.
# Para cada modelo, se evalúa su desempeño utilizando matrices de confusión y se calcula la precisión.

# Saber ubicacion: getwd()
# Cargar los resultados desde el archivo
# load("resultados.RData")


# Importar los datos
digit <- read.csv("C:/Users/Usuario_UMA/Desktop/Machine/train.csv")
test <- read.csv("C:/Users/Usuario_UMA/Desktop/Machine/test.csv")

# Muestra la proporción de etiquetas en el conjunto de datos original
prop.table(table(digit$label)) * 100

# Convierte la etiqueta en un factor
digit$label <- factor(digit$label)

## Validación Cruzada

# Tamaño del conjunto de datos: train: 42000, test: 28000
d_size <- nrow(digit) # 42000
dtest_size <- ceiling(0.2 * d_size) # Tamaño del conjunto de prueba (20%)
samples <- sample(1:d_size, d_size, replace = FALSE) # Muestra aleatoria de índices
indexes <- samples[1:dtest_size] # Índices para el conjunto de prueba

dtrain <- digit[-indexes,] # Conjunto de entrenamiento
dtest <- digit[indexes,] # Conjunto de prueba


set.seed(1234)

###################### ARBOL RPART #############################
tree = rpart(label~., data = dtrain, method = "class")

matrizconfusiontree <- table(predict(tree, newdata = dtest, type = "class"), dtest$label)
accuracytree <- sum(diag(matrizconfusiontree)) / sum(matrizconfusiontree)
accuracytree # 0.6416

fancyRpartPlot(tree)

barplot(tree$variable.importance) ## importancia pixel 433


####################### RANDOM FOREST ###########################
# Si utilizamos 10 árboles
rf1 <- randomForest(label ~ ., data = dtrain, ntree = 10, nodesize = 50)

matrizconfusion1<- table(predict(rf1, newdata = dtest), dtest$label)
accuracyRF1 <- sum(diag(matrizconfusion1)) / sum(matrizconfusion1)
accuracyRF1 # 0.9165

# Si utilizamos 5 árboles
rf2 <- randomForest(label ~ ., data = dtrain, ntree = 5, nodesize = 50)

matrizconfusion2<- table(predict(rf2, newdata = dtest), dtest$label)
accuracyRF2 <- sum(diag(matrizconfusion2)) / sum(matrizconfusion2)
accuracyRF2 # 0.87821

# Si utilizamos 2 árboles
rf3 <- randomForest(label ~ ., data = dtrain, ntree = 2, nodesize = 50)

matrizconfusion3<- table(predict(rf3, newdata = dtest), dtest$label)
accuracyRF3 <- sum(diag(matrizconfusion3)) / sum(matrizconfusion3)
accuracyRF3 # 0.77976


######################### SVM ###################################
# KSVM: Kernel = polydot
filter <- ksvm(label ~ ., data = dtrain, kernel = "polydot", kpar = list(degree = 3), cross = 3)


matrizconfusionKSVMpol<- table(predict(filter, dtest), dtest$label)
accuracyksvmpol <- sum(diag(matrizconfusionKSVMpol)) / sum(matrizconfusionKSVMpol)
accuracyksvmpol # 0.97333

########################### BAGGING ###########################
Modelo_AdaBag  <- bagging(label~., 
                          data=dtrain, 
                          na.action = na.omit,
                          mfinal=9,
                          control=rpart.control(cp = 0.001, minsplit=7))

matrizconfusionBag <- table(dtest[, "label"],predict(Modelo_AdaBag, newdata = dtest, type = "class")$class)
accuracyBag <- sum(diag(matrizconfusionBag)) / sum(matrizconfusionBag)
accuracyBag # 0.85714

########################## BOOSTING ###########################
adaboost <- boosting(label ~ ., data = dtrain, boos=TRUE, mfinal = 10, coeflearn = 'Breiman')


summary(adaboost) # resumen
adaboost$trees # arboles del modelo
adaboost$weights # pesos
adaboost$importance # importancia de las variables
errorevol(adaboost, newdata = digit) # error de validacion cruzada

# Matriz de confusión y cálculo de la precisión
matrizconfusionAdaBoost <- table(predict(adaboost, newdata = dtest, type="class")$class, Actual = dtest$label)
accuracyAdaBoost <- sum(diag(matrizconfusionAdaBoost)) / sum(matrizconfusionAdaBoost)
accuracyAdaBoost # 0.7894

# Tomamos el primer arbol de adaboost
tree1 <- adaboost$trees[[1]]

fancyRpartPlot(tree1)
barplot(tree1$variable.importance) ## importancia pixel 461

matrizconfusiontree1 <- table(dtest[, "label"],predict (tree1, newdata = dtest, type="class"))
accuracytree1 <- sum(diag(matrizconfusiontree1)) / sum(matrizconfusiontree1)
accuracytree1 # 0.5989


# Test
rotate_image <- function(image_matrix) {
  rotated_matrix <- t(apply(image_matrix, 2, rev))
  return(rotated_matrix)
}

# Elegir un elemento aleatorio del conjunto de prueba
indice_aleatorio <- sample(1:nrow(dtest), 1)
elemento_prueba <- dtest[indice_aleatorio, ]

# Extraer la etiqueta real del elemento
etiqueta_real <- elemento_prueba$label
etiqueta_real

# Extraer las características del elemento (sin la etiqueta)
elemento_prueba_sin_label <- elemento_prueba[, -1]

# Realizar la predicción con el modelo KSVM
prediccion <- predict(filter, elemento_prueba_sin_label)

# Imagen del dígito
img <- matrix(as.vector(elemento_prueba_sin_label), nrow = 28, ncol = 28, byrow = TRUE) 
img <- apply(img, 1:2, as.numeric) # convertir a numerico todos los valores
img

image(rotate_image(img), main = paste("Etiqueta Real:", etiqueta_real, "Predicción:", prediccion))

# Mostrar la etiqueta real y la predicción
cat("Etiqueta Real:", as.character(etiqueta_real), "\n")
cat("Predicción:", as.character(prediccion), "\n")


# Guarda las variables específicas del código
# save(digit, test, dtrain, dtest,
#     tree, matrizconfusiontree, accuracytree,
#     rf1, matrizconfusion1, accuracyRF1,
#     rf2, matrizconfusion2, accuracyRF2,
#     rf3, matrizconfusion3, accuracyRF3,
#     filter, matrizconfusionKSVMpol, accuracyksvmpol,
#     Modelo_AdaBag, matrizconfusionBag, accuracyBag,
#     adaboost, matrizconfusionAdaBoost, accuracyAdaBoost,
#     tree1, matrizconfusiontree1, accuracytree1,
#     file = "resultados.RData")


