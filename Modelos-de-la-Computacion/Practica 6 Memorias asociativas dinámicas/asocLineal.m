clear all;

% Definir matrices aleatorias para los patrones de entrada (X) y salida (Y)
X = rand(4, 5);
Y = rand(4, 2);

% Crear matrices adicionales A y B, que no se utilizan más adelante
A = rand(4, 5);
B = rand(4, 5);

% Orthogonalizar las filas de X y Y para evitar redundancias
X = orth(X')';
Y = orth(Y);

% Calcular las matrices de pesos w1 y w2
w1 = X' * Y;
w2 = A' * B;

%% Patrones para que la salida sea reconocida correctamente:
% Para que la salida sea reconocida correctamente, los patrones de entrada X y salida Y deben estar relacionados mediante 
% la matriz de pesos w1. En este caso, ya que X y Y son ortogonales, cualquier patrón de entrada se reconocerá correctamente.
% No hay restricciones específicas en los patrones que se deben memorizar.

%% Patrones para que la salida NO sea reconocida correctamente:
% Para que la salida no sea reconocida correctamente, se deben proporcionar patrones de entrada y salida que no estén relacionados
% de manera lineal. En este caso, la relación entre las matrices A y B no afecta al resultado final, ya que no se utilizan después
% de la inicialización. Por lo tanto, no hay patrones específicos que deban memorizarse para este propósito.

%% Razón por la que la salida podría ser incorrecta:
% En el código proporcionado, la matriz w2 se calcula pero no se utiliza posteriormente. 
% Si hubo un error en el planteamiento del problema y la intención era utilizar w2 en lugar de w1, podría haber un problema 
% en la interpretación o formulación de la pregunta. Asegúrate de verificar si la utilización de w1 es la correcta según 
% los requisitos del problema. Si no, se debería ajustar el código según las necesidades específicas del problema.
