# Practica 3
# Autor: Isidro Javier Garcia Fernandez
# Titulacion: Doble Grado Matematicas e Ingenieria Informatica

# Realiza un programa en R que calcule los siguientes parámetros de una Maquina de Soporte Vectorial (SVM, en ingles):
# 1. Determinar y mostrar los Vectores Soporte.
# 2. Calcular todos los valores del Kernel (es, la matriz K formada por: K(A,A) K(B,A) K(B,A) K(B,B)
#    Siendo A y B los puntos de un dataset con 2 observaciones, Supón que el Kernel es el dot product (K(u,v)=u.v)
# 3. Ancho del canal
# 4. Vector de Pesos normal al Hiperplano (W)
# 5. Vector B
# 6. La ecuación del Hiperplano y de los planos de soporte positivo y negativo.
# 7. Determinar la clase a la que pertenece un punto dado.
# Además, pintar el conjunto de puntos (suponiendo que inicialmente los puntos están en el plano Euclídeo) y el Hiperplano.

# Importamos las Librerias necesarias
library (kernlab)
library(e1071)


# Creamos la funcion que dira a que clase pertenece cada punto
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

## APARTADO A ##################################################################

# a. A=[0,0] que pertenece a la clase Y=+1; B=[4,4] con clase Y=-1. 
#    Clasificar los puntos [5,6] y [1,-4].

# Creamos el conjunto de datos
dataA <- data.frame(
  x1 = c(0, 4),
  x2 = c(0, 4),
  y = c(1, -1)
)
# Indicamos que la columna y es la importante
dataA$y <- as.factor(dataA$y)

# Creamos el SVM con los datos del A con un kernel lineal
svmA <- svm(y~., dataA , kernel="linear")

# svmA$coefs : coeficientes de Lagrange calculados

#Vectores de soporte
vsA <- dataA[svmA$index,1:2]

# Calculamos los valores del kernel
A=c(0,0)
B=c(4,4)
KAA=t (A) %*% A
KAB=t (A) %*% B
KBB=t (B) %*% B

# Vector de pesos normal al hiperplano (W)
# Hacemos el CrosProduct entre los vectores soporte y el coef. de Lagrange
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

# Crear un gráfico
plot(dataA[, c("x1", "x2")], col = ifelse(dataA$y == 1, "blue", "red"), pch = 19, xlim = c(-7, 7), ylim = c(-7, 7))
# Etiquetar los puntos
for (i in 1:nrow(dataA)) {
  text(dataA$x1[i], dataA$x2[i], labels = paste("(", dataA$x1[i], ",", dataA$x2[i], ")", sep = ""), pos = 3)
}
# Agregar una leyenda
legend("topleft", legend = c("Y = +1", "Y = -1"), col = c("blue", "red"), pch = 19)

# Dibujar el hiperplano
abline(a = -bA/wA[2], b = -wA[1]/wA[2], col = "green")
abline(a = (1-bA)/wA[2], b = -wA[1]/wA[2], col = "red", lty = 2)
abline(a = (-1-bA)/wA[2], b = -wA[1]/wA[2], col = "red", lty = 2)

# Determinamos a la clase que pertenece cada uno
# Puntos a clasificar
x1 = c(5, 6)
x2 = c(1, -4)

print_clasificacion(x1,wA, bA)
print_clasificacion(x2,wA, bA)


plot(svmA, dataA)

## APARTADO B ##################################################################

# b. A=[2,0] que pertenece a la clase Y=+1; B=[0,0] y C=[1,1] con clase 
#    Y=-1. Clasificar los puntos [5,6] y [1,-4].

# En este caso debemos encontrar cuales son los más cercanos, los cuales serán los futuros vectores soporte 
A = c(2,0) 
B = c(0,0) 
C = c(1,1) 

# Distancia entre A y B 
distanceAB = sqrt((A[1]-B[1])^2 + (A[2]-B[2])^2) # 2
#Distancia entre A y C 
distanceAC = sqrt((A[1]-C[1])^2 + (A[2]-C[2])^2) # sqrt(2) = 1,41..

