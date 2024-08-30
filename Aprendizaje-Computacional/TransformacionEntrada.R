library(mboost)
library(rpart)
library(s)

# Paso 1: Crear los vectores X y Y
X1 <- c(2, 2)
X2 <- c(10, 6)
X3 <- c(6, 6)
X4 <- c(6, 10)

Y1 <- c(1, 1)
Y2 <- c(1, -1)
Y3 <- c(-1, -1)
Y4 <- c(-1, 1)

X_originales <- data.frame(
  Clase = c(1, 1, 1, 1, -1, -1, -1, -1),
  X1 = c(X1[1], X2[1], X3[1], X4[1], Y1[1], Y2[1], Y3[1], Y4[1]),
  X2 = c(X1[2], X2[2], X3[2], X4[2], Y1[2], Y2[2], Y3[2], Y4[2])
  )

funcion_transformacion <- function(a) {
  if(sqrt(a[1]^2 + a[2]^2) > 2) {
    a[1] <- 4 - a[2] + abs(a[1] - a[2])
    a[2] <- 4 - a[1] + abs(a[1] - a[2])
  }
  a
}

# Paso 3: Aplicar la función de transformación a los vectores X e Y
X1 <- funcion_transformacion(X1)
X2 <- funcion_transformacion(X2)
X3 <- funcion_transformacion(X3)
X4 <- funcion_transformacion(X4)

Y1 <- funcion_transformacion(Y1)
Y2 <- funcion_transformacion(Y2)
Y3 <- funcion_transformacion(Y3)
Y4 <- funcion_transformacion(Y4)

df <- data.frame(
  Clase = c(1, 1, 1, 1, -1, -1, -1, -1),
  X1 = c(X1[1], X2[1], X3[1], X4[1], Y1[1], Y2[1], Y3[1], Y4[1]),
  X2 = c(X1[2], X2[2], X3[2], X4[2], Y1[2], Y2[2], Y3[2], Y4[2])
)

# FICHERO CAMPUS
# Ver el DataFrame resultante
print(X_originales)
print(df)

dataA <- data.frame(
  x1 = c(0, 4),
  x2 = c(0, 4),
  y = c(1, -1)
)


dataA$y <- as.factor(dataA$y)

# Creamos el SVM con los datos del A con un kernel lineal
svmA <- svm(y~., dataA , kernel="linear")
plot(svmA,data=dataA)














