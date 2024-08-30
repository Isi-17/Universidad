% Limpiar la pantalla, la línea de comandos y cerrar todas las figuras
clear;
clc;
close all;

% Cargar datos y especificar la cantidad de atributos (NumA)
load('DatosTri.mat');
NumA = 2;

% Configuración de parámetros
eta0 = 0.9;
IterMax = 1000;
FC = [8 6];

% Obtener el número de datos y dimensiones del espacio de entrada
[NumDatos, ~] = size(data);

% Inicializar pesos del mapa autoorganizado SOM (SOM)
W = rand(NumA, FC(1), FC(2));
W = GenerarSOMcuadrada(FC);

% Visualizar el estado inicial del mapa SOM
DibujarW(W, FC);
DibujarD(data);
axis([-1.5 1.5 -1.5 1.5]);
pause;

% Generar índices para las neuronas del mapa SOM
Indices = GenerarIndices(FC);

% Bucle principal de entrenamiento SOM
for i = 1:IterMax
    fprintf('i: %d\n', i);
    
    % Barajar índices de datos para presentarlos en orden aleatorio
    ind = randperm(NumDatos);
    
    % Actualizar el coeficiente de aprendizaje en cada iteración
    eta = eta0 * (1 - i / IterMax);
    
    % Iterar sobre los datos de entrada
    for j = 1:NumDatos
        % Seleccionar un patrón de entrada aleatorio
        Patron = (data(ind(j), 1:NumA))';
    
        % Calcular la neurona ganadora y sus coordenadas
        [Gx, Gy] = CalculoGanadora(W, Patron);
        IndGan = [Gx, Gy]';
        
        % Calcular la función de vecindad para las neuronas
        Vecindad = FuncionVecindad(IndGan, W, Indices);
        
        % Actualizar los pesos del SOM utilizando la regla de aprendizaje
        W = IncrementarPesos(W, Patron, Vecindad, eta);
    end
    
    % Visualizar el estado del mapa SOM cada 10 iteraciones
    if mod(i, 10) == 0
        DibujarW(W, FC);
        DibujarD(data);
        axis([-1.5 1.5 -1.5 1.5]);
        drawnow;
    end
end

% Visualizar el estado final del mapa SOM y las clases asignadas
DibujarW(W, FC);
DibujarD(data);
axis([-1.5 1.5 -1.5 1.5]);

% Visualizar la asignación de clases para cada neurona del mapa SOM
figure;
DibujarClase(data, W);
