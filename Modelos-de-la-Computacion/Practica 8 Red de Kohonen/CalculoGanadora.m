function [Gx, Gy] = CalculoGanadora(W, Patron)
    % Inicializar las coordenadas de la neurona ganadora
    Gx = 1;
    Gy = 1;

    % Inicializar la distancia óptima como infinito para la primera iteración
    distOpt = inf;

    % Obtener las dimensiones del mapa de neuronas
    [~, numFil, numCol] = size(W);

    % Iterar sobre todas las neuronas en el mapa
    for i = 1:numFil
        for j = 1:numCol
            % Calcular la distancia euclidiana entre los pesos de la neurona y el patrón
            dist = norm(W(:, i, j) - Patron, 2);

            % Comprobar si la distancia actual es menor que la distancia óptima
            if dist < distOpt
                % Actualizar las coordenadas de la neurona ganadora y la distancia óptima
                Gx = i;
                Gy = j;
                distOpt = dist;
            end
        end
    end
end
