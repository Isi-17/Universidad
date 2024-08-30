# kernel = linear 
# kernel = radial, gamma = 0,1
# kernel = polynomial, degree = 3

# Importamos las Librerias necesarias
library (kernlab)
library(e1071)

print_clasificacion <- function (x, w, b) {
  
  if ((t (w) %*% x + b) >= 0)
  {
    print (x)
    print("Pertence a la clase: 1")
    val = 1
  }
  else
  {
    print (x)
    print("Pertence a la clase: -1")
    val = -1
  }
  # Si clasifica positivamente --> azul, si clasifica negativamente --> rojo
  points(x[1], x[2], col = ifelse(val == 1, "blue", "red"), pch = 19)
  text(x[1], x[2], labels = paste("(", x[1], ",", x[2], ")", sep = ""), pos = 3)
}

dataA <- data.frame( 
  x1 = c(1, 3, 1, 3, 2, 3, 4), 
  x2 = c(1, 3, 3, 1, 2.5, 2.5, 3), 
  y = c(-1, 1, 1, -1, 1, -1, -1) 
) 

# Crear un gráfico
plot(dataA[, c("x1", "x2")], col = ifelse(dataA$y == 1, "blue", "red"), pch = 19, xlim = c(0, 5), ylim = c(0, 5))
# Etiquetar los puntos
for (i in 1:nrow(dataA)) {
  text(dataA$x1[i], dataA$x2[i], labels = paste("(", dataA$x1[i], ",", dataA$x2[i], ")", sep = ""), pos = 3)
}
# Agregar una leyenda
legend("topleft", legend = c("Y = +1", "Y = -1"), col = c("blue", "red"), pch = 19)

# Indicamos que la columna y es la importante 
dataA$y <- as.factor(dataA$y)

# Creamos el SVM con los datos del C con un kernel lineal 
svmA <- svm(y~., dataA, kernel="linear") 

#Vectores de soporte 
vsA <- dataA[svmA$index,1:2] 

# Vector de pesos normal al hiperplano (W) 
# Hacemos el CrosProduct entre los vectores soporte y el coe. de Lagrange 
wA <- crossprod(as.matrix(vsA), svmA$coefs) 

# Calcular ancho del canal 
widthA = 2/(sqrt(sum((wA)^2))) 

# Calcular vector B 
bA <- -svmA$rho 

# Calcular la ecuacion del hiperplano y de los planos de soporte positivo y negativo 
Withd=2 / (sum (sqrt ((wA)^2))) 
paste(c("[",wA,"]' * x + [",bA,"] = 0"), collapse=" ") 
paste(c("[",wA,"]' * x + [",bA,"] = 1"), collapse=" ") 
paste(c("[",wA,"]' * x + [",bA,"] = -1"), collapse=" ") 

# Dibujar el hiperplano
abline(a = -bA/wA[2], b = -wA[1]/wA[2], col = "green")
abline(a = (1 - bA) / wA[2], b = -wA[1] / wA[2], col = "red", lty = 2)
abline(a = (-1 - bA) / wA[2], b = -wA[1] / wA[2], col = "red", lty = 2)


# Determinamos a la clase que pertenece cada uno
# Puntos a clasificar
clasif1 = c(4, 2.5)
clasif2 = c(4, 1)

print_clasificacion(clasif1,wA, bA)
print_clasificacion(clasif2,wA, bA)

# El punto [4, 5] se clasifica positivamente.

plot(svmA, dataA)

### B ###
dataB <- data.frame( 
  x1 = c(1, 3, 1, 3, 2, 3, 4, 1.5, 1), 
  x2 = c(1, 3, 3, 1, 2.5, 2.5, 3, 1.5, 2), 
  y = c(-1, 1, 1, -1, 1, -1, -1, 1, -1) 
) 

# Crear un gráfico
plot(dataB[, c("x1", "x2")], col = ifelse(dataB$y == 1, "blue", "red"), pch = 19, xlim = c(0, 5), ylim = c(0, 5))
# Etiquetar los puntos
for (i in 1:nrow(dataB)) {
  text(dataB$x1[i], dataB$x2[i], labels = paste("(", dataB$x1[i], ",", dataB$x2[i], ")", sep = ""), pos = 3)
}
# Agregar una leyenda
legend("topleft", legend = c("Y = +1", "Y = -1"), col = c("blue", "red"), pch = 19)

# Indicamos que la columna y es la importante 
dataB$y <- as.factor(dataB$y)

# Creamos el SVM con los datos del C con un kernel lineal 
svmB <- svm(y~., dataB, kernel="radial", gamma = 0.1) 

#Vectores de soporte 
vsB <- dataB[svmB$index,1:2] 

# Vector de pesos normal al hiperplano (W) 
# Hacemos el CrosProduct entre los vectores soporte y el coe. de Lagrange 
wB <- crossprod(as.matrix(vsB), svmB$coefs) 

# Calcular ancho del canal 
widthB = 2/(sqrt(sum((wB)^2))) 

# Calcular vector B 
bB <- -svmB$rho 

# Calcular la ecuacion del hiperplano y de los planos de soporte positivo y negativo 
Withd=2 / (sum (sqrt ((wB)^2))) 
paste(c("[",wB,"]' * x + [",bB,"] = 0"), collapse=" ") 
paste(c("[",wB,"]' * x + [",bB,"] = 1"), collapse=" ") 
paste(c("[",wB,"]' * x + [",bB,"] = -1"), collapse=" ") 

# Dibujar el hiperplano
abline(a = -bB/wB[2], b = -wB[1]/wA[2], col = "green")
abline(a = (1 - bB) / wB[2], b = -wB[1] / wB[2], col = "red", lty = 2)
abline(a = (-1 - bB) / wB[2], b = -wB[1] / wB[2], col = "red", lty = 2)


# Determinamos a la clase que pertenece cada uno
# Puntos a clasificar
clasif1 = c(4, 2.5)
clasif2 = c(4, 1)

print_clasificacion(clasif1,wB, bB)
print_clasificacion(clasif2,wB, bB)

# El punto [4, 5] se clasifica positivamente.

plot(svmB, dataB)