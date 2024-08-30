# Autor: Isidro Javier Garcia Fernandez

# Apartado 1
# # Descripción del dataframe:
# Estamos modelando un tablero de juego 3x3, donde cada celda es representada por un atributo numerado del 1 al 9.
# Cada celda puede tomar uno de los siguientes valores:
#   "X": Si la casilla está marcada por el jugador.
#   "O": Si la casilla está marcada por el oponente.
#   "-": Si la casilla está vacía.

# El atributo de clasificación indica en qué celda el oponente debe colocar su ficha en la situación actual del juego.

# Ejemplo de la situación actual (es el turno de "X"):
# Celda1 | Celda2 | Celda3 | Celda4 | Celda5 | Celda6 | Celda7 | Celda8 | Celda9 | Clasificacion
#   "O"   "Empty"    "X"     "Empty"    "O"   "Empty"   "X"     "Empty"      "X"         6
# En este caso, el oponente "O" debe colocar su ficha en la celda 6 para ganar.

# Parte 2 - Creación de DataFrames para entrenamiento y prueba

# Datos de entrenamiento
Partida1 <- c("X", "Empty", "O", "X", "O")
Partida2 <- c("O", "O", "Empty", "Empty", "X")
Partida3 <- c("X", "Empty", "Empty", "O", "O")
Partida4 <- c("O", "X", "X", "Empty", "X")
Partida5 <- c("X", "X", "Empty", "X", "X")
Partida6 <- c("O", "O", "X", "O", "O")
Partida7 <- c("X", "X", "O", "Empty", "O")
Partida8 <- c("Empty", "Empty", "Empty", "X", "Empty")
Partida9 <- c("Empty", "Empty", "Empty", "Empty", "X")
Clasificacion <- c("8", "3", "3", "9", "8")
Partida1_entrenamiento <- as.numeric(factor(c("X", "O", "X", "O", "X")))
Partida2_entrenamiento <- as.numeric(factor(c("Empty", "O", "Empty", "X", "X")))
Partida3_entrenamiento <- as.numeric(factor(c("O", "Empty", "Empty", "X", "Empty")))
Partida4_entrenamiento <- as.numeric(factor(c("X", "Empty", "O", "Empty", "X")))
Partida5_entrenamiento <- as.numeric(factor(c("O", "X", "O", "X", "X")))
Partida6_entrenamiento <- as.numeric(factor(c("Empty", "X", "O", "Empty", "O")))
Partida7_entrenamiento <- as.numeric(factor(c("X", "X", "X", "Empty", "O")))
Partida8_entrenamiento <- as.numeric(factor(c("O", "Empty", "Empty", "X", "Empty")))
Partida9_entrenamiento <- as.numeric(factor(c("O", "X", "Empty", "X", "Empty")))
Clasificacion <- as.numeric(factor(c("8", "3", "3", "9", "8")))

datos_entrenamiento <- data.frame(
  Partida1_entrenamiento, Partida2_entrenamiento, Partida3_entrenamiento,
  Partida4_entrenamiento, Partida5_entrenamiento, Partida6_entrenamiento,
  Partida7_entrenamiento, Partida8_entrenamiento, Partida9_entrenamiento,
  Clasificacion
)

# Datos de prueba
Partida1_prueba <- c("O", "X", "Empty")
Partida2_prueba <- c("O", "O", "Empty")
Partida3_prueba <- c("X", "O", "O")
Partida4_prueba <- c("Empty", "Empty", "Empty")
Partida5_prueba <- c("X", "O", "X")
Partida6_prueba <- c("X", "Empty", "X")
Partida7_prueba <- c("X", "X", "O")
Partida8_prueba <- c("O", "X", "Empty")
Partida9_prueba <- c("O", "Empty", "Empty")
Clasificacion <- c("4", "9", "4")

# DataFrame de prueba
datos_prueba <- data.frame(
  Partida1_prueba, Partida2_prueba, Partida3_prueba,
  Partida4_prueba, Partida5_prueba, Partida6_prueba,
  Partida7_prueba, Partida8_prueba, Partida9_prueba,
  Clasificacion
)



# EJERCICIO 3

library(rpart)    # Para árboles de decisión CART
library(nnet)     # Para perceptrón
library(e1071)    # Para SVM

# Modelo CART (árbol de decisión)
t_cart <- proc.time()
arbol_rpart <- rpart(Clasificacion ~ ., data = datos_entrenamiento, method = "class")
tiempo_cart <- proc.time() - t_cart

matrizconfusion<- table(predict(arbol_rpart, datos_prueba), datos_prueba$Clasificacion)
accuracy<-sum(diag(matrizconfusion))/sum(matrizconfusion)
accuracy # 0.4

