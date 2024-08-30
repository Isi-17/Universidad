library(rpart)
library(mboost)
# data("iris")
# 5 atributos
#     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#1            5.1         3.5          1.4         0.2     setosa
#2            4.9         3.0          1.4         0.2     setosa
#3            4.7         3.2          1.3         0.2     setosa
#...          ...         ...          ...         ...     ...

# Atributo de clasificacion~atributos que queremos que intervengan separados con +
# Atributo de clasificacion~.  (todos los demás atributos)  -> Species~.
# Ejemplo: bodyfat_rpart <- rpart(myFormula, data = bodyfat, control = rpart.control(minsplit = 10))
# Vamos a crear el arbol
arbolRpart<-rpart(Species~., iris, control = rpart.control(minsplit = 10))

# rpart.control(minsplit = 20, minbucket = round(minsplit/3), cp = 0.01, maxcompete = 4, 
#               maxsurrogate = 5, usesurrogate = 2, xval = 10, surrogatestyle = 0, maxdepth = 30, ...)

# minsplit: nº min, observaciones que deben existir en un nodo para intentar dividir
# minbucket: nº min. observacioens que indicas que tiene que tener un nodo hoja. Normalmente es 1/3 * minsplit

print(arbolRpart)
#n= 150 

#node), split, n, loss, yval, (yprob)
#* denotes terminal node

#1) root 150 100 setosa (0.33333333 0.33333333 0.33333333)  
#2) Petal.Length< 2.45 50   0 setosa (1.00000000 0.00000000 0.00000000) *
#  3) Petal.Length>=2.45 100  50 versicolor (0.00000000 0.50000000 0.50000000)  
#6) Petal.Width< 1.75 54   5 versicolor (0.00000000 0.90740741 0.09259259)  
#12) Petal.Length< 4.95 48   1 versicolor (0.00000000 0.97916667 0.02083333) *
#  13) Petal.Length>=4.95 6   2 virginica (0.00000000 0.33333333 0.66666667) *
#  7) Petal.Width>=1.75 46   1 virginica (0.00000000 0.02173913 0.97826087) *

# Este plot no nos muestra la informacion. Solo un esquema del arbol.
plot(arbolRpart)
# Muestra las etiquetas con informacion.
text(arbolRpart, use.n=TRUE)




