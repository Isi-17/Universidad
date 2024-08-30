function Vecindad = FuncionVecindad(IndGan, W, Indices)
    % Obtener las dimensiones del mapa de neuronas
    [~, numFil, numCol] = size(W);
    
    % Inicializar la matriz de vecindad con ceros
    Vecindad = zeros(numFil, numCol);
    
    % Iterar sobre todas las neuronas en el mapa
    for i = 1:numFil
        for j = 1:numCol
            % Verificar si la neurona actual es la ganadora
            if (IndGan(1) == i && IndGan(2) == j)
                Vecindad(i, j) = 1;  % La neurona ganadora tiene un valor de vecindad de 1
            else
                % Verificar si la distancia Manhattan entre la neurona actual y la ganadora es 1
                if (sum(abs(IndGan - Indices(:, i))) == 1)
                    Vecindad(:, j) = 0.15;  % Vecindad de las neuronas adyacentes a la ganadora
                end
            end
        end
    end
end
