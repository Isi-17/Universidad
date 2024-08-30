#Regresion logistica con validacion cruzada
library(stats)
library(pROC)
library(nnet)
library(e1071)
library(rpart)
datos <- read.table("C:/Users/isidr/Desktop/Aprendizaje_Computacional/datos_icb.txt",header=T)
set.seed(1000)

ind <- sample(500,500)
aucs <- sample(10,10)


ii <- 0
is <- 50
idt <- ind[ii:is]
dtrain <- datos[-idt,]
dtest <- datos[idt,]
lr.fit <- glm(recid~., data=dtrain, family=binomial("logit"))
#plot(lr.fit,data=dtrain$recid)
lr.pred <- predict(lr.fit,dtest,type="response")
aucs <- auc((dtest$recid=="SI")*1, lr.pred)
plot (aucs)