# Como la distancia entre A y C es la menor, A y C son los vectores soporte.
# Como B no es vector soporte no lo añado al dataframe.
# Comento el data frame con los tres puntos.
dataB <- data.frame( 
#  x1 = c(2, 0, 1), 
#  x2 = c(0, 0, 1), 
#  y = c(1, -1, -1)
  x1 = c(2, 1), 
  x2 = c(0, 1), 
  y = c(1, -1)
) 

# Indicamos que la columna y es la importante 
dataB$y <- as.factor(dataB$y) 

# Creamos el SVM con los datos del B con un kernel lineal 
svmB <- svm(y~., dataB, kernel="linear")

#Vectores de soporte 
vsB <- dataB[svmB$index,1:2] 

# Calculamos los valores del kernel sabiendo que A y C son los vectores soporte 
KAA=t (A) %*% A 
KAC=t (A) %*% C 
KCC=t (C) %*% C 
KAB=t (A) %% B
KBB=t (B) %% B
KBC=t (B) %% C

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

# Crear un gráfico
plot(dataB[, c("x1", "x2")], col = ifelse(dataB$y == 1, "blue", "red"), pch = 19, xlim = c(-7, 7), ylim = c(-7, 7))
# Etiquetar los puntos
for (i in 1:nrow(dataB)) {
  text(dataB$x1[i], dataB$x2[i], labels = paste("(", dataB$x1[i], ",", dataB$x2[i], ")", sep = ""), pos = 3)
}
# Agregar una leyenda
legend("topleft", legend = c("Y = +1", "Y = -1"), col = c("blue", "red"), pch = 19)

# Dibujar el hiperplano
abline(a = -bB/wB[2], b = -wB[1]/wB[2], col = "green")
abline(a = (1 - bB) / wB[2], b = -wB[1] / wB[2], col = "red", lty = 2)
abline(a = (-1 - bB) / wB[2], b = -wB[1] / wB[2], col = "red", lty = 2)

# Determinamos a la clase que pertenece cada uno
# Puntos a clasificar
x1 = c(5, 6)
x2 = c(1, -4)

print_clasificacion(x1,wB, bB)
print_clasificacion(x2,wB, bB)

plot(svmB, dataB)

## APARTADO c ################################################################## 
# c. [2, 2], [2, -2], [-2, -2], [-2, 2] [2, 2], [2, -2], [-2, -2], [-2, 2] que 
#    pertenece a la clase Y=+1; [1, 1], [1, -1], [-1, -1], [-1, 1] que pertenece a 
#    la clase Y=+1. Encuentra puntos que clasifiquen positiva y negativamente

# En este caso debemos encontrar cuales son los más cercanos, los cuales serán los futuros vectores soporte 
datosC <- data.frame(
  x1 = c(2, 2, -2, -2, 1, 1, -1, -1),
  x2 = c(2, -2, -2, 2, 1, -1, -1, 1),
  y = c(1, 1, 1, 1, -1, -1, -1, -1)
)
x1 = c(2,2) 
x2 = c(2,-2)
x3 = c(-2,-2)
x4 = c(-2,2)
y1 = c(1,1) 
y2 = c(1,-1)
y3 = c(-1,-1)
y4 = c(-1,1) 

