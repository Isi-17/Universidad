library(mboost)
library(rpart)
set.seed(123)
# Vamos a hacer el CSV de abajo

# Vamos a hacer un CSV manual
x1 <- c(2.771244718, 1.728571309, 3.678319846, 3.961043357, 2.999208922, 7.497545867, 9.00220326, 7.444542326, 10.12493903, 6.642287351)
x2 <- c(1.784783929, 1.169761413, 2.81281357, 2.61995032, 2.209014212, 3.162953546, 3.339047188, 0.476683375, 3.234550982, 3.319983761)
y <- c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1)
datosexamen <- data.frame(x1, x2, y)
print(datosexamen)
# Buscamos la condicion: xj < s como nodo raíz del árbol
# Tenemos que calcular: 
#       qué variable restringimos
#       a qué valor restringimos

# Función para calcular la suma de la varianza en una región
calcular_varianza <- function(region) {
  if (length(region) == 0) {
    return(0)
  }
  mean_y <- mean(region$y)
  suma_varianza <- sum((region$y - mean_y)^2)
  return(suma_varianza)
}

# Función para encontrar la variable y el valor de división óptimos
encontrar_division_optima <- function(data) {
  mejor_variable <- NULL
  mejor_valor <- NULL
  mejor_varianza_total <- Inf
  
  for (variable in names(data)[1:2]) {
    valores_unicos <- unique(data[, variable])
    for (valor in valores_unicos) {
      region1 <- data[data[, variable] < valor, ]
      region2 <- data[data[, variable] >= valor, ]
      
      varianza_total <- calcular_varianza(region1) + calcular_varianza(region2)
      
      if (varianza_total < mejor_varianza_total) {
        mejor_varianza_total <- varianza_total
        mejor_variable <- variable
        mejor_valor <- valor
      }
    }
  }
  
  return(list(variable = mejor_variable, valor = mejor_valor, varianza_total = mejor_varianza_total))
}

# Encontrar la primera división del árbol
primera_division <- encontrar_division_optima(datosexamen)
cat("Variable óptima para la primera división:", primera_division$variable, "\n")
cat("Valor óptimo para la primera división:", primera_division$valor, "\n")
cat("Varianza total mínima:", primera_division$varianza_total, "\n")

# Función para construir un árbol de decisión de forma recursiva
construir_arbol_recursivo <- function(data, nivel) {
  # Determinar la variable y el valor de división óptimos
  division_optima <- encontrar_division_optima(data)
  
  # Imprimir información del nodo actual
  cat(rep("  ", nivel), "Nivel", nivel, "\n")
  cat(rep("  ", nivel), "Nodo", nivel, ": ", division_optima$variable, "<", division_optima$valor, "\n")
  
  # Dividir el conjunto de datos en subconjuntos R1 y R2
  R1 <- data[data[, division_optima$variable] < division_optima$valor, ]
  R2 <- data[data[, division_optima$variable] >= division_optima$valor, ]
  
  # Determinar si se debe detener la recursión
  if (nivel >= 2) {
    cat(rep("  ", nivel), "Detenido en el nivel", nivel, "\n")
    return()
  }
  
  # Llamar recursivamente a la función para los subconjuntos
  if (nrow(R1) > 0) {
    cat(rep("  ", nivel), "Izquierda\n")
    construir_arbol_recursivo(R1, nivel + 1)
  }
  if (nrow(R2) > 0) {
    cat(rep("  ", nivel), "Derecha\n")
    construir_arbol_recursivo(R2, nivel + 1)
  }
}

# Llamar a la función recursiva para construir el árbol
cat("Árbol de decisión recursivo:\n")
construir_arbol_recursivo(datosexamen, nivel = 0)


# Apartado b)
# Dividir el conjunto de datos en dos regiones R1 y R2
R1 <- datosexamen[datosexamen$x1 < primera_division$valor, ]
R2 <- datosexamen[datosexamen$x1 >= primera_division$valor, ]

# Construir árbol T1 para explotar R2
# Utilizamos la función encontrar_division_optima definida anteriormente
division_t1 <- encontrar_division_optima(R2)

# Construir árbol T2 para explotar R1
division_t2 <- encontrar_division_optima(R1)

# Evaluar precisión de T1 y T2
predicciones_T1 <- ifelse(R1[, division_t1$variable] < division_t1$valor, 0, 1)
accuracy_T1 <- mean(predicciones_T1 == R2$y)

predicciones_T2 <- ifelse(R2[, division_t2$variable] < division_t2$valor, 0, 1)
accuracy_T2 <- mean(predicciones_T2 == R1$y)

# Determinar el mejor árbol
mejor_arbol <- ifelse(accuracy_T1 > accuracy_T2, "T1", "T2")



# Imprimir resultados
ArbolT1 <- paste(
  "Arbol 1.\n",
  "Nivel 0\n",
  paste("Nodo 1(o raiz):", division_t1$variable, "<", division_t1$valor, "\n"),
  "Nivel 1\n",
  "Derecha\n",
  paste("Nodo 2:", division_t1$variable, "<", division_t1$valor, "\n"),
  "etiqueta nodo derecha - etiqueta nodo izquierda\n",
  "Izquierda\n",
  "etiqueta nodo\n"
)

cat(ArbolT1)

ArbolT2 <- paste(
  "Arbol 2.\n",
  "Nivel 0\n",
  paste("Nodo 1(o raíz):", division_t2$variable, "<", division_t2$valor, "\n"),
  "Nivel 1\n",
  "Derecha\n",
  "etiqueta nodo\n",
  "Izquierda\n",
  paste("Nodo 2:", division_t2$variable, "<", division_t2$valor, "\n"),
  "etiqueta nodo derecha - etiqueta nodo izquierda\n"
)

cat(arbolT2)


cat("Predicción.\n")
cat(paste("T1: accuracy del árbol T1 =", accuracy_T1, "\n"))
cat(paste("T2: accuracy del árbol T2 =", accuracy_T2, "\n"))
cat(paste("Mejor árbol: ", mejor_arbol, "\n"))




