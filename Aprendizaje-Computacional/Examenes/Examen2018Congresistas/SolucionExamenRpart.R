
library(e1071)
library(rpart)
voteTraining <- read_csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Examen2018Congresistas/vote.data.txt", header=FALSE)
voteTest <- read_csv("C:/Users/isidr/Desktop/Aprendizaje_Computacional/Examen2018Congresistas/vote.data.txt", header = FALSE)

# Import DataSet, vote.data NO HEADER.

voteTraining

names(voteTraining)<-c("handicappedinfants",
                       "waterprojectcostsharing",
                       "adoptionofthebudgetresolution",
                       "physicianfeefreeze",
                       "elsalvadoraid",
                       "religiousgroupsinschools",
                       "antisatellitetestban",
                       "aidtonicaraguancontra",
                       "mxmissile",
                       "immigration",
                       "synfuelscorporationcutback",
                       "educationspending",
                       "superfundrighttosue",
                       "crime",
                       "dutyfreeexports",
                       "exportadministrationactsouthafrica", "votation")

names(voteTest)<-c("handicappedinfants",
                   "waterprojectcostsharing",
                   "adoptionofthebudgetresolution",
                   "physicianfeefreeze",
                   "elsalvadoraid",
                   "religiousgroupsinschools",
                   "antisatellitetestban",
                   "aidtonicaraguancontra",
                   "mxmissile",
                   "immigration",
                   "synfuelscorporationcutback",
                   "educationspending",
                   "superfundrighttosue",
                   "crime",
                   "dutyfreeexports",
                   "exportadministrationactsouthafrica", "votation")


#Eliminar la variable physician fee freeze)
drops <- c("physicianfeefreeze")
voteTraining[ , !(names(voteTraining) %in% drops)]
voteTraining
voteTest[ , !(names(voteTest) %in% drops)]
voteTest
#Entrenar
fit <- rpart(formula= voteTraining$votation ~., data=voteTraining)


#Dibujar �rbol
plot(fit)
#Mostrar tabla CP
print(fit$cptable)
text(fit, use.n=TRUE)

#Podar el arbol eligiendo el Cp adecuado
opt <- which.min(fit$cptable[,"xerror"])
cp1 <- fit$cptable[opt, "CP"]
arbolpodado<-prune (fit, cp=cp1)
plot(arbolpodado)
text(arbolpodado, use.n=TRUE)

fit
arbolpodado


#Predecir
predict <- predict(object = arbolpodado, newdata = voteTest, type = "class")
predict
#Para comparar accuracy
prueba_fit <- predict(object = fit, newdata = voteTest, type = "class")


#Accuracy
matriz1 <- table(predict, voteTest$votation)
matriz2 <- table(prueba_fit, voteTest$votation)

suma_matriz1 <- sum(matriz1)
suma_matriz2 <- sum(matriz2)

aciertos1 <- sum(diag(matriz1))
aciertos2 <- sum(diag(matriz1))

accuracy1 <- aciertos1/suma_matriz1
accuracy2 <- aciertos2/suma_matriz2

#Comparar valores de accuracy
accuracy1
accuracy2
#Ambos son iguales, podar el arbol por los valores CP no influye aqui. Esto de debe a que el numero de splits no es grande
#y la tabla CP es pequeña, por tanto, no hay cambio significativo. Por ello, con un accuracy de 0.9701493, como nos ha
#salido, es lo suficientemente bueno y adecuado.


#Cuando se añade el campo eliminado, lo que ocurre es que simplmente el dataset se hace mas grande. 