#Distancia entre X1 y Y1 
distancex1y1 = sqrt((x1[1]-y1[1])^2 + (x1[2]-y1[2])^2) 
#Distancia entre X1 y Y2 
distancex1y2 = sqrt((x1[1]-y2[1])^2 + (x1[2]-y2[2])^2) 
#Distancia entre X1 y Y3 
distancex1y3 = sqrt((x1[1]-y3[1])^2 + (x1[2]-y3[2])^2) 
#Distancia entre X1 y Y4 
distancex1y4 = sqrt((x1[1]-y4[1])^2 + (x1[2]-y4[2])^2) 
#Distancia entre X2 y Y1 
distancex2y1 = sqrt((x2[1]-y1[1])^2 + (x2[2]-y1[2])^2) 
#Distancia entre X2 y Y2 
distancex2y2 = sqrt((x2[1]-y2[1])^2 + (x2[2]-y2[2])^2)
#Distancia entre X2 y Y3 
distancex2y3 = sqrt((x2[1]-y3[1])^2 + (x2[2]-y3[2])^2) 
#Distancia entre X2 y Y4 
distancex2y4 = sqrt((x2[1]-y4[1])^2 + (x2[2]-y4[2])^2) 
#Distancia entre X3 y Y1 
distancex3y1 = sqrt((x3[1]-y1[1])^2 + (x3[2]-y1[2])^2) 
#Distancia entre X3 y Y2 
distancex3y2 = sqrt((x3[1]-y2[1])^2 + (x3[2]-y2[2])^2) 
#Distancia entre X3 y Y3 
distancex3y3 = sqrt((x3[1]-y3[1])^2 + (x3[2]-y3[2])^2) 
#Distancia entre X3 y Y4 
distancex3y4 = sqrt((x3[1]-y4[1])^2 + (x3[2]-y4[2])^2) 
#Distancia entre X4 y Y1 
distancex4y1 = sqrt((x4[1]-y1[1])^2 + (x4[2]-y1[2])^2) 
#Distancia entre X4 y Y2 
distancex4y2 = sqrt((x4[1]-y2[1])^2 + (x4[2]-y2[2])^2) 
#Distancia entre X4 y Y3 
distancex4y3 = sqrt((x4[1]-y3[1])^2 + (x4[2]-y3[2])^2) 
#Distancia entre X4 y Y4 
distancex4y4 = sqrt((x4[1]-y4[1])^2 + (x4[2]-y4[2])^2) 

# En este caso vemos cual es menor a ojo tras calcularlas 
# En este caso la distancia entre X1 e Y1 es la menor, luego esos seán nuestros 
# vectores soporte. Hay más con la misma distancia, pero no menor, asi que escogemos la primera 
# Calculamos los valores del kernel sabiendo que A y B son los vectores soporte 
KAA=t (x1) %*% x1 
KAB=t (x1) %*% x2 
KAC=t (x1) %*% x3 
KAD=t (x1) %*% x4
KAE=t (x1) %*% y1
KAF=t (x1) %*% y2
KAG=t (x1) %*% y3
KAH=t (x1) %*% y4
KBB=t (x2) %*% x2
KBC=t (x2) %*% x3
KBD=t (x2) %*% x4
KBE=t (x2) %*% y1
KBF=t (x2) %*% y2
KBG=t (x2) %*% y3
KBH=t (x2) %*% y4
KCC=t (x3) %*% x3
KCD=t (x3) %*% x4
KCE=t (x3) %*% y1
KCF=t (x3) %*% y2
KCG=t (x3) %*% y3
KCH=t (x3) %*% y4
KDD=t (x4) %*% x4
KDE=t (x4) %*% y1
KDF=t (x4) %*% y2
KDG=t (x4) %*% y3
KDH=t (x4) %*% y4
KEE=t (y1) %*% y1
KEF=t (y1) %*% y2
KEG=t (y1) %*% y3
KEH=t (y1) %*% y4
KFF=t (y2) %*% y2
KFG=t (y2) %*% y3
KFH=t (y2) %*% y4
KGG=t (y3) %*% y3
KGH=t (y3) %*% y4
KHH=t (y4) %*% y4


# Los que tienen minima distancia son: x1, y1, x2, y2, x3, y3, x4, y4
# Creamos el conjunto de datos.
# Comento el data frame con todos los puntos.
dataC <- data.frame( 
  x1 = c(2, 2, -2, -2, 1, 1, -1, -1),
  x2 = c(2, -2, -2, 2, 1, -1, -1, 1),
  y = c(1, 1, 1, 1, -1, -1, -1, -1)
#  x1 = c(2, -1), 
#  x2 = c(2, 1), 
#  y = c(1, -1)
) 

# Indicamos que la columna y es la importante 
dataC$y <- as.factor(dataC$y) 

