library(rpart)
library(mboost)
set.seed(123)
# EXAMEN ENERO 2015

# Vamos a hacer un CSV manual
x <- c(1, 2, 3, 4, 5, 6, 7)
y <- c("a", "c", "b", "a", "b", "c", "b")
z <- c(5, 4, 4, 2, 5, 2, 4)
datosexamen <- data.frame(x, y, z)

# Entrena el árbol teniendo en cuenta que el atributo y clasifica las diferentes entradas en tres clases. 
modeloexamen <- rpart (y~x+z, data = datosexamen)

# Dibuja el árbol y muestra las reglas de clasificación.
print(modeloexamen)
plot(modeloexamen)
text(modeloexamen)

# Nuevos datos
x <- c(1, 2)
y <- c("a", "c")
z <- c(4, 6)
datosexamenTest <- data.frame(x, y, z)

# Imprime la tabla CP (Parámetro de complejidad)
prediccion <- predict(modeloexamen, datosexamenTest, type = "class")
#[1] b b
#Levels: a b c
modeloexamen$cptable
#CP nsplit   rel    error  xerror xstd
#1    0.01    0       1      0     0

# Determina usando R el valor apropiado para el parámetro CP y úsalo para podar elárbol. 
opt <- which.min(modeloexamen$cptable[,"xerror"])
cpmin <- modeloexamen$cptable[opt, "CP"] 

# Acaba de decir el profesor que mejor usar prune no raprt
# arbolPodado <- rpart(y~x+z, data = datosexamenTest, control = rpart.control(cp = cpmin))
arbolPodado <- prune(modeloexamen, cp=cpmin)

# Dibuja el árbol podado y predice los datos del apartado d) con el árbol podado
print(arbolPodado)
plot(arbolPodado)
text(arbolPodado)

prediccion <- predict(arbolPodado, datosexamenTest, type = "class")
#[1] b b
#Levels: a b c













