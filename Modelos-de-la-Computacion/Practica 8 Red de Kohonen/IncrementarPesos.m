function W = IncrementarPesos(W, Patron, Vecindad, eta)
    % Obtener las dimensiones del mapa de neuronas
    [~, numFil, numCol] = size(W);
    
    % Iterar sobre todas las neuronas en el mapa
    for i = 1:numFil
        for j = 1:numCol
            % Actualizar los pesos de la neurona actual en todas las dimensiones
            W(:, :, j) = W(:, i, j) + eta * Vecindad(i, j) * (Patron - W(:, :, j));
        end
    end 
end