# Creamos el SVM con los datos del C con un kernel lineal 
svmC <- svm(y~., dataC, kernel="linear") 

#Vectores de soporte 
vsC <- dataC[svmC$index,1:2] 

# Vector de pesos normal al hiperplano (W) 
# Hacemos el CrosProduct entre los vectores soporte y el coef. de Lagrange 
wC <- crossprod(as.matrix(vsC), svmC$coefs) 

# Calcular ancho del canal 
widthC = 2/(sqrt(sum((wC)^2))) 

# Calcular vector B 
bC <- -svmC$rho 

# Calcular la ecuacion del hiperplano y de los planos de soporte positivo y negativo 
Withd=2 / (sum (sqrt ((wC)^2))) 
paste(c("[",wC,"]' * x + [",bC,"] = 0"), collapse=" ") 
paste(c("[",wC,"]' * x + [",bC,"] = 1"), collapse=" ") 
paste(c("[",wC,"]' * x + [",bC,"] = -1"), collapse=" ")

# Crear un gráfico
plot(datosC[, c("x1", "x2")], col = ifelse(datosC$y == 1, "blue", "red"), pch = 19, xlim = c(-7, 7), ylim = c(-7, 7))
# Etiquetar los puntos
for (i in 1:nrow(datosC)) {
  text(datosC$x1[i], datosC$x2[i], labels = paste("(", datosC$x1[i], ",", datosC$x2[i], ")", sep = ""), pos = 3)
}
# Agregar una leyenda
legend("topleft", legend = c("Y = +1", "Y = -1"), col = c("blue", "red"), pch = 19)

# Dibujar el hiperplano. No podemos. No existe un hiperplano que podamos pintar para separar las clases.
abline(a = -bC/wC[2], b = -wC[1]/wC[2], col = "green")
abline(a = (1 - bC) / wC[2], b = -wC[1] / wC[2], col = "red", lty = 2)
abline(a = (-1 - bC) / wC[2], b = -wC[1] / wC[2], col = "red", lty = 2)


# Determinamos a la clase que pertenece cada uno
# Puntos a clasificar
x1 = c(5, 6)
x2 = c(1, -4)

print_clasificacion(x1,wC, bC)
print_clasificacion(x2,wC, bC)

# El punto [5, 6] se clasifica positivamente.
# El punto [1, -4] se clasifica negativamente.

# No tiene sentido. Debemos aplicar la función de transformacion.
plot(svmC, dataC)

## APARTADO d ################################################################## 
# Repite el apartado anterior utilizando la función de transformacion
funcion_transformacion <- function(a) {
  if(sqrt(a[1]^2 + a[2]^2) > 2) {
    a[1] <- 4 - a[2] + abs(a[1] - a[2])
    a[2] <- 4 - a[1] + abs(a[1] - a[2])
  }
  a
}

datosD <- data.frame(
  x1 = c(2, 2, -2, -2, 1, 1, -1, -1),
  x2 = c(2, -2, -2, 2, 1, -1, -1, 1),
  y = c(1, 1, 1, 1, -1, -1, -1, -1)
)

x1 = c(2,2) 
x2 = c(2,-2)
x3 = c(-2,-2)
x4 = c(-2,2)
y1 = c(1,1) 
y2 = c(1,-1)
y3 = c(-1,-1)
y4 = c(-1,1) 

# Aplicar la función de transformación a los vectores X e Y
x1 <- funcion_transformacion(x1)
x2 <- funcion_transformacion(x2)
x3 <- funcion_transformacion(x3)
x4 <- funcion_transformacion(x4)

y1 <- funcion_transformacion(y1)
y2 <- funcion_transformacion(y2)
y3 <- funcion_transformacion(y3)
y4 <- funcion_transformacion(y4)

datosDTrans <- data.frame(
  x1 = c(x1[1], x2[1], x3[1], x4[1], y1[1], y2[1], y3[1], y4[1]),
  x2 = c(x1[2], x2[2], x3[2], x4[2], y1[2], y2[2], y3[2], y4[2]),
  y = c(1, 1, 1, 1, -1, -1, -1, -1)
)


