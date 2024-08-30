# Print
myString <- "Hello, World!"
print ( myString)

# Logical
v <- TRUE
print(class(v))

# Numeric
v <- 23.5
print(class(v))

# Integer
v <- 2L
print(class(v))

# Complex
v <- 2+5i
print(class(v))

# Character
v <- "Hola"
print(class(v))

# Raw
v <- charToRaw("Hello")
print(class(v))

# Create a vector.
apple <- c('red','green',"yellow")
print(apple)

# Get the class of the vector --> (Character)
print(class(apple))

# Create a list.
list1 <- list(c(2,5,3),21.3,sin)

# Print the list --> function(x), Primitive("sin")
print(list1)

# Create a matrix.
M = matrix( c('a','a','b','c','b','a'), nrow = 2, ncol = 3, byrow = TRUE)
print(M)

# Create an array.
a <- array(c('green','yellow'),dim = c(3,3,2))
print(a)

# FACTORS
# Factors are the r-objects which are created using a vector. 
# It stores the vector along with the distinct values of the elements in the vector as labels.
# The labels are always character irrespective of whether it is numeric or character or Boolean etc. in the input vector.
# They are useful in statistical modeling.
# Factors are created using the factor() function. The nlevels functions gives the count of levels.

# Create a vector.
apple_colors <- c('green','green','yellow','red','red','red','green')

# Create a factor object.
factor_apple <- factor(apple_colors)

# Print the factor.
print(factor_apple)
print(nlevels(factor_apple))

# DATAFRAMES
# Create the data frame.
BMI <- 	data.frame(
  gender = c("Male", "Male","Female"), 
  height = c(152, 171.5, 165), 
  weight = c(81,93, 78),
  Age = c(42,38,26)
)
print(BMI)

# Para la creacion de variables se puede usa el punto. Ej: var.name,  .var_name, etc
# Assignment using equal operator.
var.1 = c(0,1,2,3)           

# Assignment using leftward operator.
var.2 <- c("learn","R")   

# Assignment using rightward operator.   
c(TRUE,1) -> var.3           

print(var.1)
cat ("var.1 is ", var.1 ,"\n")
cat ("var.2 is ", var.2 ,"\n")
cat ("var.3 is ", var.3 ,"\n")

# Podemos cambiar el tipo de una variable.
var_x <- "Hello"
cat("The class of var_x is ",class(var_x),"\n")

var_x <- 34.5 #NUMERIC
cat("  Now the class of var_x is ",class(var_x),"\n")

var_x <- 27L #INTEGER
cat("   Next the class of var_x becomes ",class(var_x),"\n")

# Print todas las variables creadas.
print(ls())

# library(party)  -->  es lo mismo que si hicieramos import library

# +, -, *, /, ^
v <- c( 2,5.5,6)
print(class(v)) #numeric
t <- c(8, 3, 4)
print(v+t) # suma los arrays

# %% Give the remainder of the first vector with the second
v <- c( 2,5.5,6)
t <- c(8, 3, 4)
print(v%%t)

# %/% The result of division of first vector with second (quotient)
v <- c( 2,5.5,6)
t <- c(8, 3, 4)
print(v%/%t)

# >, <, >=, <=, ==, !=
v <- c(2,5.5,6,9)
t <- c(8,2.5,14,9)
print(v>t)  #FALSE TRUE FALSE FALSE

# &, |, !
# AND, OR, NOT
v <- c(3,1,TRUE,2+3i)
t <- c(4,1,FALSE,2+3i)
print(v&t) # TRUE TRUE FALSE TRUE

v <- c(3,0,TRUE,2+2i)
t <- c(4,0,FALSE,2+3i)
print(v|t) # TRUE FALSE TRUE TRUE

v <- c(3,0,TRUE,2+2i)
print(!v) # FALSE TRUE FALSE FALSE

# &&, ||
v <- c(3,0,TRUE,2+2i)
t <- c(1,3,TRUE,2+3i)
print(v&&t)

v <- c(0,0,TRUE,2+2i)
t <- c(0,3,TRUE,2+3i)
print(v||t)

# %in% 
v1 <- 8
v2 <- 12
t <- 1:10
print(v1 %in% t) # TRUE 
print(v2 %in% t) # FALSE

# FUNCTIONS
#function_name <- function(arg_1, arg_2, ...) {
#  Function body 
#}
# Funciones prefefinidas
# Create a sequence of numbers from 32 to 44.
print(seq(32,44))

# Find mean of numbers from 25 to 82.
print(mean(25:82))

# Find sum of numbers from 41 to 68.
print(sum(41:68))

# Create a function to print squares of numbers in sequence.
new.function <- function(a) {
  for(i in 1:a) {
    b <- i^2
    print(b)
  }
}
new.function(4) #Resultado: 1, 4, 8, 16

# Funcion con argumentos de entrada
# Create a function with arguments.
new.function <- function(a,b,c) {
  result <- a * b + c
  print(result)
}

# Call the function by position of arguments.
new.function(5,3,11) # 26

# Call the function by names of the arguments.
new.function(a = 11, c = 3, b = 5) # 58
new.function(a = 11, b = 5, c = 3) # 58

# Podemos establecer un parámetro por defecto
new.function <- function(a = 3, b = 6) {
  result <- a * b
  print(result)
}

# Call the function without giving any argument.
new.function() # 18

# Podemos llamar ahora al metodo con dos parametros o especificar el valor de a
new.function(9,5) #45

# PASTE
a <- "Hello"
b <- 'How'
c <- "are you? "

print(paste(a,b,c))

print(paste(a,b,c, sep = "-"))

print(paste(a,b,c, sep = "", collapse = ""))


# REGRESION LINEAL
# The predictor vector.
x <- c(151, 174, 138, 186, 128, 136, 179, 163, 152, 131)

# The resposne vector.
y <- c(63, 81, 56, 91, 47, 57, 76, 72, 62, 48)

# Apply the lm() function. MODELO DE REGRESION LINEAL
# Encontrar una linea tal que la diferencia entre los puntos sea la menor posible.
# lm es el objeto que crea el modelo de regresión lineal. En funcion de la x, definir la y.
# Atributo de clasificacion ~ atributos que queremos que intervengan en la clasificacion.
# Si queremos que invervengan todos los atributos: y~.
relation <- lm(y~x)

# Find weight of a person with height 170.
a <- data.frame(x = 170) # crea un dataframe que contiene el valor de 170
result <-  predict(relation,a) 
print(result) # 1, 76.22869




