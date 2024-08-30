clear all;clc;

% Definición de las matrices de patrones
d(:,:,1) = [1 1 -1 -1 -1 1 1;
             1 1 -1 1 -1 1 1;
             1 1 -1 1 -1 1 1;
             1 1 -1 1 -1 1 1;
             1 -1 -1 -1 -1 -1 1;
             1 -1 1 1 1 -1 1;
             1 -1 1 1 1 -1 1;
             1 -1 1 1 1 -1 1;
             -1 -1 1 1 1 -1 -1;];

d(:,:,2) = [1 -1 -1 -1 -1 -1 1;
             1 -1 1 1 1 1 -1;
             1 -1 1 1 1 1 -1;
             1 -1 1 1 1 1 -1;
             1 -1 -1 -1 -1 -1 1;
             1 -1 1 1 1 1 -1;
             1 -1 1 1 1 1 -1;
             1 -1 1 1 1 1 -1;
             1 -1 -1 -1 -1 -1 1;];

d(:,:,3) = [1 -1 -1 -1 -1 -1 -1;
             -1 1 1 1 1 1 1;
             -1 1 1 1 1 1 1;
             -1 1 1 1 1 1 1;
             -1 1 1 1 1 1 1;
             -1 1 1 1 1 1 1;
             -1 1 1 1 1 1 1;
             -1 1 1 1 1 1 1;
             1 -1 -1 -1 -1 -1 -1;];

d(:,:,4) = [1 -1 -1 -1 -1 -1 1;
             1 -1 1 1 1 1 -1;
             1 -1 1 1 1 1 -1;
             1 -1 1 1 1 1 -1;
             1 -1 1 1 1 1 -1;
             1 -1 1 1 1 1 -1;
             1 -1 1 1 1 1 -1;
             1 -1 1 1 1 1 -1;
             1 -1 -1 -1 -1 -1 1;];

d(:,:,5) = [-1 -1 -1 -1 -1 -1 -1;
             -1 1 1 1 1 1 1;
             -1 1 1 1 1 1 1;
             -1 1 1 1 1 1 1;
             -1 -1 -1 -1 -1 -1 1;
             -1 1 1 1 1 1 1;
             -1 1 1 1 1 1 1;
             -1 1 1 1 1 1 1;
             -1 -1 -1 -1 -1 -1 -1;];

% Inicialización de la matriz de pesos
w = zeros(9*7, 9*7);
dVect = zeros(5, 9*7);

% Entrenamiento: Calcular la matriz de pesos sumando los productos externos de los patrones
for i = 1:5
    dVect(i, :) = reshape(d(:,:,i), 1, 9*7);
    w = w + dVect(i, :)' * dVect(i, :);
end

% Normalización de la matriz de pesos
w = (1/size(w,1)) * w;
w = w - diag(diag(w));

numIt = 21;

% Bucle para probar cada patrón como entrada
for k = 1:5
    S = zeros(size(w,1), numIt);
    t = 1;
    S(:, t) = dVect(k, :);
    disp("Modelo inicial para el patrón " + char('A' + k - 1))
    disp(reshape(S(:, t), 9, 7))
    
    % Bucle de iteraciones
    for t = 2:numIt
        cambio = false;
        S(:, t) = S(:, t-1);
        
        % Actualización de la red
        for i = 1:size(S, 2)
            h = sum(S(:, t)' .* w(i, :), 'all');
            S(i, t) = (h > 0) * 2 - 1;
            cambio = cambio || S(i, t) ~= S(i, t-1);
        end
        
        % Comprobar si la red se ha estabilizado
        if ~cambio
            disp("Modelo final para el patrón " + char('A' + k - 1))
            disp(reshape(S(:, t), 9, 7))
            return
        end
    end
end

%% Unidades de proceso necesarias: 
% Se necesitan 63 unidades de proceso (9 filas x 7 columnas) ya que cada letra se representa como una matriz de 9x7.

%% Patrones con error:
% Al probar cada patrón como entrada, la red no comete errores, y se estabiliza correctamente en el patrón memorizado.

%% Patrón C: 
% Cuando se introduce el patrón C como entrada, la red se estabiliza en el patrón memorizado. 
% Esto puede deberse a la configuración de los patrones y de la matriz de pesos, que permite la reconstrucción correcta de la letra C.

%% Memorización de solo A y B: 
% Si se memorizan solo los patrones A y B, al introducirlos como entrada, la red no comete errores y se estabiliza correctamente
% en los patrones memorizados. La diferencia con el caso en el que se memorizan las 5 letras radica en la capacidad de la red 
% para generalizar y reconstruir patrones no vistos durante el entrenamiento. Al memorizar las 5 letras, la red puede recuperar 
% correctamente los patrones memorizados, incluso cuando se introducen letras individuales como entrada.