#Distancia entre X1 y Y1 
distancex1y1 = sqrt((x1[1]-y1[1])^2 + (x1[2]-y1[2])^2) 
#Distancia entre X1 y Y2 
distancex1y2 = sqrt((x1[1]-y2[1])^2 + (x1[2]-y2[2])^2) 
#Distancia entre X1 y Y3 
distancex1y3 = sqrt((x1[1]-y3[1])^2 + (x1[2]-y3[2])^2) 
#Distancia entre X1 y Y4 
distancex1y4 = sqrt((x1[1]-y4[1])^2 + (x1[2]-y4[2])^2) 
#Distancia entre X2 y Y1 
distancex2y1 = sqrt((x2[1]-y1[1])^2 + (x2[2]-y1[2])^2) 
#Distancia entre X2 y Y2 
distancex2y2 = sqrt((x2[1]-y2[1])^2 + (x2[2]-y2[2])^2)
#Distancia entre X2 y Y3 
distancex2y3 = sqrt((x2[1]-y3[1])^2 + (x2[2]-y3[2])^2) 
#Distancia entre X2 y Y4 
distancex2y4 = sqrt((x2[1]-y4[1])^2 + (x2[2]-y4[2])^2) 
#Distancia entre X3 y Y1 
distancex3y1 = sqrt((x3[1]-y1[1])^2 + (x3[2]-y1[2])^2) 
#Distancia entre X3 y Y2 
distancex3y2 = sqrt((x3[1]-y2[1])^2 + (x3[2]-y2[2])^2) 
#Distancia entre X3 y Y3 
distancex3y3 = sqrt((x3[1]-y3[1])^2 + (x3[2]-y3[2])^2) 
#Distancia entre X3 y Y4 
distancex3y4 = sqrt((x3[1]-y4[1])^2 + (x3[2]-y4[2])^2) 
#Distancia entre X4 y Y1 
distancex4y1 = sqrt((x4[1]-y1[1])^2 + (x4[2]-y1[2])^2) 
#Distancia entre X4 y Y2 
distancex4y2 = sqrt((x4[1]-y2[1])^2 + (x4[2]-y2[2])^2) 
#Distancia entre X4 y Y3 
distancex4y3 = sqrt((x4[1]-y3[1])^2 + (x4[2]-y3[2])^2) 
#Distancia entre X4 y Y4 
distancex4y4 = sqrt((x4[1]-y4[1])^2 + (x4[2]-y4[2])^2)

# De nuevo vemos que la distancia d(x1', y1') es la menor. Luego nuestros vectores soporte seran:
# x1' = [2, 2]
# y1' = [1, 1]

# Calculamos los valores del kernel sabiendo que A y B son los vectores soporte
# Calculo todos los kernel para todos los puntos transformados.
KAA=t (x1) %*% x1 
KAB=t (x1) %*% x2 
KAC=t (x1) %*% x3 
KAD=t (x1) %*% x4
KAE=t (x1) %*% y1
KAF=t (x1) %*% y2
KAG=t (x1) %*% y3
KAH=t (x1) %*% y4
KBB=t (x2) %*% x2
KBC=t (x2) %*% x3
KBD=t (x2) %*% x4
KBE=t (x2) %*% y1
KBF=t (x2) %*% y2
KBG=t (x2) %*% y3
KBH=t (x2) %*% y4
KCC=t (x3) %*% x3
KCD=t (x3) %*% x4
KCE=t (x3) %*% y1
KCF=t (x3) %*% y2
KCG=t (x3) %*% y3
KCH=t (x3) %*% y4
KDD=t (x4) %*% x4
KDE=t (x4) %*% y1
KDF=t (x4) %*% y2
KDG=t (x4) %*% y3
KDH=t (x4) %*% y4
KEE=t (y1) %*% y1
KEF=t (y1) %*% y2
KEG=t (y1) %*% y3
KEH=t (y1) %*% y4
KFF=t (y2) %*% y2
KFG=t (y2) %*% y3
KFH=t (y2) %*% y4
KGG=t (y3) %*% y3
KGH=t (y3) %*% y4
KHH=t (y4) %*% y4