# Perceptrón
t_perceptron <- proc.time() 
modelo_perceptron <- nnet(Clasificacion ~ ., data = datos_entrenamiento, size = 2)
tiempo_perceptron <- proc.time() - t_perceptron 

matrizconfusion<-table( predict(modelo_perceptron ,datos_prueba ),  datos_prueba$Clasificacion, type = "class")
accuracy<-sum(diag(matrizconfusion))/sum(matrizconfusion)
accuracy # 0.237 -> con 50: 0.5

# SVM (máquinas de soporte vectorial)
t_svm <- proc.time()
modelo_svm <- svm(Clasificacion ~ ., data = datos_entrenamiento, kernel = "radial")
tiempo_svm <- proc.time() - t_svm 

matrizconfusionSVM<-table(predict(modelo_svm,datos_prueba), datos_prueba$Clasificacion , dnn=c("Prediction", "Actual"))
accuracySVMrad<- sum(diag(matrizconfusionSVM))/sum(matrizconfusionSVM)
accuracySVMrad # 0.006993007 xdddd -> Con 50: 0.2




# Ejercicio 2
# En la tabla adjunta se muestran características de unas setas y si son
# comestibles o no. Nos hemos fijado en la forma y color del sombrero
# (cap-shape y cap-color) y en el grosor y color del tronco (gill-size y gill-color).
# El atributo de clasificación es class que indica si la seta es venenosa
# (poisonous) o no (edible).

# Apartado 2
# A partir del dataframe anterior y usando el paquete kernlab entrena
# una máquina de soporte vectorial y obten los siguientes parámetros:
# ancho del canal, b, vector de Pesos normal al Hiperplano w, la
# ecuación del Hiperplano y de los planos de soporte positivo y negativo.
# Realiza la predicción de una seta con las siguientes características bell,
# white, broad y black citadas en el mismo orden que los atributos de la
# tabla adjunta ¿Podrías comerte la seta?

# Importar las librerías necesarias
library(kernlab)
library(e1071)

# Crear el dataframe con los datos de las setas
dataA <- data.frame(
  cap_shape = c("convex", "convex", "bell", "convex", "convex", "bell", "convex"),
  cap_color = c("brown", "yellow", "white", "white", "yellow", "white", "white"),
  gill_size = c("narrow", "broad", "broad", "narrow", "broad", "broad", "narrow"),
  gill_color = c("black", "black", "brown", "brown", "brown", "brown", "pink"),
  class = c("poisonous", "edible", "edible", "poisonous", "edible", "edible", "poisonous")
)

# Convertir variables categóricas a numéricas
dataA$cap_shape <- as.numeric(factor(dataA$cap_shape))
dataA$cap_color <- as.numeric(factor(dataA$cap_color))
dataA$gill_size <- as.numeric(factor(dataA$gill_size))
dataA$gill_color <- as.numeric(factor(dataA$gill_color))
dataA$class <- as.numeric(factor(dataA$class))

# Crear el modelo SVM
model <- ksvm(class ~ ., data = dataA, type = "C-svc", kernel = "vanilladot")

# Obtener los parámetros del modelo
ancho_del_canal <- model@prob.model$rho
cat("Ancho del canal:", ancho_del_canal, "\n") #null

b <- b(model)
cat("b:", b, "\n")

w <- colSums(t(model@xmatrix[[1]]) * model@coef[[1]])
cat("Vector de pesos normal al hiperplano w:", w, "\n")

ecuacion_hiperplano <- paste("0 = ", w[1], "*x1 + ", w[2], "*x2 + ", w[3], "*x3 + ", w[4], "*x4 + ", b)
cat("Ecuación del hiperplano:", ecuacion_hiperplano, "\n")

# Realizar la predicción para una seta con las características dadas
nueva_seta <- data.frame(
  cap_shape = "bell",
  cap_color = "white",
  gill_size = "broad",
  gill_color = "black"
)

# Convertir variables categóricas a numéricas
nueva_seta$cap_shape <- as.numeric(factor(nueva_seta$cap_shape))
nueva_seta$cap_color <- as.numeric(factor(nueva_seta$cap_color))
nueva_seta$gill_size <- as.numeric(factor(nueva_seta$gill_size))
nueva_seta$gill_color <- as.numeric(factor(nueva_seta$gill_color))

# Realizar la predicción
prediccion <- predict(model, newdata = nueva_seta)
cat("Clasificación de la seta:", ifelse(prediccion > 0, "edible", "poisonous"), "\n")

# La seta es clasificada como "edible" (comestible)
