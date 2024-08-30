% Definición de los patrones de entrada (X) y salida deseada (Y)
X(1, :) =  [1 1 1 -1 1 -1 -1 1 -1];
X(2, :) =   [1 -1 -1 1 -1 -1 1 1 1];
Y(1, :) = [1 -1 -1];
Y(2, :) =  [-1 -1 1];

% Inicialización de la matriz de pesos (W) utilizando la regla de Hebbian
W = X' * Y;

% Número máximo de épocas para el entrenamiento
epocMax = 21;

% Inicialización de matrices para almacenar los estados de la red en cada época
S = zeros(size(X,2), epocMax);
S2 = zeros(size(Y,2), epocMax);

% Inicialización del estado de la red en la primera época
sinit = [1 1 1 -1 1 -1 -1 1 -1];
s2init = sign(sinit * W);
S(:,1) = sinit;
S2(:,1) = s2init;

% Bucle de entrenamiento a través de las épocas
for epoc = 2:1:epocMax
    % Actualización del estado de la red en ambas direcciones
    S(:, epoc) = sign(W * S2(:, epoc-1));
    S2(:, epoc) = sign(S(:, epoc)' * W);
    
    % Comprobación de convergencia
    if sum(S(:, epoc) == S(:, epoc-1)) == size(X, 2)
        % Si la red ha convergido, se muestra el resultado y se termina el bucle
        disp(S(:, epoc))
        disp(S2(:, epoc))
        return
    end
end