# Creamos el conjunto de datos. (Ahora con puntos A = [2, 2], B = [1, 1])
# Comento el data frame con todos los puntos.
dataD <- data.frame( 
  x1 = c(x1[1], x2[1], x3[1], x4[1], y1[1], y2[1], y3[1], y4[1]),
  x2 = c(x1[2], x2[2], x3[2], x4[2], y1[2], y2[2], y3[2], y4[2]),
  y = c(1, 1, 1, 1, -1, -1, -1, -1)
#  x1 = c(2, 1), 
#  x2 = c(2, 1), 
#  y = c(1, -1)
)

# Indicamos que la columna y es la importante 
dataD$y <- as.factor(dataD$y) 

# Creamos el SVM con los datos del C con un kernel lineal 
svmD <- svm(y~., dataD, kernel="linear") 

#Vectores de soporte 
vsD <- dataD[svmD$index,1:2] 

# Vector de pesos normal al hiperplano (W) 
# Hacemos el CrosProduct entre los vectores soporte y el coef. de Lagrange 
wD <- crossprod(as.matrix(vsD), svmD$coefs) 

# Calcular ancho del canal 
widthD = 2/(sqrt(sum((wD)^2))) 

# Calcular vector B 
bD <- -svmD$rho 

# Calcular la ecuacion del hiperplano y de los planos de soporte positivo y negativo 
Withd=2 / (sum (sqrt ((wD)^2))) 
paste(c("[",wD,"]' * x + [",bD,"] = 0"), collapse=" ") 
paste(c("[",wD,"]' * x + [",bD,"] = 1"), collapse=" ") 
paste(c("[",wD,"]' * x + [",bD,"] = -1"), collapse=" ")

# Crear un gráfico
plot(datosDTrans[, c("x1", "x2")], col = ifelse(datosDTrans$y == 1, "blue", "red"), pch = 19, xlim = c(-10, 10), ylim = c(-10, 10))
# Etiquetar los puntos
for (i in 1:nrow(datosDTrans)) {
  text(datosDTrans$x1[i], datosDTrans$x2[i], labels = paste("(", datosDTrans$x1[i], ",", datosDTrans$x2[i], ")", sep = ""), pos = 3)
}
# Agregar una leyenda
legend("topleft", legend = c("Y = +1", "Y = -1"), col = c("blue", "red"), pch = 19)

# Dibujar el hiperplano
abline(a = -bD/wD[2], b = -wD[1]/wD[2], col = "green")
abline(a = (1 - bD) / wD[2], b = -wD[1] / wD[2], col = "red", lty = 2)
abline(a = (-1 - bD) / wD[2], b = -wD[1] / wD[2], col = "red", lty = 2)


# Determinamos a la clase que pertenece cada uno
# Puntos a clasificar
x1 = c(5, 6)
x2 = c(1, -4)

print_clasificacion(x1,wD, bD)
print_clasificacion(x2,wD, bD)

# El punto [5, 6] se clasifica positivamente.
# El punto [1, -4] se clasifica negativamente.

plot(svmD, dataD)

## APARTADO e ################################################################## 
# Etiquetados positivamente:
# {(3, 1), (3, -1), (6, 1), (6, -1)}
# Etiquetados negativamente:
# {(1, 0), {0, 1), (0, -1), (-1, 0)}

datosE <- data.frame( 
  x1 = c(3,3,6,6,1,0,0,-1), 
  x2 = c(1,-1,1,-1,0,1,-1,0), 
  y = c(1,1,1,1,-1,-1,-1,-1) 
) 

x1 = c(3,1) 
x2 = c(3,-1) 
x3 = c(6,1) 
x4 = c(6,-1) 
y1 = c(1,0) 
y2 = c(0,1) 
y3 = c(0,-1) 
y4 = c(-1,0)

#Distancia entre X1 y Y1 
distancex1y1 = sqrt((x1[1]-y1[1])^2 + (x1[2]-y1[2])^2) 
#Distancia entre X1 y Y2 
distancex1y2 = sqrt((x1[1]-y2[1])^2 + (x1[2]-y2[2])^2) 
#Distancia entre X1 y Y3 
distancex1y3 = sqrt((x1[1]-y3[1])^2 + (x1[2]-y3[2])^2) 
#Distancia entre X1 y Y4 
distancex1y4 = sqrt((x1[1]-y4[1])^2 + (x1[2]-y4[2])^2) 
#Distancia entre X2 y Y1 
distancex2y1 = sqrt((x2[1]-y1[1])^2 + (x2[2]-y1[2])^2) 
#Distancia entre X2 y Y2 
distancex2y2 = sqrt((x2[1]-y2[1])^2 + (x2[2]-y2[2])^2) 
#Distancia entre X2 y Y3 
distancex2y3 = sqrt((x2[1]-y3[1])^2 + (x2[2]-y3[2])^2) 
#Distancia entre X2 y Y4 
distancex2y4 = sqrt((x2[1]-y4[1])^2 + (x2[2]-y4[2])^2) 
#Distancia entre X3 y Y1 
distancex3y1 = sqrt((x3[1]-y1[1])^2 + (x3[2]-y1[2])^2) 
#Distancia entre X3 y Y2 
distancex3y2 = sqrt((x3[1]-y2[1])^2 + (x3[2]-y2[2])^2) 
#Distancia entre X3 y Y3 
distancex3y3 = sqrt((x3[1]-y3[1])^2 + (x3[2]-y3[2])^2) 
#Distancia entre X3 y Y4 
distancex3y4 = sqrt((x3[1]-y4[1])^2 + (x3[2]-y4[2])^2) 
#Distancia entre X4 y Y1 
distancex4y1 = sqrt((x4[1]-y1[1])^2 + (x4[2]-y1[2])^2) 
#Distancia entre X4 y Y2 
distancex4y2 = sqrt((x4[1]-y2[1])^2 + (x4[2]-y2[2])^2) 
#Distancia entre X4 y Y3 
distancex4y3 = sqrt((x4[1]-y3[1])^2 + (x4[2]-y3[2])^2) 
#Distancia entre X4 y Y4 
distancex4y4 = sqrt((x4[1]-y4[1])^2 + (x4[2]-y4[2])^2) 

# En este caso la distancia entre X1 e Y1 es la menor, luego esos seán nuestros 
# vectores soporte. Hay más con la misma distancia, pero no menor, asi que escogemos la primera 
# Calculamos los valores del kernel sabiendo que A y B son los vectores soporte 
# A = [3, 1], B = [1, 0], d(A, B) = 2.236...
# Calculamos todos los Kernel.
KAA=t (x1) %*% x1 
KAB=t (x1) %*% x2 
KAC=t (x1) %*% x3 
KAD=t (x1) %*% x4
KAE=t (x1) %*% y1
KAF=t (x1) %*% y2
KAG=t (x1) %*% y3
KAH=t (x1) %*% y4
KBB=t (x2) %*% x2
KBC=t (x2) %*% x3
KBD=t (x2) %*% x4
KBE=t (x2) %*% y1
KBF=t (x2) %*% y2
KBG=t (x2) %*% y3
KBH=t (x2) %*% y4
KCC=t (x3) %*% x3
KCD=t (x3) %*% x4
KCE=t (x3) %*% y1
KCF=t (x3) %*% y2
KCG=t (x3) %*% y3
KCH=t (x3) %*% y4
KDD=t (x4) %*% x4
KDE=t (x4) %*% y1
KDF=t (x4) %*% y2
KDG=t (x4) %*% y3
KDH=t (x4) %*% y4
KEE=t (y1) %*% y1
KEF=t (y1) %*% y2
KEG=t (y1) %*% y3
KEH=t (y1) %*% y4
KFF=t (y2) %*% y2
KFG=t (y2) %*% y3
KFH=t (y2) %*% y4
KGG=t (y3) %*% y3
KGH=t (y3) %*% y4
KHH=t (y4) %*% y4

# Creamos los datas para el ejercicio 
dataE <- data.frame( 
  x1 = c(3,3,6,6,1,0,0,-1), 
  x2 = c(1,-1,1,-1,0,1,-1,0), 
  y = c(1,1,1,1,-1,-1,-1,-1) 
#  x1 = c(3,1), 
#  x2 = c(1,0), 
#  y = c(1,-1) 
) 
# Indicamos que la columna y es la importante 
dataE$y <- as.factor(dataE$y) 

# Creamos el SVM con los datos del C con un kernel lineal 
svmE <- svm(y~., dataE, kernel="linear") 

#Vectores de soporte 
vsE <- dataE[svmE$index,1:2] 

# Vector de pesos normal al hiperplano (W) 
# Hacemos el CrosProduct entre los vectores soporte y el coe. de Lagrange 
wE <- crossprod(as.matrix(vsE), svmE$coefs) 

# Calcular ancho del canal 
widthE = 2/(sqrt(sum((wE)^2))) 

# Calcular vector B 
bE <- -svmE$rho 

# Calcular la ecuacion del hiperplano y de los planos de soporte positivo y negativo 
Withd=2 / (sum (sqrt ((wE)^2))) 
paste(c("[",wE,"]' * x + [",bE,"] = 0"), collapse=" ") 
paste(c("[",wE,"]' * x + [",bE,"] = 1"), collapse=" ") 
paste(c("[",wE,"]' * x + [",bE,"] = -1"), collapse=" ") 

# Crear un gráfico
plot(datosE[, c("x1", "x2")], col = ifelse(datosE$y == 1, "blue", "red"), pch = 19, xlim = c(-10, 10), ylim = c(-10, 10))
# Etiquetar los puntos
for (i in 1:nrow(datosE)) {
  text(datosE$x1[i], datosE$x2[i], labels = paste("(", datosE$x1[i], ",", datosE$x2[i], ")", sep = ""), pos = 3)
}
# Agregar una leyenda
legend("topleft", legend = c("Y = +1", "Y = -1"), col = c("blue", "red"), pch = 19)

# Dibujar el hiperplano
abline(a = -bE/wE[2], b = -wE[1]/wE[2], col = "green")
abline(a = (1 - bE) / wE[2], b = -wE[1] / wE[2], col = "red", lty = 2)
abline(a = (-1 - bE) / wE[2], b = -wE[1] / wE[2], col = "red", lty = 2)


# Determinamos a la clase que pertenece cada uno
# Puntos a clasificar
x1 = c(4, 5)

print_clasificacion(x1,wE, bE)

# El punto [4, 5] se clasifica positivamente.

plot(svmE, dataE)

## APARTADO f ################################################################## 
# Realiza los apartados anteriores con el dataset IRIS

# Creamos los datas para el ejercicio 
data(iris) 
dataF <- iris 

# Creamos el SVM con los datos del C con un kernel lineal 
svmF <- svm(Species~., data = iris, kernel="linear") 

#Vectores de soporte 
vsF <- dataF[svmF$index,1:2] 

# Vector de pesos normal al hiperplano (W) 
# Hacemos el CrosProduct entre los vectores soporte y el coe. de Lagrange 
wF <- crossprod(as.matrix(vsF), svmF$coefs) 

# Calcular ancho del canal 
widthF = 2/(sqrt(sum((wF)^2))) 

# Calcular vector B 
bF <- -svmF$rho 

ind <- sample(150,150)
idt <- ind[1:10]
dtrain <- iris[-idt,]
dtest <- iris[idt,]
m1 <- svm(Species ~ ., data = dtrain)

matrizconfusionSVM<-table(predict(m1,dtest), dtest$Species, dnn=c("Prediction", "Actual"))
# Buscamos un mayor accuracy
accuracySVM<- sum(diag(matrizconfusionSVM))/sum(matrizconfusionSVM)

print(matrizconfusionSVM)
print(accuracySVM)

